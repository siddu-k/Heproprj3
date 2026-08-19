FROM nginx:1.23
COPY --chown=nginx:nginx . /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
