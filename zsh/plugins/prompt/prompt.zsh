##########
# Prompt #
##########
setopt prompt_subst
autoload colors
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' formats ' [%b]'

# set some colors
for COLOR in MAGENTA BLUE RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

function precmd() {
  vcs_info 'prompt'
  PS1="${PR_BLUE}%n${PR_YELLOW}${PR_RESET} ${PR_GREEN}%~${PR_CYAN}${vcs_info_msg_0_}${PR_RESET} "
  RPS1="${PR_WHITE}[%t]${PR_RESET}"
}

