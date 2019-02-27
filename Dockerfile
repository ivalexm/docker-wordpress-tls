FROM ivalexmdocker/greytlc-lamp-tls

ENV WORDPRESS_TABLE_PREFIX_FILE       "wp_"
ENV WORDPRESS_WP_DEBUG_FILE           "0"
ENV WORDPRESS_WP_DEBUG_LOG_FILE       "0"
ENV WORDPRESS_DB_NAME_FILE            "wpdb"
ENV WORDPRESS_DB_USER_FILE            "wpuser"
ENV WORDPRESS_DB_PASSWORD_FILE        "wppass"
ENV WORDPRESS_DB_HOST_FILE            "localhost"
ENV WORDPRESS_DB_CHARSET_FILE         "utf8"
ENV WORDPRESS_CREATE_WP_FILE          "0"

ENV WORDPRESS_AUTH_KEY_FILE           "auth_key"
ENV WORDPRESS_SECURE_AUTH_KEY_FILE    "secure_auth_key"
ENV WORDPRESS_LOGGED_IN_KEY_FILE      "logged_in_key"
ENV WORDPRESS_NONCE_KEY_FILE          "nonce_key"
ENV WORDPRESS_AUTH_SALT_FILE          "auth_salt"
ENV WORDPRESS_SECURE_AUTH_SALT_FILE   "secure_auth_salt"
ENV WORDPRESS_LOGGED_IN_SALT_FILE     "logged_in_salt"
ENV WORDPRESS_NONCE_SALT_FILE         "nonce_salt"
ENV WORDPRESS_WP_ASYNC_TASK_SALT_FILE "wp_async_task_salt"
ENV WORDPRESS_CREATE_LOCAL_WP_FILE    "0"

RUN pacman -S --noprogressbar --noconfirm --needed  libjpeg-turbo libpng libzip autoconf

ADD wpsu.sh /usr/local/bin/wpsu
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wpsu && \
    mkdir -p /srv/http -m 777 && \
    cd /srv/http/ && \
    wpsu core download

RUN rm -f /usr/local/bin/entrypoint.sh
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

WORKDIR /srv/http
ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]

