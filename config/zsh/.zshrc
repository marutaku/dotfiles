export ZPLUG_HOME=/opt/homebrew/opt/zplug
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
export PATH=$HOME/.npm-global/bin:$PATH
export PATH="/usr/local/opt/scala@2.13/bin:$PATH"
autoload -Uz compinit 
fpath=($HOME/.zsh/completion $fpath)
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
  function _ssh { compadd $(fgrep 'Host ' $HOME/.ssh/*/config | grep -v '*' |  awk '{print $2}' | sort) }
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
zplug load

#git prompt
source $HOME/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1


gcop() {
  git branch -a --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/###' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
}

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

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
