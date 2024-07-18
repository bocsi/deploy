targetScope =  'subscription'
param location string
param name string
param tags object

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location:location
  tags: tags
 }

output location string = resourceGroup.location
