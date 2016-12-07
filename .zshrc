fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
setopt HIST_IGNORE_DUPS
autoload -U promptinit
promptinit
prompt redhat
autoload -U colors
colors
colornum() {
	COLORNO="$(hostname|sum|cut -c1-2)"
	# correct color looks like black ink
        if [ "$COLORNO" = "10" ]; then
                COLORNO="19"
        fi
        if [ "$COLORNO" = "e3" ]; then
                COLORNO="e6"
        fi
        if [ "$COLORNO" = "e4" ]; then
                COLORNO="e7"
        fi
}
colornum
#local HOSTC=$'%{\e[38;5;'"$(printf "%d\n" 0x$(hostname|md5sum|cut -c1-2))"'m%}'
#local DEFAULTC=$'%{\e[m%}'
#local HOSTCOLOR=$'\e[38;5;'"$(printf "%d\n" 0x$(hostname|sum|cut -c1-2))"'m'
local HOSTCOLOR=$'\e[38;5;'"$(printf "%d\n" 0x$COLORNO)"'m'
#PROMPT="%{$fg[green]%}[%n@%m %1~]%#%{$reset_color%} "
PROMPT="%{$HOSTCOLOR%}[%n@%m %1~]%#%{$reset_color%} "
#LEFT_PROMPT="%{$fg[green]%}[%n@%m"
LEFT_PROMPT="%{$HOSTCOLOR%}[%n@%m"
RIGHT_PROMPT=" %1~]%#%{$reset_color%} "

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

PAGER=/usr/bin/lv
export PATH="${HOME}/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# alias ls='ls --show-control-chars'  # prepare for kanji as ???

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

# rbenv completions
if [[ ! -o interactive ]]; then
    return
fi

compctl -K _rbenv rbenv

_rbenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(rbenv commands)"
  else
    completions="$(rbenv completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}

# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

case ${OSTYPE} in
  darwin*)
    bindkey '' forward-word
    bindkey '' backward-word
    # Brew-file
    if [ -f $(brew --prefix)/etc/brew-wrap ]; then
      source $(brew --prefix)/etc/brew-wrap
    fi
    ;;
  linux*)
    ;;
esac

