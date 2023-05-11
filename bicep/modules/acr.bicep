@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string = 'acr${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param location string = resourceGroup().location

@allowed(['Basic', 'Standard', 'Premium'])
@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'
@description('The principal ID of the AKS cluster')
param aksPrincipalId string
@description('Tags for the resources')
param tags object = {}
 @description('The role definition ID of the AcrPull role')
param roleAcrPull string = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
 
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
  tags: tags
}
 
resource assignAcrPullToAks 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, acrName, aksPrincipalId, 'AssignAcrPullToAks')
  scope: containerRegistry
  properties: {
    description: 'Assign AcrPull role to AKS'
    principalId: aksPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAcrPull)
  }
}
 
output name string = containerRegistry.name
