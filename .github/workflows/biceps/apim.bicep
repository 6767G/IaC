param location string
param environment string

resource apiManagement 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: 'apim-${environment}'
  location: location
  properties: {
    publisherName: 'MyCompany'
    publisherEmail: 'admin@mycompany.com'
  }
}
