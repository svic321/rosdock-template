#!/usr/bin/env bash
# Don't hard-abort on optional/network-dependent steps; only guard against unset vars.
set -uo pipefail

# GIT_TERMINAL_PROMPT=0 keeps a credential prompt from hanging when no auth is available.
if [[ ! -d "$HOME/.dotfiles" ]]; then
  if GIT_TERMINAL_PROMPT=0 git clone --bare git@github.com:svic321/dotfiles.git "$HOME/.dotfiles" 2>/dev/null \
    || GIT_TERMINAL_PROMPT=0 git clone --bare https://github.com/svic321/dotfiles "$HOME/.dotfiles" 2>/dev/null; then
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
  else
    echo "post-create: skipping dotfiles (no SSH/HTTPS access to the repo)" >&2
  fi
fi

if ! grep -Fqx '[include]' "$HOME/.gitconfig" 2>/dev/null || ! grep -Fqx '  path = ~/.svic321/git/.gitconfig' "$HOME/.gitconfig" 2>/dev/null; then
  printf '%s\n' '[include]' '  path = ~/.svic321/git/.gitconfig' >> "$HOME/.gitconfig"
fi

if [[ ! -f "$HOME/.config/starship.toml" ]] && command -v starship >/dev/null 2>&1; then
  mkdir -p "$HOME/.config"
  starship preset nerd-font-symbols -o "$HOME/.config/starship.toml"
fi

[[ -x "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" ]] && "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" >/dev/null 2>&1
[[ -x "$HOME/.svic321/bin/setup-tmux" ]] && "$HOME/.svic321/bin/setup-tmux" >/dev/null 2>&1

sudo rosdep update
if [[ -d src ]]; then
  sudo rosdep install --from-paths src --ignore-src -y
else
  echo "post-create: no src/ directory yet, skipping rosdep install" >&2
fi

sudo chown -R "$(whoami)" /home/ws/