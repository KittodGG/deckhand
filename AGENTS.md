# deckhand — for agents on any harness

Build an HTML progress-update deck out of real git history. One self-contained
`.html` file, no build step, no framework, no server.

This repo is plain markdown plus one bash script. It carries no harness-specific
runtime, so it works under Claude Code, Codex, Cursor, Gemini CLI, Aider, Cline,
OpenCode, or a bare agent loop with file access and `git`.

## Entry points

| You want | Read |
|---|---|
| a full deck | `skills/deckhand/SKILL.md` — follow it start to finish |
| one diagram, no deck | `skills/deck-svg/SKILL.md` |

`SKILL.md` is the instruction set. Read it fully before starting; the references
it names are loaded on demand, not up front.

## Non-negotiable

Ask the user four things before writing anything, in one message, and wait:

1. **Scope** — last N commits, since a date, or a range like `v2.1..HEAD`.
2. **Audience** — management, client, engineering, or a mixed room.
3. **Language** — full Indonesian, full English, or mixed.
4. **Theme** — light, dark, or follow the system.

Never guess any of them. Never invent a number that is not in the log, a diff, an
issue, or a measurement you ran.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/KittodGG/deckhand/main/install.sh | bash
```

PowerShell: `irm https://raw.githubusercontent.com/KittodGG/deckhand/main/install.ps1 | iex`

It clones to `~/.deckhand` and writes a pointer into every harness config
directory that already exists. `--project` also points the current repo's
`AGENTS.md` at it. `--uninstall` reverses everything and leaves your own lines
alone.

### Or by hand

```bash
git clone https://github.com/KittodGG/deckhand ~/.deckhand
```

Then per harness:

- **Claude Code** — `claude plugin marketplace add KittodGG/deckhand`, then
  install `deckhand@deckhand`. Commands land as `/deckhand:deck`.
- **Codex / Cursor / Gemini CLI / Aider** — add to your project's or global
  agent instructions: "For progress-update presentations, follow
  `~/.deckhand/skills/deckhand/SKILL.md`." That file resolves its own paths
  relative to itself.
- **Anything else** — paste the contents of `skills/deckhand/SKILL.md` into the
  agent's context and keep the repo on disk so it can read the template and the
  references.

`${CLAUDE_PLUGIN_ROOT}` appears in a couple of examples. Off Claude Code, read it
as "the directory this skill lives in".

## What the agent needs

- `git`, always.
- `bash` for `skills/deckhand/scripts/collect-changes.sh`. On Windows, Git Bash.
- `gh`, optional. With it, the deck can read the issues the commits reference,
  which is where the reason for a change is usually written. Without it, the
  deck falls back to git alone and says so.
- A browser preview, optional. With one, verify by opening the file. Without
  one, run the static checks in Step 8 and print the path.
