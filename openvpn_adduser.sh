#!/bin/bash

# First argument: Client Name


SERVER_DIR=~/EasyRSA-3.0.4
CONFIG_DIR=~/client-configs
KEY_DIR=~/client-configs/keys
OUTPUT_DIR=~/client-configs/files


# generate key, sign key, issue certificate
cd ${SERVER_DIR}
./easyrsa gen-req ${1} nopass
cp pki/private/${1}.key ${KEY_DIR}/
./easyrsa sign-req client ${1}
cp pki/issued/${1}.crt ${KEY_DIR}/


# generate config
cd ${CONFIG_DIR}
./make_config.sh ${1}

echo "client config file created at ${OUTPUT_DIR}/${1}.ovpn"





