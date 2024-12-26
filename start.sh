#!/bin/bash
## Make Colorful text for the console
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

Text="${GREEN}[STARTUP]${NC}"

# Check if the txAdmin username and password are set
if [ -z "$TXADMIN_USER" ]; then
    echo -e "${Text} ${RED}txAdmin username is not set! Please set TXADMIN_USER in Pterodactyl settings.${NC}"
    exit 1
fi

if [ -z "$TXADMIN_PASSWORD" ]; then
    echo -e "${Text} ${RED}txAdmin password is not set! Please set TXADMIN_PASSWORD in Pterodactyl settings.${NC}"
    exit 1
fi

echo -e "${Text} ${BLUE}Updating admins.json with the new username and password...${NC}"

# Define the admins.json file path
ADMINS_JSON="txdata/admins.json"

# Ensure the parent directory exists
mkdir -p "$(dirname "$ADMINS_JSON")"

# Create or update the admins.json file
cat <<EOF > "$ADMINS_JSON"
[
  {
    "name": "$TXADMIN_USER",
    "password_hash": "$TXADMIN_PASSWORD"
  }
]
EOF

echo -e "${Text} ${GREEN}admins.json updated successfully!${NC}"

echo -e "${Text} ${BLUE}Starting FiveM Server with custom txAdmin username and password...${NC}"

# Start the server with the specified txAdmin credentials
$(pwd)/alpine/opt/cfx-server/ld-musl-x86_64.so.1 --library-path "$(pwd)/alpine/usr/lib/v8/:$(pwd)/alpine/lib/:$(pwd)/alpine/usr/lib/" -- $(pwd)/alpine/opt/cfx-server/FXServer +set citizen_dir $(pwd)/alpine/opt/cfx-server/citizen/ +set sv_licenseKey ${FIVEM_LICENSE} +set steam_webApiKey ${STEAM_WEBAPIKEY} +set sv_maxplayers ${MAX_PLAYERS} +set serverProfile default +set txAdminPort ${TXADMIN_PORT} +set txAdminUser ${TXADMIN_USER} +set txAdminPassword ${TXADMIN_PASSWORD} $( [ "$TXADMIN_ENABLE" == "1" ] || printf %s '+exec server.cfg' )
