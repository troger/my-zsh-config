export ZSH=$HOME/.zsh

# Load custom plugins
for plugin ($ZSH/plugins/*) source $plugin/*.zsh

# emacs mode
bindkey -e

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export NVM_DIR="/Users/tom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# hub alias
eval "$(hub alias -s)"
