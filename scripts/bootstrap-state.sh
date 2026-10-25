#!/usr/bin/env bash
# Creates the storage account that holds Terraform remote state.
# Run once per subscription before the first `terraform init`.
set -euo pipefail

LOCATION="${LOCATION:-uksouth}"
RESOURCE_GROUP="${RESOURCE_GROUP:-rg-tfstate}"
CONTAINER="${CONTAINER:-tfstate}"
# Storage account names must be globally unique, 3-24 lowercase alphanumerics.
STORAGE_ACCOUNT="${STORAGE_ACCOUNT:-tfstate$(openssl rand -hex 4)}"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none

az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_GRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --allow-shared-key-access false \
  --output none

az storage account blob-service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --enable-versioning true \
  --enable-delete-retention true \
  --delete-retention-days 30 \
  --output none

# Shared keys are disabled, so the caller needs a data-plane role to create the container.
SCOPE=$(az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" --query id --output tsv)
az role assignment create \
  --assignee "$(az ad signed-in-user show --query id --output tsv)" \
  --role "Storage Blob Data Contributor" \
  --scope "$SCOPE" \
  --output none

az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login \
  --output none

echo "State storage ready. Set storage_account_name = \"$STORAGE_ACCOUNT\" in environments/*/providers.tf"
