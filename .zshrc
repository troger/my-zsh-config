###############
# tom's zshrc #
###############

export ZSH=$HOME/.zsh

######################
# command completion #
######################

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' use-compctl false

autoload -Uz compinit
compinit

############
# NO beep! #
############
unsetopt beep
unsetopt hist_beep
unsetopt list_beep

###############
# zsh options #
###############
unsetopt clobber
unsetopt ignore_eof
setopt nullglob
setopt auto_cd
# pushd & popd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home
# bg jobs
unsetopt bg_nice
unsetopt hup
# completion
unsetopt list_ambiguous
setopt auto_remove_slash
unsetopt glob_dots
setopt chase_links

###########
# history #
###########
export HISTORY=1000
export SAVEHIST=1000
export HISTFILE=$HOME/.history
# options
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first

# rw-r--r-- for files
# rwxr-xr-x for folders
umask 022

# Load custom plugins
for plugin ($ZSH/plugins/*) source $plugin/*.zsh

