# load a current version of the functions module from the API, then import it into the current scope

$authToken = "[Your auth token]"
$serverUrl = "http://[Your SQL Data Catalog Server FQDN]:15156" # or https:// if you've configured SSL
$instanceName = 'sql-server1.domain.com'
$databaseNames = @('AdventureWorks', 'StackOverflow2010', 'Forex')

Invoke-WebRequest -Uri "$serverUrl/powershell" -OutFile 'data-catalog.psm1' `
    -Headers @{"Authorization" = "Bearer $authToken" }

Import-Module .\data-catalog.psm1 -Force

# connect to your SQL Data Catalog instance - you'll need to generate an auth token in the UI
Connect-SqlDataCatalog -AuthToken $authToken -ServerUrl $serverUrl

$databaseNames |
    ForEach-Object {
        $fileName = $_ + ".csv"
        Export-Classification -instanceName $instanceName -databaseName $_ -exportFile $fileName -format 'csv'
    }
