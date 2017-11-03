export ZSH=$HOME/.zsh

# Load custom plugins
for plugin ($ZSH/plugins/*) source $plugin/*.zsh

# emacs mode
bindkey -e

export NVM_DIR="/Users/tom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# hub alias
eval "$(hub alias -s)"
