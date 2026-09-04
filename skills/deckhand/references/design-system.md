# Design system — editorial Linear

The look: a neutral, quiet canvas; type doing the heavy lifting at sizes that
feel almost rude; a sans-serif workhorse interrupted by serif italic; small
frosted pills floating in the layout; a four-point sparkle where a bullet would
normally sit. Restraint everywhere except the headline.

Two failure modes to avoid. One is the corporate template: gradient banner,
three equal cards, icon in a circle. The other is the overcooked art project:
five typefaces, animation on everything, unreadable from the back of the room.

## Typefaces

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,500;0,700;1,500;1,600&display=swap" rel="stylesheet">
```

- **Manrope** carries everything: headlines, body, labels, numbers. 800 for hero
  words, 700 for slide titles, 500/400 for body, 600 for pills and labels.
- **Playfair Display, italic** is an accent only. One to four words per slide,
  never a whole line, never body text. It marks the editorial beat in a
  headline: *the* generic, *nyaris* selesai, *what* actually shipped.
- Numbers use Manrope with `font-variant-numeric: tabular-nums` so stat rows
  line up.

Rule of thumb: if a slide has more than one Playfair fragment, it has one too
many.

## Type scale

Slides are laid out against a 1280x720 stage that scales, so use `clamp()` with
viewport units and let the whole thing breathe.

| Role | Size | Weight | Tracking |
|---|---|---|---|
| Hero (title slide) | `clamp(3.2rem, 8.5vw, 7.5rem)` | 800 | `-0.045em` |
| Slide title | `clamp(2rem, 4.4vw, 3.6rem)` | 700 | `-0.035em` |
| Section kicker | `0.78rem` | 600 | `0.14em`, uppercase |
| Lead paragraph | `clamp(1.05rem, 1.7vw, 1.45rem)` | 400 | `-0.01em` |
| Body | `clamp(0.95rem, 1.35vw, 1.12rem)` | 400 | normal |
| Stat number | `clamp(2.6rem, 5vw, 4.2rem)` | 800 | `-0.04em` |
| Caption / meta | `0.8rem` | 500 | `0.02em` |

Line height: `0.95` for hero, `1.05` for slide titles, `1.55` for body. Tight
headlines against loose body is most of the effect.

Measure: body text never wider than `62ch`. A slide of full-width text at 1080p
is unreadable from row three.

## Color

Three layers. Do not add a fourth.

1. **Neutral ground.** Warm off-white, not pure white. `#f6f5f3` background,
   `#12110f` ink, `#6b6862` muted. Dark variant: `#0e0e10` ground, `#f4f3f1`
   ink, `#8e8b86` muted.
2. **Project accent.** The color the product already uses, pulled in Step 3.
   Used for the active state, the sparkle, one word in the headline, the
   progress rail, the chart's primary series. Roughly 5% of the pixels.
3. **One counter-accent that is not in the project.** This is what stops the
   deck from looking like a screenshot of the app. Pick a warm answer to a cool
   brand, or a cool answer to a warm one, and give it exactly one job: emphasis
   on numbers, or the "before" side of a comparison.

Pairings that work:

| Project accent | Counter-accent | Feel |
|---|---|---|
| teal `#00a9b4` | terracotta `#c2532f` | technical, warm |
| indigo `#4f46e5` | amber `#d97706` | product, energetic |
| forest `#166534` | clay `#b45309` | grounded |
| slate blue `#334155` | coral `#e5484d` | serious, one alarm color |

Semantic colors sit outside the palette and stay boring: success `#2f7d4f`,
warning `#b7791f`, danger `#c0392b`. Never let the accent mean "good" and the
counter-accent mean "bad" — that reads as decoration, not as data.

```css
:root {
  --ground: #f6f5f3;
  --surface: #ffffff;
  --ink: #12110f;
  --ink-soft: #4a4842;
  --muted: #6b6862;
  --line: rgba(18, 17, 15, 0.10);
  --accent: #00a9b4;          /* from the project */
  --accent-soft: rgba(0, 169, 180, 0.12);
  --counter: #c2532f;         /* deliberately not from the project */
  --counter-soft: rgba(194, 83, 47, 0.12);
  --radius-pill: 999px;
  --radius-card: 18px;
}
```

Both themes ship in the template. Light is the bare `:root`, dark is redefined
twice: under `@media (prefers-color-scheme: dark)` guarded as
`:root:not([data-theme="light"])`, and again under `:root[data-theme="dark"]` so
an explicit choice wins in both directions. Pin one with `data-theme` on `<html>`
or omit it to follow the viewer's system.

Never define a color only inside a dark block, and never hand-write a second
palette. When you swap in the project's accent, lift the dark variant by 10 to
15% lightness: an accent tuned for off-white goes muddy on a dark field. Teal
`#00a9b4` becomes `#2fd0da`, terracotta `#c2532f` becomes `#e8794f`.

Default to light. A projector washes out dark backgrounds and a handout prints
from the light palette anyway. Dark earns its place in a dim room or a screen
share.

Contrast floor: 4.5:1 under 24px, 3:1 above. A projector eats contrast, so aim
above the minimum.

## Layout

- Full-viewport slides, one idea each. If two ideas are fighting, that is two
  slides.
- Asymmetry over centering. Centered everything is the tell of a template.
  Anchor content to a 12-column grid and let it sit off-center: content in
  columns 2 to 8, a visual in 8 to 12, a lot of empty air.
- Padding: `clamp(3rem, 7vw, 7rem)` horizontal, never under 2.5rem vertical.
- Vertical rhythm in multiples of 8px.
- Empty space is content. A slide that is 55% empty reads as confident. One that
  is 20% empty reads as a document nobody edited.
- Big type is mostly a readability tool, not the content. A progress deck is
  judged on what the room learned, so headline-only slides stay rare: one per
  deck, at a section break or on the number the update turns on. Density belongs
  on the change list, restraint around it.

## Components

**Pill / badge.** The signature element. Inline, floating, frosted.

```css
.pill {
  display: inline-flex; align-items: center; gap: .5rem;
  padding: .42rem .95rem;
  border-radius: var(--radius-pill);
  background: rgba(255, 255, 255, .55);
  border: 1px solid var(--line);
  backdrop-filter: blur(14px) saturate(140%);
  font-size: .82rem; font-weight: 600; letter-spacing: .01em;
  box-shadow: 0 1px 2px rgba(18,17,15,.04), 0 8px 24px rgba(18,17,15,.05);
}
```

Variants: `.pill--accent` (accent-tinted background and text), `.pill--media`
(holds a small image, fully rounded, aspect ratio near 2.2:1, `object-fit:
cover`, sitting inline inside a headline at about 0.75em of the line height).

Shadows stay in that two-layer range everywhere. A heavy drop shadow is the
fastest way to make this look cheap.

**Sparkle.** Four-point star, inline SVG, `currentColor` so it inherits. Use it
where a bullet would go, or floating beside a hero word. Two or three per slide
at most.

```html
<svg class="spark" viewBox="0 0 24 24" aria-hidden="true">
  <path d="M12 0c.6 6.4 5 10.8 12 12-7 1.2-11.4 5.6-12 12-.6-6.4-5-10.8-12-12 7-1.2 11.4-5.6 12-12z"/>
</svg>
```

**Stat block.** Big tabular number, thin label under it, hairline rule above. No
card, no border box, no icon.

**Editorial rule.** A 1px hairline in `--line` spanning 4 to 6 grid columns,
separating a kicker from a title. Cheaper and better than a box.

**Emoji.** One or two per deck, inline in a headline, at the size of the
surrounding text. They read as punctuation, not clip art. Never in body copy,
never as a bullet icon, never three in a row.

## Motion

- Slide entrance: content fades up 12px over 420ms,
  `cubic-bezier(.2,.7,.2,1)`, children staggered 60ms apart. That is the whole
  animation budget for most slides.
- SVG diagrams may draw themselves once when their slide becomes active.
- Nothing loops forever except a genuine live indicator.
- Everything wrapped in `@media (prefers-reduced-motion: reduce)`, falling back
  to plain opacity.

Animation that does not help someone understand something only makes them wait.

## Navigation and mechanics

The template implements: arrow keys, space, PageUp/PageDown, touch swipe, `F`
for full screen, `O` for the overview grid, `Esc` to leave it, `D` to flip light
and dark, a slide counter pill, a thin progress rail in the accent,
deep-linkable `#slide-7` hashes, and a print stylesheet that emits one landscape
page per slide.

Keep them. Rewriting the shell means rebuilding all of that badly.

## Accessibility

Real headings (`h1`/`h2`), not styled divs. `aria-hidden` on decorative SVG, a
`<title>` inside meaningful SVG. Alt text on photos. Visible focus on any
control. Never encode meaning in color alone: the "before" bar gets a label, not
only a different hue.
