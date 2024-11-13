# Ролевая модель
|              Роль              |                    Права роли                     |     Группы пользователей      |
|:------------------------------:|:-------------------------------------------------:|:-----------------------------:|
|        cluster-pod-logs        |              pods get, pods/log get               |          developers           |
|       cluster-pod-reader       |          pods get, pods watch, pods list          | cluster-admins, cluster-users |
|       cluster-pod-writer       | pods create, pods patch, pods update, pods delete |        cluster-admins         |
| cluster-secrets-all-permissions |                     secrets *                     |         secret-admin          |
# Как запустить

Создать роли и привязать их к ролевым группам
```bash
./apply_role.sh
```

Создать пользователя dummy

```bash
./create_user.sh dummy
```

Создать пользователя dummy_new входящего в группу developers

```bash
./create_user.sh dummy_new developers
```

Создать пользователя dummy_super_new входящего в группу cluster-users

```bash
./create_user.sh dummy_super_new cluster-users
```

Создать пользователя bob входящего в группу cluster-admins

```bash
./create_user.sh bob cluster-admins
```

Создать пользователя bob_the_best_pm входящего в группу secrets-admin

```bash
./create_user.sh bob_the_best_pm secrets-admin
```

Проверить пользователей

```bash
./check_user.sh
```

Удалить пользователей

```bash
./delete_user.sh
```