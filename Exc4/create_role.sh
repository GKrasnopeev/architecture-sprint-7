#!/bin/bash

kubectl create role pod-reader --verb=get --verb=watch --verb=list --resource=pods
kubectl create role pod-write --verb=create --verb=patch --verb=update --verb=delete --resource=pods
kubectl create rolebinding admin-binding --role=pod-write --group=admins
kubectl create rolebinding admin-binding-read --role=pod-reader --group=admins