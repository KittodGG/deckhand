/**
 * widget-loader.js — deckhand
 * Inject widgets ke deck HTML berdasarkan spec dari agent.
 *
 * Tema: widget WAJIB 1 style dengan deck. Loader ini yang menegakkan:
 * - `customization.kind` hanya boleh accent|counter|ok|warn|bad|muted,
 *   di-map ke var(--...) deck. Hex dari agent diabaikan.
 * - Tidak ada palette sendiri di sini.
 */

(function () {
  'use strict';

  var widgetRegistry = new Map();

  var KIND_TO_VAR = {
    accent: 'var(--accent)',
    counter: 'var(--counter)',
    ok: 'var(--ok)',
    warn: 'var(--warn)',
    bad: 'var(--bad)',
    muted: 'var(--muted)'
  };

  function resolveKind(kind) {
    return KIND_TO_VAR[kind] || KIND_TO_VAR.accent;
  }

  function capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }

  async function loadWidget(spec, container) {
    var widgetEl = document.createElement('div');
    widgetEl.className = 'widget-container';
    widgetEl.dataset.widgetType = spec.type;
    if (spec.id) widgetEl.dataset.widgetId = spec.id;

    // Terapkan kind sebagai CSS var lokal agar template widget bisa pakai
    // var(--w-accent) tanpa tahu tema deck.
    var kind = (spec.customization && spec.customization.kind) || 'accent';
    widgetEl.style.setProperty('--w-accent', resolveKind(kind));
    widgetEl.style.setProperty('--w-counter', 'var(--counter)');

    try {
      if (spec.type === 'library') {
        await loadLibraryWidget(spec, widgetEl);
      } else if (spec.type === 'inline') {
        loadInlineWidget(spec, widgetEl);
      } else if (spec.type === 'composed') {
        renderComposedWidget(spec, widgetEl);
      } else {
        throw new Error('Unknown widget type: ' + spec.type);
      }
      container.appendChild(widgetEl);
      widgetRegistry.set(spec.id, widgetEl);
      return widgetEl;
    } catch (error) {
      console.error('Failed to load widget ' + spec.id + ':', error);
      widgetEl.innerHTML = '<div class="widget-error">Failed to load widget</div>';
      container.appendChild(widgetEl);
      return widgetEl;
    }
  }

  async function loadLibraryWidget(spec, container) {
    var response = await fetch(spec.path);
    if (!response.ok) throw new Error('Failed to fetch widget: ' + response.status);
    var html = await response.text();

    // Ambil <template> bila ada, agar file widget boleh bawa <style>/<script> sendiri.
    var tmp = document.createElement('div');
    tmp.innerHTML = html;
    var tpl = tmp.querySelector('template');
    container.innerHTML = '';
    if (tpl) {
      container.appendChild(tpl.content.cloneNode(true));
      // Salin <style> dari file widget (harus sudah pakai var(--...) deck).
      tmp.querySelectorAll('style').forEach(function (s) {
        container.appendChild(s.cloneNode(true));
      });
      tmp.querySelectorAll('script').forEach(function (s) {
        var ns = document.createElement('script');
        ns.textContent = s.textContent;
        container.appendChild(ns);
      });
    } else {
      container.innerHTML = html;
    }

    if (spec.data) injectData(container, spec.data);

    var widgetType = container.querySelector('[data-widget]') &&
      container.querySelector('[data-widget]').dataset.widget;
    if (widgetType) {
      var fnName = 'init' + widgetType.split('-').map(capitalize).join('');
      if (typeof window[fnName] === 'function') {
        window[fnName](container, spec.data || {}, spec.customization || {});
      }
    }
  }

  function loadInlineWidget(spec, container) {
    container.innerHTML = spec.html || '';
    if (spec.css) {
      var style = document.createElement('style');
      style.textContent = spec.css;
      container.appendChild(style);
    }
    if (spec.data) injectData(container, spec.data);
    if (spec.js) {
      try {
        var initFn = new Function('container', 'data', 'customization', spec.js);
        initFn(container, spec.data || {}, spec.customization || {});
      } catch (error) {
        console.error('Widget JS execution failed:', error);
      }
    }
  }

  function renderComposedWidget(spec, container) {
    var composition = document.createElement('div');
    composition.className = 'composed-widget';
    composition.innerHTML =
      '<div class="pill">composed widget — render dari primitives</div>' +
      '<pre class="mono" style="font-size:12px;overflow:auto"></pre>';
    composition.querySelector('pre').textContent = JSON.stringify(spec.primitives || {}, null, 2);
    container.appendChild(composition);
  }

  function injectData(container, data) {
    Object.entries(data).forEach(function ([key, value]) {
      container.querySelectorAll('[data-inject="' + key + '"]').forEach(function (el) {
        if (typeof value === 'object' && value !== null) {
          el.textContent = JSON.stringify(value, null, 2);
        } else {
          el.textContent = value;
        }
      });
    });
  }

  // Auto-boot: render window.WIDGET_SPECS ke [data-widget-slot="..."]
  document.addEventListener('DOMContentLoaded', async function () {
    if (!Array.isArray(window.WIDGET_SPECS)) return;
    for (var i = 0; i < window.WIDGET_SPECS.length; i++) {
      var spec = window.WIDGET_SPECS[i];
      var slot = document.querySelector('[data-widget-slot="' + spec.slot + '"]');
      if (slot) {
        try { await loadWidget(spec, slot); }
        catch (e) { console.error(e); }
      }
    }
  });

  window.WidgetLoader = { loadWidget: loadWidget, widgetRegistry: widgetRegistry, resolveKind: resolveKind };
})();
