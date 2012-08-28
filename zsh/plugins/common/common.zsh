export LC_CTYPE="en_US.UTF-8"

# rw-r--r-- for files
# rwxr-xr-x for folders
umask 022

alias grep='grep --color=auto'
alias ls='ls -GhF'

alias l='ls -ls'
alias ll='ls -lsA'
alias lla='ls -la'

alias less='less --quiet'
alias df='df -h'
alias du='du -h'
alias m='mutt -y'
alias md='mkdir'
alias rd='rmdir'
alias cd..='cd ..'
alias tailf='tail -f'

alias myip="ifconfig | grep 192.168 || ifconfig | grep 10.32"
alias psg="ps ax | grep -i"

# Git
alias gspull='git stash && git pull && git stash pop'
alias gspush='git stash && git pull && git push && git stash pop'
alias gfspull='gitf stash && gitf pull && gitf stash pop'
alias gfspush='gitf stash && gitf pull && gitf push && git stash pop'

#export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a iTerm"'
export EDITOR='subl -w'

# functions
ff () {
  find . -iname $1 -print
}
