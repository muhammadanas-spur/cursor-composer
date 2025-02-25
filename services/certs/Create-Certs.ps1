# [string]$Password = [Guid]::NewGuid().ToString("N")
# Set-Content -Path "${PSScriptRoot}\Password.txt" -Value $Password -NoNewline

# docker run --rm --entrypoint="/bin/bash" -v "${PSScriptRoot}:/Certs" -w="/Certs" mcr.microsoft.com/dotnet/aspnet:8.0 "/Certs/CreateCerts.sh"

# $envTemplate = Get-Content -Path "${PSScriptRoot}\ContainerCerts.env.template"
# $envWPassword = $envTemplate.Replace("`$Password", $Password)


# $integrationsApiEnv = $envWPassword.Replace("`$ProjectName", "integrations.api")
# Set-Content -Path "${PSScriptRoot}\..\Services\Integrations\Integrations.API\ContainerCerts.env" -Value $integrationsApiEnv

# $queuingApiEnv = $envWPassword.Replace("`$ProjectName", "queuing.api")
# Set-Content -Path "${PSScriptRoot}\..\Services\Queuing\Queuing.API\ContainerCerts.env" -Value $queuingApiEnv

# $businessmodulesApiEnv = $envWPassword.Replace("`$ProjectName", "businessmodules.api")
# Set-Content -Path "${PSScriptRoot}\..\Services\BusinessModules\BusinessModules.API\ContainerCerts.env" -Value $businessmodulesApiEnv

# $webaggregatorApiEnv = $envWPassword.Replace("`$ProjectName", "webaggregator")
# Set-Content -Path "${PSScriptRoot}\..\APIGateways\WebAggregator\ContainerCerts.env" -Value $webaggregatorApiEnv

# $alertsApiEnv = $envWPassword.Replace("`$ProjectName", "alerts.api")
# Set-Content -Path "${PSScriptRoot}\..\Services\Alerts\Alerts.API\ContainerCerts.env" -Value $alertsApiEnv

# $interactionsApiEnv = $envWPassword.Replace("`$ProjectName", "interactions.api")
# Set-Content -Path "${PSScriptRoot}\..\Services\Interactions\Interactions.API\ContainerCerts.env" -Value $interactionsApiEnv

# $testCaCert = New-Object -TypeName "System.Security.Cryptography.X509Certificates.X509Certificate2" @("${PSScriptRoot}\test-ca.crt", $null)

# $storeName = [System.Security.Cryptography.X509Certificates.StoreName]::Root;
# $storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
# $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($storeName, $storeLocation)
# $store.Open(([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite))
# try
# {
#     $store.Add($testCaCert)
# }
# finally
# {
#     $store.Close()
#     $store.Dispose()
# }


# Generate a new password and save it to a file
Write-Host "Generating a new password..."
[string]$Password = [Guid]::NewGuid().ToString("N")
Write-Host "Saving the password to Password.txt..."
Set-Content -Path "${PSScriptRoot}\Password.txt" -Value $Password -NoNewline

# Run the Docker container to create certificates
Write-Host "Running the Docker container to create certificates..."
docker run --rm --entrypoint="/bin/bash" -v "${PSScriptRoot}:/Certs" -w="/Certs" mcr.microsoft.com/dotnet/aspnet:8.0 "/Certs/CreateCerts.sh"

# Read the environment template and replace placeholders with actual values
Write-Host "Reading the environment template..."
$envTemplate = Get-Content -Path "${PSScriptRoot}\ContainerCerts.env.template"
Write-Host "Replacing placeholders in the environment template with actual values..."
$envWPassword = $envTemplate.Replace("`$Password", $Password)

# Define a list of services and their corresponding paths
Write-Host "Defining a list of services and their corresponding paths..."
$services = @{
    "backendservices" = "${PSScriptRoot}\..\backendservices\ContainerCerts.env"
    "anotherbackendservice" = "${PSScriptRoot}\..\anotherbackendservice\ContainerCerts.env"
   }

# Loop through each service and create the environment file
foreach ($service in $services.GetEnumerator()) {
    Write-Host "Creating environment file for $($service.Key)..."
    $envContent = $envWPassword.Replace("`$ProjectName", $service.Key)
    Set-Content -Path $service.Value -Value $envContent
}

# Load the test CA certificate and add it to the certificate store
Write-Host "Loading the custom-sample-ca CA certificate..."
$testCaCert = New-Object -TypeName "System.Security.Cryptography.X509Certificates.X509Certificate2" @("${PSScriptRoot}\custom-sample-ca.crt", $null)
$storeName = [System.Security.Cryptography.X509Certificates.StoreName]::Root
$storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store($storeName, $storeLocation)
Write-Host "Opening the certificate store..."
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
try {
    Write-Host "Adding the test CA certificate to the store..."
    $store.Add($testCaCert)
} finally {
    Write-Host "Closing the certificate store..."
    $store.Close()
    $store.Dispose()
}