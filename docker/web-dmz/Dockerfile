FROM nginx:1.27-alpine
RUN apk upgrade --no-cache
COPY index.html /usr/share/nginx/html/index.html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY 40-route-retour.sh /docker-entrypoint.d/40-route-retour.sh
RUN chmod +x /docker-entrypoint.d/40-route-retour.sh
EXPOSE 80
