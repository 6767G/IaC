param location string
param environment string

resource adf 'Microsoft.DataFactory/factories@2021-06-01' = {
  name: 'adf-${environment}'
  location: location
  properties: {}
}
