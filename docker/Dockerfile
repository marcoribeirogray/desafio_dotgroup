FROM php:8.3-fpm-alpine AS builder

RUN apk add --no-cache nginx

FROM php:8.3-fpm-alpine

LABEL maintainer="DevOps Desafio DotGroup" \
      description="Aplicacao PHP containerizada com nginx" \
      version="1.0"

RUN apk add --no-cache nginx && \
    addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser && \
    mkdir -p /var/www/html /var/log/nginx /var/lib/nginx/tmp && \
    chown -R appuser:appuser /var/www/html /var/log/nginx /var/lib/nginx /run/nginx && \
    chmod -R 755 /var/www/html

COPY --chown=appuser:appuser app/index.php /var/www/html/
COPY --chown=appuser:appuser app/nginx.conf /etc/nginx/http.d/default.conf
COPY --chown=appuser:appuser docker/start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["/usr/local/bin/start.sh"]