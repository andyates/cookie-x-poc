#!/bin/bash
# (C) Copyright 2023 Hewlett Packard Enterprise Development LP

set -e

ISTIOPATH="$HOME/istio-1.17.2"
COOKIEXIMAGE="cookie-x-poc"


if [ ! -d "$ISTIOPATH" ]; then
        echo "Istio installation not found: $ISTIOPATH"
        exit 1
else
        echo "IstioPath installation: $ISTIOPATH"
fi

pushd $ISTIOPATH

# if errors happens from now on, ignore and keep executing
set +e

kubectl delete -f samples/addons
sleep 3
istioctl uninstall -y --purge
sleep 3
kubectl delete namespace istio-system
sleep 5
kubectl label namespace default istio-injection-
kubectl delete -f samples/bookinfo/platform/kube/bookinfo.yaml
sleep 3
kubectl delete -f samples/bookinfo/networking/bookinfo-gateway.yaml
sleep 3

popd
kubectl delete -f cookie-x-app.yaml
kubectl delete -f policy.yml
kubectl delete -f xauth.yml
kubectl delete -f httpbin.yaml
kubectl delete -f httpbin-gateway.yaml
kubectl delete -f sleep.yaml

echo "Cleaning up docker image"
docker images | grep -i $COOKIEXIMAGE | awk '{ print $3}' | xargs docker rmi -f
