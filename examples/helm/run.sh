#!/bin/bash
# Qovery helm chart deployment example

if [ -n "$HELM_DEBUG_QOVERY" ] ; then
    set -x
fi

: "${HELM_REPO_ADD_NAME:=""}"
: "${HELM_REPO_ADD_URL:=default}"
: "${HELM_ADDITIONAL_PARAMS:=""}"
: "${HELM_VALUES_PATH:=""}"
: "${HELM_TIMEOUT_SEC:=180}"
: "${HELM_MAX_HISTORY:=50}"
: "${HELM_DRY_RUN:=false}"
: "${HELM_SHOW_DIFF:=false}"
: "${HELM_KUBERNETES_NAMESPACE:=$QOVERY_KUBERNETES_NAMESPACE_NAME}"
: "${KUBECONFIG_GET_EKS:=false}"
: "${ACTION:="$1"}"

echo "###################"
echo "# HELM DEPLOYMENT #"
echo "###################"

## Check prerequisites

if [ -z "$ACTION" ] ; then
    if [ "$ACTION" != "install" ] && [ "$ACTION" != "uninstall" ] ; then
        echo "Unknown action, command argument should be 'install' or 'uninstall'"
        exit 1
    fi
fi

if [ -z "$HELM_REPO_PATH" ] ; then
    echo "HELM_REPO_PATH environment variable not set"
    exit 1
fi

if [ -z "$HELM_RELEASE_NAME" ] ; then
    echo "HELM_RELEASE_NAME environment variable not set"
    exit 1
fi

# Manage KUBECONFIGS
KUBECONFIG_FILE_PATH="$HOME/.kube/config"
if [ -n "$KUBECONFIG_B64" ] ; then
    mkdir -p "$HOME/.kube"
    echo "$KUBECONFIG_B64" | base64 -d > "$KUBECONFIG_FILE_PATH" && chmod 600 "$KUBECONFIG_FILE_PATH"
    export KUBECONFIG=$KUBECONFIG_FILE_PATH
fi

if [ "$KUBECONFIG_GET_EKS" == "true" ] ; then

    if [ -z "$QOVERY_CLOUD_PROVIDER_REGION" ] ; then
        echo "QOVERY_CLOUD_PROVIDER_REGION environment variable not set"
        exit 1
    fi

    if [ -z "$QOVERY_KUBERNETES_CLUSTER_NAME" ] ; then
        echo "QOVERY_KUBERNETES_CLUSTER_NAME environment variable not set"
        exit 1
    fi

    CMD="aws eks update-kubeconfig --region $QOVERY_CLOUD_PROVIDER_REGION --name $QOVERY_KUBERNETES_CLUSTER_NAME"
    echo -e "\n\n[+] Running: $CMD\n"
    $CMD || exit 1
    export KUBECONFIG="$HOME/.kube/config"
fi

if [ -z "$KUBECONFIG" ] && [ ! -f "$KUBECONFIG_FILE_PATH" ] ; then
    echo "No KUBECONFIG or $KUBECONFIG_FILE_PATH found"
    exit 1
fi

## Print config
echo -e "\n##### CONFIGURED PARAMETERS #####"
echo "HELM_REPO_ADD_NAME:         $HELM_REPO_ADD_NAME"
echo "HELM_REPO_ADD_URL:          $HELM_REPO_ADD_URL"
echo "HELM_REPO_PATH:             $HELM_REPO_PATH"
echo "HELM_RELEASE_NAME:          $HELM_RELEASE_NAME"
echo "HELM_VALUES_PATH:           $HELM_VALUES_PATH"
echo "HELM_TIMEOUT_SEC:           $HELM_TIMEOUT_SEC"
echo "HELM_MAX_HISTORY:           $HELM_MAX_HISTORY"
echo "HELM_DRY_RUN:               $HELM_DRY_RUN"
echo "HELM_SOW_DIFF:              $HELM_SHOW_DIFF"
echo "HELM_ADDITIONAL_PARAMS:     $HELM_ADDITIONAL_PARAMS"
echo "HELM_KUBERNETES_NAMESPACE:  $HELM_KUBERNETES_NAMESPACE"
echo "KUBECONFIG:                 $KUBECONFIG"

## Setup repo
if [ "$HELM_REPO_ADD_URL" != "default" ] && [ "$HELM_REPO_ADD_NAME" != "" ] ; then
    CMD="helm repo add $HELM_REPO_ADD_NAME $HELM_REPO_ADD_URL"
    echo -e "\n\n[+] Running: $CMD\n"
    $CMD || exit 1
fi

## Set params if required
HELM_NAMESPACE_PARAMS=""
HELM_CREATE_NAMESPACE_PARAMS=""
if [ "$HELM_KUBERNETES_NAMESPACE" != "" ] ; then
    HELM_NAMESPACE_PARAMS="--namespace $HELM_KUBERNETES_NAMESPACE"
    HELM_CREATE_NAMESPACE_PARAMS="--create-namespace --namespace $HELM_KUBERNETES_NAMESPACE"
fi

HELM_TIMEOUT="--timeout ${HELM_TIMEOUT_SEC}s"

if [ "$HELM_VALUES_PATH" != "" ] ; then
    HELM_VALUES_PATH="-f $HELM_VALUES_PATH"
fi

if [ "$HELM_DRY_RUN" == "false" ] ; then
    HELM_DRY_RUN=''
else
    HELM_DRY_RUN='--dry-run'
fi

if [ "$ACTION" == "install" ] ; then
    if [ "$HELM_SHOW_DIFF" == "true" ] ; then
        ## Show diff
        CMD="helm diff upgrade --install $HELM_NAMESPACE_PARAMS $HELM_VALUES_PATH $HELM_RELEASE_NAME $HELM_REPO_PATH"
        echo -e "\n\n[+] Running: $CMD\n"
        $CMD
    fi

    ## Install/upgrade
    CMD="helm upgrade --install --wait --atomic --history-max $HELM_MAX_HISTORY $HELM_TIMEOUT $HELM_DRY_RUN $HELM_CREATE_NAMESPACE_PARAMS $HELM_VALUES_PATH $HELM_ADDITIONAL_PARAMS $HELM_RELEASE_NAME $HELM_REPO_PATH"
    echo -e "\n\n[+] Running: $CMD\n"
    $CMD
elif [ "$ACTION" == "uninstall" ] ; then
    ## Ensure it's installed, otherwise, it's ok
    if [ $(helm $HELM_NAMESPACE_PARAMS list -f "^$HELM_RELEASE_NAME$" --no-headers | wc -l) -eq 1 ] ; then
        ## Uninstall
        CMD="helm uninstall --wait $HELM_DRY_RUN $HELM_NAMESPACE_PARAMS $HELM_TIMEOUT $HELM_VALUES_PATH $HELM_RELEASE_NAME"
        echo -e "\n\n[+] Running: $CMD\n"
        $CMD
    else
        echo "'$HELM_RELEASE_NAME' release in namespace '$HELM_KUBERNETES_NAMESPACE' was not found, it may have already been uninstalled manually"
    fi
else
    echo "Unknown action: $ACTION"
    exit 1
fi
