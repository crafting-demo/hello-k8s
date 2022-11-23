#!/bin/bash

while true; do
    HOST=$(kubectl -n $APP_NS get svc frontend-lb -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    [[ -n "$HOST" ]] || HOST=$(kubectl -n $APP_NS get svc frontend-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [[ -z "$HOST" ]]; then
        echo "External load balancer IP/Hostname unavailable ..."
        sleep 1
        continue
    fi
    echo "External load balancer: $HOST"
    socat TCP-LISTEN:3800,fork,reuseaddr TCP-CONNECT:$HOST:80
done
