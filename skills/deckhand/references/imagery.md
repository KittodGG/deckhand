# Imagery

Photos are the easiest way to make a deck look expensive and the easiest way to
make it look like a template. The difference is whether the picture belongs to
the story.

## What earns a place

1. **Product screenshots.** The strongest image in a progress deck. If you
   changed a screen, show the screen. Ask the user for a screenshot, or take one
   yourself in the browser pane when the app runs locally.
2. **Diagrams.** See the SVG playbook. Prefer drawing over photographing.
3. **A single atmospheric photo** on the title slide or a section break, when
   the deck needs a breath. One or two in a whole deck, not more.

Nothing else. A stock photo of people pointing at a laptop adds zero
information and costs credibility.

## Sourcing

Any source is fine as long as the image is genuinely high quality and licensed
for the use. In practice:

- **Unsplash** and **Pexels** for atmosphere. Pin a specific photo by its ID
  rather than a random-image endpoint, so the deck looks the same every time it
  opens.
- The **project's own assets**: logo, product screenshots, brand photography.
- **Never** an AI-generated photo that pretends to be a real product screen, a
  real person, or a real record. Illustration that is obviously illustration is
  fine.

Credit the photographer in a caption or in the closing slide when the license
asks for it.

## One visual family

Every photo in the deck gets identical treatment. Consistency is what makes
three unrelated photos look intentional:

- Same crop shape. The pill crop is the house style: `border-radius: 999px`,
  aspect ratio near 2.2:1, `object-fit: cover`.
- Same tonal treatment. Pick one and apply it everywhere:
  `filter: grayscale(1)` with an accent overlay at 12 to 18% opacity, or
  `saturate(.85) contrast(1.05)` for a light unified look.
- Same edge. Either every photo has a hairline `--line` border or none does.

```css
.pill--media img {
  display: block; width: 100%; height: 100%;
  object-fit: cover;
  filter: saturate(.9) contrast(1.03);
}
```

Inline media pills sitting inside a headline are the signature move: a headline
word, then a small photo capsule at roughly 0.75em of the line height, then the
rest of the headline. Two per deck at most, or the trick wears out.

## Screenshots

- Capture at 2x, then display at 1x. A blurry screenshot on a projector is
  worse than no screenshot.
- Crop to the part being discussed. A full browser window with tabs and a
  bookmarks bar wastes 60% of the slide.
- Blur or replace real customer names, emails, and financial figures unless the
  room is already cleared for them. Check this every time; it is the one image
  mistake that costs more than the deck is worth.
- Frame it with a hairline border and the card radius, never a fake browser
  chrome mockup.

## Weight and offline use

A deck is one file that gets emailed and opened on a laptop with hotel wifi.

- Remote images: fine for a deck presented from a connected machine, and each
  one is a chance for a grey box on stage.
- If the deck must work offline, embed images as `data:` URIs. Keep the file
  under about 12MB; resize to a 2400px long edge and re-encode as WebP or JPEG
  at quality 80 before embedding.
- Always set `width`/`height` or an `aspect-ratio` so nothing reflows while
  loading.
- Every image gets alt text that says what it shows, not "screenshot".
