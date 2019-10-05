function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function git_stash_count() {
  if [ $GIT_BRANCH != ""]; then
    count=$(git 2>/dev/null stash list | grep "${GIT_BRANCH}" | wc -l | awk '{print $1}')
    [ $count != 0 ] && echo " ($count)"
  fi
}

# Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" on "
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}●"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}✓"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}|$(git_stash_count)"

ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_STAGED="|%{$fg[red]%}%{✚ %G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="|%{$fg[red]%}%{✖ %G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="|%{$fg[yellow]%}%{✎ %G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="|%{$fg[blue]%}%{⬇ %G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="|%{$fg[blue]%}%{⬆ %G%}"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="|%{$fg[yellow]%}%{✱%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="|%{$fg_bold[green]%}%{✔%G%}"


ZSH_THEME_XENV_PROMPT_PREFIX=" using "
ZSH_THEME_XENV_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_XENV_PROMPT_SEP=" "
ZSH_THEME_XENV_RUBY_ICON=$'RB'
ZSH_THEME_XENV_PYTHON_ICON=$'PY'
ZSH_THEME_XENV_JAVA_ICON=$'J'
ZSH_THEME_XENV_RBENV_PROMPT_PREFIX="%{$fg_bold[red]%}${ZSH_THEME_XENV_RUBY_ICON}%{$reset_color%}|%{$fg_bold[white]%}"
ZSH_THEME_XENV_PYENV_PROMPT_PREFIX="%{$fg_bold[green]%}${ZSH_THEME_XENV_PYTHON_ICON}%{$reset_color%}|%{$fg_bold[white]%}"
ZSH_THEME_XENV_JENV_PROMPT_PREFIX="%{$fg_bold[magenta]%}${ZSH_THEME_XENV_JAVA_ICON}%{$reset_color%}|%{$fg_bold[white]%}"

function join_arr {
  echo -n "$1"
  if [ "$#" -gt 1 ]; then
    shift
    printf "%s" "${@/#/$ZSH_THEME_XENV_PROMPT_SEP}"
  fi
}


function xenv_prompt_info() {
  local -a lang_versions

  if [[ $+commands[rbenv] -eq 1 && -n "$(rbenv local 2>/dev/null)" ]]; then
    lang_versions+="${ZSH_THEME_XENV_RBENV_PROMPT_PREFIX}$(rbenv_prompt_info)"
  fi
  if [[ $+commands[pyenv] -eq 1 &&  -n "$(pyenv local 2>/dev/null)" ]]; then
    lang_versions+="${ZSH_THEME_XENV_PYENV_PROMPT_PREFIX}$(pyenv_prompt_info)"
  fi
  if [[ $+commands[jenv] -eq 1 && -n "$(jenv local 2>/dev/null)" ]]; then
    lang_versions+="${ZSH_THEME_XENV_JENV_PROMPT_PREFIX}$(jenv_prompt_info)"
  fi

  if [ ${#lang_versions[*]} -gt 0 ]; then
    echo "${ZSH_THEME_XENV_PROMPT_PREFIX}$(join_arr ${lang_versions})${ZSH_THEME_XENV_PROMPT_SUFFIX}"
  fi
}

# git_prompt_info

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[blue]%}%2c%{$reset_color%}$(xenv_prompt_info)$(git_super_status)
%% '
RPROMPT=''
