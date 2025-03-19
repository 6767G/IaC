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
