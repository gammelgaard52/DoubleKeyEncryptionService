import os
import json

# Define logic to update the JSON
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

# Define logic to read key
def read_key(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
        
        # Skip lines until "BEGIN" is found
        start_index = None
        for i, line in enumerate(lines):
            if "BEGIN" in line:
                start_index = i + 1
                break
        
        # Skip lines until "END" is found
        end_index = None
        for i, line in enumerate(lines[start_index:]):
            if "END" in line:
                end_index = start_index + i
                break
        
        # Extract content between markers
        key_content = ''.join(lines[start_index:end_index])
        
        # Remove leading and trailing whitespace and replace newline characters
        key_content = key_content.strip().replace("\n", "")
        
        return key_content

    except FileNotFoundError:
        print("Key file not found.")
        return None

# Define logic to convert comma separated into array
def convert_to_list(value):
    # Split the string into a list
    list = value.split(',')
    # Strip leading and trailing whitespace from each entry
    list = [data.strip() for data in list]
    return list

# Read the content of certificate files
cert_public_key_content = read_key(os.environ.get('newPublicPem'))
cert_private_key_content = read_key(os.environ.get('newPrivatePem'))

# Split the strings into arrays
authorized_email_addresses = convert_to_list(os.environ.get('newValueEmail'))
validIssuers = convert_to_list(os.environ.get('newValidIssuer'))

# Example usage:
file_path_json = os.environ.get('JSON_FILE_PATH')  # Change this to the path of your JSON file
updates = {
    "AzureAd.ClientId": os.environ.get('newClientId'),
    "AzureAd.TenantId": os.environ.get('newTenantId'),
    "AzureAd.TokenValidationParameters.ValidIssuers": validIssuers,
    "JwtAudience": os.environ.get('newJwtAudience'),
    "TestKeys.0.Name": os.environ.get('newValueKeyName'),
    "TestKeys.0.Id": os.environ.get('newValueKeyId'),
    "TestKeys.0.AuthorizedEmailAddress": authorized_email_addresses,
    "TestKeys.0.PublicPem": cert_public_key_content,
    "TestKeys.0.PrivatePem": cert_private_key_content
}

update_json(file_path_json, updates)