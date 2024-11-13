#!/bin/bash

for user in $(< ./.created_users); do
    if [[ -n $user ]]; then
        csr_name=$user-csr
        context_name=$user-context
        echo
        echo "Удаление пользователя: $user"
        kubectl delete csr $csr_name
        kubectl config delete-context $context_name
        kubectl config delete-user $user
        rm -rf $user
        sed -i '' '1d' .created_users
    fi
done

echo
echo "Перечень контекста:"
kubectl config get-contexts
echo
echo "Список пользователей:"
kubectl config get-users