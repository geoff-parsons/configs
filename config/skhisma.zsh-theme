function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function git_branch_name() {
  git branch 2> /dev/null | grep "^\*" | sed "s/^\*\ //"
}

function git_stash_count() {
  branch=$(git_branch_name)
  if [ $branch != ""]; then
    count=$(git 2> /dev/null stash list | grep "${branch}" | wc -l | awk '{print $1}')
    [ $count != 0 ] && echo " ($count)"
  fi
}

# Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" on "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}$(git_stash_count)"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}✓"

# RVM prompt
ZSH_THEME_RVM_PROMPT_PREFIX=" using %{$fg_bold[blue]%}"
ZSH_THEME_RVM_PROMPT_SUFFIX="%{$reset_color%}"


PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[blue]%}%2c%{$reset_color%}$(git_prompt_info)$(rvm_prompt_info)
%% '
