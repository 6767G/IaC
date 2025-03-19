param location string
param environment string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01' = {
  name: 'kv-${environment}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
  }
}
