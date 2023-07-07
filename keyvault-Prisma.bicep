
@description('Tags that will be applied to all resource provisioned in this Bicep file.')
param tags object

@description('Key Vault parameters used across Bicep file.')
param keyVaults array

@description('Provision many Key Vaults.')
module keyvaultModule 'vaults.bicep' = [for kv in keyVaults: {
  name: kv.name
  scope: resourceGroup(kv.resourceGroupName)
  params: {
    keyvaultName: kv.name
    location: kv.location
    tags: union(tags, kv.tags)
    enableRbacAuthorization: kv.enableRbacAuthorization
    enabledForTemplateDeployment: kv.enabledForTemplateDeployment
    networkRuleBypass: kv.networkRuleBypass
    enableSoftDelete: kv.enableSoftDelete
    softDeleteRetentionInDays: kv.softDeleteRetentionInDays
    enablePurgeProtection: kv.enablePurgeProtection
  }
}]
