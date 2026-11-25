#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 || -z "$1" ]]; then
    printf 'Usage: %s "<paired iPhone name or device identifier>"\n' "$0" >&2
    exit 2
fi

device="$1"
script_dir="$(cd "$(dirname "$0")" && pwd)"
label="local.studentbevis.iphone-update"
domain="gui/$(/usr/bin/id -u)"
agent="$HOME/Library/LaunchAgents/$label.plist"
log="$HOME/Library/Logs/Studentbevis-iPhone-update.log"

if [[ -e "$agent" ]]; then
    printf 'An updater is already configured at %s.\n' "$agent" >&2
    exit 1
fi

# Confirm this selector resolves to a paired device before registering the job.
/usr/bin/xcrun devicectl device info details --device "$device" --timeout 15 >/dev/null

config="$(mktemp)"
trap 'rm -f "$config"' EXIT
/usr/bin/plutil -create xml1 "$config"
/usr/bin/plutil -insert Label -string "$label" "$config"
/usr/bin/plutil -insert ProgramArguments -json '[]' "$config"
/usr/bin/plutil -insert ProgramArguments.0 -string /bin/bash "$config"
/usr/bin/plutil -insert ProgramArguments.1 -string "$script_dir/update-iphone.sh" "$config"
/usr/bin/plutil -insert ProgramArguments.2 -string --install-only "$config"
/usr/bin/plutil -insert ProgramArguments.3 -string "$device" "$config"
/usr/bin/plutil -insert RunAtLoad -bool YES "$config"
/usr/bin/plutil -insert StartInterval -integer 3600 "$config"
/usr/bin/plutil -insert StandardOutPath -string "$log" "$config"
/usr/bin/plutil -insert StandardErrorPath -string "$log" "$config"
/usr/bin/plutil -lint "$config"

/bin/mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
if ! (set -o noclobber; /bin/cat "$config" > "$agent"); then
    exit 1
fi
if ! /bin/launchctl bootstrap "$domain" "$agent"; then
    /bin/rm -f "$agent"
    exit 1
fi

printf 'Background updates enabled. Log: %s\n' "$log"
