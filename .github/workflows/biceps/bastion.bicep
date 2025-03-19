param location string
param environment string
param vnetName string

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: 'bastion-${environment}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureBastionSubnet')
          }
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', 'bastion-ip-${environment}')
          }
        }
      }
    ]
  }
}
