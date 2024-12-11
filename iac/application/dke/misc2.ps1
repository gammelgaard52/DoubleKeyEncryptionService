# Set the name of the existing label to use as a template
$existingLabelName = "DKE"

# Set the name, display name, and tooltip for the new label
$newLabelName = "New-DKE-Label"
$newDisplayName = "New DKE Label"
$newTooltip = "This is a new sensitivity label based on the DKE label."

# Retrieve the existing label details
$existingLabel = Get-Label -Identity $existingLabelName

if ($existingLabel -eq $null) {
    Write-Error "Label '$existingLabelName' not found. Ensure it exists before running this script."
    exit 1
}

# Extract all relevant settings from the existing label
$advancedSettings = @{}

# Extract encryption settings
# Parse the LabelActions JSON string into a PowerShell object
$labelActions = $existingLabel.LabelActions | ConvertFrom-Json

#
#
# Now filter for the encryption action where Type is "encrypt"
$encryptionAction = $labelActions | Where-Object { $_.Type -eq "encrypt" }

# Extract the 'Settings' for encryption
$encryptionSettings = $encryptionAction.Settings

# Display the extracted encryption settings
$encryptionSettings
$doubleKeyEncryptionUrl = $encryptionSettings | Where-Object { $_.Key -eq "doublekeyencryptionurl" } | Select-Object -ExpandProperty Value
$encryptionTemplateId = $encryptionSettings | Where-Object { $_.Key -eq "templateid" } | Select-Object -ExpandProperty Value
$rightsDefinitions = $encryptionSettings | Where-Object { $_.Key -eq "rightsdefinitions" } | Select-Object -ExpandProperty Value

# Add encryption settings to advanced settings
$advancedSettings.Add("doublekeyencryptionurl", $doubleKeyEncryptionUrl)
$advancedSettings.Add("templateid", $encryptionTemplateId)
$advancedSettings.Add("rightsdefinitions", $rightsDefinitions)

#
#
# Extract watermarking settings if enabled
$watermarkingEnabled = $labelActions | Where-Object { $_.Type -eq "watermark" }
if ($watermarkingEnabled) {
    $applyWatermarkingEnabled = $watermarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "enabled" } | Select-Object -ExpandProperty Value
    $applyWatermarkingText = $watermarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "watermarktext" } | Select-Object -ExpandProperty Value
    $applyWatermarkingFontColor = $watermarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "watermarkfontcolor" } | Select-Object -ExpandProperty Value
    $applyWatermarkingFontSize = $watermarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "watermarkfontsize" } | Select-Object -ExpandProperty Value

    # Add watermarking settings to advanced settings
    $advancedSettings.Add("applyWatermarkingEnabled", $applyWatermarkingEnabled)
    $advancedSettings.Add("applyWatermarkingText", $applyWatermarkingText)
    $advancedSettings.Add("applyWatermarkingFontColor", $applyWatermarkingFontColor)
    $advancedSettings.Add("applyWatermarkingFontSize", $applyWatermarkingFontSize)
}

# Extract content marking settings if enabled
$contentMarkingEnabled = $existingLabel.LabelActions | Where-Object { $_.Type -eq "contentmarking" }
if ($contentMarkingEnabled) {
    $applyContentMarkingFooterEnabled = $contentMarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "footerenabled" } | Select-Object -ExpandProperty Value
    $applyContentMarkingFooterText = $contentMarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "footertext" } | Select-Object -ExpandProperty Value
    $applyContentMarkingFooterFontColor = $contentMarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "footerfontcolor" } | Select-Object -ExpandProperty Value
    $applyContentMarkingFooterFontSize = $contentMarkingEnabled | Select-Object -ExpandProperty Settings | Where-Object { $_.Key -eq "footerfontsize" } | Select-Object -ExpandProperty Value

    # Add content marking settings to advanced settings
    $advancedSettings.Add("applyContentMarkingFooterEnabled", $applyContentMarkingFooterEnabled)
    $advancedSettings.Add("applyContentMarkingFooterText", $applyContentMarkingFooterText)
    $advancedSettings.Add("applyContentMarkingFooterFontColor", $applyContentMarkingFooterFontColor)
    $advancedSettings.Add("applyContentMarkingFooterFontSize", $applyContentMarkingFooterFontSize)
}

# Extract general label settings (non-encryption related)
$generalSettings = @{
    "Name"          = $newLabelName
    "DisplayName"   = $newDisplayName
    "Tooltip"       = $newTooltip
    "ContentType"   = "File, Email"
    "Mode"          = "Enforce"
}

# Create the new label using the extracted settings
New-Label `
    -Name $generalSettings.Name `
    -DisplayName $generalSettings.DisplayName `
    -Tooltip $generalSettings.Tooltip `
    -ContentType $generalSettings.ContentType `
    -AdvancedSettings $advancedSettings

Write-Output "New label '$newLabelName' created successfully."
