---
description: "START HERE. Builds the whole deck: reads real git history, asks scope + audience + language first, writes semi-technical copy, draws its own SVG diagrams. Use /deckhand:deck-svg only for a standalone diagram."
argument-hint: "[optional: 20 commits | since 2026-08-01 | repo path]"
---

Use the `deckhand` skill to build a presentation deck.

User hint (may be empty): $ARGUMENTS

Rules that override any assumption you might make:

1. Run the intake questions first. Even when the hint above already names a
   commit count or a date, you still need audience and language. Never guess
   any of the three.
2. Only report facts you pulled out of git and the working tree. No invented
   metrics, no invented dates, no rounded-up numbers.
3. Finish by opening the deck file itself in the browser pane, by its
   `file:///…` URL, and taking a screenshot of the title slide plus one content
   slide. Never start the project's dev server to do this: the deck is a static
   file, and showing the user their own app on localhost instead of the deck is
   the single most confusing way to end this task.
