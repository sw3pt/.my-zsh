#!/usr/bin/env zsh

# Enable quick reverse search 
# https://unix.stackexchange.com/a/672892
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Most of the rest is from oh-my-zsh
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end
setopt prompt_subst


# Autocomplete case-insentive
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-cache yes


export ZSH_CACHE_DIR=~/.my-zsh-cache/
mkdir -p $ZSH_CACHE_DIR
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Highlight Autocompleted element
zstyle ':completion:*' menu select


for file in "$MYZSH"/completions/*.autodep.sh; do
  # Skip if no files match
  [ -e "$file" ] || continue

  cmd_name=$(basename "$file" .autodep.sh)

  # Check if the command exists using whence
  cmd_path=$(whence "$cmd_name")

  # Construct the "disable" variable dynamically
  disable_var="DISABLE_${cmd_name:u}"  # uppercase helper name

  # Check if command exists AND the disable variable is not set
  if [ -n "$cmd_path" ] && [ -z "${(P)disable_var}" ]; then
    source "$file"
  fi
done


# Setup MacOS specific completions
if [[ "$OSTYPE" = darwin* ]]; then
  if docker desktop version >/dev/null 2>&1; then
    fpath=(~/.docker/completions $fpath)
  fi
  if whence brew >/dev/null 2>&1; then
    fpath=(/opt/homebrew/completions/zsh $fpath)
  fi
fi

# Setup Kubectl autocomplete
if whence kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
# Setup oc autocomplete
if whence oc >/dev/null 2>&1; then
  source <(oc completion zsh)
fi
# Setup kcm autocomplete
if whence kcm >/dev/null 2>&1; then
  source <(kcm completion zsh)
fi
# Setup kcm autocomplete
if whence virtctl >/dev/null 2>&1; then
  source <(virtctl completion zsh)
fi

