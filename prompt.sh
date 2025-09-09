_myzsh_sanitize() {
  echo "$1" | sed 's/%/%%/g'  # escape % to prevent prompt sequence issues
}

_myzsh_dynamic_prompt() {

  APPEND_PROMPT=""
  # Loop over files in the directory
  for file in "$MYZSH"/prompt-helpers/*.autodep.sh; do
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

      if [[ ! -z "${EXPORT_PROMPT_SKIP}" ]]; then
        unset EXPORT_PROMPT_SKIP
        continue
      fi

      APPEND_PROMPT+=" [$EXPORT_PROMPT%{$reset_color%}]"
      unset EXPORT_PROMPT
    fi
  done
  echo "$APPEND_PROMPT"
}


PROMPT='%{$fg_bold[green]%}%n@$SHORT_HOST %{$fg[blue]%}%D{[%X]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%}$(_myzsh_dynamic_prompt)
%{$fg_bold[blue]%}\$%{$reset_color%} '

# Slight mod of omz candy
# PROMPT=$'%{$fg_bold[green]%}%n@$SHORT_HOST %{$fg[blue]%}%D{[%X]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} \
# %{$fg[blue]%}%{$fg_bold[blue]%}\$%{$reset_color%} '

