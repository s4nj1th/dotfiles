autoload -U colors && colors	# Load colors

# # detailed
PROMPT="%B%{$fg[red]%}[%{$fg[green]%}%n%{$fg[yellow]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%1~%{$fg[red]%}]%{$reset_color%}%#%b "
# PROMPT="[%n@%M %1~]%# "

# # minimal
# PROMPT="%{$fg[red]%}[%B%{$fg[magenta]%}%1~%b%{$fg[red]%}]%{$fg[white]%}%# "
# PROMPT="%B%{$fg[white]%}%~%b%{$fg[white]%} ❱ "
# PROMPT='%~ %#: '
# PROMPT='%n@%m %1~ %# '

export PATH="${PATH}:${HOME}/.local/bin"
export EDITOR="nvim"
export TERMINAL="foot"
export BROWSER="firefox"

# export PAGER="nvim +Man!"

# export GTK_THEME=Adwaita-dark

setopt autocd
setopt interactive_comments

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$HOME/.cache/zsh/history

function clear-screen-and-scrollback() {
  builtin echoti civis >"$TTY"
  builtin print -rn -- $'\e[H\e[2J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
  builtin print -rn -- $'\e[3J' >"$TTY"
  builtin echoti cnorm >"$TTY"
}
# zle -N clear-screen-and-scrollback
# bindkey '^L' clear-screen-and-scrollback

source ~/.config/zsh/aliases
source ~/.config/zsh/startup

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

bindkey '^[h' backward-word
bindkey '^[l' forward-word
bindkey '^[[1;3A' up-line-or-search
bindkey '^[[1;3B' down-line-or-search

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# autoload -U history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^[[A" history-beginning-search-backward-end
# bindkey "^[[B" history-beginning-search-forward-end

# if [[ "$(tty)" == "/dev/tty1" ]]; then
#   startx
# fi

bindkey "^[^?" backward-delete-word
bindkey "^[[P" forward-delete-word

# autoload -U compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit

autoload -Uz compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # bar
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use bar shape cursor on startup.
preexec() { echo -ne '\e[5 q' ; # Use bar shape cursor for each new prompt.
}

case "$TERM" in (foot)
    local term_title () { print -n "\e]0;${(j: :q)@}\a" }
    precmd () {
      local DIR="$(print -P ' [%n@%m %~]%# ')"
      # local DIR="$(print -P '%n@%m %~')"
      term_title "$DIR" #"zsh"
    }
    preexec () {
      local DIR="$(print -P ' [%n@%m %~]%# ')"
      # local DIR="$(print -P '%n@%m %~')"
      local CMD="${(j:\n:)${(f)1}}"
      # term_title "$DIR" "$CMD"
      term_title "$CMD"
    }
  ;;
esac

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}



source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

[ -f "/home/s4nj1th/.ghcup/env" ] && . "/home/s4nj1th/.ghcup/env" # ghcup-env
