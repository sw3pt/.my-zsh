MYZSH_P_KUBE_KUBECTL="${MYZSH_P_KUBE_KUBECTL:-kubectl}"

MYZSH_P_KUBE_NAMESPACE=$(_myzsh_sanitize $(${MYZSH_P_KUBE_KUBECTL} config view --minify --output 'jsonpath={..namespace}' 2>/dev/null))
MYZSH_P_KUBE_CLUSTER=$(_myzsh_sanitize $(${MYZSH_P_KUBE_KUBECTL} config view --minify --output 'jsonpath={.clusters[0].name}' 2>/dev/null))

MYZSH_P_KUBE_CLUSTER_COLOR="${MYZSH_P_KUBE_CLUSTER_COLOR:-green}"

EXPORT_PROMPT="%{$fg[$MYZSH_P_KUBE_CLUSTER_COLOR]%}${MYZSH_P_KUBE_CLUSTER}%{$reset_color%}/%{$fg[magenta]%}${MYZSH_P_KUBE_NAMESPACE}"