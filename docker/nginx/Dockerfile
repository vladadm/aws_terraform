FROM nginx:latest

ARG HTML=/var/www/html/
RUN mkdir -p $HTML
COPY conf/index.html $HTML

COPY conf/my_site.conf /etc/nginx/conf.d/

EXPOSE 80
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
#ENTRYPOINT [ "./docker-entrypoint.sh" ]
