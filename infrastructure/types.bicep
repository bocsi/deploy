@export()
type subnets = {
  name: string
  addressPrefix: string
}
@export()
type vnet_settings = {
  addressPrefixes: string []
  subnets: subnets[]
}
