# How to create OpenID Connect

## Credentials.json

Used for OpenID Connect specification
<https://learn.microsoft.com/en-us/azure/app-service/deploy-github-actions?tabs=openid%2Caspnetcore>

## federated-credential.azcli

Script to configure the federated credential using the credentials.json as input
<https://learn.microsoft.com/en-us/azure/app-service/deploy-github-actions?tabs=openid%2Caspnetcore>

## key_store_tester.ps1

Used to verify endpoint in web app

## replace.py

Used to update appSettings.json file with values stored in Github as varibles
