# Widget Primitives

Primitives adalah building blocks untuk membuat widget. Ada 3 kategori: **Data**, **Interaction**, dan **Visual**. Compose primitives ini untuk membuat widget yang sesuai dengan insight.

> **Theme rule (wajib):** widget HARUS 1 style dengan deck. Hanya pakai CSS
> variables dari `assets/deck-template.html`
> (`--ground, --surface, --ink, --ink-soft, --muted, --line, --line-strong,
> --accent, --accent-soft, --counter, --counter-soft, --ok, --warn, --bad`),
> font `Manrope` + `Playfair Display italic` (aksen), angka tabular-nums.
> Jangan hardcode palette (`#10b981`, `#8b5cf6`, `#f59e0b`, dsb) di widget.

---

## 1. Data Primitives

Tipe data yang bisa divisualisasikan:

### `number`
Angka tunggal, optional trend arrow atau sparkline.
- **Contoh:** Total commits: 847 (+23%)
- **Visual channel:** `size` (font besar) atau `position` (vertical bar)
- **Interaction:** `drill` (click untuk breakdown)

### `list`
Array of items, bisa scroll atau paginated.
- **Contoh:** List of commits, list of contributors
- **Visual channel:** `position` (vertical stack), `color` (status)
- **Interaction:** `filter` (search), `drill` (click item untuk detail)

### `graph`
Nodes + edges, untuk networks/trees/flows.
- **Contoh:** Contributor network, file dependency graph, git branch tree
- **Visual channel:** `position` (force layout), `size` (degree), `color` (category)
- **Interaction:** `drill` (click node), `highlight` (hover edges)

### `timeline`
Ordered events dalam waktu.
- **Contoh:** Commit history, release dates
- **Visual channel:** `position` (horizontal), `size` (event importance), `color` (type)
- **Interaction:** `scrub` (drag untuk explore range), `drill` (click event)

### `grid`
2D array, bisa heatmap atau calendar.
- **Contoh:** Contribution heatmap, file churn matrix
- **Visual channel:** `color` (intensity), `position` (row/column)
- **Interaction:** `filter` (by category), `drill` (click cell)

### `text`
String content, bisa panjang atau pendek.
- **Contoh:** Commit message, PR description
- **Visual channel:** `opacity` (highlight keywords), `color` (sentiment)
- **Interaction:** `highlight` (hover untuk emphasize), `reveal` (expand full text)

### `binary`
Yes/no, on/off, before/after.
- **Contoh:** PR merged or rejected, test passed or failed
- **Visual channel:** `color` (green/red), `shape` (check/cross)
- **Interaction:** `compare` (toggle between states)

---

## 2. Interaction Primitives

Cara user interact dengan widget:

### `scrub`
Drag untuk explore range (waktu, values).
- **Affordance:** Draggable handle dengan visual feedback
- **Contoh:** Timeline slider, price range filter
- **Feedback:** Update display real-time saat drag

### `filter`
Narrow down subset berdasarkan criteria.
- **Affordance:** Search box, dropdown, chips
- **Contoh:** Filter commits by author, filter issues by label
- **Feedback:** Items yang tidak match fade out atau hilang

### `drill`
Click untuk expand detail.
- **Affordance:** Cursor pointer, hover highlight, "+" icon
- **Contoh:** Click commit untuk lihat diff, click file untuk lihat history
- **Feedback:** Smooth transition ke detail view

### `compare`
Side-by-side atau toggle antara 2 state.
- **Affordance:** Toggle switch, split view divider
- **Contoh:** Before/after, version A vs B
- **Feedback:** Smooth transition atau split animation

### `highlight`
Emphasize subset tanpa mengubah layout.
- **Affordance:** Hover trigger atau button
- **Contoh:** Highlight top 5 contributors, highlight anomali
- **Feedback:** Dim yang lain, saturate yang di-highlight

### `animate`
Show change over time.
- **Affordance:** Play button atau auto-play
- **Contoh:** Animate commit growth, animate network formation
- **Feedback:** Smooth transitions dengan easing

### `reveal`
Progressively show info (tidak sekaligus).
- **Affordance:** Scroll trigger atau click "show more"
- **Contoh:** Show commit messages one by one, reveal details on demand
- **Feedback:** Staggered fade-in atau slide-in

---

## 3. Visual Primitives

Channel visual untuk encode data. Semua warna HARUS turun dari deck tokens
(`--accent` untuk primer, `--counter` untuk pembanding, `--ok/--warn/--bad`
untuk semantik). Jangan tambah hue baru.

### `position`
X,Y placement dalam 2D space.
- **Data type:** Numerical (continuous) atau categorical (discrete)
- **Contoh:** Scatter plot, bar chart, timeline
- **Rules:** Jangan pakai untuk categorical >10 items (terlalu crowded)

### `size`
Magnitude (width, height, radius).
- **Data type:** Numerical
- **Contoh:** Bar height, bubble radius, font size
- **Rules:** Use linear scale, jangan squared (misleading)

### `color`
Category atau intensity — wajib dari deck tokens.
- **Data type:** Categorical (accent vs counter) atau numerical
  (accent-soft → accent, atau ok/warn/bad untuk status)
- **Contoh:** Category colors, heatmap intensity
- **Rules:** Max 2 data hues (accent + counter) + 3 semantic (ok/warn/bad).
  Intensity via lightness/opacity steps, bukan hue baru.

### `opacity`
Confidence, recency, relevance.
- **Data type:** Numerical (0-1)
- **Contoh:** Old commits faded, uncertain data transparent
- **Rules:** Min opacity 0.2 (harus masih visible)

### `shape`
Type, status, category.
- **Data type:** Categorical
- **Contoh:** Circle vs square untuk different commit types
- **Rules:** Max 5 distinct shapes, harus distinguishable. Jangan encode makna
  hanya via warna (lihat `design-system.md` accessibility).

### `motion`
Transition, pulse, flow.
- **Data type:** Temporal atau state change
- **Contoh:** Packet flight animation, pulse on update
- **Rules:** Duration 200-500ms, easing `cubic-bezier(.2,.7,.2,1)`, jangan loop
  infinite (distracting). Hormati `prefers-reduced-motion`.

---

## Composition Rules

### Rule 1: Data Type → Visual Channel

| Data Type | Best Channels | Avoid |
|-----------|---------------|-------|
| Numerical | `size`, `position` | `color` (hard to compare) |
| Categorical | `color` (accent vs counter), `shape` | `size` (implies magnitude) |
| Temporal | `position` (timeline), `motion` | `color` (unless cyclic) |
| Relational | `position` (graph), `motion` (flow) | `size` (unclear meaning) |

### Rule 2: Insight Type → Interaction Pattern

| Insight | Recommended Interactions | Example Widget |
|---------|-------------------------|----------------|
| Trend over time | `scrub` + `animate` | Timeline dengan slider |
| Outlier detection | `highlight` + `drill` | List dengan anomaly marker |
| Comparison | `compare` (toggle/side-by-side) | Before/after viewer |
| Pattern recognition | `filter` + `highlight` | Heatmap dengan category filter |
| Relationship | `drill` + `highlight` | Network graph |
| Hierarchy | `drill` (expand/collapse) | File tree, org chart |

### Rule 3: Complexity Budget

**JANGAN OVERLOAD:**

- **1 insight per widget** — Jika ada 2 insight, bikin 2 widget atau pilih yang paling penting
- **Max 2 interaction primitives** — Scrub + filter okay. Scrub + filter + drill + compare = terlalu banyak
- **Max 3 visual channels** — Position + size + color okay. Tambah opacity + shape = visual noise

**Contoh violation:**
- ❌ Network graph dengan node size, node color, edge width, edge color, node shape, edge opacity (6 channels)
- ✅ Network graph dengan node size (degree) + node color (accent/counter) + edge opacity (weight) (3 channels)

### Rule 4: Affordance Clarity

Setiap interaction harus punya **visual affordance**:

- `scrub` → Draggable handle dengan grab cursor
- `filter` → Search box dengan placeholder, dropdown dengan chevron
- `drill` → Cursor pointer, hover highlight, "+" atau "→" icon
- `compare` → Toggle switch atau split divider
- `highlight` → Hover state atau button
- `animate` → Play button atau auto-play indicator
- `reveal` → "Show more" button atau scroll indicator

Tanpa affordance, user tidak tahu bisa interact.

### Rule 5: Theme Conformance (deckhand)

- Widget mewarisi `var(--...)` deck — tidak ada `:root` palette sendiri.
- Light/dark otomatis via `data-theme` di `<html>`; jangan tulis
  `@media (prefers-color-scheme)` sendiri di widget.
- Pill/badge di widget memakai class `.pill` deck bila memungkinkan.

---

## Contoh Composition

### Contoh 1: Contributor Leaderboard

**Insight:** "Alice contributed 3x more commits than average in Q3"

**Primitives:**
- Data: `list` (contributors) + `number` (commit count)
- Interaction: `scrub` (time range) + `drill` (click contributor untuk lihat commits)
- Visual: `position` (vertical stack) + `size` (bar width) + `color` (accent untuk top contributor, muted untuk sisanya)

**Result:** Horizontal bar chart dengan time slider, click bar untuk expand commit list.

### Contoh 2: File Churn Heatmap

**Insight:** "auth.ts adalah hotspot — di-edit 47x dalam 2 minggu"

**Primitives:**
- Data: `grid` (file tree) + `number` (edit count per file)
- Interaction: `drill` (click file untuk lihat edit history) + `filter` (by folder)
- Visual: `color` (accent intensity) + `position` (folder hierarchy) + `opacity` (recency)

**Result:** File tree dengan color intensity = edit frequency, click untuk timeline edits.

### Contoh 3: Git Flow Animation

**Insight:** "PR #142 melalui 3 branches sebelum merge ke main"

**Primitives:**
- Data: `graph` (branches) + `timeline` (commits)
- Interaction: `animate` (packet flight dari branch ke branch) + `drill` (click commit)
- Visual: `position` (branch layout) + `motion` (packet animation) + `color` (accent vs counter untuk branch type)

**Result:** Git branch diagram dengan animated packet yang tunjukin flow commit.

---

## Anti-Patterns

### ❌ Terlalu Banyak Interactions
```
Widget dengan: scrub + filter + drill + compare + highlight + animate
```
**Problem:** User bingung mana yang harus dilakukan dulu.
**Fix:** Pilih 2 interactions paling penting.

### ❌ Visual Channel Overload
```
Scatter plot dengan: x, y, size, color, shape, opacity, border
```
**Problem:** Tidak bisa decode semua channels sekaligus.
**Fix:** Max 3 channels, sisanya pakai tooltip.

### ❌ Interaction Tanpa Affordance
```
Graph yang bisa di-click tapi tidak ada cursor pointer atau hover effect
```
**Problem:** User tidak tahu bisa interact.
**Fix:** Tambah cursor pointer, hover highlight, atau icon.

### ❌ Misleading Scale
```
Bar chart dengan y-axis mulai dari 50 (bukan 0)
```
**Problem:** Perbedaan kecil terlihat besar.
**Fix:** Selalu mulai dari 0 untuk bar chart, atau kasih label jelas.

### ❌ Widget Tanpa Insight
```
Pie chart yang cuma menampilkan data tanpa cerita
```
**Problem:** "So what?" — User tidak tahu kenapa ini penting.
**Fix:** Mulai dari insight statement, baru pilih widget.

### ❌ Theme Breakout (deckhand-specific)
```
Widget dengan background #000, accent #10b981, font Space Grotesk sendiri
```
**Problem:** Satu deck terlihat seperti 3 produk berbeda. Light/dark toggle (`D`) tidak mempan ke widget.
**Fix:** Ganti semua ke `var(--surface)`, `var(--accent)`, `Manrope`.
