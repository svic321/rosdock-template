#!/usr/bin/env bash
set -e

git clone --bare git@github.com:svic321/dotfiles.git "$HOME/.dotfiles" \
  || git clone --bare https://github.com/svic321/dotfiles "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
sudo rosdep update
sudo rosdep install --from-paths src --ignore-src -y
sudo chown -R "$(whoami)" /home/ws/