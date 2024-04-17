#!/usr/bin/env bash

VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
rm "$VSCODE_SETTING_DIR/settings.json"
ln -s "$DOTFILES_REPO_DIR/config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

rm "$VSCODE_SETTING_DIR/keybindings.json"
ln -s "$DOTFILES_REPO_DIR/config/vscode/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"
cat "$DOTFILES_REPO_DIR/config/vscode/extensions" | while read line; do
  code --install-extension $line
done
