param location string
param vgw_name string
param lgw_name string
param vpn_connection_name string
param connection_type string
@secure()
param sharedKey string

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-11-01' existing = {
  name: vgw_name
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-11-01' existing = {
  name: lgw_name
}

resource vpnVnetConnection 'Microsoft.Network/connections@2023-02-01' = {
  name: vpn_connection_name
  location: location
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
      properties:{}
    }
    localNetworkGateway2: {
      id: localNetworkGateway.id
      properties:{}
    }
    connectionType: connection_type
    routingWeight: 0
    sharedKey: sharedKey 
  }
}
