# Widget Examples — Complete Library (22 Widgets)

Library widget interaktif untuk deckhand. Setiap widget: use case, data format,
interactions, customization, quality gates.

> **Theme rule:** semua widget di `widgets/` HARUS 1 style dengan deck.
> Warna hanya `var(--accent) / --counter / --ok / --warn / --bad / --line`,
> font Manrope (+ Playfair italic untuk aksen), radius/shadow dari
> `design-system.md`. Widget yang hardcode hex sendiri DITOLAK di
> `validate-widget.sh`.

File implementasi ada di `../widgets/<nama>.html`. Format data di bawah adalah
kontrak `window.WIDGET_SPECS[i].data`.

---

## AGENTIC OS WIDGETS (7)

### 1. Benchmark Runner (`benchmark-runner.html`)
Side-by-side comparison dengan live counters.
```json
{
  "left": { "name": "Jev AI", "metrics": { "time": 3.41, "cost": 0.01 } },
  "right": { "name": "GPT-6", "metrics": { "time": 9.93, "cost": 4.80 } },
  "unit": { "time": "seconds", "cost": "USD" }
}
```
Interactions: Run / Reset. Customization: unit labels, animation speed.
Warna: left = `--accent`, right = `--counter`.

### 2. Inbox Scanner (`inbox-scanner.html`)
Triage list dengan verdict badges.
```json
{
  "items": [{ "id": 1, "sender": "PayPal Billing", "subject": "URGENT", "verdict": "scam", "confidence": 99.2 }],
  "totalScanned": 20, "categories": ["scam", "clean"]
}
```
Interactions: Scan (sweep animation), filter by category.
Warna: scam = `--bad`, clean = `--ok`.

### 3. Churn Gauge (`churn-gauge.html`)
Radial gauge + sparkline.
```json
{
  "value": 42, "max": 100, "label": "Churn Risk", "status": "ELEVATED",
  "trend": [35, 38, 42, 45, 42],
  "thresholds": { "low": 35, "medium": 70, "high": 100 }
}
```
Threshold colors: low = `--ok`, medium = `--warn`, high = `--bad`.

### 4. Slopology Analyzer (`slopology-analyzer.html`)
Real-time text analyzer.
```json
{
  "text": "In today's fast-paced...",
  "phrases": ["leverage", "seamless", "cutting-edge"],
  "metrics": { "aiScore": 94, "phraseHits": 18, "cadence": 0.12 }
}
```
Interactions: type/paste → live analysis + highlight.
Highlight memakai `--bad` soft, bukan merah neon hardcode.

### 5. Design Selector (`design-selector.html`)
Tile grid scanner.
```json
{
  "tiles": [{ "id": 1, "name": "Meridian", "tokens": { "accent": "#00a9b4" } }],
  "match": { "id": 1, "confidence": 98.7 }, "scanTime": 0.41
}
```
Match highlight = `var(--accent)` border + `var(--accent-soft)` fill.

### 6. Router Packet (`router-packet.html`)
Packet flight antar nodes (SVG).
```json
{
  "nodes": [
    { "id": "query", "x": 0, "y": 50, "label": "Query In" },
    { "id": "classifier", "x": 50, "y": 50, "label": "Classifier" },
    { "id": "model-a", "x": 100, "y": 25, "label": "Model A" }
  ],
  "edges": [{ "from": "query", "to": "classifier" }],
  "packets": [{ "route": ["query", "classifier", "model-a"], "kind": "accent" }]
}
```
`kind: accent|counter` — jangan kirim hex dari agent; loader map ke variables.

### 7. ROI Counters (`roi-counters.html`)
Animated number counters.
```json
{
  "counters": [
    { "label": "Time Saved", "value": 78, "suffix": "%", "kind": "accent" },
    { "label": "Cost Reduction", "value": 99.2, "suffix": "%", "kind": "ok" }
  ],
  "animationDuration": 1200
}
```

---

## GENERAL PURPOSE WIDGETS (15)

### 8. Timeline Scrubber (`timeline-scrubber.html`)
```json
{
  "events": [{ "date": "2024-01-15", "title": "Commit #142", "author": "alice", "type": "commit", "details": "Fix auth bug" }],
  "range": { "start": "2024-01-01", "end": "2024-03-31" }
}
```
Drag slider → filter range, click event → detail.

### 9. Interactive Diff Viewer (`interactive-diff.html`)
```json
{
  "file": "src/auth.ts",
  "before": { "lines": [{ "num": 2, "content": "return false;", "type": "deleted" }] },
  "after": { "lines": [{ "num": 2, "content": "return validate();", "type": "added" }] }
}
```
Added = `--ok` soft, deleted = `--bad` soft. Toggle unified/split.

### 10. Contributor Network (`contributor-network.html`)
```json
{
  "nodes": [{ "id": "alice", "commits": 120, "role": "backend" }],
  "edges": [{ "source": "alice", "target": "bob", "weight": 15 }]
}
```
Node size = commits, edge width = weight. Drag + click profile.

### 11. Heatmap Calendar (`heatmap-calendar.html`)
```json
{ "days": [{ "date": "2024-01-01", "count": 5 }], "weekStart": "monday" }
```
Intensity = `--accent` opacity steps (bukan green GitHub hardcode),
agar ikut tema deck. Hover tooltip, click day → events.

### 12. Branch Explorer (`branch-explorer.html`)
```json
{
  "branches": [{ "name": "main", "commits": [{ "sha": "abc123", "message": "Initial", "date": "2024-01-01" }] }]
}
```
Click branch → expand commits.

### 13. File Tree with Churn (`file-tree-churn.html`)
```json
{
  "tree": [{ "name": "src", "type": "folder", "children": [{ "name": "auth.ts", "type": "file", "edits": 47 }] }],
  "maxEdits": 50
}
```
Churn color = `--counter`/`--bad` opacity steps. Click file → history.

### 14. Metric Card (`metric-card.html`)
```json
{
  "value": 847, "label": "Total Commits", "trend": "+23%",
  "trendDirection": "up", "sparkline": [12, 15, 18, 22, 28, 35]
}
```
Click → drill-down. Sparkline stroke = `var(--accent)`.

### 15. Issue → PR → Commit Chain (`issue-pr-chain.html`)
```json
{
  "issue": { "number": 142, "title": "Auth bug", "status": "closed" },
  "pr": { "number": 145, "title": "Fix auth", "status": "merged" },
  "commits": [{ "sha": "abc123", "message": "Fix auth token validation" }]
}
```
Status colors: merged/closed = `--ok`, open = `--warn`.

### 16. Code Ownership Map (`code-ownership-map.html`)
```json
{
  "files": [{ "path": "src/auth.ts", "owner": "alice", "size": 1234 }],
  "owners": [{ "id": "alice", "kind": "accent" }, { "id": "bob", "kind": "counter" }]
}
```
Maks 8 owners; lebih dari itu group jadi "others" (`--muted`).

### 17. Before/After Toggle (`before-after-toggle.html`)
```json
{
  "before": { "title": "v1.0", "content": "Old...", "metrics": { "performance": 45 } },
  "after": { "title": "v2.0", "content": "New...", "metrics": { "performance": 89 } }
}
```
Before = `--counter` label, after = `--accent` label.

### 18. Search & Filter Interface (`search-filter.html`)
```json
{
  "items": [{ "id": 1, "title": "Commit #142", "author": "alice", "date": "2024-01-15", "tags": ["auth"] }],
  "filters": [{ "field": "author", "type": "dropdown", "options": ["alice", "bob"] }]
}
```

### 19. Release Train (`release-train.html`)
```json
{
  "releases": [{ "version": "v1.0", "date": "2024-01-01", "highlights": ["Initial release"], "commits": 45 }]
}
```
Click release → expand changelog.

### 20. Anomaly Detector (`anomaly-detector.html`)
```json
{
  "series": [{ "date": "2024-01-01", "value": 12 }],
  "anomalies": [{ "date": "2024-01-15", "value": 87, "reason": "10x spike" }]
}
```
Anomaly marker = `--bad`, hover → explanation.

### 21. Decision Tree (`decision-tree.html`)
```json
{
  "nodes": [
    { "id": "start", "label": "PR Submitted", "type": "start" },
    { "id": "tests", "label": "Tests Pass?", "type": "decision" }
  ],
  "edges": [{ "from": "start", "to": "tests" }]
}
```

### 22. Time Machine (`time-machine.html`)
```json
{
  "commits": [{ "sha": "abc123", "date": "2024-01-01", "message": "Initial commit" }],
  "states": { "abc123": { "files": ["README.md"], "stats": { "files": 2, "lines": 150 } } }
}
```
Scrub timeline → switch commit state.

---

## Widget Selection Guide

| Insight Type | Recommended Widgets |
|--------------|---------------------|
| Single metric dengan trend | Metric Card, ROI Counters |
| Comparison (A vs B) | Benchmark Runner, Before/After Toggle |
| Activity over time | Timeline Scrubber, Heatmap Calendar, Release Train |
| List triage/scanning | Inbox Scanner, Search & Filter |
| Risk/health score | Churn Gauge |
| Text analysis | Slopology Analyzer |
| Matching/selection | Design Selector |
| Flow/routing | Router Packet, Decision Tree |
| Network/collaboration | Contributor Network |
| Code changes | Interactive Diff Viewer |
| Repository structure | File Tree Churn, Branch Explorer, Code Ownership Map |
| Trace story | Issue → PR → Commit Chain, Time Machine |
| Outlier detection | Anomaly Detector |

## Widget Combinations

### Combo 1: "Repository Health Dashboard"
Metric Cards (4 KPIs) + Heatmap Calendar + File Tree Churn.

### Combo 2: "Release Deep-Dive"
Release Train + Timeline Scrubber + Contributor Network.

### Combo 3: "PR Journey"
Issue → PR → Commit Chain + Interactive Diff Viewer + Decision Tree.

### Combo 4: "Performance Analysis"
Benchmark Runner + Anomaly Detector + Time Machine.

## Customization kontrak (theme-safe)

```json
{
  "type": "library",
  "path": "widgets/metric-card.html",
  "data": { "value": 847, "label": "Total Commits" },
  "customization": {
    "kind": "accent",
    "showSparkline": true,
    "enableDrillDown": false
  }
}
```

`kind` hanya boleh: `accent | counter | ok | warn | bad | muted`.
Jangan kirim `color: "#..."` dari agent — loader yang map ke `var(--...)`.
