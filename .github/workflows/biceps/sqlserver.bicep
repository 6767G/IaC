param location string
param environment string
param adminUser string
param adminPassword string

resource sql 'Microsoft.Sql/servers@2021-02-01' = {
  name: 'sql-${environment}'
  location: location
  properties: {
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
  }
}
