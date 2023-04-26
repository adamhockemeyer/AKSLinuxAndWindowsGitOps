@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 40

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 1

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(100)
param agentWindowsCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@description('The size of the Virtual Machine.')
param agentWindowsVMSize string = 'standard_d2s_v3'


// @description('User name for the Linux Virtual Machines.')
// param linuxAdminUsername string

// @description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
// param sshRSAPublicKey string

resource aks 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: '1.25.6'
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'Standard'
      outboundType: 'loadBalancer'
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        osDiskSizeGB: osDiskSizeGB
        osDiskType: 'Ephemeral'
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
      }
      {
        name: 'win01'
        osDiskSizeGB: osDiskSizeGB
        osDiskType: 'Ephemeral'
        count: agentWindowsCount
        vmSize: agentWindowsVMSize
        osType: 'Windows'
        mode: 'User'
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
      }
    ]
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
output clusterName string = aks.name
