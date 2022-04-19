FROM nginx:1.21.6-alpine
LABEL maintainer="dmitriy.ivashin"
# Копируем код из локального контекста в рабочую директорию образа
COPY hello-dev.conf /etc/nginx/conf.d/default.conf
COPY index.php /var/www/hello.dev/index.php
# Указываем Nginx запускаться на переднем плане (daemon off)
ENTRYPOINT ["nginx", "-g", "daemon off;"]