param lgw_name string
param location string
@description('Local network site address space.')
param local_network_address_space string
@description('IP address of local network gateway (your on-prem firewall IP, for vpn termination).')
param lgw_ip_address string

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-11-01' = {
  name: lgw_name
  location: location
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        local_network_address_space
      ]
    }
    gatewayIpAddress: lgw_ip_address
  }
}
