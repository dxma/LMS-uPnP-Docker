#!/bin/bash

config=upnpbridge.xml

if [[ -f $config ]]; then
  # run at background
  squeeze2upnp-linux-x86_64 -Z -I -d all=info -x $config
else
  echo "scanning clients, will exit in 30 minutes..."
  squeeze2upnp-linux-x86_64 -i $config
fi