FROM php:8.3-fpm-alpine AS build
# Camada de build apenas executa lint nos arquivos PHP para falhar cedo.
WORKDIR /app
COPY app/ ./
RUN find . -type f -name "*.php" -exec php -l {} \;

FROM php:8.3-fpm-alpine
# Instala Nginx, cria o usuario nao-root e prepara diretorios usados pelos servicos.
RUN apk add --no-cache nginx \
    && addgroup -S appuser \
    && adduser -S -G appuser appuser \
    && mkdir -p /var/log/nginx /var/lib/nginx/tmp /var/cache/nginx /run/nginx \
    && chown -R appuser:appuser /var/log/nginx /var/lib/nginx/tmp /var/cache/nginx /run/nginx

# Copia o codigo validado e as configuracoes customizadas para o container final.
COPY --from=build /app /var/www/html
COPY app/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/start.sh /usr/local/bin/start.sh

# Garante que arquivos criticos permanecam com o usuario da aplicacao e alinha o master do Nginx.
RUN chown -R appuser:appuser /var/www/html /etc/nginx/http.d/default.conf /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh \
    && sed -i 's/^user .*/user appuser;/' /etc/nginx/nginx.conf

USER appuser

EXPOSE 8080

# Healthcheck simples para confirmar que Nginx e PHP-FPM estao respondendo via proxy local.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["/usr/local/bin/start.sh"]
