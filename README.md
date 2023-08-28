# LMS-uPnP-Docker
docker image for philippe44/LMS-uPnP

## Background

This is a well-known logitech media server extension, which bridges DLNA compatible music client as LMS player.
Usually you will get it installed together with LMS, from its plugins repository. This option requires you to run LMS docker image in host network mode.

In my case, I don't want to run the bridge inside LMS container, simply because:
   1. I don't want to expose entire LMS service onto my host network.
   2. It is hard to check the bridge running state, well it is possibile via LMS but requires a few clicks.
   3. For small customizations.

Thus I decided to build this tiny docker image dedicated for runing the bridge only.

## Configuration

Way to run and configure the docker service, via docker compose. Below is my compose content:
```yaml
---
version: "2.1"
services:
  lms-upnp-bridge:
    image: dxma/lms-upnp-bridge:2.2.3
    container_name: lms-upnp-bridge
    environment:
      - PUID=1000
      - PGID=100
      - TZ=Asia/Shanghai
    volumes:
      - /Application/lms-upnp-bridge:/config
    restart: unless-stopped

    network_mode: host
```

At first run, the container will try to discover all clients inside your network. A config file /config/upnpbridge.xml will be made when everything goes well. The container will
then exit automatically.
Start the container again and you are good to go.

## Troubleshoot

First check the container log, everything will be printed there.
If that is not enough, customize /config/upnpbridge.xml yourself and restart the container. A common helpful approach is change logging level from info (default) into debug.

## Technical Note

The bridge will bind on at least 2 ports:
   * 49152: upnp socket starting port, a new web service will be made for each running client following this port
   * 1900: this is not explicitly mentioned, it is the dnla server port

While deploying the bridge first time, I got strange port bind error due to 1900 port occupassion. The jellyfin service running on my NAS box also binds to port 1900.
You have to turn off the other dlna server in this case and free up 1900.
