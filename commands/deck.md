---
description: Build an HTML progress-update presentation from real git history
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
3. Finish by opening the deck in the browser pane and taking a screenshot of
   the title slide plus one content slide, so the user sees it works.
