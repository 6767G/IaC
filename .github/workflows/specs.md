# Azure Infrastructure Specifications (specs.md)

## Naming Convention
All resources follow the naming convention:
- **Resource Groups**: `rg-{environment}-{name}`
- **Virtual Network**: `vnet-{environment}`
- **Azure Bastion**: `bastion-{environment}`
- **Virtual Machine**: `vm-{environment}-{role}`
- **Data Factory**: `adf-{environment}`
- **SQL Server**: `sql-{environment}`
- **Storage Account**: `st{environment}{unique}`
- **Azure Databricks**: `adb-{environment}`
- **Application Gateway**: `agw-{environment}`
- **Key Vault**: `kv-{environment}`
- **Kubernetes Service**: `aks-{environment}`
- **Azure Functions**: `func-{environment}`
- **Cosmos DB**: `cosmos-{environment}`
- **API Management**: `apim-{environment}`
- **Logic Apps**: `logic-{environment}`
- **Service Bus**: `sb-{environment}`

### Environment Values
- **Production** = `prod`
- **Development** = `dev`
- **Testing** = `test`

---

## Bicep Modules
Each service is implemented as an independent **Bicep** module, and `main.bicep` calls them.

### Additional Services
The following Bicep modules extend the infrastructure with additional capabilities:

#### 8. Application Gateway (`appgateway.bicep`)
```bicep
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
```

#### 9. Key Vault (`keyvault.bicep`)
```bicep
param location string
param environment string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01' = {
  name: 'kv-${environment}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
  }
}
```

#### 10. Kubernetes Service (`aks.bicep`)
```bicep
param location string
param environment string

resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: 'aks-${environment}'
  location: location
  properties: {
    kubernetesVersion: '1.24.6'
    enableRBAC: true
  }
}
```

#### 11. Azure Functions (`functions.bicep`)
```bicep
param location string
param environment string

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'func-${environment}'
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'plan-${environment}')
  }
}
```

#### 12. Cosmos DB (`cosmosdb.bicep`)
```bicep
param location string
param environment string

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: 'cosmos-${environment}'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
  }
}
```

#### 13. API Management (`apim.bicep`)
```bicep
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
```

#### 14. Logic Apps (`logicapps.bicep`)
```bicep
param location string
param environment string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logic-${environment}'
  location: location
  properties: {
    definition: {}
  }
}
```

#### 15. Service Bus (`servicebus.bicep`)
```bicep
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
```

This expanded infrastructure setup ensures scalability and better security for cloud-based applications.

