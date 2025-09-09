#!/usr/bin/env zsh

# Verify that we are in zsh

[ -n "$ZSH_VERSION" ] || {
  echo "not running zsh?"
  return 1
}
MYZSH=${0:a:h}

autoload -U colors && colors

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

setopt autocd
setopt autopushd
setopt combiningchars
setopt noflowcontrol
setopt interactive
setopt interactivecomments
setopt longlistjobs
setopt monitor
setopt pushdignoredups
setopt pushdminus
setopt zle

source "$MYZSH"/aliases.sh
source "$MYZSH"/common.sh
source "$MYZSH"/completion.sh
source "$MYZSH"/history.sh
source "$MYZSH"/prompt.sh
source "$MYZSH"/functions.sh

source <("$MYZSH"/plugin/kcm/kcm setup terminal)