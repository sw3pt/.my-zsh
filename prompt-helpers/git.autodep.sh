MYZSH_P_GIT_BRANCH=$(_myzsh_sanitize $(git branch --show-current 2>/dev/null))
if ! git rev-parse --is-inside-work-tree &>/dev/null; then 
  EXPORT_PROMPT_SKIP=true
fi
EXPORT_PROMPT="%F{166}$MYZSH_P_GIT_BRANCH%f"