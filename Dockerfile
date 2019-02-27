FROM ivalexmdocker/greytlc-lamp-tls

ENV WORDPRESS_table_prefix       "wp_"
ENV WORDPRESS_WP_DEBUG           "0"
ENV WORDPRESS_WP_DEBUG_LOG       "0"
ENV WORDPRESS_DB_NAME            "wpdb"
ENV WORDPRESS_DB_USER            "wpuser"
ENV WORDPRESS_DB_PASSWORD        "wppass"
ENV WORDPRESS_DB_HOST            "localhost"
ENV WORDPRESS_DB_CHARSET         "utf8"
ENV WORDPRESS_CREATE_WP          "0"

ENV WORDPRESS_AUTH_KEY           "auth_key"
ENV WORDPRESS_SECURE_AUTH_KEY    "secure_auth_key"
ENV WORDPRESS_LOGGED_IN_KEY      "logged_in_key"
ENV WORDPRESS_NONCE_KEY          "nonce_key"
ENV WORDPRESS_AUTH_SALT          "auth_salt"
ENV WORDPRESS_SECURE_AUTH_SALT   "secure_auth_salt"
ENV WORDPRESS_LOGGED_IN_SALT     "logged_in_salt"
ENV WORDPRESS_NONCE_SALT         "nonce_salt"
ENV WORDPRESS_WP_ASYNC_TASK_SALT "wp_async_task_salt"
ENV WORDPRESS_CREATE_LOCAL_WP              "0"
ADD wpsu.sh /usr/local/bin/wpsu

RUN pacman -S --noprogressbar --noconfirm --needed  libjpeg-turbo libpng libzip autoconf

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wpsu && \
    mkdir -p /var/www/html -m 777 && \
    cd /var/www/html/ && \
    wpsu core download

RUN rm -f /usr/local/bin/entrypoint.sh
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
