#!/usr/bin/env zsh

#oh my zsh plugin

# Utility print functions (json / yaml)
function _build_kubectl_out_alias {
  setopt localoptions norcexpandparam

  # alias function
  eval "function $1 { $2 }"

  # completion function
  eval "function _$1 {
    words=(kubectl \"\${words[@]:1}\")
    _kubectl
  }"

  compdef _$1 $1
}

_build_kubectl_out_alias "kj"  'kubectl "$@" -o json | jq'
_build_kubectl_out_alias "ky"  'kubectl "$@" -o yaml | yq'
unfunction _build_kubectl_out_alias

_kvent() {
    typeset -A opt_args

  if [ "$CURRENT" -eq 2 ]; then
    local events=($(kubectl get events -o jsonpath='{range .items[*]}{.involvedObject.kind}/{.involvedObject.name}{"\n"}{end}' 2>/dev/null | tr '[:upper:]' '[:lower:]' | uniq))
    _describe "event objects" events
    return
  fi

}
compdef _kvent kvent