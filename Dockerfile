# customized based on https://github.com/Logitech/slimserver-platforms/blob/public/8.4/Docker/Dockerfile
#Base image
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
ENV PUID=99 PGID=100

ENV VERSION=2.2.3
ENV UPNP_PORT=49152

# Install packages
RUN apt-get update -qq  && \
	apt-get install --no-install-recommends -qy wget curl perl tzdata libwww-perl libfont-freetype-perl liblinux-inotify2-perl libdata-dump-perl libio-socket-ssl-perl libnet-ssleay-perl libcrypt-ssleay-perl libcrypt-openssl-rsa-perl libgomp1 lame unzip && \
	apt-get clean -qy && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add & configure user
RUN useradd -u $PUID -g $PGID -G audio -d /config -m squeeze2upnp

# Download squeeze2upnp binaries
RUN cd /tmp && wget https://sourceforge.net/projects/lms-plugins-philippe44/files/UPnPBridge-$VERSION.zip && unzip UPnPBridge-$VERSION.zip && cp Bin/squeeze2upnp-linux-x86_64* /usr/bin && chmod 0755 /usr/bin/squeeze2upnp-linux-x86_64*

# Add startup script
COPY start-container.sh /usr/bin/start-container
RUN chmod 0755 /usr/bin/start-container

EXPOSE ${UPNP_PORT}
USER squeeze2upnp
WORKDIR /config

CMD ["start-container"]
