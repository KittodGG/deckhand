---
name: deck-svg
description: >
  Hand-author a professional inline SVG diagram: architecture and data flow,
  before/after comparison, timeline, pipeline with drop-off, state machine, or a
  small chart. Static or animated, theme-aware through CSS variables, no chart
  library and no external assets. Use when someone asks for a diagram, a
  visualization, "gambarkan alurnya", "bikin diagram", "visualize this
  architecture", "buatkan SVG", or when a slide, README, or doc would be clearer
  with a drawing than with a paragraph.
---

# deck-svg

One diagram, drawn by hand, that inherits the surrounding page's colors and
fonts.

## Before drawing, check the gate

> Would a reader understand this faster from the picture than from two
> sentences of text?

If no, write the two sentences and stop. Diagrams of lists, of two numbers, or
of definitions cost more attention than they return.

## Then

1. Read `../deckhand/references/svg-playbook.md`. It carries the house style,
   the six patterns, the animation recipes, and the shipping checks. Follow it
   rather than inventing a look.
2. Ask what the picture is for if it is not obvious: a slide behind a speaker, a
   README on GitHub, a doc someone reads alone. That changes minimum font size
   and how much detail survives.
3. Match the host page's palette. Use `var(--accent)` and friends when the page
   defines them; fall back to `currentColor` plus one named accent when it does
   not, so the drawing still works in light and dark.
4. Animate only when the motion carries meaning, and only once on arrival.
   Always ship the `prefers-reduced-motion` fallback.
5. Verify before handing it over: readable at 25% zoom, understandable in
   grayscale, real words in every label, nothing overlapping, a `<title>`
   element that says what it shows.

## Output

Inline `<svg>` with a fixed `viewBox`, no `width`/`height` attributes, and
`width: 100%` from CSS. Paste-ready into HTML. If the target is a standalone
`.svg` file instead, say so and add the `xmlns` attribute.
