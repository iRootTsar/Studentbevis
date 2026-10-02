# Releasing StudentbevisAppen

This project uses GitHub Actions for builds and release artifacts.

## Normal Builds

Every push to `main` or `master` runs `.github/workflows/ios-build.yml`.
It builds the app for the iOS Simulator without code signing.

## IPA Releases

`.github/workflows/ios-release.yml` can create an installable `.ipa`, but only after Apple signing secrets are configured in GitHub.

Required repository secrets:

- `APPLE_TEAM_ID`
- `IOS_CERTIFICATE_BASE64`
- `IOS_CERTIFICATE_PASSWORD`
- `IOS_PROVISIONING_PROFILE_BASE64`
- `IOS_PROVISIONING_PROFILE_NAME`
- `KEYCHAIN_PASSWORD`

Create a release by pushing a version tag:

```bash
git tag v2.0.0
git push origin v2.0.0
```

GitHub Actions will archive the app, export an IPA, upload it as an Actions artifact, and attach it to the GitHub Release.

## Notes

Do not commit `.ipa` files to Git. They are generated build artifacts and should live in GitHub Actions artifacts or GitHub Releases.
