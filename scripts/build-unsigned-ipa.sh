#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
DERIVED_DATA="$BUILD_DIR/DerivedData"
APP_PATH="$DERIVED_DATA/Build/Products/Release-iphoneos/StudentbevisAppen.app"
IPA_PATH="$BUILD_DIR/StudentbevisAppen-UNSIGNED-AltStore.ipa"

cd "$ROOT_DIR"

xcodebuild \
  -project StudentbevisAppen.xcodeproj \
  -scheme StudentbevisAppen \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

test -d "$APP_PATH"
rm -rf "$BUILD_DIR/Payload" "$IPA_PATH"
mkdir -p "$BUILD_DIR/Payload"
cp -R "$APP_PATH" "$BUILD_DIR/Payload/"

cd "$BUILD_DIR"
/usr/bin/ditto -c -k --keepParent Payload "$IPA_PATH"

echo "Created unsigned IPA:"
echo "$IPA_PATH"
