
@description('The location to use for the deployment. defaults to Resource Groups location.')
param location string = resourceGroup().location

param name string = 'kv-${uniqueString(resourceGroup().id)}'

param tags object = {}

var akvName = take(name,24)

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: akvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
  }
  tags: tags
}

output name string = keyVault.name
