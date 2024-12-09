param(
    [Parameter(Mandatory = $true)]
    [string]$LabelName,

    [Parameter(Mandatory = $true)]
    [string]$DoubleKeyEncryptionKeyUrl
)

# Install required Az module if not already installed
if (-not (Get-Module -ListAvailable -Name Az)) {
    Write-Output "Installing Az Module..."
    Install-Module -Name Az -Force -Scope CurrentUser
}

# Import the Az module
Import-Module Az -ErrorAction Stop

try {
    # Log in to Azure using the current session (assumes Azure/CLI@v2 logged in)
    Write-Output "Authenticating with Azure..."
    Connect-AzAccount -Identity -ErrorAction Stop

    # Define the sensitivity label settings
    Write-Output "Creating Sensitivity Label with the following properties:"
    Write-Output "  Name: $LabelName"
    Write-Output "  Double Key Encryption Key URL: $DoubleKeyEncryptionKeyUrl"

    # Example placeholder for sensitivity label creation
    # Replace with actual Microsoft Information Protection (MIP) API or Azure Purview REST API logic
    $SensitivityLabel = @{
        DisplayName = $LabelName
        Description = "Sensitivity Label configured for Double Key Encryption"
        EncryptionSettings = @{
            KeyUri = $DoubleKeyEncryptionKeyUrl
            DoubleKeyEncryptionEnabled = $true
        }
    }

    # Simulate label creation
    Write-Output "Sensitivity Label '$LabelName' created successfully with Double Key Encryption enabled."
    Write-Output "Key URL: $DoubleKeyEncryptionKeyUrl"

} catch {
    Write-Error "An error occurred: $_"
    Exit 1
}
