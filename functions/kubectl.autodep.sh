#!/usr/bin/env zsh

# Function to print Kubernetes secret data
ksecret() {
  local namespace
  local secret

  if [ ! -t 0 ]; then
    # Read YAML from stdin
    yaml=$(< /dev/stdin)
    echo $yaml | yq '.data[] | key + ": " + @base64d'
    return
  fi

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case $1 in
      -n|--namespace)
        namespace=$2
        shift 2
        ;;
      -*)
        echo "Unknown option: $1"
        return 1
        ;;
      *)
        secret=$1
        shift
        ;;
    esac
  done

  if [[ -z $secret ]]; then
    echo "Usage: ksecret [-n <namespace>] <secret-name>"
    return 1
  fi

  echo $(kubectl get secret "$secret" ${namespace:+-n${namespace}}  -o go-template='{{range $k,$v := .data}}{{printf "%s: %s\\n" $k (base64decode $v)}}{{end}}')
}

# Completion function for ksecret
_ksecret() {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  local -a secrets namespaces

  cur="${words[CURRENT]}"

  # Complete namespace after -n
  if [[ "${words[CURRENT-1]}" == "-n" ]]; then
    namespaces=($(kubectl get ns -o jsonpath='{.items[*].metadata.name}'))
    _describe 'namespace' namespaces
    return
  fi

  # Complete secret names (use -n if specified)
  # Determine namespace from flag if present
  namespace=""
  for ((i=1;i<=$#words;i++)); do
    if [[ "${words[i]}" == "-n" && $((i+1)) -le $#words ]]; then
      namespace="${words[i+1]}"
    fi
  done

  secrets=($(kubectl get secrets -n "$namespace" -o jsonpath='{.items[*].metadata.name}'))
  _describe 'secret' secrets
}

# Register the completion for ksecret
compdef _ksecret ksecret
