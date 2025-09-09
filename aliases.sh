#!/usr/bin/env zsh


for file in "$MYZSH"/aliases/*.autodep.sh; do
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

alias kcm="$MYZSH"/plugin/kcm/kcm