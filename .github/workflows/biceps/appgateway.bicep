param location string
param environment string
param vnetName string

resource appGateway 'Microsoft.Network/applicationGateways@2021-02-01' = {
  name: 'agw-${environment}'
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'gatewayIP'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AppGatewaySubnet')
          }
        }
      }
    ]
  }
}
