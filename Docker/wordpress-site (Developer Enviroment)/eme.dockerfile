FROM php:7.2-apache 

ENV WP_VERSION 5.7

# Update
RUN apt-get update

RUN a2enmod rewrite

# Install mysqli ext
RUN docker-php-ext-install mysqli

# Install git 
RUN apt-get install -y git

# Clear cache
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add uploads.ini file
RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "file_uploads = On" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/uploads.ini 

# Add the core files
RUN cd /var/www/html/
ADD https://wordpress.org/wordpress-$WP_VERSION.tar.gz ./
RUN tar -xzf wordpress-$WP_VERSION.tar.gz --strip-components=1 \
 && rm wordpress-$WP_VERSION.tar.gz

