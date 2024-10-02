# based on https://github.com/Logitech/slimserver-platforms/blob/public/8.4/Docker/Dockerfile
# FROM debian:bookworm-slim
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
ENV PUID=1000 PGID=1000

ENV VERSION=3.3.9

# Install packages
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
RUN sed -i 's#deb.debian.org#mirrors.ustc.edu.cn#g' /etc/apt/sources.list && sed -i 's#security.debian.org/debian-security#mirrors.ustc.edu.cn/debian-security#g' /etc/apt/sources.list && \
    apt-get update -qq  && \
	apt-get install --no-install-recommends -qy wget tzdata ca-certificates unzip perl libwww-perl libfont-freetype-perl liblinux-inotify2-perl libdata-dump-perl libio-socket-ssl-perl libnet-ssleay-perl libcrypt-ssleay-perl libcrypt-openssl-rsa-perl libgomp1 lame && \
	apt-get clean -qy && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN sed -i 's/mirrors.ustc.edu.cn/deb.debian.org/g' /etc/apt/sources.list.d/debian.sources
RUN sed -i 's#mirrors.ustc.edu.cn/debian-security#security.debian.org/debian-security#g' /etc/apt/sources.list && sed -i 's#mirrors.ustc.edu.cn#deb.debian.org#g' /etc/apt/sources.list

# Add user
RUN groupadd -g $PGID squeeze2upnp
RUN useradd -u $PUID -g $PGID -G audio -d /config -m squeeze2upnp

# Download binary
RUN cd /tmp && wget -O UPnPBridge-$VERSION.zip https://sourceforge.net/projects/lms-plugins-philippe44/files/UPnPBridge-$VERSION.zip/download && \
	unzip UPnPBridge-$VERSION.zip && cp Bin/squeeze2upnp-linux-x86_64* /usr/bin && chmod 0755 /usr/bin/squeeze2upnp-linux-x86_64* && \
	rm -rf /tmp/*

USER squeeze2upnp
WORKDIR /config

CMD ["squeeze2upnp-linux-x86_64", "-x", "config.xml", "-I", "-Z"]
