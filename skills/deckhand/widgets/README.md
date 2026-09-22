# Widget Library (22 widgets)

Library widget interaktif deckhand. Semua widget **theme-conformant**: 1 style
mengikuti tema deck (`data-theme="light|dark"`, toggle `D`).

## Aturan tema (wajib untuk semua widget di folder ini)

- Warna HANYA `var(--ground, --surface, --ink, --ink-soft, --muted, --line,
  --accent, --accent-soft, --counter, --counter-soft, --ok, --warn, --bad)`.
  Jangan hardcode hex (`#10b981` dsb).
- Font warisi deck: Manrope (+ Playfair italic untuk aksen 1–4 kata).
- Radius/shadow dari deck: `--r-card:18px`, `--shadow-card`, border `var(--line)`.
- `kind` di spec hanya boleh `accent|counter|ok|warn|bad|muted` — loader map ke variables.
- Motion: `cubic-bezier(.2,.7,.2,1)`, hormati `prefers-reduced-motion`.

## Kategori

### Dari Agentic OS (7)
1. `benchmark-runner.html` — side-by-side comparison + live counters
2. `inbox-scanner.html` — list scanner + sweep animation
3. `churn-gauge.html` — radial gauge + sparkline
4. `slopology-analyzer.html` — real-time text analyzer
5. `design-selector.html` — tile grid scanner
6. `router-packet.html` — packet flight antar nodes (SVG)
7. `roi-counters.html` — animated counters

### General Purpose (15)
8. `timeline-scrubber.html` 9. `interactive-diff.html`
10. `contributor-network.html` 11. `heatmap-calendar.html`
12. `branch-explorer.html` 13. `file-tree-churn.html`
14. `metric-card.html` 15. `issue-pr-chain.html`
16. `code-ownership-map.html` 17. `before-after-toggle.html`
18. `search-filter.html` 19. `release-train.html`
20. `anomaly-detector.html` 21. `decision-tree.html`
22. `time-machine.html`

## Cara pakai

```html
<section class="slide" data-title="Contributors">
  <div class="slide__inner">
    <div data-widget-slot="contrib"></div>
  </div>
</section>
<script>
window.WIDGET_SPECS = [{
  id: 'contrib', slot: 'contrib', type: 'library',
  path: 'widgets/contributor-network.html',
  data: { nodes: [], edges: [] },
  customization: { kind: 'accent' }
}];
</script>
```

Loader (`../assets/widget-loader.js`) fetch file, inject `data-inject`,
panggil `init<Name>(container, data, customization)`.

## Tambah widget baru

1. Buat `widgets/<nama>.html` dengan `<template>` + `<style>` + `<script>`.
2. Root punya `data-widget="<nama>"`, init function `init<Name>`.
3. Hanya pakai `var(--...)` deck. Test light + dark (tombol `D`).
4. Dokumentasikan di `../references/widget-examples.md`.
5. Jalankan `bash ../scripts/validate-widget.sh`.
