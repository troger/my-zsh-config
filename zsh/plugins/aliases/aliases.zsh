###########
# Aliases #
###########

alias grep='grep --color=auto'
alias ls='ls -GhF'

alias l='ls -ls'
alias ll='ls -lsA'
alias lla='ls -la'

alias df='df -h'
alias du='du -h'
alias m='mutt -y'
alias md='mkdir'
alias rd='rmdir'
alias cd..='cd ..'
alias tailf='tail -f'

alias myip="ifconfig | grep 192.168 || ifconfig | grep 10.32 || ifconfig | grep 10.213"
alias psg="ps ax | grep -i"

alias sb='subl'

alias gradlew="./gradlew"

alias less='less -RiX'

alias code='code-insiders'

alias redis-start='redis-server /usr/local/etc/redis.conf'
