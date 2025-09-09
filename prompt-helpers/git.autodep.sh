MYZSH_P_GIT_BRANCH=$(_myzsh_sanitize $(git branch --show-current 2>/dev/null))
if ! git rev-parse --is-inside-work-tree &>/dev/null; then 
  EXPORT_PROMPT_SKIP=true
  return
fi

_myzsh_git_prompt() {
  # Check if we're inside a git repo
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  # Current branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always)

  # Ahead/behind info
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [ -n "$upstream" ]; then
    counts=$(git rev-list --left-right --count HEAD..."$upstream" 2>/dev/null)
    ahead=$(echo "$counts" | awk '{print $1}')
    behind=$(echo "$counts" | awk '{print $2}')
  else
    behind=0
    ahead=0
  fi

  # Changes (staged + unstaged + untracked)
  changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ] && [ "$changes" -eq 0 ]; then
    color="%F{2}"
  else
    color="%F{1}"
  fi

  # Output format: branch↓behind↑ahead ✚changes
  out="$branch"
  [ "$behind" -ne 0 ] && out="$out↓$behind"
  [ "$ahead"  -ne 0 ] && out="$out↑$ahead"
  [ "$changes" -ne 0 ] && out="$out ✚$changes"
  out="$out"

  printf "%s%s%s" "$color" "$(_myzsh_sanitize "$out")" "%f"
}

EXPORT_PROMPT="$(_myzsh_git_prompt)"