param location string
param environment string

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'func-${environment}'
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'plan-${environment}')
  }
}
