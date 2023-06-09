param clusterName string
param fluxExtensionName string


resource aks 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' existing = {
  name: clusterName
}

resource flux 'Microsoft.KubernetesConfiguration/extensions@2022-11-01' existing = {
  name: fluxExtensionName
  scope: aks
}

resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-11-01' = {
  name: 'cluster-config'
  scope: aks
  dependsOn: [
    flux
  ]
  properties: {
    scope: 'cluster'
    namespace: 'cluster-config'
    sourceKind: 'GitRepository'
    suspend: false
    gitRepository: {
      url: 'https://github.com/adamhockemeyer/AKSLinuxAndWindowsGitOps'
      timeoutInSeconds: 600
      syncIntervalInSeconds: 600
      repositoryRef: {
        branch: 'main'
      }

    }
    kustomizations: {
      infra: {
        path: './flux-config/infrastructure'
        dependsOn: []
        timeoutInSeconds: 1200
        syncIntervalInSeconds: 600
        prune: true
      }
      mvc: {
        path: './flux-config/apps/staging/eshop-mvc'
        dependsOn: [
          'infra'
        ]
        timeoutInSeconds: 600
        syncIntervalInSeconds: 600
        retryIntervalInSeconds: 600
        prune: true
      }
      wcf: {
        path: './flux-config/apps/staging/eshop-wcf'
        dependsOn: [
          'infra'
        ]
        timeoutInSeconds: 600
        syncIntervalInSeconds: 600
        retryIntervalInSeconds: 600
        prune: true
      }
      webforms: {
        path: './flux-config/apps/staging/eshop-webforms'
        dependsOn: [
          'infra'
        ]
        timeoutInSeconds: 600
        syncIntervalInSeconds: 600
        retryIntervalInSeconds: 600
        prune: true
      }
    }
  }
}

output fluxConfigRepo string = fluxConfig.properties.gitRepository.url
