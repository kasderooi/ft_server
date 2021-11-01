# OS
FROM	debian:buster

# Update and install
RUN		apt update; \
		apt upgrade -y; \
		apt	-y install wget; \
		apt -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring; \
		apt -y install nginx; \
		apt -y install mariadb-server;

# Configure nginx
COPY 	./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN 	ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# Autoindex command
COPY	./srcs/autoindex.sh ./usr/bin/autoindex
RUN		chmod 755 ./usr/bin/autoindex

# Working directory
WORKDIR /var/www/html/

# Get php
RUN 	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz; \
		tar -xvzf phpMyAdmin-5.0.1-english.tar.gz; \
		rm -rf phpMyAdmin-5.0.1-english.tar.gz; \
		mv phpMyAdmin-5.0.1-english phpmyadmin; \
		rm index.nginx-debian.html;
COPY 	./srcs/config.inc.php phpmyadmin/

# Set MYSSQL
RUN		service mysql start; \
		mysql -u root; \
		mysql -e "CREATE DATABASE wordpress;"; \
		mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';"; \
		mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';"; \
		mysql -e "FLUSH PRIVILEGES;";

# Get wordpress
RUN 	service mysql start; \
		mysql -u root; \
		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
		chmod 755 wp-cli.phar; \
		mv wp-cli.phar ../../../usr/local/bin/wp; \
		wp core download --allow-root; \
		wp config create --allow-root --dbname=wordpress --dbuser=admin --dbpass=password; \
		wp core install --allow-root --url=localhost --title=ft_server --admin_email=kde-rooi@student.codam.nl --admin_user=admin --admin_password=password;

# Configure certificate
RUN 	openssl req -x509 -nodes -days 365 -subj "/C=NL/ST=NoordHolland/L=Haarlem/O=42/OU=Codam/CN=kde-rooi" -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

# Give permissions
RUN 	chown -R www-data:www-data *; \
		chmod -R 755 *;

# Configure MYSQL and run all
CMD		service mysql start; \
		service nginx start; \
		service php7.3-fpm start; \
		bash

EXPOSE	80
