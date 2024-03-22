import json

def update_json(file_path, updates):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
    except FileNotFoundError:
        print("File not found.")
        return
    except json.JSONDecodeError:
        print("Invalid JSON format.")
        return

    for key, value in updates.items():
        nested_keys = key.split('.')
        current_data = data
        for nested_key in nested_keys[:-1]:
            if isinstance(current_data, list):
                index = int(nested_key)
                current_data = current_data[index]
            else:
                current_data = current_data.get(nested_key, {})
        if isinstance(current_data, list):
            index = int(nested_keys[-1])
            current_data[index] = value
        else:
            current_data[nested_keys[-1]] = value

    try:
        with open(file_path, 'w') as file:
            json.dump(data, file, indent=4)
        print("JSON file updated successfully.")
    except Exception as e:
        print("Error occurred while updating the JSON file:", e)

# Example usage:
file_path = "JSON_FILE_PATH"  # Change this to the path of your JSON file
updates = {
    "AzureAd.ClientId": os.environ.get('newClientId'),
    "AzureAd.TenantId": os.environ.get('newTenantId'),
    "AzureAd.TokenValidationParameters.ValidIssuers": [os.environ.get('newValidIssuer')],
    "JwtAudience": os.environ.get('newJwtAudience'),
    "TestKeys.0.Name": os.environ.get('newValueKeyName'),
    "TestKeys.0.Id": os.environ.get('newValueKeyId'),
    "TestKeys.0.AuthorizedEmailAddress": [os.environ.get('newValueEmail')],
    "TestKeys.0.PublicPem": os.environ.get('newPublicPem'),
    "TestKeys.0.PrivatePem": os.environ.get('newPrivatePem')
}

update_json(file_path, updates)