# helium-data-hotspot

This is a balena version based on the Nebra helium hotspot.

## Disclaimer

This Helium Hotspot is going to transfer LoRa data to Helium but it's not going to perform proof-of-coverage or anything else to retrieve tokens.

## Requirements

### Hardware

* Raspberry Pi 3/4 or [balenaFin](https://www.balena.io/fin/)
* SD card in case of the RPi 3/4
* Power supply and (optionally) ethernet cable
* LoRa concentrator (SX1301 or SX1302) (e.g. [RAK2245](https://store.rakwireless.com/products/rak2245-pi-hat) and [RAK2287](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak2287))

### Software

* A balenaCloud account ([sign up here](https://dashboard.balena-cloud.com/))
* [balenaEtcher](https://balena.io/etcher)

## Deploy the fleet

Find 2 possibilities here:

### One-click deploy using [Balena Deploy](https://www.balena.io/docs/learn/deploy/deploy-with-balena-button/)

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/mpous/helium-data-hotspot)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!

### Deploy via [Balena CLI](https://www.balena.io/docs/reference/balena-cli/)

If you are a balena CLI expert, feel free to use [balena CLI](https://www.balena.io/docs/reference/balena-cli/). This option lets you configure in detail some options, like adding new services to your deploy or configure de DNS Server to use.

- Sign up on [balena.io](https://dashboard.balena.io/signup)
- Create a new fleet on balenaCloud.
- Click `Add a new device` and download the balenaOS image it creates.
- Burn and SD card (if using a Pi), connect it to the device and boot it up.

While the device boots (it will eventually show up in the balenaCloud dashboard) we will prepare de services:

- Clone this repository to your local workstation. Don't forget to update the submodules.
```
cd ~/workspace
git clone https://github.com/mpous/helium-data-hotspot
cd helium-data-hotspot
git submodule update --init
```
- Using [Balena CLI](https://www.balena.io/docs/reference/cli/), push the code to the fleet with `balena push <fleet-name>`
- See the magic happening, your device is getting updated 🌟Over-The-Air🌟!




