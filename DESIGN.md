# Design language

Monochrome and editorial, styled like an astrology app: stark ink on paper, a serif for display text, mono for everything else, and thin line art. The visitor view speaks like a horoscope. The recruiter view is a plain, factual résumé in the same visual style.

## Principles

1. **Two colors and their tints only.** Ink and paper, plus a dim tone and a line tone. No accent hues, gradients, glows or colored badges.
2. **Lines, not boxes.** Group content with 1px rules (`--line`). Avoid filled cards and backgrounds, and never use left-border accent cards.
3. **Serif speaks, mono informs.** Instrument Serif is for headlines, titles and placement names. IBM Plex Mono is for body text, labels, buttons and navigation.
4. **Lowercase voice.** All copy is lowercase, including headings, names and nav. Labels and buttons are uppercased by CSS (`text-transform`), never typed in caps.
5. **Generous space, quiet motion.** Leave large vertical rhythm between sections. Motion is limited to short opacity, transform or stroke changes, and is disabled under `prefers-reduced-motion`.

## Tokens (`styles.css` → `:root`)

| token    | light     | dark      |
| -------- | --------- | --------- |
| `--bg`   | `#f3f1ec` | `#0b0b0a` |
| `--fg`   | `#2a2926` | `#dbd8d1` |
| `--dim`  | `#57554f` | `#a3a099` |
| `--line` | `#cfccc4` | `#33322f` |

- Dark mode follows the device setting via `prefers-color-scheme` until the visitor picks a theme with the header toggle (`data-theme` on `<html>`). Every new color must be defined in **both** themes.
- `--dim` text must keep at least 4.5:1 contrast on `--bg`. Don't lighten it.
- Never hard-code hex values outside `:root`.

## Type scale

| role          | class                                | spec                                                        |
| ------------- | ------------------------------------ | ----------------------------------------------------------- |
| display       | `.display`                           | serif 400, `clamp(52px, 8.5vw, 124px)`, lh 0.95, ls -0.02em |
| section title | `.h2`                                | serif 400, `clamp(40px, 5.5vw, 72px)`, lh 1                 |
| item title    | (e.g. `.work-title`, `.entry-title`) | serif, 28–36px, lh 1.05–1.1                                 |
| body          | `body`                               | mono 15px, lh 1.6                                           |
| label         | `.label`                             | mono 12px, uppercase, ls 0.14em, `--dim`                    |
| button / nav  | `.btn`, `.nav`                       | mono 12–13px, uppercase, ls 0.08–0.14em                     |

Use `<em>` (serif italic) to emphasize one word in a headline, at most one per headline.

## Components

- **Section**: `.section` with a `.section-head` (`.label` numbered `NN — name`, then `.h2`), and a bottom rule.
- **Buttons**: `.btn` is an outlined pill and `.btn-solid` is the filled pill. Use one solid button per group. Minimum height 48px.
- **Lists of things**: rows separated by rules (`.work`, `.timeline`, `.placements`).
- **Columns**: `.columns` / `.col` with a `.col-title` underlined in `--fg`.
- **Facts grid**: `.facts`, cells bordered on all sides by `--line`.
- **Glyphs and illustrations**: inline SVG, `stroke="currentColor"`, 1px strokes, `fill="none"`. Dots are the only fills. No emoji and no icon fonts.
- **Theme toggle**: `.theme-toggle`, a 44px outlined circle at the top right of the header with a 1px line moon (in light mode) or sun (in dark mode). On narrow screens it stays beside the wordmark and the nav drops to its own row (below 760px wide).
- **Floating switch**: `.switch-dock` is fixed and centered 32px above the bottom of the screen. Don't add other floating UI.

## Layout

- Max width 1200px with a 24px gutter (20px under 480px).
- Use fluid layouts first (`flex-wrap`, `grid` with `repeat(auto-fit, minmax(…, 1fr))`, `clamp()`). Add breakpoints only as a last resort.
- Every change must work at 390px wide with no horizontal scroll.
- Touch targets are at least 44px.

## Voice

- **Visitor view**: astrology-style metaphors mapped to real facts ("sun in typescript", "today is good for shipping", "are we compatible?"). Keep it short and dry, with no exclamation marks.
- **Recruiter view**: no metaphors. Plain facts, dates and outcomes.
- Never invent facts, metrics or projects. Leave a `[PLACEHOLDER IN BRACKETS]` instead.

## Don'ts

No accent colors, gradients, shadows (except the floating switch), rounded cards, emoji, stock illustrations, Inter, Roboto or Arial, Title Case or ALL CAPS typed in the source, or animated backgrounds.
