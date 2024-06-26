#!/bin/bash

# Source common env variables
. ./common_vars.sh

# Get admin token using environment variables for credentials
echo "Obtaining admin token..."
$KC_INSTALL_DIR/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user $KEYCLOAK_ADMIN --password $KEYCLOAK_ADMIN_PASSWORD

# Read the direct access property of the account console
echo "Reading direct access property of the account-console client..."
$KC_INSTALL_DIR/bin/kcadm.sh get clients -q clientId=account-console --fields 'id,directAccessGrantsEnabled'

# Store property ACC_CLIENT_ID in an environment variable
export ACC_CLIENT_ID=$($KC_INSTALL_DIR/bin/kcadm.sh get clients -q clientId=account-console --fields id | jq -r '.[0].id')
echo "Stored Account Console Client ID: $ACC_CLIENT_ID"

# Enable direct grant on the account-console client
echo "Enabling direct grant on the account-console client..."
$KC_INSTALL_DIR/bin/kcadm.sh update clients/$ACC_CLIENT_ID -r master -s directAccessGrantsEnabled=true -o --fields 'id,directAccessGrantsEnabled'

# Create a user named Francis
echo "Creating user Francis..."
$KC_INSTALL_DIR/bin/kcadm.sh create users -r master -s username=francis -s firstName=Francis -s lastName=Pouatcha -s email=fpo@mail.de -s enabled=true

# Set password for Francis
echo "Setting password for user Francis..."
$KC_INSTALL_DIR/bin/kcadm.sh set-password -r master --username $USER_FRANCIS_NAME --new-password $USER_FRANCIS_PASSWORD

echo "Script execution completed."
