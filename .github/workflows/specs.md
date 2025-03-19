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

### Environment Values
- **Production** = `prod`
- **Development** = `dev`
- **Testing** = `test`

---

## Bicep Modules
Each service is implemented as an independent **Bicep** module, and `main.bicep` calls them.

### 1. Virtual Network (`vnet.bicep`)
```bicep
param location string
param environment string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet-${environment}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'subnet-default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
```

### 2. Azure Bastion (`bastion.bicep`)
```bicep
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
```

### 3. Windows Virtual Machine (`vm.bicep`)
```bicep
param location string
param environment string
param adminUsername string
param adminPassword string

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'vm-${environment}-web'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    osProfile: {
      computerName: 'vm-${environment}-web'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
  }
}

resource autoShutdown 'Microsoft.DevTestLab/schedules@2021-05-01' = {
  name: 'shutdown-compute-vm'
  properties: {
    status: 'Enabled'
    timeZoneId: 'UTC'
    dailyRecurrence: {
      time: '18:00'
    }
    taskType: 'ComputeVmShutdownTask'
  }
}
```

### 4. Data Factory (`datafactory.bicep`)
```bicep
param location string
param environment string

resource adf 'Microsoft.DataFactory/factories@2021-06-01' = {
  name: 'adf-${environment}'
  location: location
  properties: {}
}
```

### 5. SQL Server (`sqlserver.bicep`)
```bicep
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
```

### 6. Storage Account (`storage.bicep`)
```bicep
param location string
param environment string

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'st${environment}${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

### 7. Azure Databricks (`databricks.bicep`)
```bicep
param location string
param environment string

resource databricks 'Microsoft.Databricks/workspaces@2021-06-01' = {
  name: 'adb-${environment}'
  location: location
  properties: {
    managedResourceGroupId: resourceGroup().id
  }
}
```

---

## GitHub Actions Workflow (`.github/workflows/azure-deploy.yml`)
```yaml
name: Deploy Azure Infrastructure

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    name: Deploy Bicep Templates to Azure
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Login to Azure
      uses: azure/login@v1
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    - name: Deploy Bicep template
      run: |
        az deployment group create \
          --resource-group myResourceGroup \
          --template-file main.bicep \
          --parameters environment=dev adminUsername=admin adminPassword=SuperSecret!
```

---

## How to Use
1. **Save** all Bicep files in your repository.
2. **Update** the `azure-deploy.yml` file with your parameters.
3. **Create an Azure AD App Registration**:
   ```sh
   az ad sp create-for-rbac --name "github-actions" --role Contributor --scopes /subscriptions/<subscription-id> --sdk-auth
   ```
4. **Add GitHub Secrets**:
   - `AZURE_CLIENT_ID`: `<appId>`
   - `AZURE_TENANT_ID`: `<tenant>`
   - `AZURE_SUBSCRIPTION_ID`: `<subscriptionId>`
5. **Push changes** to the `main` branch and GitHub Actions will deploy your infrastructure automatically!

