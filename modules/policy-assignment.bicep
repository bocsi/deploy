targetScope = 'subscription'
param description string
param location string
param policyAssignmentName string
param policyDefinitionID string
param policyDisplayName string
param nonComplianceMessage string
param tagName string

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignmentName
  location: location
  properties: {
    policyDefinitionId: policyDefinitionID
    description: description
    displayName: policyDisplayName
    parameters: {
      tagName: {
        value: tagName
      }
    }
    nonComplianceMessages: [
      {
        message: nonComplianceMessage
      }
    ]
  }
}

