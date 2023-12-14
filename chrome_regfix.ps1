#This script allows Google Chrome to autoupdate on Windows
#Fixes specific registry issues
#By: David Krause
#Date: 12/14/2023

$registryPath = "HKLM:\SOFTWARE\Policies\Google\Update"
$anyRegistryKeysExist = $false
$defaultRegistryValueName = "(Default)"

# Define the specific names of the registry keys to be checked and updated
$registryKeys = @(
    "DisableAutoUpdateChecksCheckboxValue",
    "Update{2BF2CA35-CCAF-4E58-BAB7-4163BFA03B88}",
    "Update{4DC8B4CA-1BDA-483E-B5FA-D3C12E15B62D}",
    "Update{74AF07D8-FB8F-4D41-8AC7-927721D56EBB}",
    "Update{8A69D345-D564-463C-AFF1-A69DE530F96}",
    "Update{8A69D345-D564-463C-AFF1-A69DE530F96D}"
)

# Check each registry key and update it if the current value is 0
foreach ($key in $registryKeys) {
    $keyPath = "$registryPath\$key"
    if (Test-Path $keyPath) {
        $anyRegistryKeysExist = $true
        try {
            $valueData = Get-ItemPropertyValue -Path $keyPath -Name $defaultRegistryValueName -ErrorAction Stop
            if ($valueData -eq 0) {
                Set-ItemProperty -Path $keyPath -Name $defaultRegistryValueName -Value 1
                Write-Host "Updated registry key at $keyPath from 0 to 1."
            } else {
                Write-Host "Registry key at $keyPath does not need updating (current value: $valueData)."
            }
        } catch {
            Write-Warning "Error accessing registry key at ${keyPath}: $_"
        }
    } else {
        Write-Host "Registry key $keyPath does not exist."
    }
}

# Provide feedback if no registry keys exist
if (-not $anyRegistryKeysExist) {
    Write-Host "No relevant registry keys found to update."
}
