param nsg_name string
param nsg_location string
param tags object

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: nsg_name
  location: nsg_location
  properties: {
    securityRules: [
      {
        name: 'AllowICMP'
        properties: {
          description: 'Allow ICMP traffic'
          priority: 4096
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Icmp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
  tags: tags
}

output nsg_id string = nsg.id
