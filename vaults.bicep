@description('KeyVault Name')
param keyvaultName string

@description('Location - Azure Region')
param location string = resourceGroup().location

@description('Tags')
param tags object = {}

@description('Sku')
@allowed([
  'standard'
  'premium'
])
param sku string = 'standard'

@description('Tenant ID')
param tenantId string =  tenant().tenantId

@description('Allowed IP Addresses')
param allowedIps array = []

@description('Allowed VNet IDs')
param allowedVnetIds array = []

@description('Enabled for Deployment')
param enabledForDeployment bool = false

@description('Enabled for Disk Encryption')
param enabledForDiskEncryption bool = false

@description('Enabled for Template Deployment')
param enabledForTemplateDeployment bool = false

@description('Enable Purge Protection')
param enablePurgeProtection bool = true

@description('Enable Soft Delete')
param enableSoftDelete bool = true

@description('Number of retention days. It accepts >=7 and <=90.')
param softDeleteRetentionInDays int = 90

@description('Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.')
param enableRbacAuthorization bool = false

@description('Network Rule Bypass settings')
@allowed([
  'None'
  'AzureServices'
])
param networkRuleBypass string = 'None'

@description('Network Rule Default Action')
@allowed([
  'Allow'
  'Deny'
])
param networkRuleDefaultAction string = 'Deny'

@description('and Access Policies')
param accessPolicies array = []

@description('and Access Policies')
param publicNetworkAccess string = 'disabled'

@description('Provision a Key Vault')
resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultName
  location: location
  tags: tags

  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: sku
    }
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableSoftDelete: enableSoftDelete
    enablePurgeProtection: enablePurgeProtection ? true : null
    enableRbacAuthorization: enableRbacAuthorization
    softDeleteRetentionInDays: softDeleteRetentionInDays
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      bypass: networkRuleBypass
      defaultAction: networkRuleDefaultAction
      virtualNetworkRules: [for vnet in allowedVnetIds: {
        id: vnet
      }]
      ipRules: [for ip in allowedIps: {
        value: ip
      }]
    }

    accessPolicies: [for policy in accessPolicies: {
      tenantId: tenantId
      objectId: policy.objectId
      permissions: {
        keys: policy.keys
        secrets: policy.secrets
        storage: policy.storage
        certificates: policy.certificates
      }
    }]
  }
}

@description('Output: Key Vault properties')
output keyvaultProperties object = keyvault.properties
@description('Output: Key Vault property: enableRbacAuthorization')
output keyvaultRbacAuth bool = keyvault.properties.enableRbacAuthorization
@description('Output: Key Vault property: identity')
output keyVaultResourceId string = keyvault.id
@description('Output: Key Vault property: name')
output keyVaultName string = keyvault.name
