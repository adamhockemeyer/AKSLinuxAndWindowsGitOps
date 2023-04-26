targetScope = 'subscription'

param resourceGroupName string = 'aks-win-rg'
param location string = deployment().location

var aksName = 'aks-${uniqueString(resourceGroupName)}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: location
  properties: {
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  scope: resourceGroup
  params: {
    clusterName: aksName
    dnsPrefix: aksName
    location: resourceGroup.location
  }
}

module fluxExtension 'modules/aks-flux-extension.bicep' = {
  name: 'fluxExtension'
  scope: resourceGroup
  params: {
    clusterName: aks.outputs.clusterName
  }
}

module fluxConfig 'modules/aks-flux-config.bicep' = {
  name: 'fluxConfig'
  scope: resourceGroup
  params: {
    clusterName: aks.outputs.clusterName
    fluxExtensionName: fluxExtension.outputs.extensionName
  }
}

