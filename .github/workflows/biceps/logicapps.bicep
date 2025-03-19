param location string
param environment string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logic-${environment}'
  location: location
  properties: {
    definition: {}
  }
}
