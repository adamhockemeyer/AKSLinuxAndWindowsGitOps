param keyVaultName string

@description('An array of Service Principal IDs')
#disable-next-line secure-secrets-in-params //Disabling validation of this linter rule as param does not contain a secret.
param rbacSecretUserSps array = []

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

var keyVaultSecretsUserRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource rbacSecretUserSp 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for rbacSp in rbacSecretUserSps : if(!empty(rbacSp)) {
  scope: keyVault
  name: guid(keyVault.id, rbacSp, keyVaultSecretsUserRole)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalType: 'ServicePrincipal'
    principalId: rbacSp
  }
}]
