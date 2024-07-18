param location string
param gateway_vnet_name string
param hub_rg_name string
param vgw_ip_name string 
param vgw_name string
@allowed([
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw4'
])
param vgw_sku string
param vgw_ip_config_name string
param tags object

resource hub_rg 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: hub_rg_name
  scope: subscription()
}

resource vgwPublicIPAdres 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: vgw_ip_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: tags
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-06-01' existing = {
  name: gateway_vnet_name
  scope: hub_rg
}

resource GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = {
  name: 'GatewaySubnet'
  parent: vnet
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-11-01' = {
  name: vgw_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: vgw_ip_config_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: GatewaySubnet.id
          }
          publicIPAddress: {
            id: vgwPublicIPAdres.id
          }
        }
      }
    ]
    sku: {
      name: vgw_sku
      tier: vgw_sku
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
  }
  tags: tags
}

output vgw_ip string = vgwPublicIPAdres.properties.ipAddress
