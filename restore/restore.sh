#!/bin/bash

# restore volumes via volsync
kubectl -k volsync/
# Array which includes all namespaces in which pods should be restartet
NAMESPACE_LIST=("default" "monitoring")

# Loop through each namespace in the list [@] creates 
for NAMESPACE in "${NAMESPACE_LIST[@]}"; do

  # Get the list of pod names in the namespace
  POD_NAMES=$(kubectl get pods -n $NAMESPACE --no-headers=true | awk '{print $1}')

  # Loop through each pod and delete it, which will cause it to be restarted
  for POD_NAME in $POD_NAMES; do
    kubectl delete pod $POD_NAME -n $NAMESPACE
  done

done
