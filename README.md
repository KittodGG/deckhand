# deckhand

Turn real git history into a presentation deck someone can sit through.

One `.html` file. No build step, no framework, no server. Double-click to open,
arrow keys to present, `Ctrl/Cmd+P` for a PDF.

## What it does

You run `/deck`. It asks four things before writing a single word:

1. **Scope** — last N commits, everything since a date, or a range like
   `v2.1..HEAD`.
2. **Audience** — management, client, engineering team, or a mixed room.
3. **Language** — full Indonesian, full English, or mixed (Indonesian sentences
   with English technical terms).
4. **Theme** — light, dark, or follow the viewer's system.

Then it reads the actual commits and diffs, pulls the GitHub issues those
commits reference so the deck can say *why* a change had to happen, groups them
into themes people care about, writes the copy at a semi-technical register that a manager follows and
an engineer does not find condescending, runs an anti-slop pass over it, and
renders the deck in an editorial style built on Manrope and Playfair Display,
using colors pulled from the project itself.

Diagrams get drawn only where a picture genuinely beats a paragraph. Usually
three to six in a twenty-slide deck. For an engineering room, the next-steps
slide comes ranked High / Medium / Low with a line of justification under each
item, so the room has something to argue with.

## Install

```bash
/plugin marketplace add KittodGG/deckhand
/plugin install deckhand@deckhand
```

Or from a local clone:

```bash
/plugin marketplace add /path/to/deckhand
/plugin install deckhand@deckhand
```

**Not on Claude Code?** The skill is plain markdown plus one bash script, so it
runs under Codex, Cursor, Gemini CLI, Aider, and anything else that can read
files and run `git`. Clone it and point your agent at
`skills/deckhand/SKILL.md`; `AGENTS.md` has the per-harness lines.

## Use

```
/deck
/deck 30 commits
/deck since 2026-08-01
```

The skill also triggers on plain requests: "buatkan presentasi update sprint
ini", "make a progress deck for the client", "slide deck of what changed since
July".

## Which entry point

The plugin exposes three names. Only the first is the one you normally type.

| Entry | What it is | When |
|---|---|---|
| `/deckhand:deck` | the command, and the whole job: git history, intake, copy, **SVG diagrams**, verification | building a deck |
| `/deckhand:deckhand` | the skill the command drives, minus the command's extra guardrails | rarely typed; fires on its own from plain requests like "bikin presentasi update sprint ini" |
| `/deckhand:deck-svg` | one standalone diagram, no deck around it | a picture for a README, a doc, or a slide that already exists |

A deck already contains its diagrams. `deck-svg` exists for the times you want a
drawing and nothing else.

## What ships in the box

| Path | What it is |
|---|---|
| `AGENTS.md` | how to run it outside Claude Code |
| `skills/deckhand/SKILL.md` | the workflow, intake through verification |
| `skills/deckhand/assets/deck-template.html` | the deck shell: slides, keyboard and touch nav, overview grid, progress rail, print stylesheet |
| `skills/deckhand/scripts/collect-changes.sh` | pulls commits, churn, contributors, type breakdown |
| `skills/deckhand/references/design-system.md` | type scale, palette rules, components, motion budget |
| `skills/deckhand/references/narrative.md` | semi-technical register, depth per audience, language modes |
| `skills/deckhand/references/humanize.md` | the anti-AI-slop pass, English and Indonesian |
| `skills/deckhand/references/svg-playbook.md` | six diagram patterns, house style, animation recipes |
| `skills/deckhand/references/imagery.md` | photo sourcing, one visual family, screenshot hygiene |
| `skills/deck-svg/SKILL.md` | the diagram half, usable on its own anywhere |

## Presenting

| Key | Action |
|---|---|
| `→` `space` `PgDn` | next |
| `←` `PgUp` | previous |
| `F` | full screen |
| `O` | overview grid |
| `Esc` | leave overview |
| `D` | flip light and dark |
| `Ctrl/Cmd+P` | print, one landscape page per slide, speaker notes included |

Slides deep-link: `#slide-7` opens on slide 7.

## Design notes

The style is Linear-flavored minimalism crossed with editorial layout:
oversized type on a warm neutral ground, a serif italic accent of one to four
words per slide, frosted pill badges, a four-point sparkle where a bullet would
normally sit. Every rule, including where you are allowed to break it, is in
`references/design-system.md`.

The anti-slop pass owes its approach to
[blader/humanizer](https://github.com/blader/humanizer). If that skill is
installed, deckhand runs it on the copy and layers deck-specific rules on top.

## License

MIT.
