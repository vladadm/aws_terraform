FROM nginx:1.20

ARG HTML=/var/www/html/

RUN mkdir -p $HTML

COPY conf/index.html $HTML
COPY pages $HTML/my_page
COPY conf/my_site.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]
#ENTRYPOINT [ "./docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 8080
