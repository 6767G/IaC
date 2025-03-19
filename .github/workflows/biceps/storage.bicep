param location string
param environment string

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'st${environment}${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
