# **Введение**

В данном домашнем задании нам необходимо получить практический начальный опыт работы с Docker.

---

# **Создание кастомного образа nginx и публикация его в docker hub **

1. Устнавливаем Docker на хост машину (Ubuntu) по следующей инструкции - https://docs.docker.com/engine/install/ubuntu/. Создаём Dockerfile следующего содержания.
```
FROM nginx:1.21.6-alpine
LABEL maintainer="dmitriy.ivashin"
# Задаём текущую рабочую директорию
WORKDIR /usr/share/nginx/html/
# Копируем код из локального контекста в рабочую директорию образа
COPY index.html /usr/share/nginx/html/index.html
# Указываем порт
EXPOSE 80
# Указываем Nginx запускаться на переднем плане (daemon off)
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```
2. Собираем образ nginx на базе alpine.
```
dima@Test-Ubuntu-1:~/otus/my-hw13$ docker build -t myiddockhub/nginx-alpine-otus:v1 .
Sending build context to Docker daemon  3.072kB
Step 1/6 : FROM nginx:1.21.6-alpine
 ---> 51696c87e77e
Step 2/6 : LABEL maintainer="dmitriy.ivashin"
 ---> Running in 47a1ff3a151f
Removing intermediate container 47a1ff3a151f
 ---> ca4095270fce
Step 3/6 : WORKDIR /usr/share/nginx/html/
 ---> Running in 833105f02378
Removing intermediate container 833105f02378
 ---> 0c8950e5b7c6
Step 4/6 : COPY index.html /usr/share/nginx/html/index.html
 ---> fc84f04a7536
Step 5/6 : EXPOSE 80
 ---> Running in d2eb2eb4cbdc
Removing intermediate container d2eb2eb4cbdc
 ---> 534ca3635285
Step 6/6 : ENTRYPOINT ["nginx", "-g", "daemon off;"]
 ---> Running in fef3e9050885
Removing intermediate container fef3e9050885
 ---> 1360318cb968
Successfully built 1360318cb968
Successfully tagged myiddockhub/nginx-alpine-otus:v1
```

3. Запускаем наш image и проверяем работоспособность нашего контейнера путём проверки нашей изменённой тестовой странички.
```
dima@Test-Ubuntu-1:~/otus/my-hw13$ docker run -it --rm -d -p 8080:80 --name webnginx myiddockhub/nginx-alpine-otus:v1
3084f3d520a705185c15492bde44a1819537bb1dfc42b8e56648441f9a877c37
dima@Test-Ubuntu-1:~/otus/my-hw13$ curl http://localhost:8080
<!DOCTYPE html>

<html lang="ru">
<head>

<meta charset="UTF-8">

<title> Test page nginx</title>
</head>

<body>

<h1> Test page for Docker - Nginx <h1>
</body>
```
![alt text](/screenshots/hw13-1.PNG?raw=true "Screenshot1") 

4. Теперь логинемся в docker hub и загружаем туда наш image.
dima@Test-Ubuntu-1:~/otus/my-hw13$ docker login
```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
.....
Login Succeeded

dima@Test-Ubuntu-1:~/otus/my-hw13$ docker push myiddockhub/nginx-alpine-otus:v1
The push refers to repository [docker.io/myiddockhub/nginx-alpine-otus]
12fd06e23684: Pushed
b991c80c3ef2: Mounted from library/nginx
8df6b63c60d4: Mounted from library/nginx
d63b53686463: Mounted from library/nginx
c0b09410617a: Mounted from library/nginx
be9057e6dae4: Mounted from library/nginx
4fc242d58285: Mounted from library/nginx
v1: digest: sha256:4f445fdb44ed67e147354fffa849eea6664df329920e42d48459fe7c0cf4fbaf size: 1775
```

### ** Ссылка на пепозиторий - https://hub.docker.com/repository/docker/myiddockhub/nginx-alpine-otus**

### **Вопросы**
1. Разница между контейнером и образом? Образ - это своего рода template, на основе которого мы можем запустить сколько угодно контрейнеров, передавая в них различные параметры.
2. Можно ли в контейнере собрать ядро? Так как контейнер это не виртуализация железа, как виртуальная машина - а сущность, которая использует виртуализацию хостовой операционной системы - то есть использует то же ядро, то собрать ядро в контейнере наверно нельзя. 

---

# **Создание кастомных образов nginx и php, объединение их в docker-compose.**

1. Аналогично задания 1 - собираем два образа по Dockerfile находящихся в папках `nginx` и `php`.
```
dima@Test-Ubuntu-1:~/otus/my-hw13-3/nginx$ docker build -t myiddockhub/nginx-for-phpinfo-otus:v1 .

dima@Test-Ubuntu-1:~/otus/my-hw13-3/php$ docker build -t myiddockhub/php-fpm-for-phpinfo-otus:v1 .
```

2. Публикуем их на docker hub.
```
dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker login

dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker push myiddockhub/nginx-for-phpinfo-otus:v1

dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker push myiddockhub/php-fpm-for-phpinfo-otus:v1
```

3. Удаляем локальные images (для проверки), запускаем docker-compose.yml.
```
dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker images
REPOSITORY                             TAG             IMAGE ID       CREATED        SIZE
myiddockhub/nginx-for-phpinfo-otus     v1              b783e8c26410   2 hours ago    23.4MB
myiddockhub/php-fpm-for-phpinfo-otus   v1              b768360b6d2a   2 hours ago    508MB
php                                    7.4-fpm         fb25aaa96351   22 hours ago   443MB
my-hw13-2_php                          latest          6d42096df821   41 hours ago   508MB
myiddockhub/nginx-alpine-otus          v1              1360318cb968   4 days ago     23.4MB
ubuntu                                 latest          825d55fb6340   2 weeks ago    72.8MB
nginx                                  1.21.6-alpine   51696c87e77e   2 weeks ago    23.4MB
alpine                                 latest          0ac33e5f5afa   2 weeks ago    5.57MB
mysql                                  latest          667ee8fb158e   3 weeks ago    521MB
nginx                                  latest          12766a6745ee   3 weeks ago    142MB
hello-world                            latest          feb5d9fea6a5   6 months ago   13.3kB

dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker rmi b783e8
Untagged: myiddockhub/nginx-for-phpinfo-otus:v1
Untagged: myiddockhub/nginx-for-phpinfo-otus@sha256:7acb226943db63f38ede8052db1e3bac8dc1ec89f2c3f2084c3f08fd541c45ed
Deleted: sha256:b783e8c2641088a9b40d832f33219713b47ac530fd1c9fa090226e496a2ed3c8
Deleted: sha256:df1c66d429d5c48db59a97e0bacac8ff37bbf6419ac6cbada118dbee2e3cb38d
Deleted: sha256:2d6a9114a91be83f77dd76e81311e197c3241aca7f56f5135c15ca7c1ffac399

dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker rmi b768
Untagged: myiddockhub/php-fpm-for-phpinfo-otus:v1
Untagged: myiddockhub/php-fpm-for-phpinfo-otus@sha256:7354c5c46d74976bf1e36bb38d117e57f0dcc111059409be3efd440922353c75
Deleted: sha256:b768360b6d2afa352ee8770e8230854517cd1b9581d807dd5061b5db0aba59b7
Deleted: sha256:2f03c916f4803bec97b0c5912c1f84c7dea4561bee1f20b0aecc76d4690b26c0
Deleted: sha256:c9388b2d7802302940a58657e101f75c70c5b842d52aeffd856fad58c8e034a8
Deleted: sha256:169233637c931488b9e43f94fea03ae34ca1a152796f1013065bdd50f601e59d
Deleted: sha256:b04ecfd57dd43a5d4b2cbf90991782ffc789ef3d32673af2c04e621bab90a666

dima@Test-Ubuntu-1:~/otus/my-hw13-3$ docker-compose up -d
[+] Running 24/24
 ⠿ php Pulled                                                                                                                                                                                                                                                             5.0s
   ⠿ c229119241af Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 47e86af584f1 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ e1bd55b3ae5f Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 1f3a70af964a Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ b33242e2136c Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 8a0e8837c5c8 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ f4406e4dc424 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 5bd1b5b74c3f Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 026b1b1bad50 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ ab31c755c308 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 2e0ef4144c22 Pull complete                                                                                                                                                                                                                                           2.8s
   ⠿ 464c827123b4 Pull complete                                                                                                                                                                                                                                           2.9s
   ⠿ 96ad38fdfc20 Pull complete                                                                                                                                                                                                                                           3.0s
   ⠿ 2f0197d703c6 Pull complete                                                                                                                                                                                                                                           3.0s
 ⠿ nginx Pulled                                                                                                                                                                                                                                                           4.6s
   ⠿ df9b9388f04a Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 5867cba5fcbd Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 4b639e65cb3b Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 061ed9e2b976 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ bc19f3e8eeb1 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 4071be97c256 Already exists                                                                                                                                                                                                                                          0.0s
   ⠿ 3b00dc9f663f Pull complete                                                                                                                                                                                                                                           1.8s
   ⠿ e07e5d1e09ce Pull complete                                                                                                                                                                                                                                           2.5s
[+] Running 3/3
 ⠿ Network my-hw13-3_default    Created                                                                                                                                                                                                                                   0.0s
 ⠿ Container my-hw13-3-php-1    Started                                                                                                                                                                                                                                   0.7s
 ⠿ Container my-hw13-3-nginx-1  Started
 ```

 4. Подключаемся по http до хостовой машины с другого компьютера и проверяем вывод.
 ![alt text](/screenshots/hw13-2.PNG?raw=true "Screenshot2") 