---
name: deckhand
description: >
  Build a self-contained HTML presentation deck about what changed in a codebase:
  development progress updates, sprint reviews, demo days, stakeholder briefings,
  client check-ins. Reads real git history (last N commits, or everything since a
  date), turns it into semi-technical narrative that non-engineers can follow, and
  renders it in an editorial / Linear style with Manrope + Playfair Display,
  colors pulled from the project itself, and SVG visuals only where a picture
  beats a sentence.
  Trigger on /deck, "buatkan presentasi update", "presentasi progress", "slide
  deck of what changed", "progress deck", "sprint review slides", "demo deck",
  "presentation for management about this release".
---

# Deckhand

Turn commits into a deck someone can actually sit through.

Output is one `.html` file. No build step, no framework, no server. Opens by
double-click, presents full screen, prints to PDF.

## Step 1 — Intake (never skip, never guess)

Ask all three questions in a single `AskUserQuestion` call before touching git.
If the user already answered one in their prompt, still confirm the other two.
Do not start writing with an assumed audience or an assumed language.

**Question 1 — Scope.** header `Cakupan`

| Option | Meaning |
|---|---|
| `Last N commits` | ask for N, offer 10 / 20 / 50 as options |
| `Since a date` | ask for the date, `YYYY-MM-DD` |
| `Since a tag or branch point` | e.g. `v2.1..HEAD`, `main..develop` |

**Question 2 — Audience.** header `Audiens`. Options worth offering:
management / non-technical stakeholders, client, internal engineering team,
mixed (management sitting with engineers). Audience decides depth, not honesty:
you never hide a problem, you change how much machinery you explain.

**Question 3 — Language.** header `Bahasa`:

- `Full Indonesia` — every sentence Indonesian. Technical nouns that have no
  natural Indonesian form stay English (endpoint, deploy, cache, migration).
- `Full English`
- `Campur` — Indonesian sentences, English technical terms, which is how most
  Indonesian engineering teams actually talk.

Also worth asking in the same call when the repo is ambiguous: which repo or
subfolder. A monorepo with three apps needs to know which one is on stage.

## Step 2 — Pull the real changes

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/deckhand/scripts/collect-changes.sh" --count 20
bash "${CLAUDE_PLUGIN_ROOT}/skills/deckhand/scripts/collect-changes.sh" --since 2026-08-01
bash "${CLAUDE_PLUGIN_ROOT}/skills/deckhand/scripts/collect-changes.sh" --range v2.1..HEAD
```

Add `--repo <path>` for a subproject. The script prints subject lines, authors,
dates, changed-file stats, and a conventional-commit type breakdown.

Then go deeper than the subject lines. Commit messages are a table of contents,
not the content. For anything that will get its own slide, read the diff
(`git show --stat <sha>`, then the actual hunks) so you can say what the feature
does for a user, not what the commit renamed. A slide that only paraphrases a
commit subject is a slide that wasted a minute of someone's life.

Group the raw log into 4 to 8 themes. Themes are user-facing, not
type-facing: "Approval flow now survives a rejected step" beats "12 fixes".

**Facts only.** Every number on a slide comes from the log, the diff, a test
run, or a benchmark you actually executed. If you want to claim something got
faster, measure it or drop the claim.

## Step 3 — Read the project's identity

Before styling, spend a couple of minutes learning what the project looks like:

- Accent colors: `tailwind.config.*`, `theme.json`, `:root` CSS variables,
  `app.json` / `app.config.*` for Expo, brand hex codes in `CLAUDE.md` or
  `DESIGN.md`.
- Product name, version, current release channel: `package.json`, changelog.
- Stack, so vocabulary matches reality.

Feed the accent color into the palette per `references/design-system.md`. If the
project has no color of its own, use the neutral default in that file and say so
to the user in one line.

## Step 4 — Outline before HTML

Write the slide list as plain text and show it to the user before building. A
deck that reads well as a bullet list reads well as slides; one that does not
will not be rescued by typography.

Default arc, stretch or trim as the material demands (no slide limit):

1. Title — product, period covered, who it is for
2. The one-paragraph version — what changed, in five lines
3. Numbers that are actually true — commits, files, features shipped, period
4. One theme per section: what it does, why it mattered, what it took
5. What broke and how it was handled, when there was something
6. What is still open — honest, dated, no "coming soon" vapor
7. Next period's focus
8. Close — one ask or one decision needed from the room

## Step 5 — Write the copy

Follow `references/narrative.md` for depth and framing, and
`references/humanize.md` for the anti-slop pass. The humanize pass is not
optional; run it over the finished copy before it goes into the HTML.

Short version of both: lead with the effect on the person in the room, name the
mechanism in one clause, keep sentence lengths uneven, cut every phrase that
would survive being deleted.

## Step 6 — Build the deck

Start from `assets/deck-template.html`. It carries the whole system already:
fonts, palette variables, slide mechanics, keyboard and touch navigation,
overview grid, progress rail, print stylesheet, reveal animation, and the
component vocabulary (pills, badges, sparkles, stat blocks, editorial titles).

Copy it, replace the palette variables and the `<section class="slide">`
blocks, and delete the demo slides. Do not restyle it from scratch: the design
is the deliverable's spine, and `references/design-system.md` explains every
rule it encodes, including where you are allowed to depart from it.

Write the file to `presentations/<project>-update-<YYYY-MM-DD>.html` in the
user's repo unless they name a path.

## Step 7 — Visuals, only where they earn it

Read `references/svg-playbook.md`. The gate before drawing anything:

> Would a reader understand this faster from the picture than from two
> sentences of text?

Yes for: architecture and data flow, before/after of a process, a timeline with
overlap, a comparison across three or more dimensions, a pipeline with stages.
No for: a list, two numbers, a definition, "our values", decoration.

Most decks need 3 to 6 real visuals. A deck where every slide has a diagram is
a deck where none of them mean anything. Photos follow
`references/imagery.md` — one visual family, never decorative filler.

## Step 8 — Verify, then hand it over

1. Open it in the browser pane (`preview_start` with a `file://` URL).
2. `read_console_messages` — zero errors.
3. Arrow-key through every slide; check nothing overflows at 1280×720 and at
   1920×1080.
4. Screenshot the title slide and one content slide.
5. Send the file with `SendUserFile`.

Tell the user how to present it: `F` full screen, arrows or space to advance,
`O` for the overview grid, `Ctrl/Cmd+P` to export a PDF.

## Reference files

| File | Read it when |
|---|---|
| `references/design-system.md` | before writing any HTML or CSS |
| `references/narrative.md` | before writing copy, per audience |
| `references/humanize.md` | after the copy exists, as a pass over it |
| `references/svg-playbook.md` | when a slide might need a diagram |
| `references/imagery.md` | when a slide might need a photo |
