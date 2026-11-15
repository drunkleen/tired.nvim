# Repository Guidelines

## Project Structure & Module Organization

This repository is a Neovim configuration, with `init.lua` as its entry point. Core options, keymaps, and autocommands are in `lua/options.lua`, `lua/mappings.lua`, and `lua/autocmds.lua`. Local features and their plugin specifications live in `lua/tired/`; personal plugin additions live in `lua/plugins/`. `lua/base46/` contains the theme engine and palettes, and `lua/volt/` contains UI helpers. `preview.png` is the README screenshot. There is no dedicated test directory or build output.

## Development Commands

- `nvim` starts the configuration; `init.lua` bootstraps `lazy.nvim` on first launch.
- `nvim --headless +qa` checks that startup completes without an interactive UI. Run it after changing startup code or plugin setup.
- `stylua --check .` checks Lua formatting; `stylua .` formats Lua files using `.stylua.toml`.
- In Neovim, `:Lazy sync` updates plugins, `:MasonInstallAll` installs configured external tools, and `:TSInstallAll` installs configured Treesitter parsers.

No compilation step or project task runner is defined.

## Coding Style & Naming Conventions

Use two spaces for Lua indentation, Unix line endings, and the repository's StyLua settings (120-column width and preferred double quotes). Keep module names lowercase and follow the existing directory layout: for example, add a feature under `lua/tired/<feature>/` and its plugin specification under `lua/tired/plugins/` or `lua/plugins/`. Keep theme palettes in `lua/base46/themes/<name>.lua`. Follow nearby Lua patterns for `require` calls and plugin tables.

## Testing Guidelines

There is no automated test framework or coverage target. Run `stylua --check .` and `nvim --headless +qa`, then manually exercise the affected feature in Neovim. For UI or theme changes, check the relevant command or mapping and confirm that highlights and windows render as expected. Note any checks you could not run in the pull request.

## Commits & Pull Requests

Recent commit subjects use short, imperative descriptions such as `Fix LSP, mason, and treesitter setup`. Keep each commit focused and describe the user-visible change. Pull requests should explain the change, list verification steps, and link a related issue when one exists. Include a screenshot for visual changes, such as themes or dashboard layout.
