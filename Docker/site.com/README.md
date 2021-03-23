# Setup wordpress site on Developer Enviroment

### Developer Enviroment
Developer enviroment will be either windows or linux. XAMMP or WAMP server or docker is setup in developers machine.

### site-data
If core-files of a wordpress site is altered those files are moved into this folder. These should be mounted individually as shown in docker-compose file below.

### wp-content
In docker file after adding core files to the base image, wp-content folder of the existing site is mounted in docker-compose file. All the themes,plugins,uploads will be listed inside this directory.

### Custom named docker-file
By using a base php apache image & specific wordpress version fllowing docker image is build. 
id_rsa is added in dockerfile to perform git opreations later.


```sh
# base image
FROM php:7.2-apache 

# mention the required wordpress version
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


```

### docker-compose
Above site data and wp-content direcory is mounted in this docker-compose file. 
Ex:
```sh
    volumes:
      - ./eme-data/annual-trip-2016:/var/www/html/annual-trip-2016
      - ./eme-data/holidays:/var/www/html/holidays
      - ./eme-data/newsletters:/var/www/html/newsletters
      - ./eme-data/.htaccess:/var/www/html/.htaccess
      - ./eme-data/emebase-config.ini:/var/www/html/emebase-config.ini
      - ./eme-data/favicon.ico:/var/www/html/favicon.ico
      - ./eme-data/wp-config.php:/var/www/html/wp-config.php
      - ./wp-content:/var/www/html/wp-content
```
service name should be matched and placed to identify by the nginx-proxy.

In here the docker-compose uses above custom build context dockerfile,
```sh
    build:
      context: ./
      dockerfile: eme.dockerfile  
```

### Apply docker-compose.yml