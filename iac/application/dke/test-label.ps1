# login section start
Install-Module ExchangeOnlineManagement -Force
Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName admin@m365licenstest.onmicrosoft.com

admin@m365licenstest.onmicrosoft.com
!tsg1Roug3

# login section end

# Get different info of labels
Get-Label -Identity "DKE" | Format-List
Get-Label -Identity "DKE" -IncludeDetailedLabelActions

Get-Label | Format-Table -Property DisplayName, Name, Guid, ContentType


# Update existing label with new information
$Languages = @("fr-fr","it-it","de-de")
$DisplayNames=@("Publique","Publico","Oeffentlich")
$Tooltips = @("Texte Français","Testo italiano","Deutscher text")
$label = "Public"
$DisplayNameLocaleSettings = [PSCustomObject]@{LocaleKey='DisplayName';
Settings=@(
@{key=$Languages[0];Value=$DisplayNames[0];}
@{key=$Languages[1];Value=$DisplayNames[1];}
@{key=$Languages[2];Value=$DisplayNames[2];})}
$TooltipLocaleSettings = [PSCustomObject]@{LocaleKey='Tooltip';
Settings=@(
@{key=$Languages[0];Value=$Tooltips[0];}
@{key=$Languages[1];Value=$Tooltips[1];}
@{key=$Languages[2];Value=$Tooltips[2];})}
Set-Label -Identity $Label -LocaleSettings (ConvertTo-Json $DisplayNameLocaleSettings -Depth 3 -Compress),(ConvertTo-Json $TooltipLocaleSettings -Depth 3 -Compress)