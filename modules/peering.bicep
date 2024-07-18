param to_resource_group_name string
param to_vnet_name string
param from_vnet_name string
param peering_name string
@description('true or false: If remote gateways can be used on this virtual network.')
param use_remote_gateway bool
@description('true or false: If gateway links can be used in remote virtual networking to link to this virtual network.')
param allow_gateway_transit bool

resource to_resource_group 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: to_resource_group_name
  scope: subscription()
}

resource from_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: from_vnet_name
}

resource to_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: to_vnet_name
  scope: to_resource_group
}

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: peering_name
  parent: from_vnet
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    useRemoteGateways: use_remote_gateway
    allowGatewayTransit: allow_gateway_transit
    remoteVirtualNetwork: {
      id: to_vnet.id
    }
  }
}
