export LC_CTYPE="en_US.UTF-8"

# rw-r--r-- for files
# rwxr-xr-x for folders
umask 022

#export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a iTerm"'
#export EDITOR='subl -w'
export EDITOR='vim'

# functions
ff () {
  find . -iname $1 -print
}
