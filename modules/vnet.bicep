import* as types from '../infrastructure/types.bicep'
param vnet_name string
param location string = resourceGroup().location
param vnet_settings types.vnet_settings
@description('Network security group name')
param nsg_name string
param tags object

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-06-01' existing = {
  name: nsg_name
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnet_settings.addressPrefixes
    }
    subnets: [ for subnet in vnet_settings.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: {
          id: networkSecurityGroup.id
        }
      }
    }]
  }
  tags: tags
}

// Output the subnet IDs
output subnet_ids array = [ for subnet in vnet_settings.subnets: {
  id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnet.name)
}]
