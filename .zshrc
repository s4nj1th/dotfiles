autoload -U colors && colors
export PATH=$PATH:$HOME/.local/bin

setopt PROMPT_SUBST

PROMPT='%B%F{red}[%F{green}%n%F{yellow}@%F{blue}%m %F{magenta}%1~%F{red}]%f%F{yellow}$(git_branch)%f %#%b '
# PROMPT='%B%F{red}[%F{green}%n%F{yellow}@%F{blue}%m %F{magenta}%1~%F{red}]%f %#%b '
# PROMPT=' %B%F{blue}%1~%f%F{yellow}$(git_branch)%f %#%b '

git_branch() {
  local branch dirty
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    dirty="*"
  fi
  echo "  $branch$dirty"
}

export EDITOR=nvim

setopt autocd
setopt interactive_comments

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$HOME/.zsh_history

function clear-screen-and-scrollback() {
  builtin echoti civis >"$TTY"
  builtin print -rn -- $'\e[H\e[2J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
  builtin print -rn -- $'\e[3J' >"$TTY"
  builtin echoti cnorm >"$TTY"
}

source ~/.config/zsh/aliases
source ~/.config/zsh/startup

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -v
export KEYTIMEOUT=1

autoload -Uz compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # bar
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
    bindkey '^[b' backward-word
    bindkey '^[f' forward-word
    bindkey '^[h' backward-word
    bindkey '^[l' forward-word
    bindkey '^[[1;9D' backward-word
    bindkey '^[[1;9C' forward-word
    bindkey '^[[1;9A' up-line-or-search
    bindkey '^[[1;9B' down-line-or-search
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^[^?' backward-delete-word
    bindkey '^[[3;2~' forward-delete-word
}
zle -N zle-line-init

preexec() { echo -ne '\e[5 q'; }

case "$TERM" in (foot|alacritty)
    local term_title () { print -n "\e]0;${(j: :q)@}\a" }
    precmd () {
      local DIR="$(print -P ' [%n@%m %~]%# ')"
      term_title "$DIR"
    }
    preexec () {
      local CMD="${(j:\n:)${(f)1}}"
      term_title "$CMD"
    }
esac

function y() {
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if [[ -f "$tmp" ]]; then
    cwd="$(cat "$tmp")"
    rm "$tmp"
    if [[ -d "$cwd" ]]; then
      cd "$cwd"
    fi
  fi
}
