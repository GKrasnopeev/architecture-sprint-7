# Как запустить

### 1. Запустить Minikube с добавлением политик
```bash
minikube start --cni calico
```

### 2. Настроить политики
```bash
kubectl apply -f default-deny-ingress.yaml
kubectl apply -f non-admin-api-allow.yaml
kubectl apply -f admin-api-allow.yaml
```

### 3. Создать сервисы
```bash
labels=(front-end back-end-api admin-front-end admin-back-end-api)

for label in ${labels[@]}; do
    kubectl run $label-app --image=nginx --labels role=$label --expose --port 80 
done
```

### 4. Проверить доступность сервиса `front-end-app`
```bash
wget -qO- --timeout=2 http://front-end-app
```
### 5. Проверить доступность сервиса `back-end-api-app`
```bash
wget -qO- --timeout=2 http://back-end-api-app
```
### 6. Проверить доступность сервиса `admin-front-end-app`
```bash
wget -qO- --timeout=2 http://admin-front-end-app
```
### 7. Проверить доступность сервиса `admin-back-end-api-app`
```bash
wget -qO- --timeout=2 http://admin-back-end-api-app
```
### 8. Удалить сервисы
```bash
for resource in $(kubectl get pods,services --no-headers=true -o name --field-selector=metadata.name!=kubernetes); do
    kubectl delete $resource
done
```

### 9. Удалить политики
```bash
kubectl delete -f default-deny-ingress.yaml
kubectl delete -f non-admin-api-allow.yaml
kubectl delete -f admin-api-allow.yaml
```

# 21.11.2024