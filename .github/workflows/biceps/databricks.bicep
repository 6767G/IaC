param location string
param environment string

resource databricks 'Microsoft.Databricks/workspaces@2021-06-01' = {
  name: 'adb-${environment}'
  location: location
  properties: {
    managedResourceGroupId: resourceGroup().id
  }
}
