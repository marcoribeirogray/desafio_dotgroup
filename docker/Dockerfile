FROM php:8.3-fpm-alpine

LABEL maintainer="DevOps Desafio DotGroup" \
      description="Aplicacao PHP containerizada com nginx" \
      version="1.0"

RUN apk add --no-cache nginx \
    && addgroup -g 1000 appuser \
    && adduser -D -u 1000 -G appuser appuser \
    && mkdir -p /var/www/html /var/log/nginx /var/lib/nginx/tmp /var/cache/nginx /run/nginx \
    && chown -R appuser:appuser /var/www/html /var/log/nginx /var/lib/nginx /var/cache/nginx /run/nginx

COPY app/index.php /var/www/html/
COPY app/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/start.sh /usr/local/bin/start.sh

RUN chown -R appuser:appuser /var/www/html /etc/nginx/http.d/default.conf /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh \
    && sed -i 's/^user = .*/user = appuser/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^group = .*/group = appuser/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's@^listen = .*@listen = 127.0.0.1:9000@' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^user .*/user appuser;/' /etc/nginx/nginx.conf

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["/usr/local/bin/start.sh"]
