# Ayhan Aksoy — portfolio

Static personal site: plain HTML, CSS and JavaScript. No frameworks, build step, bundler or npm dependencies. Don't add any without asking.

@DESIGN.md

## Files

- `index.html`: all content. Both views live in this one file.
- `styles.css`: all styles. Design tokens live in `:root`.
- `main.js`: the visitor ⇄ recruiter switch, the light ⇄ dark toggle and the footer year. Keep it small and dependency-free.
- `assets/`: the cv PDF (git-ignored, name set by `CV` in `contact.env`), `favicon.svg` (plus `favicon-32.png` and `apple-touch-icon.png` rendered from it), `og-image.png`. Only the chosen cv is copied to `dist/`; other PDFs stay local.
- `build.sh`: writes a minified copy of the site to `dist/` (esbuild via `npx`, no `package.json`). Deploy `dist/`; never edit it by hand. `dist/` is gitignored.
- `VERSION`: the site version (`MAJOR.MINOR.PATCH`). `build.sh` stamps it into the footer of `dist/index.html`; the source footer shows `dev`.
- `contact.env`: the real email, github and linkedin urls and the cv name (git-ignored; format in `contact.env.example`). `CV` is the cv file name in `assets/` without `.pdf`. `build.sh` fills the `[YOUR EMAIL]`, `[GITHUB URL]`, `[LINKEDIN URL]` and `[CV]` placeholders in `dist/index.html` from it. Keep those placeholders in `index.html`; never put the real values in source.
- `README.md`: setup, build, deploy and versioning for humans. Update it when the build, files or workflow change.

## Versioning

Claude bumps `VERSION` as part of every change to the site itself (`index.html`, `styles.css`, `main.js` or `assets/`):

- **major**: a redesign, or a structural change such as the two views.
- **minor**: a new feature or section (e.g. the light ⇄ dark toggle).
- **patch**: fixes and small tweaks (copy, colors, assets).

Rules:

- Bump once per task, by the biggest change in it. Several fixes in one task are one patch bump; a feature plus fixes is one minor bump.
- Bumping resets the numbers to the right (`1.1.3` + a feature → `1.2.0`).
- Don't bump for changes that don't reach the site: `CLAUDE.md`, `DESIGN.md`, `README.md`, `build.sh`, `.gitignore`.
- State the old and new version in the summary (e.g. "version 1.1.0 → 1.1.1, patch: softer text color"), so the user can veto or change the level.
- Gaps between deployed versions are fine; semver doesn't require every number to ship.

## The two views

- `<html data-view="visitor|recruiter">` decides what shows. Mark elements with `data-view="visitor"` or `data-view="recruiter"`; elements with no attribute are shared.
- Hiding is done only by the CSS rule under "View switching". Don't toggle visibility in JS.
- Precedence: `?view=` in the URL, then `localStorage`, then `visitor`. An inline script in `<head>` sets the view before first paint; keep it.
- New content: decide which view it belongs to. Visitor content uses the astrology voice; recruiter content is factual.
- Printing always outputs the recruiter view as a CV (`@media print`). Check new recruiter sections in print preview.

## Color scheme

- The site follows the device setting (`prefers-color-scheme`) until the visitor uses the toggle in the header. Their choice is saved in `localStorage` as `theme` and set as `<html data-theme="light|dark">` by the inline `<head>` script before first paint.
- Dark token values live in two places in `styles.css`: the `prefers-color-scheme: dark` block and `:root[data-theme="dark"]`. Change both together.

## Conventions

- Use semantic HTML (`section`, `nav`, `ul`/`ol`, `dl`, `article`, real `button` and `a`). Icon-only controls need `aria-label`.
- Use classes over inline styles and reuse existing classes before adding new ones.
- Use CSS custom properties for all colors. Every new color needs light and dark values.
- Wrap `localStorage` access in try/catch.
- Copy is lowercase in the source.

## Before finishing a change

1. Open `index.html` at 390px and 1440px wide, in both views and both color schemes.
2. Check there is no horizontal scroll and no console errors.
3. Check that the floating switch never covers the last content (the footer has bottom padding for it).
4. Check that keyboard focus is visible and everything is reachable with Tab.
5. Bump `VERSION` if the site changed (see "Versioning").
