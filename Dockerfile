# Use debian:bookworm-slim as the base image
FROM debian:bookworm-slim

# Update package list and install Apache, PHP, and the required extensions
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php \
    php \
    php-fileinfo \
    php-iconv \
    php-zip \
    php-mbstring \
    tar

# Enable directory listing by modifying the default Apache configuration
# RUN sed -i 's/Options Indexes FollowSymLinks/Options Indexes/' /etc/apache2/sites-enabled/000-default.conf

# Disable directory listing by modifying the default Apache configuration
RUN sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/apache2/apache2.conf

# Allow .htaccess overrides by setting AllowOverride to All
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Set index.php as the default file
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

# Copy your website files into the Apache document root
COPY ./myfiles/filemanager/ /var/www/html/

# Grant write permission to the document root folder
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html

# Enable Apache rewrite module (useful for URLs rewriting if needed)
RUN a2enmod rewrite

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Apache when the container is started
CMD ["apachectl", "-D", "FOREGROUND"]

