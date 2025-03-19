param location string = 'westeurope'
param environment string = 'dev'
param adminUsername string
param adminPassword string

module vnet './vnet.bicep' = {
  name: 'deployVnet'
  params: {
    location: location
    environment: environment
  }
}

module bastion './bastion.bicep' = {
  name: 'deployBastion'
  params: {
    location: location
    environment: environment
    vnetName: vnet.outputs.vnetName
  }
}

module vm './vm.bicep' = {
  name: 'deployVm'
  params: {
    location: location
    environment: environment
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module datafactory './datafactory.bicep' = {
  name: 'deployDataFactory'
  params: {
    location: location
    environment: environment
  }
}

module sqlserver './sqlserver.bicep' = {
  name: 'deploySqlServer'
  params: {
    location: location
    environment: environment
    adminUser: adminUsername
    adminPassword: adminPassword
  }
}

module storage './storage.bicep' = {
  name: 'deployStorage'
  params: {
    location: location
    environment: environment
  }
}

module databricks './databricks.bicep' = {
  name: 'deployDatabricks'
  params: {
    location: location
    environment: environment
  }
}