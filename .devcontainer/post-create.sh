#!/usr/bin/env bash
set -e

git clone --bare git@github.com:svic321/dotfiles.git "$HOME/.dotfiles" \
  || git clone --bare https://github.com/svic321/dotfiles "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
if ! grep -Fqx '[include]' "$HOME/.gitconfig" 2>/dev/null || ! grep -Fqx '  path = ~/.svic321/git/.gitconfig' "$HOME/.gitconfig" 2>/dev/null; then
  printf '%s\n' '[include]' '  path = ~/.svic321/git/.gitconfig' >> "$HOME/.gitconfig"
fi
if [[ ! -f "$HOME/.config/starship.toml" ]]; then
  mkdir -p "$HOME/.config"
  starship preset nerd-font-symbols -o "$HOME/.config/starship.toml"
fi
"$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" >/dev/null 2>&1
"$HOME/.svic321/bin/setup-tmux" >/dev/null 2>&1
sudo rosdep update
sudo rosdep install --from-paths src --ignore-src -y
sudo chown -R "$(whoami)" /home/ws/