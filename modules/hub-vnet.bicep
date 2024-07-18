param hub_vnet_name string
param location string
param hub_vnet_address string
param gateway_subnet_address string
param hub_internal_subnet_name string
param hub_internal_subnet_address string
param hub_nsg_name string
param tags object

resource hub_nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = {
  name: hub_nsg_name
}


resource hub_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: hub_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hub_vnet_address
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: gateway_subnet_address
        }
      }
      {
        name: hub_internal_subnet_name
        properties: {
          addressPrefix: hub_internal_subnet_address
          networkSecurityGroup: {
            id: hub_nsg.id
          }
        }
      }
    ]
  }
  tags: tags
}
