##########
# Prompt #
##########
setopt prompt_subst
autoload colors
colors

# set some colors
for COLOR in MAGENTA BLUE RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

autoload -U regexp-replace
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}S%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}U%f'


zstyle ':vcs_info:git*' formats ' %F{magenta}[%b %c%u%m%F{magenta}]%f'
zstyle ':vcs_info:git*' actionformats ' %F{blue}[%F{red}(%a)%F{blue}%b %c%u%m%F{blue}]%f'

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash git-untracked

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats': %c
function +vi-git-untracked(){
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[unstaged]+='%F{red}T%f'
    fi
}

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    hook_com[misc]+=" %f(${remote})"

    # if [[ -n ${remote} ]] ; then
    #     ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    #     regexp-replace ahead ' ' ''
    #     (( $ahead )) && gitstatus+=( "%F{green}+${ahead}%f" )

    #     behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    #     regexp-replace behind ' ' ''
    #     (( $behind )) && gitstatus+=( "%F{red}-${behind}%f" )
    #     if [ "${gitstatus}" ] ; then ;
    #       hook_com[misc]+=" %f(${remote} ${(j:/:)gitstatus})" ;
    #     else ;
    #       hook_com[misc]+=" %f(${remote})"
    #     fi

    #fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(command git stash list 2>/dev/null | wc -l)
        regexp-replace stashes ' ' ''
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

function precmd() {
  vcs_info 'prompt'
  PS1="${PR_BLUE}%n${PR_YELLOW}${PR_RESET} ${PR_GREEN}%~${vcs_info_msg_0_}${PR_RESET} "
  RPS1="${PR_YELLOW}[%t]${PR_RESET}"

  __LAST=${PWD##*/}
  __IN=${PWD%/*}
  regexp-replace __IN "$HOME" '~'
  echo -ne "\e]1;${__LAST} in ${__IN}\a"
}
