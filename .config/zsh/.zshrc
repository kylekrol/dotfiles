bindkey -v

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_STATE_HOME"/zsh/history

# Aliases
alias diff='diff --color=auto'
alias dotfiles='git --git-dir="$HOME"/.dotfiles/.git --work-tree="$HOME"'
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias nmcli='nmcli --color yes'
alias wget='wget --hsts-file="$XDG_CACHE_HOME"/wget-hsts'

# Colored man pages
man() {
    env                                         \
        LESS_TERMCAP_mb=$(printf "\e[1;31m")    \
        LESS_TERMCAP_md=$(printf "\e[1;31m")    \
        LESS_TERMCAP_me=$(printf "\e[0m")       \
        LESS_TERMCAP_se=$(printf "\e[0m")       \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m")       \
        LESS_TERMCAP_us=$(printf "\e[1;32m")    \
        man "$@"
}

# Setup zsh autosuggestions and/or syntax highlighting if installed
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    bindkey '^x' autosuggest-accept
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Completions
zmodload zsh/complist

autoload -Uz compinit && compinit
_comp_options+=(globdots)

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

# Prompt
autoload -Uz colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git*' formats " %{$fg_bold[magenta]%}%s!%{$fg_bold[cyan]%}%b"

PS2="%{$fg_bold[blue]%}%#%{$reset_color%} "
precmd() {
    vcs_info

    PS1="%{$fg_bold[blue]%}@%m %{$fg_bold[yellow]%}%~${vcs_info_msg_0_}"

    if [[ -n "$VIRTUAL_ENV" ]]; then
        PS1+=" %{$fg_bold[magenta]%}$(basename "$VIRTUAL_ENV")!%{$fg_bold[cyan]%}$(python --version 2>&1 | sed 's/Python //')"
    fi

    PS1+="%{$reset_color%}
$PS2"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
setopt prompt_subst
