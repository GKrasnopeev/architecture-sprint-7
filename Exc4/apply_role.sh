#!/bin/bash

kubectl config use-context minikube
kubectl apply -f ./roles.yml
kubectl apply -f ./binding.yml
