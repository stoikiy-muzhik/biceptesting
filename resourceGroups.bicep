@description('Resource Group Name')
param resourceGroupName string
@description('Resource Group Location')
param location string = 'local'

// @allowed([
//   'CanNotDelete'
//   'ReadOnly'
//   ''
// ])
// @description('Resource Group Lock Level')
// param lockLevel string = ''

// @description('Resource Group Lock Notes')
// param lockNotes string = ''

@description('Tags')
param tags object = {}


// var createLock = lockLevel != ''

targetScope = 'subscription'

@description('Provision a Resource Group')
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {

  name: resourceGroupName
  location: location
  tags: tags

}

// @description('Provision a Resource Group Lock')
// resource rgLock 'Microsoft.Authorization/locks@2020-05-01' = if(createLock) {
//   name: '${resourceGroupName}-lock'
//   properties: {
//     level: lockLevel
//     notes: lockNotes
//   }
// }

@description('Output: Resource Group properties')
output resourceGroupObject object = rg.properties
@description('Output: Resource Group Name')
output resourceGroupName string = rg.name
// @description('Output: Resource Group Lock Level')
// output resourceLockLevel string = lockLevel
