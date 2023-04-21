#!/bin/bash

echo "Starting start-gatewayrs.sh"

#rm -f settings.toml
#rm -f /etc/helium_gateway/settings.toml

echo "Checking for I2C device"

mapfile -t data < <(i2cdetect -y 1)

for i in $(seq 1 ${#data[@]}); do
    # shellcheck disable=SC2206
    line=(${data[$i]})
    # shellcheck disable=SC2068
    if echo ${line[@]:1} | grep -q 60; then
        echo "ECC is present."
        ECC_CHIP=True
    else
        echo "ECC is not present."
    fi
done

echo "Setting REGION_OVERRIDE"
if [[ -v REGION_OVERRIDE ]]
then
  echo "REGION_OVERRED is set to ${REGION_OVERRIDE}"
  echo 'region = "'"${REGION_OVERRIDE}\"" >> settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

echo "Interacting with ECC_CHIP"
if [[ -v ECC_CHIP ]]
then
  echo "Using ECC for public key."
  if [[ -v GW_KEYPAIR ]]
  then
    echo 'keypair = "'${GW_KEYPAIR}'"' >> settings.toml
  else
    echo 'keypair = "ecc://i2c-1:96&slot=0"' >> settings.toml
  fi
else
  echo "Key file already exists"
  #echo 'keypair = "/var/data/gateway_key.bin"' >> /etc/helium_gateway/settings.toml
  sed -i 's#^keypair = .*#keypair = "/var/data/gateway_key.bin"#' /etc/helium_gateway/settings.toml
  sed -i 's/^listen = .*/listen = "helium-miner:1680"/' /etc/helium_gateway/settings.toml
fi

#cat /etc/helium_gateway/settings.toml.template >> settings.toml
#cp settings.toml /etc/helium_gateway/settings.toml


echo "Calling helium_gateway server ..."
/usr/bin/helium_gateway -c /etc/helium_gateway/settings.toml server


echo "Checking key info..."
if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway/settings.toml key info)
then
  echo "Can't get miner key info"
  #exit 1
else
  echo "$PUBLIC_KEYS" > /var/data/key_json
fi

