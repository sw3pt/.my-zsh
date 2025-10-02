# Set editor to vscode window if running inside vscode
if [ "$TERM_PROGRAM" = "vscode" ]; then
  export EDITOR='code -w -'
  export KUBE_EDITOR='code -w -'
fi

if whence kcm >/dev/null 2>&1; then
  source <(kcm setup terminal)
fi