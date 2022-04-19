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