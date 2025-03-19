param location string
param environment string

resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: 'aks-${environment}'
  location: location
  properties: {
    kubernetesVersion: '1.24.6'
    enableRBAC: true
  }
}
