export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
autoload -U promptinit; promptinit
#fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fpath=(~/.zsh-completions $fpath)
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=~/.npm-global/bin:$PATH
export PATH="/usr/local/opt/scala@2.13/bin:$PATH"
autoload -Uz compinit 
fpath=(~/.zsh/completion $fpath)
compinit -i

compinit -u
zmodload -i zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

setopt PROMPT_SUBST
# cd を使わずに移動できる
setopt auto_cd
# "cd -"の時点でTabを押すとディレクトリの履歴が見れる
setopt auto_pushd
# コマンドの打ち間違いを指摘してくれる
setopt correct
setopt auto_list
#かっこの対応などを自動的に補完する
setopt auto_param_keys
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

########################################
#               zplugs 
#######################################
zplug "yous/lime"
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'chrissicool/zsh-256color'
zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"
# zplug "b4b4r07/enhancd", use:enhancd.sh
zplug "zsh-users/zsh-history-substring-search", hook-build:"__zsh_version 4.3"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "supercrabtree/k"
zplug "junegunn/fzf", use:shell/key-bindings.zsh
zplug "junegunn/fzf", use:shell/completion.zsh
zplug "b4b4r07/enhancd", use:init.sh
zplug "paulirish/git-open", as:plugin
zplug "zsh-users/zsh-syntax-highlighting", defer:2

chpwd() {
}
: "sshコマンド補完を~/.ssh/configから行う" && {
  function _ssh { compadd $(fgrep 'Host ' ~/.ssh/*/config | grep -v '*' |  awk '{print $2}' | sort) }
}
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load  --verbose

#git prompt
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
#PROMPT='[%n@%m:%~]$(__git_ps1" (%s)")%# '
# For pyenv 
export PYENV_ROOT=/usr/local/var/pyenv
if which pyenv > /dev/null; then 
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)";
fi

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0`
export COMPOSE_FILE=docker-compose.yml

gcop() {
  git branch -a --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/###' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
}
eval "$(rbenv init -)"

bindkey '^]' peco-src
function peco-src() {
  local src=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N peco-src

#### Alias ####
alias git-branch-delete="git branch --merged | grep -v  -e main -e master| xargs -I % git branch -d %"
alias devc="devcontainer"
## Docker ##
alias dcu="docker compose up"
alias dce="docker compose exec"
alias dcd="docker compose down"
alias dcr="docker compose run --rm"
alias dcp="docker compose ps"
alias dcl="docker compose logs"
alias dcb="docker compose build"

## Git ##
alias gfa="git fetch --all"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/marutaku/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/marutaku/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/marutaku/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/marutaku/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/marutaku/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
. "$HOME/.asdf/asdf.sh"
