#!/bin/sh

export DOTFILES_REPO_DIR="${REPO_DIR:-$HOME/dotfiles}"

if [ ! -d "$REPODOTFILES_REPO_DIR_DIR" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/marutaku/dotfiles.git
else
  echo "Updating dotfiles..."
  git -C ${DOTFILES_REPO_DIR} pull
fi

sh ${DOTFILES_REPO_DIR}/script/setup.sh
