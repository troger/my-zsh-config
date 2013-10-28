export ZSH=$HOME/.zsh

# Load custom plugins
for plugin ($ZSH/plugins/*) source $plugin/*.zsh

# emacs mode
bindkey -e

