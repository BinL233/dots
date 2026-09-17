# Dot Files

Personal dotfiles for my macOS development setup — Neovim, Zsh, Ghostty, iTerm2,
p10k, plus an AeroSpace + SketchyBar tiling/status-bar setup.

![os](images/os.png)
![nvim](images/nvim.png)

## Contents

| Path | What it is | Where it goes |
| --- | --- | --- |
| `nvim/` | Neovim config ([lazy.nvim](https://github.com/folke/lazy.nvim)) | `~/.config/nvim` |
| `macos/zshrc` | Zsh config (oh-my-zsh + powerlevel10k) | `~/.zshrc` |
| `macos/.p10k.zsh` | Powerlevel10k prompt theme | `~/.p10k.zsh` |
| `macos/setup_macos.sh` | Homebrew bootstrap for a fresh Mac | run once |
| `ghostty/config` | [Ghostty](https://ghostty.org) terminal config | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `iterm2/iTerm2_State.itermexport` | iTerm2 settings export | import from iTerm2 |
| `aerospace/.aerospace.toml` | [AeroSpace](https://nikitabobko.github.io/AeroSpace/) tiling WM | `~/.aerospace.toml` |
| `sketchybar/` | [SketchyBar](https://felixkratz.github.io/SketchyBar/) status bar | `~/.config/sketchybar` |

## Setup

```sh
git clone <this-repo> ~/Documents/Repos/dots
cd ~/Documents/Repos/dots

# 1. Install tooling (Homebrew, neovim, oh-my-zsh, p10k, yazi, kubectl, ...)
sh macos/setup_macos.sh

# 2. Symlink the configs
ln -s "$PWD/nvim"            ~/.config/nvim
ln -s "$PWD/macos/zshrc"     ~/.zshrc
ln -s "$PWD/macos/.p10k.zsh" ~/.p10k.zsh
ln -s "$PWD/ghostty/config"  ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -s "$PWD/aerospace/.aerospace.toml" ~/.aerospace.toml
ln -s "$PWD/sketchybar"      ~/.config/sketchybar
```

For iTerm2: **Preferences → General → Settings → Import** and select
`iterm2/iTerm2_State.itermexport`.

Open `nvim` afterwards — lazy.nvim bootstraps itself and installs all plugins on
first launch.

### Window manager & status bar

`setup_macos.sh` does not cover these yet — install them by hand:

```sh
brew install --cask nikitabobko/tap/aerospace
brew install FelixKratz/formulae/sketchybar
brew install jq gh    # used by the sketchybar plugins
brew install --cask font-sf-pro sketchybar-app-font

brew services start sketchybar
```

Then open AeroSpace once and grant it Accessibility permission.

## Neovim layout

```
nvim/
├── init.lua              # bootstraps lazy.nvim, loads config/*
├── lazy-lock.json        # pinned plugin versions
└── lua/
    ├── config/           # options, keymaps, lsp, treesitter, colortheme
    └── plugins/          # one file per plugin spec
```

## SketchyBar layout

```
sketchybar/
├── sketchybarrc          # bar appearance + which items are enabled
├── colors.sh, icons.sh   # shared palette and SF Symbols
├── items/                # item definitions (apple, spaces, calendar, wifi, ...)
├── plugins/              # the scripts each item runs on its events
└── helper/               # C helper process, built by sketchybarrc on load
```

Items are toggled by commenting/uncommenting their `source` line at the bottom of
`sketchybarrc`. `spaces.sh` is driven by AeroSpace, which fires
`aerospace_workspace_change` / `aerospace_focus_change` from `.aerospace.toml`.

## Notes

- AeroSpace keys: `alt-hjkl` focus, `alt-shift-hjkl` move, `alt-1..9` workspaces,
  `alt-shift-1..9` move window to workspace, `alt-enter` fullscreen, `alt-tab`
  back-and-forth, `alt-shift-;` service mode. `alt-/` and `alt-,` are left unbound
  on purpose — they clash with the terminal and with barbar in Neovim.
- Shell aliases worth knowing: `n` → `nvim`, `k`/`kubectl` → `kubecolor`.
