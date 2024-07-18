// declare parameters - parameters.bicepparam
param location resourceGroup().location
param deploy_gateway bool

// resource names
var prefixes = loadJsonContent('prefixes.json')
var default_tag_name = 'environment'
var hub_rg_name = '${prefixes.resourceGroup}-${prefixes.hub}-${location}'
var hub_vnet_name = '${prefixes.virtualNetwork}-${prefixes.hub}-${location}'
var hub_internal_subnet_name = '${prefixes.subnet}-${prefixes.hub}-${prefixes.internalTier}-${location}'
var hub_nsg_name = '${prefixes.networkSecurityGroup}-${prefixes.hub}-${location}'
var production_rg_name = '${prefixes.resourceGroup}-${prefixes.production}-${location}'
var production_vnet_name = '${prefixes.virtualNetwork}-${prefixes.production}-${location}'
var production_nsg_name = '${prefixes.networkSecurityGroup}-${prefixes.production}-${location}'
var development_rg_name = '${prefixes.resourceGroup}-${prefixes.development}-${location}'
var development_vnet_name = '${prefixes.virtualNetwork}-${prefixes.development}-${location}'
var development_nsg_name = '${prefixes.networkSecurityGroup}-${prefixes.development}-${location}'
var staging_rg_name = '${prefixes.resourceGroup}-${prefixes.staging}-${location}'
var staging_vnet_name = '${prefixes.virtualNetwork}-${prefixes.staging}-${location}'
var staging_nsg_name = '${prefixes.networkSecurityGroup}-${prefixes.staging}-${location}'
var vgw_name = '${prefixes.virtualNetworkGateway}-${prefixes.hub}-${location}'
var vgw_ip_config_name = '${prefixes.publicIPConfiguration}-${prefixes.hub}-${location}'
var vgw_ip_name = '${prefixes.publicIP}-${prefixes.hub}-${prefixes.virtualNetworkGateway}-${location}'
// peerings names
var hub_to_prod_peering_name = '${prefixes.peering}-${prefixes.hub}-${prefixes.virtualNetwork}-to-${prefixes.production}-${prefixes.virtualNetwork}'
var prod_to_hub_peering_name = '${prefixes.peering}-${prefixes.production}-${prefixes.virtualNetwork}-to-${prefixes.hub}-${prefixes.virtualNetwork}'
var hub_to_stg_peering_name  = '${prefixes.peering}-${prefixes.hub}-${prefixes.virtualNetwork}-to-${prefixes.staging}-${prefixes.virtualNetwork}'
var stg_to_hub_peering_name  = '${prefixes.peering}-${prefixes.staging}-${prefixes.virtualNetwork}-to-${prefixes.hub}-${prefixes.virtualNetwork}'
var hub_to_dev_peering_name  = '${prefixes.peering}-${prefixes.hub}-${prefixes.virtualNetwork}-to-${prefixes.development}-${prefixes.virtualNetwork}'
var dev_to_hub_peering_name  = '${prefixes.peering}-${prefixes.development}-${prefixes.virtualNetwork}-to-${prefixes.hub}-${prefixes.virtualNetwork}'
// tags
var hub_tags = {
  environment: prefixes.hub
}
var production_tags = {
  environment: prefixes.production
}
var development_tags = {
  environment: prefixes.development
}
var staging_tags = {
  environment: prefixes.staging  
}
var hub_net_tags = {
  environment: prefixes.hub
  function: 'network'
}
var production_net_tags = {
  environment: prefixes.production
  function: 'network'
}
var development_net_tags = {
  environment: prefixes.development
  function: 'network'
}
var staging_net_tags = {
  environment: prefixes.staging
  function: 'network'  
}
//vnet settings variables
var vgw_sku = 'VpnGw2'
var hub_vnet_address = '10.254.0.0/16'
var gateway_subnet_address = '10.254.1.0/24'
var hub_internal_subnet_address = '10.254.0.0/24'
var development_vnet_address = '10.220.0.0/16'
var production_vnet_address = '10.200.0.0/16'
var staging_vnet_address = '10.210.0.0/16'
var production_subnet_names = {
  data: '${prefixes.subnet}-${prefixes.production}-${prefixes.dataTier}-${location}'
  internal: '${prefixes.subnet}-${prefixes.production}-${prefixes.internalTier}-${location}'
  dmz: '${prefixes.subnet}-${prefixes.production}-dmz-${location}'
}
var production_subnets_prefixes = {
    data: '10.200.0.0/24'
    internal: '10.200.1.0/24'
    dmz: '10.200.2.0/24'
}

var development_subnet_names = {
  data: '${prefixes.subnet}-${prefixes.development}-${prefixes.dataTier}-${location}'
  internal: '${prefixes.subnet}-${prefixes.development}-${prefixes.internalTier}-${location}'
  dmz: '${prefixes.subnet}-${prefixes.development}-dmz-${location}'
}
var development_subnets_prefixes = {
    data: '10.220.0.0/24'
    internal: '10.220.1.0/24'
    dmz: '10.220.2.0/24'
}

var staging_subnet_names = {
  data: '${prefixes.subnet}-${prefixes.staging}-${prefixes.dataTier}-${location}'
  internal: '${prefixes.subnet}-${prefixes.staging}-${prefixes.internalTier}-${location}'
  dmz: '${prefixes.subnet}-${prefixes.staging}-dmz-${location}'
}
var staging_subnets_prefixes = {
    data: '10.210.0.0/24'
    internal: '10.210.1.0/24'
    dmz: '10.210.2.0/24'
}
var production_vnet_settings = {
  addressPrefixes: [
    production_vnet_address
  ]
  subnets: [
    {
      name: production_subnet_names.data
      addressPrefix: production_subnets_prefixes.data
    }
    {
      name: production_subnet_names.internal
      addressPrefix: production_subnets_prefixes.internal
    }
    {
      name: production_subnet_names.dmz
      addressPrefix: production_subnets_prefixes.dmz
    }
  ]
}
var development_vnet_settings = {
  addressPrefixes: [
    development_vnet_address
  ]
  subnets: [
    {
      name: development_subnet_names.data
      addressPrefix: development_subnets_prefixes.data
    }
    {
      name: development_subnet_names.internal
      addressPrefix: development_subnets_prefixes.internal
    }
    {
      name: development_subnet_names.dmz
      addressPrefix: development_subnets_prefixes.dmz
    }
  ]
}
var staging_vnet_settings = {
  addressPrefixes: [
    staging_vnet_address
  ]
  subnets: [
    {
      name: staging_subnet_names.data
      addressPrefix: staging_subnets_prefixes.data
    }
    {
      name: staging_subnet_names.internal
      addressPrefix: staging_subnets_prefixes.internal
    }
    {
      name: staging_subnet_names.dmz
      addressPrefix: staging_subnets_prefixes.dmz
    }
  ]
}
// create resource groups
module hub_rg 'modules/resource_group.bicep' = {
  name: hub_rg_name
  scope: subscription()
  params: {
    location: location
    name: hub_rg_name
    tags: hub_tags
  }
}
module production_rg 'modules/resource_group.bicep' = {
  scope: subscription()
  name: production_rg_name
  params: {
    location: location
    name: production_rg_name
    tags: production_tags
  }
}
module development_rg 'modules/resource_group.bicep' = {
  scope: subscription()
  name: development_rg_name
  params: {
    location: location
    name: development_rg_name
    tags: development_tags
  }
}
module staging_rg 'modules/resource_group.bicep' = {
  scope: subscription()
  name: staging_rg_name
  params: {
    location: location
    name: staging_rg_name
    tags: staging_tags
  }
}
// create virtual networks and network security groups
module hub_nsg 'modules/nsg.bicep' = {
  name: hub_nsg_name
  scope: resourceGroup(hub_rg.name)
  params: {
    nsg_location: hub_rg.outputs.location
    nsg_name: hub_nsg_name
    tags: hub_net_tags
  }
  dependsOn: [hub_rg]
}

module hub_vnet 'modules/hub-vnet.bicep' = {
  name: hub_vnet_name
  scope: resourceGroup(hub_rg.name)
  params: {
    gateway_subnet_address: gateway_subnet_address
    hub_internal_subnet_address: hub_internal_subnet_address
    hub_internal_subnet_name: hub_internal_subnet_name
    hub_nsg_name: hub_nsg.name
    hub_vnet_address: hub_vnet_address
    hub_vnet_name: hub_vnet_name
    location: hub_rg.outputs.location
    tags: hub_net_tags
  }
  dependsOn: [hub_nsg]
}
// create Virtual network Gateway if deploy_gateway is set to true
module virtual_network_gateway 'modules/vgw.bicep' = if(deploy_gateway){
  scope: resourceGroup(hub_rg.name)
  name: vgw_name
  params: {
    gateway_vnet_name: hub_vnet.name
    hub_rg_name: hub_rg.name
    location: hub_rg.outputs.location
    vgw_ip_config_name: vgw_ip_config_name
    vgw_ip_name: vgw_ip_name
    vgw_name: vgw_name
    vgw_sku: vgw_sku
    tags: hub_net_tags
  }
  dependsOn: [hub_vnet]
}

module staging_nsg 'modules/nsg.bicep' = {
  name: staging_nsg_name
  scope: resourceGroup(staging_rg.name)
  params: {
    nsg_location: staging_rg.outputs.location
    nsg_name: staging_nsg_name
    tags: staging_net_tags
  }
  dependsOn: [staging_rg]
}
module staging_vnet 'modules/vnet.bicep' = {
  name: staging_vnet_name
  scope: resourceGroup(staging_rg.name)
  params: {
    vnet_name: staging_vnet_name
    vnet_settings: staging_vnet_settings
    nsg_name: staging_nsg.name
    tags: staging_net_tags
  }
  dependsOn: [staging_nsg]
}

module development_nsg 'modules/nsg.bicep' = {
  name: development_nsg_name
  scope: resourceGroup(development_rg.name)
  params: {
    nsg_location: development_rg.outputs.location
    nsg_name: development_nsg_name
    tags: development_net_tags
  }
  dependsOn: [development_rg]
}
module development_vnet 'modules/vnet.bicep' = {
  name: development_vnet_name
  scope: resourceGroup(development_rg.name)
  params: {
    vnet_name: development_vnet_name
    vnet_settings: development_vnet_settings
    nsg_name: development_nsg.name
    tags: development_net_tags
  }
  dependsOn: [development_nsg]
}

module production_nsg 'modules/nsg.bicep' = {
  name: production_nsg_name
  scope: resourceGroup(production_rg.name)
  params: {
    nsg_location: production_rg.outputs.location
    nsg_name: production_nsg_name
    tags: production_net_tags
  }
  dependsOn: [production_rg]
}
module production_vnet 'modules/vnet.bicep' = {
  name: production_vnet_name
  scope: resourceGroup(production_rg.name)
  params: {
    vnet_name: production_vnet_name
    vnet_settings: production_vnet_settings
    nsg_name: production_nsg.name
    tags: production_net_tags
  }
  dependsOn: [production_nsg]
}

// peerings
// hub to production
module peering_hub_to_prod 'modules/peering.bicep' = {
  name: hub_to_prod_peering_name
  scope: resourceGroup(hub_rg.name)
  params: {
    allow_gateway_transit: true
    from_vnet_name: hub_vnet.name
    peering_name: hub_to_prod_peering_name
    to_resource_group_name: production_rg.name
    to_vnet_name: production_vnet.name
    use_remote_gateway: false
  }
  dependsOn: [
    hub_vnet
    production_vnet
  ]
}
module peering_prod_to_hub 'modules/peering.bicep' = {
  name: prod_to_hub_peering_name
  scope: resourceGroup(production_rg.name)
  params: {
    allow_gateway_transit: false
    from_vnet_name: production_vnet.name
    peering_name: prod_to_hub_peering_name
    to_resource_group_name: hub_rg.name
    to_vnet_name: hub_vnet.name
    use_remote_gateway: deploy_gateway
  }
  dependsOn: deploy_gateway ? [virtual_network_gateway] : [production_vnet]
}
// hub to staging
module peering_hub_to_stg 'modules/peering.bicep' = {
  name: hub_to_stg_peering_name
  scope: resourceGroup(hub_rg.name)
  params: {
    allow_gateway_transit: true
    from_vnet_name: hub_vnet.name
    peering_name: hub_to_stg_peering_name
    to_resource_group_name: staging_rg.name
    to_vnet_name: staging_vnet.name
    use_remote_gateway: false
  }
  dependsOn: [
    hub_vnet
    staging_vnet
  ]
}
module peering_stg_to_hub 'modules/peering.bicep' = {
  name: stg_to_hub_peering_name
  scope: resourceGroup(staging_rg.name)
  params: {
    allow_gateway_transit: false
    from_vnet_name: staging_vnet.name
    peering_name: stg_to_hub_peering_name
    to_resource_group_name: hub_rg.name
    to_vnet_name: hub_vnet.name
    use_remote_gateway: deploy_gateway
  }
  dependsOn: deploy_gateway ? [virtual_network_gateway] : [staging_vnet]
}
// hub to developmnet
module peering_hub_to_dev 'modules/peering.bicep' = {
  name: hub_to_dev_peering_name
  scope: resourceGroup(hub_rg.name)
  params: {
    allow_gateway_transit: true
    from_vnet_name: hub_vnet.name
    peering_name: hub_to_dev_peering_name
    to_resource_group_name: development_rg.name
    to_vnet_name: development_vnet.name
    use_remote_gateway: false
  }
  dependsOn: [
    hub_vnet
    development_vnet
  ]
}
module peering_dev_to_hub 'modules/peering.bicep' = {
  name: dev_to_hub_peering_name
  scope: resourceGroup(development_rg.name)
  params: {
    allow_gateway_transit: false
    from_vnet_name: development_vnet.name
    peering_name: dev_to_hub_peering_name
    to_resource_group_name: hub_rg.name
    to_vnet_name: hub_vnet.name
    use_remote_gateway: deploy_gateway
  }
  dependsOn: deploy_gateway ? [virtual_network_gateway] : [development_vnet]
}

// Policy Assignments
// Require a tag on resources

resource pid_0dd0877a_bdc4_4f9d_8dc1_8a111778d92d_partnercenter 'Microsoft.Resources/deployments@2020-06-01' = {
  name: 'pid-0dd0877a-bdc4-4f9d-8dc1-8a111778d92d-partnercenter'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}
