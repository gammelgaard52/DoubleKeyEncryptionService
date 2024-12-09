#!/bin/bash

set -euo pipefail

# Input parameters
LABEL_NAME="$1"
DKE_KEY_URL="$2"

# Validate inputs
if [[ -z "$LABEL_NAME" || -z "$DKE_KEY_URL" ]]; then
  echo "Usage: $0 <LabelName> <DoubleKeyEncryptionKeyUrl>"
  exit 1
fi

# Define API endpoint
GRAPH_LABELS_URL="https://graph.microsoft.com/v1.0/informationProtection/sensitivityLabels"

# Build the label payload
LABEL_PAYLOAD=$(jq -n --arg name "$LABEL_NAME" --arg url "$DKE_KEY_URL" '{
  "displayName": $name,
  "description": "Sensitivity Label configured for Double Key Encryption",
  "encryption": {
    "keyUri": $url,
    "doubleKeyEncryption": {
      "isEnabled": true
    }
  }
}')

# Call the Microsoft Graph API using az rest
echo "Creating Sensitivity Label '$LABEL_NAME' with DKE using Azure CLI..."
RESPONSE=$(az rest --method post \
  --url "$GRAPH_LABELS_URL" \
  --body "$LABEL_PAYLOAD" \
  --headers "Content-Type=application/json")

# Extract the label ID from the response
LABEL_ID=$(echo "$RESPONSE" | jq -r '.id')

if [[ -n "$LABEL_ID" && "$LABEL_ID" != "null" ]]; then
  echo "Sensitivity Label created successfully with ID: $LABEL_ID"
else
  echo "Failed to create Sensitivity Label. Response: $RESPONSE"
  exit 1
fi
