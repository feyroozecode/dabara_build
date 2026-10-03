# Dabara for VS Code

Syntax highlighting, live error squiggles with `DBR` codes, completion, hover, **Format Document**, and
*Run / Test / New Project* commands for `.ha` files.

> **Preview.** Keyword names are provisional pending review by native Hausa speakers.

## Install

1. Install the `dabara` program first (see the [main page](../README.md#install)) — version
   **0.6.0-beta.1 or newer**.
2. Get the extension:
   - **From a release (works today):** download `dabara-language-support-<version>.vsix` from the
     [Releases](../../../releases) page, then
     ```sh
     code --install-extension dabara-language-support-0.6.0.vsix
     ```
     or in VS Code: *Extensions* ▸ `…` ▸ *Install from VSIX…*
   - **From the Marketplace / Open VSX:** *not published yet* — this page will link to it when it is.
3. Open any `.ha` file. If the status bar shows ⚠ *Dabara*, hover it: it says whether `dabara` is missing,
   too old, or not found (set `dabara.path` in settings to point at it).

## What you get

Highlighting generated from the language itself · errors as you type · completion & hover for every
keyword and function · format on demand (`dabara tsari` rules) · `Ctrl+F5` runs the file · *Test Project*
runs `dabara gwaji` and shows failures in the Problems panel · *New Project* runs `dabara sabo`.

Extension source and issues: <https://github.com/feyroozecode/dabara-vscode-extension>.
Any other editor can use the language server: `dabara lsp`.
