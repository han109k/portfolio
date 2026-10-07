# My portfolio

Personal portfolio site, written in plain HTML, CSS and JavaScript with no framework and no npm dependencies.

The site has two views of the same page:

- **visitor**: the default, written like a horoscope ("sun in typescript").
- **recruiter**: a plain, factual résumé. Printing the page always gives this view as a CV.

A floating switch at the bottom changes the view. Share `?view=recruiter` to open the résumé view directly. A toggle in the header switches between light and dark mode; until a visitor uses it, the site follows the device setting.

## Project structure

```
index.html            all content, both views
styles.css            all styles; design tokens in :root
main.js               view switch, light/dark toggle, footer year
assets/               favicons, link-preview image, cv pdf (pdfs are git-ignored)
build.sh              builds the deployable copy into dist/
VERSION               site version, shown in the footer of the build
contact.env.example   format for contact.env (contact details and cv name)
DESIGN.md             design language: colors, type, components, voice
CLAUDE.md             working rules for Claude Code
```

## Building for deploy

One-time setup:

1. Put your cv PDF in `assets/`, e.g. `assets/ayhanaksoy.pdf`. PDFs in `assets/` are git-ignored, so keep a backup elsewhere.
2. Copy `contact.env.example` to `contact.env` and fill it in. `contact.env` is git-ignored, so these values never appear in the source or history.

   ```
   EMAIL=you@example.com
   GITHUB_URL=https://github.com/your-name
   LINKEDIN_URL=https://www.linkedin.com/in/your-name
   CV=your-name
   ```

   `CV` is the cv's file name without `.pdf`: `CV=your-name` makes the "download cv" button serve `assets/your-name.pdf`. To ship a new cv, add the file and change `CV`.

Then build:

```sh
./build.sh
```

This writes `dist/`. It needs Node (esbuild is fetched through `npx`; there's no `package.json`). The build:

- minifies `styles.css` and `main.js`
- strips HTML comments
- stamps the version from `VERSION` into the footer
- fills the contact details and the cv link from `contact.env`
- copies `assets/`, including only the chosen cv (other PDFs, like drafts, stay local)

The build stops with an error if `VERSION` isn't `MAJOR.MINOR.PATCH`, `contact.env` is missing or incomplete, the cv file named by `CV` doesn't exist, or a placeholder wasn't replaced.

Upload the contents of `dist/` to your host. Edit the source files only; `dist/` is regenerated on every build and is git-ignored.

## Versioning

The version lives in `VERSION` and follows [semantic versioning](https://semver.org):

| change                        | example                 | bump              |
| ----------------------------- | ----------------------- | ----------------- |
| redesign or structural change | replacing the two views | `1.1.0` → `2.0.0` |
| new feature or section        | the light/dark toggle   | `1.1.0` → `1.2.0` |
| fix or small tweak            | copy, colors, a new cv  | `1.1.0` → `1.1.1` |

Bump once per release, by the biggest change in it. Optionally tag the release in git: `git tag v1.1.1`.

## Favicons

`assets/favicon.svg` is the source. If you change it, regenerate the PNG fallbacks:

```sh
rsvg-convert -w 32 -h 32 assets/favicon.svg -o assets/favicon-32.png
rsvg-convert -w 180 -h 180 assets/favicon.svg -o assets/apple-touch-icon.png
```

## Design

See [DESIGN.md](DESIGN.md). In short: two colors (ink and paper), Instrument Serif for headlines, IBM Plex Mono for everything else, thin line art, and lowercase copy throughout.
