#!/usr/bin/env bash

set -e

CONFIG="$1"
NAME="$2"
FORMAT="$3"
DESCRIBE="$4"

if [[ -z ${CONFIG} ]]; then
  echo "Usage: $0 kubeconfig.yaml [directory_name] [output_format] [describe_items_too?]"
  exit 1
fi

if [[ -z ${NAME} ]]; then
  NAME="k8s"
fi

if [[ -z ${FORMAT} ]]; then
  FORMAT="json"
fi

if [[ -z ${DESCRIBE} ]]; then
  DESCRIBE="true"
fi

mkdir -p ${NAME}


# All api resources can be obtained via kubectl api-resources
# Note the following are not supported (at least in digital ocean's kubernetes, where this was tested):
# unavailable namespaced resources: bindings, localsubjectaccessreviews
# unavailable non namespaced resources: tokenreviews, selfsubjectaccessreviews, selfsubjectrulesreviews, subjectaccessreviews


NAMESPACED_RESOURCES=(
configmaps
endpoints
events
limitranges
persistentvolumeclaims
pods
podtemplates
replicationcontrollers
resourcequotas
secrets
serviceaccounts
services
controllerrevisions
daemonsets
deployments
replicasets
statefulsets
horizontalpodautoscalers
cronjobs
jobs
ciliumendpoints
ciliumnetworkpolicies
leases
endpointslices
events
ingresses
ingresses
networkpolicies
poddisruptionbudgets
rolebindings
roles
volumesnapshots
)

NON_NAMESPACED_RESOURCES=(
componentstatuses
namespaces
nodes
persistentvolumes
mutatingwebhookconfigurations
validatingwebhookconfigurations
customresourcedefinitions
apiservices
certificatesigningrequests
ciliumclusterwidenetworkpolicies
ciliumnodes
ingressclasses
runtimeclasses
podsecuritypolicies
clusterrolebindings
clusterroles
priorityclasses
volumesnapshotclasses
volumesnapshotcontents
csidrivers
csinodes
storageclasses
volumeattachments
)


mkdir -p ${NAME}



for res in ${NON_NAMESPACED_RESOURCES[@]}; do
  kubectl --kubeconfig=${CONFIG} get ${res} -o ${FORMAT} > ${NAME}/${res}.${FORMAT}

  if [[ "$DESCRIBE" == "true" ]]; then
    kubectl --kubeconfig=${CONFIG} describe  ${res} -A > ${NAME}/describe_${res}.txt
  fi
done


for res in ${NAMESPACED_RESOURCES[@]}; do
  kubectl --kubeconfig=${CONFIG} get ${res} -A -o ${FORMAT} > ${NAME}/${res}.${FORMAT}

  if [[ "$DESCRIBE" == "true" ]]; then
    kubectl --kubeconfig=${CONFIG} describe  ${res} -A > ${NAME}/describe_${res}.txt
  fi
done


