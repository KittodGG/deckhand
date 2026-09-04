# deckhand installer for Windows PowerShell.
# One copy on disk, a pointer in every harness that is actually installed.
# Nothing is written to a config directory that does not already exist.
#
#   irm https://raw.githubusercontent.com/KittodGG/deckhand/main/install.ps1 | iex
#   .\install.ps1 -Project
#   .\install.ps1 -Uninstall

param(
  [switch]$Project,
  [switch]$Uninstall,
  [string]$DeckhandHome = "$HOME\.deckhand",
  [string]$Repo = "https://github.com/KittodGG/deckhand"
)

$ErrorActionPreference = 'Stop'
$Start = '<!-- deckhand:start -->'
$End   = '<!-- deckhand:end -->'

function Say($m) { Write-Host "  $m" }

function Get-Block {
  @"
$Start
## deckhand — progress-update presentations

When the user asks for a presentation, slide deck, progress update, sprint
review, or demo deck built from what changed in a repo, follow
``$DeckhandHome\skills\deckhand\SKILL.md`` start to finish.

For a standalone diagram with no deck around it, follow
``$DeckhandHome\skills\deck-svg\SKILL.md``.

Ask scope, audience, language, and theme before writing anything. Never state a
number that is not in the git log, a diff, an issue, or a measurement you ran.
$End
"@
}

function Remove-Block($file) {
  if (-not (Test-Path $file)) { return }
  $out = @(); $skip = $false
  foreach ($line in (Get-Content $file)) {
    if ($line -match [regex]::Escape($Start)) { $skip = $true }
    if (-not $skip) { $out += $line }
    if ($line -match [regex]::Escape($End)) { $skip = $false }
  }
  while ($out.Count -gt 0 -and $out[-1] -eq '') { $out = $out[0..($out.Count - 2)] }
  Set-Content -Path $file -Value $out -Encoding utf8
}

function Write-Block($file) {
  $dir = Split-Path -Parent $file
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  if (-not (Test-Path $file)) { New-Item -ItemType File $file | Out-Null }
  Remove-Block $file
  Add-Content -Path $file -Value "" -Encoding utf8
  Add-Content -Path $file -Value (Get-Block) -Encoding utf8
  Say "pointer  $file"
}

$Targets = @(
  @{ Dir = "$HOME\.codex";           File = "$HOME\.codex\AGENTS.md" },
  @{ Dir = "$HOME\.gemini";          File = "$HOME\.gemini\GEMINI.md" },
  @{ Dir = "$HOME\.config\opencode"; File = "$HOME\.config\opencode\AGENTS.md" },
  @{ Dir = "$HOME\.opencode";        File = "$HOME\.opencode\AGENTS.md" },
  @{ Dir = "$HOME\.cursor";          File = "$HOME\.cursor\AGENTS.md" },
  @{ Dir = "$HOME\.copilot";         File = "$HOME\.copilot\AGENTS.md" },
  @{ Dir = "$HOME\.factory";         File = "$HOME\.factory\AGENTS.md" },
  @{ Dir = "$HOME\.cline";           File = "$HOME\.cline\AGENTS.md" },
  @{ Dir = "$HOME\.aider";           File = "$HOME\.aider\AGENTS.md" },
  @{ Dir = "$HOME\.goose";           File = "$HOME\.goose\AGENTS.md" },
  @{ Dir = "$HOME\.amp";             File = "$HOME\.amp\AGENTS.md" },
  @{ Dir = "$HOME\.continue";        File = "$HOME\.continue\AGENTS.md" },
  @{ Dir = "$HOME\.pi";              File = "$HOME\.pi\AGENTS.md" }
)

if ($Uninstall) {
  Write-Host "Removing deckhand."
  foreach ($p in @("$HOME\.claude\skills\deckhand", "$HOME\.claude\skills\deck-svg")) {
    if (Test-Path $p) { Remove-Item -Recurse -Force $p; Say "removed  $p" }
  }
  foreach ($t in $Targets) { if (Test-Path $t.File) { Remove-Block $t.File; Say "cleaned  $($t.File)" } }
  foreach ($f in @("$HOME\AGENTS.md", ".\AGENTS.md")) { if (Test-Path $f) { Remove-Block $f } }
  if (Test-Path $DeckhandHome) { Remove-Item -Recurse -Force $DeckhandHome; Say "removed  $DeckhandHome" }
  Write-Host "Done."
  return
}

Write-Host "deckhand"

$here = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
if (Test-Path "$DeckhandHome\.git") {
  git -C $DeckhandHome pull --quiet --ff-only 2>$null
  Say "updated  $DeckhandHome"
} elseif (Test-Path "$here\skills\deckhand\SKILL.md") {
  if ($here -ne $DeckhandHome) {
    New-Item -ItemType Directory -Force $DeckhandHome | Out-Null
    Copy-Item -Recurse -Force "$here\skills" $DeckhandHome
    foreach ($f in @('AGENTS.md', 'README.md')) {
      if (Test-Path "$here\$f") { Copy-Item -Force "$here\$f" $DeckhandHome }
    }
  }
  Say "copied   $DeckhandHome"
} else {
  git clone --quiet --depth 1 $Repo $DeckhandHome
  Say "cloned   $DeckhandHome"
}

# Claude Code reads ~/.claude/skills/<name>/SKILL.md with no config file at all.
if (Test-Path "$HOME\.claude") {
  $plugins = "$HOME\.claude\plugins\installed_plugins.json"
  if ((Test-Path $plugins) -and (Select-String -Path $plugins -Pattern 'deckhand@deckhand' -Quiet)) {
    Say "skipped  ~\.claude\skills (plugin deckhand@deckhand already installed)"
  } else {
    New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
    foreach ($s in @('deckhand', 'deck-svg')) {
      $dst = "$HOME\.claude\skills\$s"
      if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
      Copy-Item -Recurse -Force "$DeckhandHome\skills\$s" $dst
    }
    Say "skill    ~\.claude\skills\deckhand"
  }
}

foreach ($t in $Targets) { if (Test-Path $t.Dir) { Write-Block $t.File } }
if ($Project) { Write-Block ".\AGENTS.md" }

Write-Host ""
Write-Host 'Ask any of them: "buatkan presentasi update dari 20 commit terakhir"'
Write-Host "Claude Code with the plugin installed also has /deckhand:deck."
