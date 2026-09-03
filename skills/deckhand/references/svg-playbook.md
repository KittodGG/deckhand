# SVG playbook

Hand-authored inline SVG. No chart library, no icon font, no external asset. A
diagram that lives in the HTML scales cleanly on a projector, prints to PDF,
and inherits the deck's palette through CSS variables.

## The gate

Draw only when this is true:

> A reader understands this faster from the picture than from two sentences of
> text.

**Draw it:** system architecture and data flow, before/after of a process,
a timeline where things overlap, a pipeline with stages and failure points, a
comparison across three or more dimensions, a distribution or a trend over time,
a state machine, a hierarchy someone has to navigate.

**Do not draw it:** a list, a single number, two numbers, a definition, a
sequence of two steps, a team structure everyone already knows, "our values", or
anything where the picture would be boxes containing the same words the slide
already says.

A deck of 20 slides usually earns 3 to 6 diagrams. When every slide has one,
none of them carry meaning.

## House style

Diagrams look like the deck, not like a whiteboard export.

- Stroke `1.5` for structure, `1` for hairlines. No stroke over `2` except a
  deliberate emphasis path.
- Corner radius `10` to `14` on nodes, matching `--radius-card`.
- Fill nodes with `var(--surface)`, stroke with `var(--line)`, label in
  `var(--ink)`. The accent marks one path or one node, never all of them.
- Labels in Manrope via `font-family: inherit` on the `<svg>` and
  `font-size: 13`, `font-weight: 600`. Never below 12 — projectors.
- No drop shadows inside SVG. No gradients unless the data is continuous.
- Arrowheads: one shared `<marker>`, small, filled with `currentColor`.
- Generous internal padding. A cramped diagram reads as clutter at distance.

Skeleton every diagram starts from:

```html
<svg class="viz" viewBox="0 0 900 420" role="img" aria-labelledby="viz1-t">
  <title id="viz1-t">Alur unggah dokumen sampai masuk index</title>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5"
            markerWidth="6" markerHeight="6" orient="auto-start-reverse">
      <path d="M0 0 L10 5 L0 10 z" fill="currentColor"/>
    </marker>
  </defs>
  <g class="viz-layer">…</g>
</svg>
```

```css
.viz { width: 100%; height: auto; font-family: inherit; color: var(--muted); }
.viz .node   { fill: var(--surface); stroke: var(--line); stroke-width: 1.5; }
.viz .node--hot { stroke: var(--accent); stroke-width: 2; }
.viz .label  { fill: var(--ink); font-size: 13px; font-weight: 600; }
.viz .sub    { fill: var(--muted); font-size: 11.5px; font-weight: 500; }
.viz .flow   { stroke: var(--line); stroke-width: 1.5; fill: none;
               marker-end: url(#arrow); }
.viz .flow--hot { stroke: var(--accent); }
```

`viewBox` fixed, no `width`/`height` attributes, `width: 100%` in CSS. That is
what makes it scale.

## Six patterns that cover most decks

**1. Flow / architecture.** Rounded nodes on a horizontal or L-shaped spine,
arrows between them, one branch highlighted in the accent as the path the story
follows. Group each node as `<g>` with `<rect>` + `<text>` so it moves as a
unit. Cap at 7 nodes; past that, collapse a group into one node labelled with
its own count.

**2. Before / after.** Two columns sharing a baseline. The "before" column in
`--counter`, the "after" in `--accent`, a hairline between them and a single
delta label in the middle. This is the highest-value diagram in a progress deck
and the one most often replaced with a paragraph.

**3. Timeline.** A horizontal axis with dated ticks and bars for overlapping
work. Bars at `height 22`, `rx 11`. Today marked with a dashed vertical hairline
in the accent. Only real dates from git.

**4. Stage pipeline with drop-off.** Stages as blocks whose widths encode a
count, with the number inside and the loss between stages labelled. Works for
ingest pipelines, funnels, approval chains.

**5. Bar or line comparison.** Only when the data has more than three points.
For fewer, a stat row of big numbers reads better than a chart. Baseline always
at zero. Direct-label the series at the end of the line; no legend, no gridlines
beyond a hairline at each tick.

**6. State machine.** Circles for states, labelled arcs for transitions, the
new transition you shipped drawn in the accent while the pre-existing ones stay
neutral. This is how you show "what changed" without a wall of text.

## Animation

Static is the default. Animate only when the motion carries the meaning: a flow
that draws in the direction the data travels, a bar that grows to show a change,
a stage that fills to show progress.

Trigger it once, when the slide becomes active. The template dispatches this by
adding `.is-active` to the current slide, so scope every animation to
`.slide.is-active .viz` and it plays on arrival and resets on leave.

**Draw-on path:**

```css
.slide.is-active .viz .flow {
  stroke-dasharray: var(--len, 600);
  stroke-dashoffset: var(--len, 600);
  animation: draw .9s cubic-bezier(.2,.7,.2,1) forwards;
}
@keyframes draw { to { stroke-dashoffset: 0; } }
```

Set `--len` per path from `path.getTotalLength()` on load, or overshoot with a
constant larger than any path; the overshoot costs a little timing precision and
zero code.

**Staggered node entrance:** `opacity` and a 6px `translateY`, 60ms apart, via
`animation-delay: calc(var(--i) * 60ms)` with `--i` set on each `<g>`.

**Grow a bar:** animate `transform: scaleY()` with `transform-origin` on the
baseline, not the `height` attribute. Height animation forces layout on every
frame; the transform runs on the compositor.

**Live pulse:** a small dot with `r` animating between 3 and 5 at 2s, only for
something genuinely live. Never as decoration.

Everything above sits under:

```css
@media (prefers-reduced-motion: reduce) {
  .viz *, .slide * { animation: none !important; transition: none !important; }
  .viz .flow { stroke-dashoffset: 0; }
}
```

## Checks before a diagram ships

1. Readable at 25% zoom. That is roughly the back row.
2. Understandable in grayscale. Print the slide mentally.
3. Every label has a real word in it, not `Service A`.
4. No text smaller than 11.5px in the `viewBox` scale.
5. Nothing overlaps at 1280x720 or at 1920x1080.
6. A `<title>` that says what the picture shows, for screen readers and for the
   speaker who forgot what the slide meant.
