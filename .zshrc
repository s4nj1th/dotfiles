autoload -U colors && colors

PROMPT="%B%{$fg[red]%}[%{$fg[green]%}%n%{$fg[yellow]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%1~%{$fg[red]%}]%{$reset_color%}%#%b "

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

bindkey '^[b' backward-word
bindkey '^[f' forward-word

bindkey "^[[1;9D" backward-word
bindkey "^[[1;9C" forward-word

bindkey '^[h' backward-word
bindkey '^[l' forward-word

bindkey '^[[1;9A' up-line-or-search
bindkey '^[[1;9B' down-line-or-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^[^?' backward-delete-word

bindkey '^[[3;2~' forward-delete-word

autoload -Uz compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

bindkey -v
export KEYTIMEOUT=1

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
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q';
}

case "$TERM" in (foot)
    local term_title () { print -n "\e]0;${(j: :q)@}\a" }
    precmd () {
      local DIR="$(print -P ' [%n@%m %~]%# ')"
      term_title "$DIR" #"zsh"
    }
    preexec () {
      local DIR="$(print -P ' [%n@%m %~]%# ')"
      local CMD="${(j:\n:)${(f)1}}"
      term_title "$CMD"
    }
  ;;
esac

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi --cwd-file="$tmp" "$@"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

