#!/bin/bash

# Install WordPress.
wp core install --path=/var/www/html \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --admin_password="$WORDPRESS_ADMIN_PASS"  \
        --url="http://localhost:$DOCKER_WORDPRESS_PORT" \
        --allow-root

# Install and activate plugins.
wp plugin install query-monitor --activate --allow-root

# Delete default plugins.
wp plugin delete akismet --allow-root
wp plugin delete hello --allow-root

# Keep container running.
tail -f /dev/null
