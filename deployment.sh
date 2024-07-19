#! /bin/bash

# install required packages
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az bicep install
sudo apt install git -y

# get the deployment script
git clone https://github.com/bocsi/deploy.git

az login --identity

currentdir=$(pwd)
cd "$currentdir/deploy"

# Store the output in an array
mapfile -t deployments < <(az deployment sub list --query "[?properties.outputs != null].{Location: properties.outputs.location.value, Timestamp: properties.timestamp}" --output tsv)

# Find the newest timestamp and corresponding location
location=$(printf "%s\n" "${deployments[@]}" | awk '
BEGIN { max_time = "1970-01-01T00:00:00Z" }
{
  timestamp = $2
  if (timestamp > max_time) {
    max_time = timestamp
    locationproperty = $1
  }
}
END { print locationproperty }
')

# find the deployment location
mapfile -t deployments_location < <(az deployment sub list --query "[?properties.outputs != null].{Location: location, Timestamp: properties.timestamp}" --output tsv)

# Find the newest timestamp and corresponding location
deployment_location=$(printf "%s\n" "${deployments_location[@]}" | awk '
BEGIN { max_time = "1970-01-01T00:00:00Z" }
{
  timestamp = $2
  if (timestamp > max_time) {
    max_time = timestamp
    deployment_location_property = $1
  }
}
END { print deployment_location_property }
')

# Modify the bicep file with the location of the last deployment
sed -i "s/param location string = .*/param location string = '$location'/g" mainTemplate.bicep

az bicep build --file mainTemplate.bicep
az deployment sub create --location $deployment_location --template-file mainTemplate.json
