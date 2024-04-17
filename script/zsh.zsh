#!/usr/bin/env zsh

# Download git-prompt.sh if not exists
if [ ! -e ~/.git-prompt.sh ]; then
  curl -XGET https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh >~/.git-prompt.sh
fi
ln -sfv $(DOTFILES_REPO_DIR)/config/zsh/.zshrc $(HOME)/.zshrc
source $(HOME)/.zshrc
