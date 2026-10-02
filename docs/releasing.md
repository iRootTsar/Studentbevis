# Building StudentbevisAppen for iPhone

This repository is designed for a free Apple Account / Xcode Personal Team workflow.

There is no paid Apple Developer Program requirement for local development.

## What GitHub Produces

GitHub Actions produces:

- simulator build checks
- an unsigned IPA named `StudentbevisAppen-UNSIGNED-AltStore.ipa`

The unsigned IPA is intended for AltStore/AltServer or another local signing tool.

It is not:

- an App Store build
- a TestFlight build
- an Ad Hoc release
- directly installable by tapping the file on stock iOS

## Daily Local Development

1. Pull the latest code.
2. Open `StudentbevisAppen.xcodeproj`.
3. Select your iPhone as the run destination.
4. Make sure Signing & Capabilities uses your Personal Team.
5. Press `Cmd+R`.

Xcode signs and installs the app on your phone.

Free Personal Team provisioning expires after 7 days. Rebuild from Xcode when that happens.

## Creating an Unsigned IPA Locally

Run:

```bash
./scripts/build-unsigned-ipa.sh
```

The output is:

```text
build/StudentbevisAppen-UNSIGNED-AltStore.ipa
```

Use this with AltStore/AltServer. AltStore signs it for the specific iPhone during installation.

## Creating an Unsigned IPA in GitHub

Every push to `main` or `dev` runs `.github/workflows/ios-release.yml`.

Actions artifacts are downloaded by GitHub as a `.zip`. The zip contains the IPA.

To download from Actions:

1. Open the GitHub repository.
2. Go to Actions.
3. Open the latest `Unsigned iOS IPA` run.
4. Download the `StudentbevisAppen-UNSIGNED-AltStore` artifact.
5. Import that IPA into AltStore.

## Downloading a Raw IPA File

When `main` builds successfully, the workflow also updates a rolling GitHub Release:

```text
Latest unsigned IPA for AltStore
```

That release contains the raw file:

```text
StudentbevisAppen-UNSIGNED-AltStore.ipa
```

Use this release asset when you want to send someone a direct `.ipa` file without the GitHub Actions artifact zip wrapper.

## Creating a Persistent GitHub Release

Actions artifacts expire. For a longer-lived downloadable file, create a version tag:

```bash
git tag v2.0.0
git push origin v2.0.0
```

The workflow attaches `StudentbevisAppen-UNSIGNED-AltStore.ipa` to the GitHub Release.

Friends can download that IPA, but they still need their own AltStore/AltServer setup to sign and install it on their own iPhone.

## No Apple Signing Secrets

This workflow does not use:

- `APPLE_TEAM_ID`
- `IOS_CERTIFICATE_BASE64`
- `IOS_CERTIFICATE_PASSWORD`
- `IOS_PROVISIONING_PROFILE_BASE64`
- `IOS_PROVISIONING_PROFILE_NAME`
- `KEYCHAIN_PASSWORD`

Those are for paid/manual Apple signing workflows and are intentionally not needed here.
