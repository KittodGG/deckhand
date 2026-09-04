---
name: deckhand
description: >
  The engine behind /deckhand:deck; run that command instead unless you want the
  workflow without its extra guardrails. Builds a self-contained HTML deck about
  what changed in a codebase: progress updates, sprint reviews, demo days,
  stakeholder briefings, client check-ins. Asks scope, audience, and language
  first, reads real git history (last N commits or since a date), turns it into
  semi-technical narrative non-engineers can follow, runs an anti-AI-slop pass,
  and renders it in an editorial / Linear style with Manrope + Playfair Display
  and colors pulled from the project. Draws its own inline SVG diagrams where a
  picture beats a sentence, so no separate diagram skill is needed for a deck.
  Trigger on /deck, "buatkan presentasi update", "presentasi progress", "slide
  deck of what changed", "progress deck", "sprint review slides", "demo deck",
  "presentation for management about this release".
---

# Deckhand

Turn commits into a deck someone can actually sit through.

Output is one `.html` file. No build step, no framework, no server. Opens by
double-click, presents full screen, prints to PDF.

## Step 0 — Which harness you are on

This skill is plain markdown plus one shell script, so it runs anywhere an agent
can read files and run `git`. Nothing below needs a Claude Code tool.

- **Asking questions.** Claude Code has `AskUserQuestion`, which renders the
  intake as pickable options. Everywhere else, ask the same questions as one
  numbered message and wait for the reply. Never split them across turns.
- **Paths.** Under Claude Code the skill lives at `${CLAUDE_PLUGIN_ROOT}`. Under
  any other harness, resolve paths relative to this `SKILL.md`, or to
  `~/.deckhand` / the cloned repo if that is where the user put it.
- **Preview.** Claude Code and Cursor can open the finished file in a browser
  pane. Codex, Gemini CLI, Aider, and a plain terminal cannot: skip the preview
  steps, run the static checks instead, and print the absolute path so the user
  opens it themselves.
- **Sending files.** `SendUserFile` is Claude Code only. Elsewhere, print the
  path.

Everything else in this file is harness-neutral.

## Step 1 — Intake (never skip, never guess)

Ask all four questions in one go before touching git, in a single
`AskUserQuestion` call if the harness has it, otherwise as one numbered message.
If the user already answered one in their prompt, still confirm the rest. Do not
start writing with an assumed audience or an assumed language.

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

**Question 4 — Theme.** header `Tema`:

- `Terang` — pins `data-theme="light"`. The default for a printed handout, a
  bright meeting room, or a projector, which washes out dark backgrounds.
- `Gelap` — pins `data-theme="dark"`. Good for a dim room or a screen share.
- `Ikut sistem` — omit the attribute and the deck follows each viewer's OS
  setting.

Set the attribute on the `<html>` tag. The palette is already defined for both
in the template; do not hand-write a second set of colors. Whatever the choice,
the viewer can still press `D` to flip.

Also worth asking in the same message when the repo is ambiguous: which repo or
subfolder. A monorepo with three apps needs to know which one is on stage.

## Step 2 — Pull the real changes

`<skill>` below is this skill's own directory: `${CLAUDE_PLUGIN_ROOT}/skills/deckhand`
under Claude Code, otherwise wherever this `SKILL.md` sits.

```bash
bash "<skill>/scripts/collect-changes.sh" --count 20
bash "<skill>/scripts/collect-changes.sh" --since 2026-08-01
bash "<skill>/scripts/collect-changes.sh" --range v2.1..HEAD
```

Add `--repo <path>` for a subproject. The script prints subject lines, authors,
dates, changed-file stats, a conventional-commit type breakdown, and the issue
numbers those commits reference.

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

### Read the issues the commits point at

A commit message says what changed. The issue behind it says why it had to
change, who reported it, what it broke, and what "done" meant. That is exactly
the half a progress deck needs and the half git alone cannot give you. Teams
that open an issue before every fix are handing you the narrative for free.

The script's `## ISSUE REFS` section lists the numbers. For each one that will
reach a slide:

```bash
gh issue view <number> --json number,title,body,labels,state,closedAt
gh issue list --state closed --search "closed:>=2026-08-01" --json number,title,labels
```

Pull out: the reported symptom in the reporter's own words, the root cause if it
was written down, the labels (they usually carry severity and area), and whether
it is actually closed. Then use it like this:

- The issue's symptom becomes the "why it mattered" line on the theme slide.
- The reporter's phrasing is better plain-language copy than anything you would
  write. Borrow it.
- An issue still open while its commits are merged is a partial fix, and belongs
  on the open-items slide, not the shipped list.
- Labels feed the priority ranking on the recommendations slide.

Cite issue numbers on the slide only for an engineering audience. `#412` means
nothing to a manager; the sentence from its body means everything.

If `gh` is missing or unauthenticated, say so in one line and continue from git
alone. Do not stall the deck on it, and do not invent an issue's contents.

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
5. The change list — every shipped item, one line each, grouped by kind
6. What broke and how it was handled, when there was something
7. What is still open — honest, dated, no "coming soon" vapor
8. What we recommend next — ranked, see below
9. Close — one ask or one decision needed from the room

**Rank the recommendations.** The next-steps slide is the one engineers argue
about, so give them something to argue with. Group into `High` / `Medium` /
`Low` and put one line of justification under each item:

- `High` — blocks other work, costs the team every day, or is a live risk.
- `Medium` — hurts, but there is a workaround people are already using.
- `Low` — worth doing when there is room. Nothing breaks if it waits.

Two `High` items is a plan. Six is a list nobody will act on, so merge or demote.
The justification line is what makes the ranking arguable instead of arbitrary:
"blocks the staging deploy" beats "important". Issue labels and the open-items
slide are where the ranking comes from, not from a feeling.

For a management-only room, keep the same order but drop the tags: three
sentences in priority order reads better than a triage board.

**Keep display slides rare.** A slide that is one big typographic statement is
worth at most one per deck, and only where it earns the pause: a section break
before a long stretch, or the single number the whole update turns on. In a
progress deck those slides are the ones people tune out on, so the default is
information. Every slide should carry something a listener could repeat back
afterwards. When in doubt, add a row to the change list instead of adding a
slide.

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

Copy it, set `data-theme` on `<html>` per the theme answer, replace the palette
variables and the `<section class="slide">` blocks, and delete the demo slides.
Both palettes are already defined, so a theme choice is one attribute, never a
second stylesheet. Do not restyle it from scratch: the design
is the deliverable's spine, and `references/design-system.md` explains every
rule it encodes, including where you are allowed to depart from it.

Write the file to `presentations/<project>-update-<YYYY-MM-DD>.html` in the
user's repo unless they name a path.

**It is a deck, not a dashboard.** This is the most common way the output goes
wrong: the shell stays correct while the slides fill up with tiles until the
thing reads as a monitoring panel. A dashboard shows many numbers at once so a
reader can scan for anomalies. A deck shows one idea at a time because a speaker
is talking over it. Hard limits:

- One stat row (`.stats`) in the whole deck, on the numbers slide. Nowhere else.
- At most two `.card` blocks on a slide, and never a grid of three or more —
  three equal cards in a row is the corporate-template tell.
- One chart or diagram per slide. Two visuals side by side is a dashboard panel.
- No sidebar, no KPI strip, no widget grid, no per-slide legend or filter row.
- If a slide needs a scrollbar to show everything, it is two slides.

The change list on slide 5 is the one place density belongs, and it is a text
ledger, not tiles.

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

**Never start the project's dev server for this.** The deck is a static file and
has nothing to do with the app. `preview_start` with a `name` from
`.claude/launch.json` boots the product on localhost and shows the user their own
dashboard instead of the deck, which looks exactly like the skill produced the
wrong thing. Open the file and only the file.

**On a harness with a browser preview** (Claude Code, Cursor):

1. Open the deck's own `file:///…` URL. No launch config, no dev server, no
   localhost. If a server is already running, ignore it.
2. Confirm the tab is the deck: the slide counter reads `1 / N`.
3. Read the console — zero errors.
4. Arrow-key through every slide; check nothing overflows at 1280×720 and at
   1920×1080.
5. Screenshot the title slide and one content slide.
6. Hand over the file (`SendUserFile` where it exists, otherwise the path).

**On a harness without one** (Codex, Gemini CLI, Aider, plain terminal), do the
static checks instead and say plainly that you could not open it:

```bash
grep -c '<section class="slide"' <file>   # slide count matches your outline
grep -c '{{' <file>                       # zero placeholders left
```

Then confirm every `{{...}}` is gone, the palette variables are the project's,
and `data-theme` matches what the user asked for.

Either way, tell the user how to open it: double-click, or `start <path>` on
Windows, `open <path>` on macOS, `xdg-open <path>` on Linux. Then how to present
it: `F` full screen, arrows or space to advance, `O` for the overview grid, `D`
to flip light and dark, `Ctrl/Cmd+P` to export a PDF.

## Reference files

| File | Read it when |
|---|---|
| `references/design-system.md` | before writing any HTML or CSS |
| `references/narrative.md` | before writing copy, per audience |
| `references/humanize.md` | after the copy exists, as a pass over it |
| `references/svg-playbook.md` | when a slide might need a diagram |
| `references/imagery.md` | when a slide might need a photo |
