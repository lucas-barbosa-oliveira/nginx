#!/usr/bin/env sh

default_redirect()
{
cat > /etc/nginx/conf.d/default_redirect.conf << EOF
server {
  listen 80 default_server;
  listen 443 ssl default_server;

  ssl_certificate     /etc/.certs/server.crt;
  ssl_certificate_key  /etc/.certs/server.key;
  return 404;
}
EOF
}

create_config_file()
{
cat > /etc/nginx/conf.d/$1.conf << EOF
server {
  listen       80;
  listen       443 ssl;

  access_log /var/log/nginx/nginx-access.log;
  error_log /var/log/nginx/nginx-access.error debug;

  server_name     *.$2 $2;

  location / {
    proxy_set_header Host \$host;
    proxy_pass $3;
  }
}
EOF
}

default_redirect

DOMAIN_SERVICES=$(echo "${DOMAIN_SERVICES}" | sed 's@,@ @g')
for DOMAIN_SERVICE in ${DOMAIN_SERVICES} ; do
    DOMAIN=$(echo ${DOMAIN_SERVICE} | sed 's@:@ @' | cut -d ' ' -f 1)
    SERVICE_URL=$(echo ${DOMAIN_SERVICE} | sed 's@:@ @' | cut -d ' ' -f 2)
    SERVICE_NAME=$(echo ${SERVICE_URL} | sed 's@.*//@@')
    create_config_file "${SERVICE_NAME}-${RANDOM}" "${DOMAIN}" "${SERVICE_URL}"
done
cat /etc/nginx/conf.d/*.conf

apk add nano
sed -ie "/http {/a\\    server_names_hash_bucket_size  64;" /etc/nginx/nginx.conf
nginx -g 'daemon off;'
