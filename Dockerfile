FROM ubuntu:14.04

MAINTAINER Rocco Bruyn <rocco.bruyn@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install packages
# Create necessary directories
# Remove apt cache
# Add servername to apache config
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		nano \
		apache2 \
		supervisor && \
	mkdir -p \
		/var/lock/apache2 \
		/var/run/apache2 \
		/var/log/supervisor && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i "N;$!/Global configuration\n#/a \
		ServerName localhost" /etc/apache2/apache2.conf

# Add supervisor configuration that starts apache
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Overwrite default index file 
ADD index.html /var/www/html/index.html

# Expose port 80 for web traffic
EXPOSE 80

# Start supervisor with provides configuration
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
