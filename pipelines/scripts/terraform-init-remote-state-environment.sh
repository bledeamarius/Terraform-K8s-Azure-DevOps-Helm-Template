#!/bin/bash

USECASE=$1
ENV=$2
REMOTE_STATE_RESOURCE_GROUP="rg-$1-terraform"
REMOTE_STATE_LOCATION="westeurope"
REMOTE_STATE_STORAGE_ACCOUNT="sa${USECASE//-/}terraform"
REMOTE_STATE_STORAGE_CONTAINER="tf-state-$1-${ENV,,}"

# # Create a resource group for our remote state if it doesn't exist
if [ $(az group exists --name $REMOTE_STATE_RESOURCE_GROUP) = false ]; then
  echo "Creating resource group for remote state..."
  az group create -n $REMOTE_STATE_RESOURCE_GROUP --location $REMOTE_STATE_LOCATION
else
  echo "Resource group already exists."
fi

STORAGE_ACCOUNT_NAME=$(az storage account list --resource-group $REMOTE_STATE_RESOURCE_GROUP --query "[].name" -o tsv) 

# Create a storage account for our remote state if it doesn't exist
if [[ $STORAGE_ACCOUNT_NAME != $REMOTE_STATE_STORAGE_ACCOUNT ]]; then
  echo "Creating storage account for remote state..."
  az storage account create -n $REMOTE_STATE_STORAGE_ACCOUNT --resource-group $REMOTE_STATE_RESOURCE_GROUP --location $REMOTE_STATE_LOCATION --sku Standard_LRS
else
  echo "Storage account already exists."
fi

STORAGE_ACCOUNT_KEY=$(az storage account keys list -n $REMOTE_STATE_STORAGE_ACCOUNT --query "[0].value" -o tsv)  
STORAGE_CONTAINER_NAME=$(az storage container list --account-key $STORAGE_ACCOUNT_KEY --account-name $REMOTE_STATE_STORAGE_ACCOUNT --query "[].name" -o tsv)

# Create a storage container if it doesn't exist
if [[ $STORAGE_CONTAINER_NAME != $REMOTE_STATE_STORAGE_CONTAINER ]]; then
  echo "Creating storage container for remote state..."
  az storage container create -n $REMOTE_STATE_STORAGE_CONTAINER --account-name $REMOTE_STATE_STORAGE_ACCOUNT --account-key $STORAGE_ACCOUNT_KEY
else
  echo "Storage container already exists."
fi