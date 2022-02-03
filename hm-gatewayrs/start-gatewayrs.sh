#!/bin/bash

rm -f settings.toml
rm -f /etc/helium_gateway/settings.toml

if ! LISTEN_ADDR=$(/bin/hostname -i)
then
  echo "Can't get hostname"
  exit 1
else
  echo 'listen_addr = "'"${LISTEN_ADDR}"':1680"' >> settings.toml
fi

if [[ -v REGION_OVERRIDE ]]
then
  echo 'region = "'"${REGION_OVERRIDE}\"" >> settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

if [ -f "/var/data/gateway_key.bin" ]
then
  echo "Key file already exists"
  echo 'keypair = "/var/data/gateway_key.bin"' >> settings.toml
else
  echo "Starting the service temporarily, copy key to persistent storage and restart server"

  #Addition to Alpha21 change
  /usr/bin/helium_gateway -c /etc/helium_gateway server &

  echo "Test line blocking"
  sleep 30
  #cp /etc/helium_gateway/gateway_key.bin /var/data/gateway_key.bin
  #End Addition to Alpha21 Change

  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info)
  then
    echo "Can't get miner key info, possible running first time?"
    #balena-idle #to avoid crashing and allow debug
    exit 1
  else
    cp /etc/helium_gateway/gateway_key.bin /var/data/gateway_key.bin
    echo 'keypair = "/var/data/gateway_key.bin"' >> settings.toml
    PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info) || exit 1
    echo "$PUBLIC_KEYS" > /var/data/key_json
    python3 /opt/nebra-gatewayrs/keys.py
  fi
fi

echo "" >> settings.toml
cat /etc/helium_gateway/settings.toml.template >> settings.toml
cp settings.toml /etc/helium_gateway/settings.toml

#addition after alpha21
echo "kill temp server"
kill %1 2> /dev/null #Killing job when running the first time the helium-miner, before key provisioning, avoiding collision with a new instance
if [ -f "/var/data/key_json" ]
#if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info)
then
  echo "Getting Public Key from existing file"
  PUBLIC_KEYS=$(cat /var/data/key_json)
  #balena-idle #to avoid crahing and allow debug
else
  echo "Unable to get the Public Key from existing file"
  #PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info) || exit 1
  #echo "$PUBLIC_KEYS" > /var/data/key_json
  #python3 /opt/nebra-gatewayrs/keys.py
fi
/usr/bin/helium_gateway -c /etc/helium_gateway server