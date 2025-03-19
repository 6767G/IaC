param location string
param environment string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-06-01' = {
  name: 'sb-${environment}'
  location: location
  properties: {
    sku: {
      name: 'Standard'
      tier: 'Standard'
    }
  }
}
