#!/bin/sh

kubectl config set-cluster test-doc --server=http://localhost:8080
kubectl config set-context test-doc --cluster=test-doc
kubectl config use-context test-doc
