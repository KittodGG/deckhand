# deckhand

Turn real git history into a presentation deck someone can sit through.

One `.html` file. No build step, no framework, no server. Double-click to open,
arrow keys to present, `Ctrl/Cmd+P` for a PDF.

## Install

One command. It clones once to `~/.deckhand`, then writes a pointer into every
agent harness that is actually installed on the machine. Config directories that
do not exist are left alone.

```bash
curl -fsSL https://raw.githubusercontent.com/KittodGG/deckhand/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/KittodGG/deckhand/main/install.ps1 | iex
```

Add `--project` (`-Project` on PowerShell) to also point the current repo's
`AGENTS.md` at it, which covers every harness that reads project instructions.
`--uninstall` removes the pointers and the clone, and leaves your own lines in
those files untouched.

Running it again updates in place. It never writes the same block twice.

### Claude Code, with slash commands

The installer drops the skills into `~/.claude/skills/`, which is enough to use
them. Install the plugin instead if you want `/deckhand:deck`:

```bash
claude plugin marketplace add KittodGG/deckhand
claude plugin install deckhand@deckhand
```

The installer detects that and skips the skills copy, so the two never collide.

## Compatibility

The skill is markdown plus one bash script. Nothing in it is tied to a vendor,
so the only question per harness is where the pointer goes.

| Harness | How it loads | Written by the installer |
|---|---|---|
| Claude Code | native skill dir, or the plugin | `~/.claude/skills/`, or `claude plugin install` |
| OpenAI Codex CLI | global instructions | `~/.codex/AGENTS.md` |
| Antigravity CLI / Gemini CLI | global instructions | `~/.gemini/GEMINI.md` |
| OpenCode | AGENTS.md convention | `~/.config/opencode/AGENTS.md` |
| Cursor | AGENTS.md convention | `~/.cursor/AGENTS.md` |
| GitHub Copilot CLI | AGENTS.md convention | `~/.copilot/AGENTS.md` |
| Factory Droid | AGENTS.md convention | `~/.factory/AGENTS.md` |
| Cline, Aider, Goose, Amp, Continue, Pi | AGENTS.md convention | `~/.<harness>/AGENTS.md` |
| Grok Build | reads Claude Code config | whatever the Claude Code row wrote |
| OpenHands, Windsurf, Qwen Code, Crush, anything else | project instructions | `./AGENTS.md` with `--project` |

The mechanism is the same in every row: the harness reads an instruction file,
that file names the skill's path, the agent opens it when the task calls for it.
Rows are grouped by that mechanism rather than by individual testing, so if a
harness moves its config path, point it at
`~/.deckhand/skills/deckhand/SKILL.md` by hand and it works the same.

### By hand, no script

```bash
git clone https://github.com/KittodGG/deckhand ~/.deckhand
```

Then add one line to whatever instruction file your agent reads:

> For progress-update presentations, follow
> `~/.deckhand/skills/deckhand/SKILL.md`.

That is the whole integration. `AGENTS.md` in this repo says the same thing with
a little more context.

## Use

Say it in plain language:

```
buatkan presentasi update dari 20 commit terakhir
make a progress deck for the client, everything since August 1
slide deck of what changed on this branch, for the engineering team
```

On Claude Code with the plugin: `/deckhand:deck`, `/deckhand:deck 30 commits`,
`/deckhand:deck since 2026-08-01`.

It asks four things before writing a single word:

1. **Scope** — last N commits, since a date, or a range like `v2.1..HEAD`.
2. **Audience** — management, client, engineering team, or a mixed room.
3. **Language** — full Indonesian, full English, or mixed (Indonesian sentences
   with English technical terms).
4. **Theme** — light, dark, or follow the viewer's system.

Then it reads the actual commits and diffs, pulls the GitHub issues those
commits reference so the deck can say *why* a change had to happen, groups
everything into themes people care about, writes the copy at a semi-technical
register that a manager follows and an engineer does not find condescending,
runs an anti-slop pass over it, and renders the deck in an editorial style built
on Manrope and Playfair Display using colors pulled from the project itself.

Diagrams get drawn only where a picture genuinely beats a paragraph, usually
three to six in a twenty-slide deck. Where behaviour must be *seen* (a flow,
a triage, a comparison over time), the agent can select from 22
theme-conformant widgets in `skills/deckhand/widgets/` — or invent a custom
one from primitives. Widgets always follow the deck theme (single style via
`var(--...)`, ikut `data-theme` + tombol `D`), never a palette of their own. For an engineering room the next-steps
slide comes ranked High / Medium / Low with a line of justification under each
item, so the room has something to argue with.

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

## Requirements

- `git`, always.
- `bash` for `collect-changes.sh`. Git Bash on Windows.
- `gh`, optional. With it the deck reads the issues behind the commits, which is
  where the reason for a change is usually written. Without it the deck falls
  back to git alone and says so.
- A browser preview, optional. With one the agent verifies by opening the file.
  Without one it runs static checks and prints the path.

## What ships in the box

| Path | What it is |
|---|---|
| `install.sh` / `install.ps1` | detect harnesses, write pointers, update, uninstall |
| `AGENTS.md` | the cross-harness entry point |
| `skills/deckhand/SKILL.md` | the workflow, intake through verification |
| `skills/deckhand/assets/deck-template.html` | the deck shell: slides, keyboard and touch nav, overview grid, progress rail, both themes, print stylesheet, widget slots |
| `skills/deckhand/assets/widget-loader.js` | theme-aware widget loader: injects `window.WIDGET_SPECS` into `[data-widget-slot]`, maps `kind` to deck variables |
| `skills/deckhand/widgets/` | 22 theme-conformant widget templates (7 Agentic OS + 15 general) — 1 style mengikuti tema deck |
| `skills/deckhand/references/widget-primitives.md` | widget building blocks: data / interaction / visual + composition rules + theme rule |
| `skills/deckhand/references/widget-creation.md` | protocol to invent custom widgets + 6 quality gates (incl. theme conformance) |
| `skills/deckhand/references/widget-examples.md` | 22 documented widgets with data formats + selection guide |
| `skills/deckhand/scripts/collect-changes.sh` | commits, churn, contributors, type breakdown, issue refs |
| `skills/deckhand/references/design-system.md` | type scale, palette rules, components, motion budget |
| `skills/deckhand/references/narrative.md` | semi-technical register, depth per audience, language modes |
| `skills/deckhand/references/humanize.md` | the anti-AI-slop pass, English and Indonesian |
| `skills/deckhand/references/svg-playbook.md` | six diagram patterns, house style, animation recipes |
| `skills/deckhand/references/imagery.md` | photo sourcing, one visual family, screenshot hygiene |
| `skills/deck-svg/SKILL.md` | the diagram half, usable on its own anywhere |

## Design notes

Linear-flavored minimalism crossed with editorial layout: oversized type on a
warm neutral ground, a serif italic accent of one to four words per slide,
frosted pill badges, a four-point sparkle where a bullet would normally sit.
Both light and dark palettes ship in the template; pin one with `data-theme` on
`<html>` or leave it to follow the viewer. Every rule, including where you are
allowed to break it, is in `references/design-system.md`.

The anti-slop pass owes its approach to
[blader/humanizer](https://github.com/blader/humanizer). If that skill is
installed, deckhand runs it on the copy and layers deck-specific rules on top.

## License

MIT.
