﻿param
(
    [Parameter(Mandatory=$true, HelpMessage="Provide a password to store in the KeyVault")]
    [securestring] $password
)

#create the resource group
New-AzureRmResourceGroup -Name KeyVaultDemo -Location westus -Force

#create the keyvault. note that this command is not idempotent.
$vault = New-AzureRmKeyVault -VaultName KVDemo -ResourceGroupName KeyVaultDemo -EnabledForTemplateDeployment -Location westus

#create/set the secret
$secret = Set-AzureKeyVaultSecret -VaultName KVDemo -Name MySecret -SecretValue $password

#echo the vault id
Write-Host Vault Id: $vault.ResourceId

#echo the vault secret
Write-Host Secret Id: $secret.Name

$TemplateUri = "https://raw.githubusercontent.com/cliveg/demo/master/DemoVSO/DemoVSO/KeyVault/azuredeploy.json"
$TemplateParameterUri = "https://raw.githubusercontent.com/cliveg/demo/master/DemoVSO/DemoVSO/KeyVault/azuredeploy.parameters.json"

#Deploy using the secret
New-AzureRmResourceGroupDeployment -ResourceGroupName KeyVaultDemoVM -TemplateUri $TemplateUri -TemplateParameterUri $TemplateParameterUri

#cleanup non-idempotent resources
#Remove-AzureRmKeyVault -VaultName KVDemo -ResourceGroupName KeyVaultDemo -Force