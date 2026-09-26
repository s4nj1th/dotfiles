autoload -U colors && colors
autoload -Uz compinit
autoload -Uz add-zsh-hook
zmodload zsh/complist

export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
export EDITOR=nvim
export LESS="--RAW-CONTROL-CHARS"

export GOPATH="$HOME/.local/share/go"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export PATH="/Users/s4n/.antigravity/antigravity/bin:$PATH"

export CHROME_EXECUTABLE="/Applications/Helium.app/Contents/MacOS/Helium"

[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP

setopt PROMPT_SUBST
setopt autocd
setopt interactive_comments

PROMPT='%B%F{red}[%F{green}%n%F{yellow}@%F{blue}%m %F{magenta}%1~%F{red}]%f%F{yellow}$(git_branch)%f %#%b '

git_branch() {
    local branch dirty
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        dirty="%F{red}*%f"
    fi
    echo " %F{blue} $branch%f$dirty"
}

HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"

source ~/.config/zsh/aliases
source ~/.config/zsh/startup

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

fpath=(/Users/s4n/.docker/completions $fpath)

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

tmux-widget() {
    BUFFER="tmux new-session -A -s main"
    zle accept-line
}

zle -N tmux-widget
bindkey -M viins '^ ' tmux-widget

zle-keymap-select() {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q' ;;
        viins|main) echo -ne '\e[5 q' ;;
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

preexec() {
    echo -ne '\e[5 q'
}

title-precmd() {
    print -Pn "\e]2;%~\a"
}

title-preexec() {
    print -Pn "\e]2;${(q-)1}\a"
}

add-zsh-hook precmd title-precmd
add-zsh-hook preexec title-preexec

function clear-screen-and-scrollback() {
    builtin echoti civis >"$TTY"
    builtin print -rn -- $'\e[H\e[2J' >"$TTY"
    builtin zle .reset-prompt
    builtin zle -R
    builtin print -rn -- $'\e[3J' >"$TTY"
    builtin echoti cnorm >"$TTY"
}

function y() {
    local tmp cwd
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
