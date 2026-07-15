# CLAUDE.md

Guidance for AI assistants (and humans) working in this repository.

## What this project is

**WBB6-flying-elements** is a small plugin for **WoltLab Burning Board (WBB) /
WoltLab Suite Core**. Its purpose, per the README, is to let a user **activate
or deactivate a specific piece of CSS** — i.e. toggle a visual/CSS "element" on
or off (the "flying elements").

The `WBB6` in the name targets **WoltLab Suite / Burning Board 6.x**.

## Current state of the repository

> Read this before assuming any code exists.

As of now the repository is **scaffold-only**. The complete tracked contents are:

```
LICENSE      # GNU license text
README.md    # one-line project description
CLAUDE.md    # this file
```

There is **no plugin source code, no package archive, and no build tooling yet.**
Do not reference files, classes, templates, or an `option.xml`/`package.xml` as
if they exist — they do not. When you add the first real code, **update the
"Repository layout" section below** to match reality.

## Repository layout (target)

WoltLab plugins are distributed as a `.tar` package built from a defined file
layout. When this plugin gains code, it will conventionally look like:

```
package.xml              # Package metadata + install/update instructions (required)
files/                   # PHP/other files copied into the WSC installation
  lib/                   # PHP classes (PSR-style, namespaced)
templates/               # Frontend .tpl template files
acptemplates/            # Admin Control Panel .tpl template files
style/                   # SCSS/CSS delivered by the plugin
  *.scss
option.xml               # Options exposed in the ACP (e.g. the CSS on/off toggle)
templateListener.xml     # Hooks that inject template code at defined event points
eventListener.xml        # PHP event listeners
language/                # <language>.xml translation files (e.g. de.xml, en.xml)
```

The core toggle feature will most likely be implemented as either:
- an **ACP option** (`option.xml`) whose value gates whether the CSS is emitted, and/or
- a **template listener** (`templateListener.xml`) that conditionally injects a
  `<style>` block or a CSS class based on that option / a user preference.

Confirm the actual approach against the code once it exists rather than assuming.

## Development workflow

### Git / branching

- Active development branch for the current task: **`claude/claude-md-docs-lao5md`**.
- Default branch: **`main`**.
- Do all work on the designated feature branch, commit with clear messages, and
  push with `git push -u origin <branch-name>`. Do **not** push to `main` or any
  other branch without explicit permission.
- Do **not** open a pull request unless explicitly asked.

### Building a WoltLab package (for reference, once code exists)

WoltLab packages are plain `.tar` archives. A typical manual build bundles the
component archives and wraps them with `package.xml`:

```sh
# Example only — adjust to the real file set once it exists.
tar cf files.tar -C files .
tar cf templates.tar -C templates .
tar cf <plugin>.tar package.xml files.tar templates.tar option.xml language/*.xml ...
```

The resulting `<plugin>.tar` is what gets uploaded via the WoltLab ACP
(*Configuration → Packages → Install Package*). Many maintainers script this in
a `Makefile`, shell script, or CI workflow — none exists here yet; add one and
document it here when you do.

There is currently **no test suite, linter, or CI configuration.** If you
introduce PHP code, prefer aligning with WoltLab's coding standards and add
tooling (e.g. `php -l` syntax checks, `phpstan`, a build script) alongside a
note here.

## Key conventions

- **Target platform:** WoltLab Suite Core / Burning Board **6.x**. Language
  features and APIs should match WSC 6.x (PHP 8.1+, its template syntax, its
  SCSS pipeline).
- **CSS/SCSS:** styling should go through WoltLab's style system (SCSS delivered
  via the `style/` folder or injected through a template listener) rather than
  hardcoded inline styles, so the toggle integrates with the board's theming.
- **i18n:** user-facing strings and ACP option labels use WoltLab language
  items defined in `language/*.xml`, referenced as `{lang}...{/lang}` /
  `WCF::getLanguage()->get(...)`.
- **Encoding / line endings:** keep files UTF-8; WoltLab XML files declare
  `<?xml version="1.0" encoding="UTF-8"?>`.

## Notes for AI assistants

- This is a very small, single-purpose plugin. Keep changes minimal and focused
  on the CSS-toggle feature; avoid introducing framework, build, or dependency
  scaffolding that the project doesn't need.
- The README is the source of truth for intent; keep it and this file in sync
  as the plugin takes shape.
- When you add the first source files, **replace the "Current state" and
  "Repository layout (target)" sections above with the actual structure.**
