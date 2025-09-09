#!/usr/bin/env zsh

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history


setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt sharehistory

alias history='fc -lf'