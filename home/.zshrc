autoload -Uz add-zsh-hook compinit
zmodload zsh/complist

typeset -U path fpath PATH

export EDITOR="nvim"
export LESS="--RAW-CONTROL-CHARS"
export MANPAGER="nvim +Man!"
export GOPATH="$HOME/.local/share/go"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export CHROME_EXECUTABLE="/Applications/Helium.app/Contents/MacOS/Helium"

path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.antigravity/antigravity/bin"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "$ANDROID_HOME/platform-tools"
    "/opt/homebrew/opt/openjdk@21/bin"
    $path
)

fpath=(
    "$HOME/.docker/completions"
    $fpath
)

[[ -f "$HOME/.LESS_TERMCAP" ]] &&
    source "$HOME/.LESS_TERMCAP"

setopt PROMPT_SUBST
setopt AUTOCD
setopt INTERACTIVE_COMMENTS

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

git_branch() {
    local branch

    branch=$(git symbolic-ref --short HEAD 2>/dev/null) ||
        branch=$(git rev-parse --short HEAD 2>/dev/null) ||
        return

    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        print -r -- " %F{blue} $branch%f%F{red}*%f"
    else
        print -r -- " %F{blue} $branch%f"
    fi
}

PROMPT='%B%F{red}[%F{green}%n%F{yellow}@%F{blue}%m %F{magenta}%1~%F{red}]%f%F{yellow}$(git_branch)%f %#%b '

[[ -r "$HOME/.config/zsh/aliases" ]] &&
    source "$HOME/.config/zsh/aliases"

[[ -r "$HOME/.config/zsh/startup" ]] &&
    source "$HOME/.config/zsh/startup"

ZSH_PLUGIN_DIR="/opt/homebrew/share"

[[ -r "$ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] &&
    source "$ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"

[[ -r "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_CACHE_DIR="$HOME/.cache/zsh"

mkdir -p "$ZSH_CACHE_DIR"

compinit -d "$ZSH_CACHE_DIR/zcompdump"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

bindkey -v
export KEYTIMEOUT=1

bindkey -v '^?' backward-delete-char
bindkey '^[^?' backward-delete-word
bindkey '^[[3;2~' forward-delete-word

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

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

FZF_DIR="$(brew --prefix)/opt/fzf/shell"

[[ -r "$FZF_DIR/key-bindings.zsh" ]] &&
    source "$FZF_DIR/key-bindings.zsh"

[[ -r "$FZF_DIR/completion.zsh" ]] &&
    source "$FZF_DIR/completion.zsh"

tmux-widget() {
    [[ -n "$TMUX" ]] && return

    BUFFER="tmux new-session -A -s main"
    zle accept-line
}

zle -N tmux-widget
bindkey -M viins '^ ' tmux-widget

# clear-screen-and-scrollback() {
#     builtin echoti civis >"$TTY"
#     builtin print -rn -- $'\e[H\e[2J' >"$TTY"
# 
#     builtin zle .reset-prompt
#     builtin zle -R
# 
#     builtin print -rn -- $'\e[3J' >"$TTY"
#     builtin echoti cnorm >"$TTY"
# }
# 
# zle -N clear-screen-and-scrollback
# bindkey '^X^L' clear-screen-and-scrollback

zle-keymap-select() {
    case "$KEYMAP" in
        vicmd)
            print -n -- '\e[1 q'
            ;;
        viins | main)
            print -n -- '\e[5 q'
            ;;
    esac
}

zle -N zle-keymap-select

zle-line-init() {
    zle -K viins
    print -n -- '\e[5 q'
}

zle -N zle-line-init

preexec() {
    print -n -- '\e[5 q'
}

title-precmd() {
    print -Pn '\e]2;%~\a'
}

title-preexec() {
    print -Pn '\e]2;${(q-)1}\a'
}

add-zsh-hook precmd title-precmd
add-zsh-hook preexec title-preexec

y() {
    local tmp cwd

    tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return

    yazi "$@" --cwd-file="$tmp"

    if [[ -f "$tmp" ]]; then
        cwd="$(<"$tmp")"
        rm -f "$tmp"

        [[ -d "$cwd" ]] && cd -- "$cwd"
    fi
}

[[ -r "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
