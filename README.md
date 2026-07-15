# WBB6-flying-elements

Small plugin for WoltLab Burning Board / WoltLab Suite Core **6.x** that lets
each registered user turn a piece of animated CSS — the "flying elements"
(`.fly-item`, e.g. falling leaves) — **on or off** from their own account
settings.

The plugin ships the cross-style base CSS centrally, so it no longer has to be
pasted into the ACP or every style. The concrete graphic and animation stay
customizable **per style**.

## How it works

The plugin adds:

- a **user option** `flyingElements` (a checkbox under *Settings → Appearance*),
  enabled by default; and
- a **template listener** that injects a tiny bit of CSS into the page `<head>`
  on every frontend page, across all styles.

The CSS is split across two head hook points so the cascade does the work with
**no `!important`**, and a third listener injects the markup:

| Listener (template / event) | When it loads | What it does |
| --- | --- | --- |
| `headInclude` / `metaTags` | **before** the active style's CSS | base positioning of `.fly-item` (styles can still override size/position) |
| `headInclude` / `stylesheets` | **after** the active style's CSS | controls `display`; hides `.fly-item` only for logged-in users who disabled the option |
| `footer` / `footer` | end of `<body>` | injects the `.fly-item` elements (`fly-1`…`fly-6`) so styles need **CSS only** |

Behavior:

| Visitor | Option | Result |
| --- | --- | --- |
| Guest | – | visible (as before) |
| Logged-in, option on (default) | 1 | visible (as before) |
| Logged-in, option off | 0 | hidden |

## Install

```sh
./build.sh
```

This produces `de.imperatorbob.flyingelements.tar`. Upload it in the ACP under
*Configuration → Packages → Install Package*.

## Per-style customization

The plugin owns the markup, the positioning, and the show/hide. A style only
adds **CSS** — no HTML box, no template edits. Put this in the style's
*Individual CSS* (*ACP → Appearance → Styles → [style] → Individual CSS*):

```css
/* Graphic + animation only. Position, z-index and the on/off switch
   are provided by the plugin. */
.fly-item {
    width: 40px;
    height: 40px;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    top: -60px;
}
.fly-item.fly-1 { left: 10%; background-image: url("leaf1.png"); animation: flyDown 12s linear infinite; }
.fly-item.fly-2 { left: 45%; background-image: url("leaf2.png"); animation: flyDown 15s linear infinite 4s; }
.fly-item.fly-3 { left: 75%; background-image: url("leaf3.png"); animation: flyDown 10s linear infinite 8s; }

@keyframes flyDown {
    0%   { transform: translate(0, 0) rotate(0deg) scale(0.5); opacity: 0; }
    50%  { transform: translate(10vw, 60vh) rotate(180deg) scale(1.2); opacity: 0.7; }
    100% { transform: translate(20vw, 120vh) rotate(360deg) scale(0.3); opacity: 0; }
}
```

Notes:

- The plugin injects `fly-1`…`fly-6`; a style styles as many as it wants. Any
  `.fly-item` a style doesn't define stays invisible (no background, 0 height).
- **No `display` and no `!important`** are needed — the plugin controls those,
  which is what lets the per-user switch win.
- A style that defines no `.fly-item` CSS simply shows nothing.
