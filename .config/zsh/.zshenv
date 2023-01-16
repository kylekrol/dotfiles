export BROWSER=google-chrome
export EDITOR=nvim
export SHELL=zsh
export TERM=alacritty
export VISUAL=nvim

export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME"/ripgrep/config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export TEXMFHOME="$XDG_DATA_HOME"/texmf
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export TEXMFCONFIG="$XDG_CONFIG_HOME"/texlive/texmf-config
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

export PATH="$CARGO_HOME"/bin:"$HOME"/.local/bin:"$PATH"

