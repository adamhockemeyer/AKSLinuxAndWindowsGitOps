targetScope = 'subscription'

param resourceGroupName string = 'aks-win-rg'
param location string = deployment().location
param lastUpdated string = utcNow()

var aksName = 'aks-${uniqueString(resourceGroupName)}'

var tags = {
  project: 'AKSLinuxAndWindowsGitOps'
  lastUpdated: lastUpdated
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: location
  properties: {
  }
  tags: tags
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  scope: resourceGroup
  params: {
    clusterName: aksName
    dnsPrefix: aksName
    location: resourceGroup.location
    tags: tags
  }
}

module acr 'modules/acr.bicep' = {
  name: 'acr'
  scope: resourceGroup
  params: {
    acrName: 'acr${uniqueString(resourceGroupName)}'
    location: resourceGroup.location
    aksPrincipalId: aks.outputs.clusterPrincipalId
    tags: tags
  }
}

module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVault'
  scope: resourceGroup
  params: {
    name: 'kv-${uniqueString(resourceGroupName)}'
    location: resourceGroup.location
    tags: tags
  }
}

module keyVaultRbac 'modules/keyvault-rbac.bicep' = {
  scope: resourceGroup
  name: 'keyVaultRbac-aks-csi'
  params: {
    keyVaultName: keyVault.outputs.name
    rbacSecretUserSps: [
      aks.outputs.azureKeyVaultSecretsProviderPrincipalId
    ]
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

