Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
Install-Module -Name Az.Accounts -Force -Scope CurrentUser
Import-Module ExchangeOnlineManagement
Import-Module Az.Accounts

Connect-IPPSSession -UserPrincipalName admin@m365licenstest.onmicrosoft.com

Get-Label -IncludeDetailedLabelActions

Get-Label

Get-Label -Identity "DKE" | Format-List *