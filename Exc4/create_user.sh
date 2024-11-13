#!/bin/bash

user="${1:-test}"
group1="${2:-group1}"
group2="${3:-group2}"
user_dir=$user
user_file=$user

if [[ -d "$user" ]]; then
    echo "Директория пользователя существует" && exit
fi

kubectl config use-context minikube

# Создаем директорию для ключа и сертификата
mkdir $user

echo "Создание сертификатов для пользователя: $user"

key_file=$user_dir/$user_file.key
crt_file=$user_dir/$user_file.crt
context_name=$user-context
csr_name=$user-csr

# Генерируем закрытый ключ
openssl genrsa -out $key_file 2048

# Отправляем запрос на подпись сертификата
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $csr_name
spec:
  request: $(openssl req -new -key $key_file -subj "/CN=$user/O=$group1/O=$group2" | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

# Работаем с сертификатом пользователя
kubectl certificate approve $csr_name
kubectl wait --for=jsonpath='{.status.certificate}' csr/$csr_name
kubectl get csr $csr_name -o jsonpath='{.status.certificate}'| base64 -d > $crt_file

# Добавляем пользователя в конфигурацию с контекстом
echo "Создание контекста пользователя: $user"
kubectl config set-credentials $user --client-key=$key_file --client-certificate=$crt_file --embed-certs=true
kubectl config set-context $context_name --cluster=minikube --user=$user

echo $user | tee -a .created_users