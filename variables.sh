# Set editor to vscode window if running inside vscode
if [ "$TERM_PROGRAM" = "vscode" ]; then
  export EDITOR='code -w -'
  export KUBE_EDITOR='code -w -'
fi