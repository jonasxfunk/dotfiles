# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/): zsh,
Neovim, tmux, WezTerm, yazi, starship, bat.

## Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jonasxfunk/dotfiles
```

`run_once_install-tools.sh` installs the CLI tools (ripgrep, fzf, fd, bat,
eza, zoxide, starship, uv, ...) as user-space binaries into `~/.local/bin`
on macOS and Linux, no root required.

Update an existing install:

```sh
chezmoi update
```

## Note

This repository is a read-only mirror. Configs that depend on private data
or infrastructure (Taskwarrior sync, notes vault) are stripped out.
