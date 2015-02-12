autoload -U compinit
compinit
setopt HIST_IGNORE_DUPS
autoload -U promptinit
promptinit
prompt redhat
autoload -U colors
colors
PROMPT="%{$fg[green]%}[%n@%m %1~]%#%{$reset_color%} "
LEFT_PROMPT="%{$fg[green]%}[%n@%m"
RIGHT_PROMPT=" %1~]%#%{$reset_color%} "

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

PAGER=/usr/bin/lv

_set_env_git_current_branch() {
  GIT_CURRENT_BRANCH=$( git branch &> /dev/null | grep '^\*' | cut -b 3- )
}

_update_prompt () {
  if [ "`git ls-files 2>/dev/null`" ]; then
    PROMPT="%{$fg[green]%}${LEFT_PROMPT}:[${GIT_CURRENT_BRANCH}]${RIGHT_PROMPT}%{$reset_color%} "
  fi
}

: <<'#__COMMENT_OUT__'
_update_rprompt () {
  if [ "`git ls-files 2>/dev/null`" ]; then
    RPROMPT="[%~:$GIT_CURRENT_BRANCH]"
  else
    RPROMPT="[%~]"
  fi
}
#__COMMENT_OUT__


precmd() 
{ 
  _set_env_git_current_branch
  _update_prompt
}

chpwd()
{
  _set_env_git_current_branch
  _update_prompt
}
