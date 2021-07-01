Create a Linode Nano 1 GB instance with the latest version of Ubuntu.

Set the root password and SSH key through the Linode web interface.

As root, install web server, DB, and connection between them

    apt update
    apt upgrade
    apt install nginx mariadb-server php-fpm php-mysql php-gd php-imagick php-dom php-mbstring php-curl php-zip

Then

    cd /var/www
    wget https://wordpress.org/latest.tar.gz
    md5sum latest.tar.gz

Check MD5 against https://wordpress.org/download/releases/

    tar xzvf latest.tar.gz
    rm -rf html
    mv wordpress html
    rm latest.tar.gz
    cd html
    cp ./wp-config-sample.php ./wp-config.php
    chown -R www-data:www-data /var/www/html

Open up `wp-config.php` and add database credentials.

Create database for Wordpress.

    [bstaff01@nolopwp-dev-01 ~]$ mysql -u root -p
    Enter password:
    MariaDB [(none)]> CREATE USER wordpress@localhost IDENTIFIED BY "secret-password-goes-here";
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> CREATE DATABASE wordpress;
    Query OK, 1 row affected (0.00 sec)

    MariaDB [(none)]> GRANT ALL ON wordpress.* TO wordpress@localhost;
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> EXIT;
    Bye

Configure PHP-FPM and PHP-MySQL

    systemctl restart nginx
    systemctl restart php7.4-fpm

Create file `nginx-wordpress.conf` in `/etc/nginx/sites-available` containing
https://raw.githubusercontent.com/tufts-nolop/nolop-software-infrastructure/master/nginx-wordpress.conf

    cd /etc/nginx/sites-enabled
    rm default
    ln -s /etc/nginx/sites-available/nginx-wordpress.conf default
    root@li905-38:/etc/nginx/sites-enabled# ls -l
    total 0
    lrwxrwxrwx 1 root root 47 Oct 30 14:50 default -> /etc/nginx/sites-available/nginx-wordpress.conf

Set up SSL certificates

    snap install core
    snap refresh core
    snap install --classic certbot

Comment out the SSL section at the end of `nginx.conf` and run

    certbot --nginx

Add to server block in `nginx-wordpress.conf`:

    client_max_body_size 200M;

Restart Nginx.

Log in to Wordpress and copy over Wordpress backups.

Install backups.

Lie down and die like a proud man.
