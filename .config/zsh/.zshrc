
# Enable colors
autoload -Uz colors && colors

# Configure the history files
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_STATE_HOME"/zsh/history

# Update zsh completions
#fpath=(~/.local/src/zsh-completions/src $fpath)

# Basic auto/tab completion (including hidden files)
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Control key bindings
function kkrol::to_vim() {
  BUFFER=""
  zle accept-line
}
zle -N kkrol::to_vim
bindkey "^v" kkrol::to_vim

# VI mode
bindkey -v
export KEYTIMEOUT=1

# Aliases and prompt
source "$ZDOTDIR/aliasesrc"
source "$ZDOTDIR/promptrc"

# Enable autosuggestions and syntax highlighting
bindkey '^x' autosuggest-accept
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

