#!/bin/bash

resources=(pods "pods --subresource=log" secrets)
permissions=(get list watch create patch update delete)

for user in $(< ./.created_users); do
    if [[ -n $user ]]; then
        context_name=$user-context
        echo
        echo "Проверка пользователя:"
        kubectl config use-context $context_name
        kubectl auth whoami
        echo
        for resource in "${resources[@]}"; do
            for permission in "${permissions[@]}"; do
                echo "Права $permission на ресурс $resource у пользователя $user:" $(kubectl auth can-i $permission $resource --all-namespaces)
            done
        done
    fi
done

echo
echo "Возвращение контекста:"
kubectl config use-context minikube
kubectl auth whoami