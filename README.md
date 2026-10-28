# TRABUILD Landing Page

The public landing page for TRABUILD, built with Flutter Web.

## Requirements

- Flutter 3.44 or later (stable channel)

## Run locally

```sh
flutter pub get
flutter run -d chrome --dart-define=API_URL=https://admin.trabuild.com/api/v1
```

`API_URL` is the base URL of the TRABUILD API.

The page also runs without an API. It then shows placeholder images and
fallback contact details.

## Routes

| Path | Page |
| --- | --- |
| `/` | Landing page |
| `/about` | About Us |
| `/privacy` | Privacy Policy |
| `/terms` | Terms & Conditions |
| `/reset-password?token=...` | Password reset form |

The app uses real paths, not URL fragments. A web server must send all unknown
paths to `index.html`. The supplied nginx config already does this.

## Project layout

```
lib/
  config/      API URL configuration
  constants/   Colours, strings, legal page content
  pages/       Legal pages, password reset
  sections/    Hero, gallery, stats, CTA, contact, footer
  widgets/     Shared widgets
nginx/         nginx template used by the Docker image
web/           Web shell (index.html, manifest)
```
