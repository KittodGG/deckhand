# Widget Creation Protocol

Gunakan protocol ini ketika perlu membuat widget custom yang tidak ada di library dan tidak bisa di-compose dari primitives dengan cara standard.

> **Theme rule:** output widget HARUS 1 style dengan deck. Lihat Rule 5 di
> `widget-primitives.md`. Semua sketch dan build memakai tokens
> `--ground/--surface/--ink/--accent/--counter/--ok/--warn/--bad`.

---

## Step 1: Insight Statement

Tulis insight dalam **1 kalimat spesifik**. Harus ada angka atau comparison.

**✅ Good:**
- "auth.ts di-edit 47x dalam 2 minggu, 10x lebih sering dari rata-rata file"
- "Alice contribute 3x lebih banyak commits daripada member lain di Q3"
- "PR #142 stuck di review selama 14 hari, 3x lebih lama dari average"

**❌ Bad:**
- "Show file churn" (tidak spesifik)
- "Contributor stats" (tidak ada insight)
- "PR timeline" (tidak ada cerita)

**Template:**
```
[Subject] [verb] [angka], [comparison/context]
```

---

## Step 2: Core Question

Apa yang harus bisa dijawab user setelah lihat widget ini?

**Contoh:**
- "File mana yang paling sering berubah?"
- "Kapan aktivitas repo paling tinggi?"
- "Siapa yang paling banyak contribute?"
- "Kenapa PR ini lama di-merge?"

Jika tidak bisa articulate core question, insight-nya belum cukup jelas. Kembali ke Step 1.

---

## Step 3: Visual Metaphor

Pilih metaphor visual yang **natural** untuk insight:

| Insight Type | Natural Metaphors |
|--------------|-------------------|
| Comparison | Leaderboard, racing bars, side-by-side cards |
| Distribution | Histogram, scatter plot, box plot |
| Flow | Sankey diagram, river, pipeline |
| Hierarchy | Treemap, sunburst, org chart |
| Network | Force graph, adjacency matrix, arc diagram |
| Time | Timeline, Gantt chart, calendar heatmap |
| Geographic | Map dengan markers atau choropleth |
| Process | Flowchart, decision tree, swimlane |

**Pertanyaan guide:**
- Apakah ini tentang **ranking**? → Leaderboard
- Apakah ini tentang **perubahan over time**? → Timeline
- Apakah ini tentang **hubungan antar entities**? → Network
- Apakah ini tentang **proporsi**? → Treemap atau stacked bar

---

## Step 4: Sketch 3 Opsi

Buat 3 quick sketches dengan complexity berbeda:

### Option A: Simple
- Minimal interactions (1 saja)
- Minimal visual channels (2 saja)
- Fokus ke clarity
- **Contoh:** Bar chart dengan hover tooltip

### Option B: Medium
- 2 interactions (e.g., scrub + drill)
- 3 visual channels
- Balance antara insight depth dan simplicity
- **Contoh:** Timeline dengan slider + click untuk expand detail

### Option C: Ambitious
- Multiple interactions
- Rich visual encoding
- High insight density
- **Contoh:** Network graph dengan filter, drill, dan animation

**Tulis untuk tiap opsi:**
1. Visual description (1-2 kalimat)
2. Interactions yang dipakai
3. Data yang dibutuhkan
4. Estimated complexity (Low/Medium/High)

---

## Step 5: Pilih Terbaik + Justifikasi

Pilih 1 opsi dan tulis **kenapa**:

**Template justifikasi:**
```
Pilih Option [A/B/C] karena:
- Clarity: [alasan]
- Insight depth: [alasan]
- Feasibility: [alasan]
- Time budget: [alasan]
```

**Contoh:**
```
Pilih Option B karena:
- Clarity: Timeline familiar, tidak perlu explanation
- Insight depth: Bisa lihat trend + drill ke specific commit
- Feasibility: Tidak perlu complex graph layout
- Time budget: Bisa implement dalam 2 jam
```

**Pertimbangan:**
- Jika audience technical → boleh Option C
- Jika audience management → Option A atau B
- Jika waktu terbatas → Option A
- Jika insight complex → Option B atau C

---

## Step 6: Build dari Primitives

Decompose widget ke primitives (lihat `widget-primitives.md`):

**Template:**
```markdown
### Data Primitives
- [tipe]: [deskripsi]

### Interaction Primitives
- [tipe]: [trigger] → [action]

### Visual Primitives
- [channel]: [encode apa] (wajib sebut token deck yang dipakai)
```

**Contoh untuk File Churn Heatmap:**
```markdown
### Data Primitives
- grid: File tree structure (folders → files)
- number: Edit count per file
- timeline: Edit history per file (untuk drill-down)

### Interaction Primitives
- drill: Click file → expand edit history timeline
- filter: Dropdown folder → show only files in that folder
- highlight: Hover file → tooltip dengan stats

### Visual Primitives
- color: Edit intensity via --accent opacity steps (bukan hue baru)
- position: Folder hierarchy (indented tree)
- opacity: Recency (recent full, old faded)
```

**Theme checklist saat build:**
- [ ] Tidak ada hex hardcode kecuali `currentColor` / `transparent`
- [ ] Tidak ada `<link>` font sendiri — warisi Manrope/Playfair dari deck
- [ ] Radius/shadow pakai `--r-card` / `--shadow` deck
- [ ] Test dengan `data-theme="light"` dan `"dark"` (atau tekan `D`)

---

## Step 7: Quality Gates

Test widget terhadap **5 quality gates** + 1 gate tema. Semua harus PASS sebelum masuk deck.

### Gate 1: Clarity
**Test:** Tunjukkan widget ke orang yang tidak tahu context, tanya "ini tentang apa?"

**Pass jika:**
- Bisa jawab dalam 5 detik
- Tidak perlu explanation tambahan
- Insight langsung terlihat

**Fix jika fail:** Simplify, tambah label, increase contrast untuk insight utama.

### Gate 2: Data Honesty
**Test:** Apakah visualisasi jujur sama data?

**Pass jika:**
- Axis mulai dari 0 (untuk bar chart)
- Scale linear (tidak log tanpa alasan)
- Tidak ada truncated axis yang misleading
- Color intensity proportional ke value

**Fix jika fail:** Mulai axis dari 0, use linear scale, tambah gridlines dan labels.

### Gate 3: Interaction Affordance
**Test:** Apakah jelas bagaimana cara interact?

**Pass jika:**
- Draggable elements punya grab cursor
- Clickable elements punya pointer cursor + hover effect
- Ada icon atau text hint ("Click to expand", "Drag to filter")
- Feedback immediate (<100ms) saat interact

**Fix jika fail:** Tambah cursor styles, hover effects, tooltip, optimize performance.

### Gate 4: Mobile Friendly
**Test:** Apakah usable di layar 375px width?

**Pass jika:**
- Text masih readable (min 14px)
- Touch targets cukup besar (min 44×44px)
- Layout tidak broken (no horizontal scroll)
- Interactions work dengan touch

**Fix jika fail:** Increase font sizes, responsive layout (flexbox/grid), tap equivalents untuk hover.

### Gate 5: Performance
**Test:** Apakah render dan interaction fast?

**Pass jika:**
- Initial render <500ms
- Interaction feedback <100ms
- No jank (60fps animations)
- Memory usage reasonable (<50MB)

**Fix jika fail:** Lazy load, virtualize long lists, debounce, pakai CSS transforms (GPU-accelerated).

### Gate 6: Theme Conformance (deckhand)
**Test:** Taruh widget di deck light dan dark, tekan `D`.

**Pass jika:**
- Tidak ada elemen yang "lepas" (background hitam di deck terang, teks hilang di deck gelap).
- Pill/badge/widget border memakai `var(--line)`.
- Aksen memakai `var(--accent)` / `var(--counter)`, status memakai `var(--ok/--warn/--bad)`.
- `grep -E '#[0-9a-fA-F]{3,6}' widget.html` hanya mengembalikan `currentColor`/SVG generik — tidak ada palette sendiri.

**Fix jika fail:** Replace semua hex dengan variables deck.

---

## Contoh End-to-End

### Context
Commits show bahwa file `auth.ts` di-edit 47 kali dalam 2 minggu, padahal file lain rata-rata 3-5 kali.

### Step 1: Insight Statement
"auth.ts adalah hotspot — di-edit 47x dalam 2 minggu, 10x lebih sering dari rata-rata file"

### Step 2: Core Question
"File mana yang paling sering berubah, dan kapan perubahan terjadi?"

### Step 3: Visual Metaphor
Ini tentang **hierarchy** (file tree) + **intensity** (edit frequency) + **time** (when edits happened).

Metaphor candidates:
- Treemap dengan color intensity
- File tree dengan heatmap
- Calendar heatmap per file

### Step 4: Sketch 3 Opsi

**Option A: Simple Treemap**
- Treemap dengan rectangle size = file size, color = edit count (accent steps)
- Interaction: Hover untuk tooltip
- Complexity: Low

**Option B: File Tree Heatmap**
- Indented file tree dengan color intensity = edit count
- Interaction: Click file untuk expand edit timeline
- Complexity: Medium

**Option C: Interactive File Explorer**
- File tree + calendar heatmap per file + timeline scrubber
- Interaction: Drill, filter by folder, scrub time range
- Complexity: High

### Step 5: Pilih + Justifikasi
**Pilih Option B** karena:
- Clarity: File tree familiar untuk developers
- Insight depth: Bisa lihat hierarchy + drill ke timeline
- Feasibility: Tidak perlu complex treemap layout algorithm
- Time budget: Implementable dalam 3 jam

### Step 6: Build dari Primitives

**Data:**
- grid: File tree structure
- number: Edit count per file
- timeline: Edit dates per file

**Interaction:**
- drill: Click file → expand timeline
- highlight: Hover → tooltip dengan stats

**Visual:**
- color: Edit intensity via `--accent` opacity steps
- position: Folder hierarchy (indented)
- opacity: Recency (recent full, old faded)

### Step 7: Quality Gates
- ✅ Clarity: File tree familiar, color intensity intuitive
- ✅ Honesty: Linear color scale, no distortion
- ✅ Affordance: Cursor pointer on files, hover tooltip
- ✅ Mobile: Collapse tree levels, tap to expand
- ✅ Performance: Virtualize tree jika >100 files
- ✅ Theme: Lolos light/dark, hanya pakai deck tokens

**Result:** Widget "File Churn Heatmap" ready untuk deck.

---

## Checklist Final

Sebelum commit widget ke deck, pastikan:

- [ ] Insight statement jelas (1 kalimat dengan angka)
- [ ] Core question terjawab oleh widget
- [ ] Visual metaphor natural untuk insight
- [ ] Complexity budget tidak dilanggar (1 insight, max 2 interactions, max 3 visual channels)
- [ ] Semua 5 quality gates + theme gate PASS
- [ ] Widget di-test di mobile (375px width)
- [ ] Performance OK (render <500ms, interaction <100ms)
- [ ] Theme OK (light + dark, hanya deck tokens, ikut tombol `D`)
