
param clusterName string

resource aks 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' existing = {
  name: clusterName
}

resource flux 'Microsoft.KubernetesConfiguration/extensions@2022-11-01' = {
  name: 'flux'
  scope: aks
  properties: {
    extensionType: 'microsoft.flux'
    scope: {
      cluster: {
        releaseNamespace: 'flux-system'
      }
    }
    autoUpgradeMinorVersion: true
  }
}

output extensionName string = flux.name
