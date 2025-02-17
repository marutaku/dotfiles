#!/usr/bin/env zsh
set -x
if type brew >/dev/null; then
  echo "Homebrew is already installed."
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo >> $HOME/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)

echo "Updating Homebrew..."
brew update

echo "Installing Homebrew apps..."
brew bundle install --file "${REPO_DIR}/config/homebrew/Brewfile" --no-lock --verbose

exit 0
