#!/bin/bash
set -euo pipefail

install_only=false
if [[ ${1:-} == --install-only ]]; then
    install_only=true
    shift
fi

if [[ $# -ne 1 ]]; then
    printf 'Usage: %s [--install-only] "<iPhone name or device identifier>"\n' "$0" >&2
    exit 2
fi

device="$1"
project_root="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/studentbevis-update.XXXXXXXX")"
trap 'rm -rf "$build_dir"' EXIT

xcodebuild -project "$project_root/StudentbevisAppen.xcodeproj" \
    -scheme StudentbevisAppen -configuration Debug \
    -destination 'generic/platform=iOS' -derivedDataPath "$build_dir" \
    -allowProvisioningUpdates -allowProvisioningDeviceRegistration build

app="$build_dir/Build/Products/Debug-iphoneos/StudentbevisAppen.app"
profile_plist="$build_dir/provisioning-profile.plist"
# Read the signed payload without consulting the Mac's keychain for trust.
# iOS checks the profile's trust when installing the app.
if ! /usr/bin/openssl smime -verify -inform DER -in "$app/embedded.mobileprovision" -noverify -out "$profile_plist" ||
    ! expires_at="$(/usr/bin/plutil -extract ExpirationDate raw -o - "$profile_plist")" ||
    ! expires_epoch="$(/bin/date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$expires_at" +%s)"; then
    printf 'Could not verify the embedded provisioning profile expiration. Install skipped.\n' >&2
    exit 1
fi

# Allow a few minutes for Xcode to finish signing after Apple issues the profile.
minimum_remaining_seconds=$((7 * 24 * 60 * 60 - 15 * 60))
now_epoch="$(/bin/date +%s)"
if (( expires_epoch - now_epoch < minimum_remaining_seconds )); then
    printf 'Profile expires at %s. Less than 6 days and 23 hours 45 minutes remain. Install skipped.\n' "$expires_at" >&2
    exit 1
fi

printf 'Verified provisioning profile expiration: %s (UTC).\n' "$expires_at"
xcrun devicectl device install app --device "$device" "$app"
if [[ "$install_only" == true ]]; then
    exit 0
fi

bundle_id="$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$app/Info.plist")"
xcrun devicectl device process launch --device "$device" --terminate-existing "$bundle_id"
