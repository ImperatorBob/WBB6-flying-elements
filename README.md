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
**no `!important`**:

| Hook (`headInclude` event) | When it loads | What it does |
| --- | --- | --- |
| `metaTags` | **before** the active style's CSS | base positioning of `.fly-item` (styles can still override size/position) |
| `stylesheets` | **after** the active style's CSS | controls `display`; hides `.fly-item` only for logged-in users who disabled the option |

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

## Migration (after installing)

The plugin now owns the show/hide of `.fly-item`, so clean up the old CSS:

1. **Remove the `.fly-item` base block** (`display:none`, `position:fixed`, …)
   from the ACP custom CSS / style — the plugin delivers it now.
2. In your **per-style CSS**, remove any `display` / `!important` rules on
   `.fly-item`. **Keep** the `@keyframes`, the `animation:` property, the
   `background-image` / graphic, and any size/position overrides.
3. The `.fly-item` **DOM elements** are still inserted per style exactly as
   before — this plugin only controls CSS/visibility, not the markup.

Example of per-style CSS after cleanup (only appearance + motion remain):

```css
.fly-item.leaf {
    background-image: url("leaf.png");
    animation: flyDown 12s linear infinite;
}
```
