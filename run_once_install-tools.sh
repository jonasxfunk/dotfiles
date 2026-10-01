#!/usr/bin/env bash
# Installs CLI tools as user-space binaries into ~/.local/bin — same
# mechanism on macOS and Linux (and, unmodified, on root-free foreign
# servers like Lambda1/2 per A8). chezmoi runs this once per machine
# and re-runs it only if this file's content changes.
set -euo pipefail

mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/bin"

os="$(uname -s)"
arch="$(uname -m)"

github_latest_tag() {
	curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
		grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
}

# tree-sitter CLI (needed by nvim-treesitter's main branch to compile parsers)
if ! command -v tree-sitter >/dev/null 2>&1; then
	echo "Installing tree-sitter..."
	case "$os-$arch" in
	Darwin-arm64) asset="tree-sitter-macos-arm64.gz" ;;
	Darwin-x86_64) asset="tree-sitter-macos-x64.gz" ;;
	Linux-x86_64) asset="tree-sitter-linux-x64.gz" ;;
	Linux-aarch64) asset="tree-sitter-linux-arm64.gz" ;;
	*)
		echo "tree-sitter: unsupported platform $os-$arch" >&2
		asset=""
		;;
	esac
	if [ -n "$asset" ]; then
		url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/$asset"
		curl -fsSL "$url" | gunzip >tree-sitter
		chmod +x tree-sitter
	fi
fi

# neovim: the config uses vim.pack (0.12+), which distro packages often lack,
# so also replace an existing nvim that is too old. The tarball is unpacked to
# ~/.local/opt and symlinked into ~/.local/bin, which comes first in $path.
if ! command -v nvim >/dev/null 2>&1 ||
	! nvim --clean --headless -c 'if !has("nvim-0.12") | cquit | endif | qa' >/dev/null 2>&1; then
	echo "Installing neovim..."
	case "$os-$arch" in
	Darwin-arm64) asset="nvim-macos-arm64" ;;
	Darwin-x86_64) asset="nvim-macos-x86_64" ;;
	Linux-x86_64) asset="nvim-linux-x86_64" ;;
	Linux-aarch64) asset="nvim-linux-arm64" ;;
	*)
		echo "neovim: unsupported platform $os-$arch" >&2
		asset=""
		;;
	esac
	if [ -n "$asset" ]; then
		mkdir -p "$HOME/.local/opt"
		rm -rf "$HOME/.local/opt/nvim" "$HOME/.local/opt/$asset"
		url="https://github.com/neovim/neovim/releases/latest/download/$asset.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$HOME/.local/opt"
		mv "$HOME/.local/opt/$asset" "$HOME/.local/opt/nvim"
		ln -sf "$HOME/.local/opt/nvim/bin/nvim" nvim
	fi
fi

# starship
if ! command -v starship >/dev/null 2>&1; then
	echo "Installing starship..."
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "starship: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		url="https://github.com/starship/starship/releases/latest/download"
		url="$url/starship-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C .
	fi
fi

# ripgrep
if ! command -v rg >/dev/null 2>&1; then
	echo "Installing ripgrep..."
	tag="$(github_latest_tag BurntSushi/ripgrep)"
	ver="${tag#v}"
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "ripgrep: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		tmp="$(mktemp -d)"
		url="https://github.com/BurntSushi/ripgrep/releases/download/${tag}"
		url="$url/ripgrep-${ver}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$tmp"
		mv "$tmp"/ripgrep-*/rg .
		rm -rf "$tmp"
	fi
fi

# zoxide
if ! command -v zoxide >/dev/null 2>&1; then
	echo "Installing zoxide..."
	tag="$(github_latest_tag ajeetdsouza/zoxide)"
	ver="${tag#v}"
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "zoxide: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		tmp="$(mktemp -d)"
		url="https://github.com/ajeetdsouza/zoxide/releases/download/${tag}"
		url="$url/zoxide-${ver}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$tmp"
		mv "$tmp/zoxide" .
		rm -rf "$tmp"
	fi
fi

# bat
if ! command -v bat >/dev/null 2>&1; then
	echo "Installing bat..."
	tag="$(github_latest_tag sharkdp/bat)"
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "bat: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		tmp="$(mktemp -d)"
		url="https://github.com/sharkdp/bat/releases/download/${tag}"
		url="$url/bat-${tag}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$tmp"
		mv "$tmp"/bat-*/bat .
		rm -rf "$tmp"
	fi
fi

# Rebuild bat's theme cache so custom themes are recognized
command -v bat >/dev/null 2>&1 && bat cache --build

# xterm-kitty terminfo (Linux only): needed so SSH-ing in over WezTerm
# (TERM=xterm-kitty, set for Kitty graphics protocol support) doesn't break
# tmux/zsh — without it tmux refuses to start ("missing or unsuitable
# terminal") and interactive input gets garbled even outside tmux.
if [ "$os" = "Linux" ] && ! infocmp xterm-kitty >/dev/null 2>&1; then
	echo "Installing xterm-kitty terminfo..."
	tmp="$(mktemp -d)"
	curl -fsSL -o "$tmp/kitty.terminfo" \
		https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo
	tic -x -o "$HOME/.terminfo" "$tmp/kitty.terminfo"
	rm -rf "$tmp"
fi

# fzf: `fzf --zsh` (used in .zshrc) needs 0.48+, older distro packages
# (e.g. Ubuntu 24.04 ships 0.44) lack it, so also replace an outdated fzf
if ! command -v fzf >/dev/null 2>&1 || ! fzf --zsh >/dev/null 2>&1; then
	echo "Installing fzf..."
	tag="$(github_latest_tag junegunn/fzf)"
	ver="${tag#v}"
	case "$os-$arch" in
	Darwin-arm64) target="darwin_arm64" ;;
	Darwin-x86_64) target="darwin_amd64" ;;
	Linux-x86_64) target="linux_amd64" ;;
	Linux-aarch64) target="linux_arm64" ;;
	*)
		echo "fzf: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		url="https://github.com/junegunn/fzf/releases/download/${tag}"
		url="$url/fzf-${ver}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C .
	fi
fi

# yazi (+ ya, its package manager CLI); upstream only ships .zip archives
if ! command -v yazi >/dev/null 2>&1; then
	echo "Installing yazi..."
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "yazi: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		tmp="$(mktemp -d)"
		url="https://github.com/sxyazi/yazi/releases/latest/download/yazi-${target}.zip"
		curl -fsSL -o "$tmp/yazi.zip" "$url"
		unzip -q "$tmp/yazi.zip" -d "$tmp"
		mv "$tmp/yazi-${target}/yazi" "$tmp/yazi-${target}/ya" .
		rm -rf "$tmp"
	fi
fi

# eza: no macOS binaries upstream -> Homebrew there; static binary on Linux
if ! command -v eza >/dev/null 2>&1; then
	echo "Installing eza..."
	if [ "$os" = "Darwin" ]; then
		command -v brew >/dev/null 2>&1 && brew install eza
	else
		tag="$(github_latest_tag eza-community/eza)"
		ver="${tag#v}"
		case "$arch" in
		x86_64) target="x86_64-unknown-linux-gnu" ;;
		aarch64) target="aarch64-unknown-linux-gnu" ;;
		*)
			echo "eza: unsupported arch $arch" >&2
			target=""
			;;
		esac
		if [ -n "$target" ]; then
			tmp="$(mktemp -d)"
			url="https://github.com/eza-community/eza/releases/download/${tag}"
			url="$url/eza_${target}.tar.gz"
			curl -fsSL "$url" | tar -xz -C "$tmp"
			mv "$tmp/eza" .
			rm -rf "$tmp"
		fi
	fi
fi

# fd
if ! command -v fd >/dev/null 2>&1; then
	echo "Installing fd..."
	tag="$(github_latest_tag sharkdp/fd)"
	case "$os-$arch" in
	Darwin-arm64) target="aarch64-apple-darwin" ;;
	Darwin-x86_64) target="x86_64-apple-darwin" ;;
	Linux-x86_64) target="x86_64-unknown-linux-musl" ;;
	Linux-aarch64) target="aarch64-unknown-linux-musl" ;;
	*)
		echo "fd: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		tmp="$(mktemp -d)"
		url="https://github.com/sharkdp/fd/releases/download/${tag}"
		url="$url/fd-${tag}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$tmp"
		mv "$tmp"/fd-*/fd .
		rm -rf "$tmp"
	fi
fi

# yq (mikefarah/yq): plain binary per platform, no tarball/versioned filename
if ! command -v yq >/dev/null 2>&1; then
	echo "Installing yq..."
	case "$os-$arch" in
	Darwin-arm64) asset="yq_darwin_arm64" ;;
	Darwin-x86_64) asset="yq_darwin_amd64" ;;
	Linux-x86_64) asset="yq_linux_amd64" ;;
	Linux-aarch64) asset="yq_linux_arm64" ;;
	*)
		echo "yq: unsupported platform $os-$arch" >&2
		asset=""
		;;
	esac
	if [ -n "$asset" ]; then
		curl -fsSL -o yq "https://github.com/mikefarah/yq/releases/latest/download/$asset"
		chmod +x yq
	fi
fi

# node (latest LTS): mason builds many language servers from npm packages
# (pyright, bash/yaml/json/dockerfile LS, prettierd, ...), and servers rarely
# have a usable node. Official tarball into ~/.local/opt, symlinked like nvim.
if ! command -v node >/dev/null 2>&1; then
	echo "Installing node..."
	case "$os-$arch" in
	Darwin-arm64) target="darwin-arm64" ;;
	Darwin-x86_64) target="darwin-x64" ;;
	Linux-x86_64) target="linux-x64" ;;
	Linux-aarch64) target="linux-arm64" ;;
	*)
		echo "node: unsupported platform $os-$arch" >&2
		target=""
		;;
	esac
	if [ -n "$target" ]; then
		# index.json has one release per line, newest first; LTS ones carry a
		# codename. Downloaded to a file first: piping curl into `grep -m1`
		# closes the pipe early, curl fails with exit 23 and pipefail aborts.
		tmp="$(mktemp -d)"
		curl -fsSL -o "$tmp/index.json" https://nodejs.org/dist/index.json
		ver="$(grep -m1 '"lts":"' "$tmp/index.json" | sed -E 's/.*"version":"([^"]+)".*/\1/')"
		rm -rf "$tmp"
		mkdir -p "$HOME/.local/opt"
		rm -rf "$HOME/.local/opt/node"
		url="https://nodejs.org/dist/${ver}/node-${ver}-${target}.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$HOME/.local/opt"
		mv "$HOME/.local/opt/node-${ver}-${target}" "$HOME/.local/opt/node"
		for bin in node npm npx; do
			ln -sf "$HOME/.local/opt/node/bin/$bin" "$bin"
		done
	fi
fi

# uv: official installer detects OS/arch itself and installs into ~/.local/bin
if ! command -v uv >/dev/null 2>&1; then
	echo "Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# rbw: no macOS binary upstream -> Homebrew there; static binary on Linux (amd64 only)
if ! command -v rbw >/dev/null 2>&1; then
	echo "Installing rbw..."
	if [ "$os" = "Darwin" ]; then
		command -v brew >/dev/null 2>&1 && brew install rbw
	elif [ "$arch" = "x86_64" ]; then
		tag="$(github_latest_tag doy/rbw)"
		tmp="$(mktemp -d)"
		url="https://github.com/doy/rbw/releases/download/${tag}"
		url="$url/rbw_${tag}_linux_amd64.tar.gz"
		curl -fsSL "$url" | tar -xz -C "$tmp"
		mv "$tmp/rbw" "$tmp/rbw-agent" .
		rm -rf "$tmp"
	else
		echo "rbw: no prebuilt binary for $os-$arch, install manually" >&2
	fi
fi

# ruff, pyright: global CLI access via uv tool install (in addition to
# per-project dev-dependencies added by new-py-project for pinned/reproducible
# versions). pytest is deliberately NOT installed globally — it has to run
# inside each project's own venv to import that project's code.
if command -v uv >/dev/null 2>&1; then
	command -v ruff >/dev/null 2>&1 || uv tool install ruff
	command -v pyright >/dev/null 2>&1 || uv tool install pyright
	command -v jupytext >/dev/null 2>&1 || uv tool install jupytext
	command -v jupyter-lab >/dev/null 2>&1 || uv tool install jupyterlab --with jupytext
fi
