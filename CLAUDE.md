# CLAUDE.md

Guidance for AI assistants (and humans) working in this repository.

## What this project is

**WBB6-flying-elements** is a small plugin for **WoltLab Burning Board (WBB) /
WoltLab Suite Core**. Its purpose, per the README, is to let a user **activate
or deactivate a specific piece of CSS** — i.e. toggle a visual/CSS "element" on
or off (the "flying elements").

The `WBB6` in the name targets **WoltLab Suite / Burning Board 6.x**.

## Repository layout

The plugin is intentionally tiny — it has **no PHP** and no `files/` payload.
The complete tracked contents are:

```
package.xml            # Package metadata + install instructions (required)
userOption.xml         # The boolean user option `flyingElements`
templateListener.xml   # Two head listeners that emit the plugin's CSS
language/
  de.xml               # German label + description for the option
  en.xml               # English label + description for the option
build.sh               # Bundles the above into the installable .tar
README.md              # User-facing usage + migration notes
CLAUDE.md              # this file
LICENSE                # GNU license text
```

Building the package (`./build.sh`) produces
`de.imperatorbob.flyingelements.tar`, which is uploaded via the ACP
(*Configuration → Packages → Install Package*). No `files.tar` is produced
because the CSS is delivered inline through the template listener.

## How the toggle is implemented

The feature is a **user option + template listener**, deliberately with **no
PHP, no event listener, and no body-class hacks** (those `<body>`/`<html>`
class variables are undocumented internals in WSC 6.x and are avoided for
update-safety).

- `userOption.xml` defines a boolean option `flyingElements`
  (category `settings.general.appearance`, `defaultvalue=1`, `editable=3`), so
  it appears as a checkbox in each user's own account settings. Read it in a
  template as `{if $__wcf->user->flyingElements}`; guests evaluate to false.
- `templateListener.xml` has three listeners:
  - Two hook the `headInclude` template, chosen for their position in the head
    cascade (`{event metaTags}` → active style CSS → `{event stylesheets}`):
    - **`metaTags`** (before the style CSS): base `.fly-item` positioning, so any
      style can still override size/position/z-index.
    - **`stylesheets`** (after the style CSS): controls `display`, so the toggle
      wins **without `!important`**. Hides `.fly-item` only for a logged-in user
      who disabled the option.
  - One hooks the `footer` template at the stable `footer` event (end of
    `<body>`) and injects the `.fly-item` markup itself
    (`<div class="fly-item fly-1">` … `fly-6`). This means styles customize the
    elements with **CSS only** — no HTML box, no template edits. Elements a
    style doesn't define stay invisible (no background, collapsed height).
  - Inline CSS in `templatecode` must wrap its `{ }` rule bodies in
    `{literal}…{/literal}`; the template compiler would otherwise parse `{…}` as
    template tags. Only the `{if}` condition is left as real template code.

Default is **opt-out**: enabled for everyone (guests included), any registered
user can switch it off. Per-style CSS defines only the graphic
(`background-image`) and animation (`@keyframes` + `animation`) on
`.fly-item.fly-1`…`.fly-6`, not `display` and not the markup.

## Development workflow

### Git / branching

- Active development branch for the current task: **`claude/claude-md-docs-lao5md`**.
- Default branch: **`main`**.
- Do all work on the designated feature branch, commit with clear messages, and
  push with `git push -u origin <branch-name>`. Do **not** push to `main` or any
  other branch without explicit permission.
- Do **not** open a pull request unless explicitly asked.

### Building the package

WoltLab packages are plain `.tar` archives. Run:

```sh
./build.sh
```

It bundles `package.xml`, `userOption.xml`, `templateListener.xml`, and
`language/*.xml` into `de.imperatorbob.flyingelements.tar`, which is uploaded via
the WoltLab ACP (*Configuration → Packages → Install Package*). There is no
`files.tar`: the CSS ships inline in the template listener, so nothing is copied
into the WSC installation directory.

There is currently **no test suite, linter, or CI configuration** — the plugin
is XML + a shell script only. Before committing, sanity-check the XML with
`xmllint --noout *.xml language/*.xml` and confirm `./build.sh` produces the
archive. If you ever add PHP, align with WoltLab's coding standards and add a
`php -l` / `phpstan` step here.

## Key conventions

- **Target platform:** WoltLab Suite Core / Burning Board **6.x**. Language
  features and APIs should match WSC 6.x (PHP 8.1+, its template syntax, its
  SCSS pipeline).
- **CSS delivery:** the plugin's CSS is injected through the template listener
  at the `headInclude` head events. SCSS/the `style/` PIP is deliberately **not**
  used, because it compiles per style and would not apply cross-style; the head
  listener applies on every page regardless of the active style.
- **i18n:** user-facing strings and ACP option labels use WoltLab language
  items defined in `language/*.xml`, referenced as `{lang}...{/lang}` /
  `WCF::getLanguage()->get(...)`.
- **Encoding / line endings:** keep files UTF-8; WoltLab XML files declare
  `<?xml version="1.0" encoding="UTF-8"?>`.

## Notes for AI assistants

- This is a very small, single-purpose plugin. Keep changes minimal and focused
  on the CSS-toggle feature; avoid introducing framework, build, or dependency
  scaffolding that the project doesn't need (no PHP, no event listeners, no SCSS
  pipeline unless there's a concrete reason).
- The README is the source of truth for intent; keep it and this file in sync
  as the plugin changes.
- If you bump the plugin, update `<version>`/`<date>` in `package.xml` together.
