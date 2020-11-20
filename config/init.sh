#!/usr/bin/env sh

create_config_file()
{
cat > /etc/nginx/conf.d/default.conf << EOF
server {
  listen       80;
  listen       443 ssl;

  access_log /var/log/nginx/nginx-access.log;
  error_log /var/log/nginx/nginx-access.error debug;

  server_name     *.$2;

  ssl_certificate     /etc/.certs/server.crt;
  ssl_certificate_key  /etc/.certs/server.key;

  location / {
    proxy_set_header Host \$host;
    proxy_pass $3;
  }
}
EOF
}

DOMAIN_SERVICES=$(echo "${DOMAIN_SERVICES}" | sed 's@,@ @g')

for DOMAIN_SERVICE in ${DOMAIN_SERVICES} ; do
    DOMAIN=$(echo ${DOMAIN_SERVICE} | sed 's@:@ @' | cut -d ' ' -f 1)
    SERVICE_URL=$(echo ${DOMAIN_SERVICE} | sed 's@:@ @' | cut -d ' ' -f 2)
    SERVICE_NAME=$(echo ${SERVICE_URL} | sed 's@.*//@@')
    create_config_file "${SERVICE_NAME}" "${DOMAIN}" "${SERVICE_URL}"
    cat /etc/nginx/conf.d/${SERVICE_NAME}.conf
done

#rm -rf /etc/nginx/conf.d/default.conf

apk add nano
nginx -g 'daemon off;'
