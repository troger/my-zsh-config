##########
# Prompt #
##########
setopt prompt_subst
autoload colors
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' formats ' %F{blue}[%F{cyan}%b%F{blue}]%f'
zstyle ':vcs_info:git*' formats ' %F{blue}[%F{cyan}%b%c%u%F{blue}]%f'

zstyle ':vcs_info:git*:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:git*:*' unstagedstr "%F{yellow}●%f"
zstyle ':vcs_info:*' check-for-changes true

# set some colors
for COLOR in MAGENTA BLUE RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

function precmd() {
  vcs_info 'prompt'
  PS1="${PR_BLUE}%n${PR_YELLOW}${PR_RESET} ${PR_GREEN}%~${PR_CYAN}${vcs_info_msg_0_}${PR_RESET} "
  RPS1="${PR_BLACK}[%t]${PR_RESET}"
}

