param privateEndpointName string
param location string = resourceGroup().location
param storageAccountId string
param subnetId string
param tagValues object

@allowed([
    'blob'
    'table'
    'queue'
    'share'
])
param groupIds array = [
    'blob'
]

var privateDnsZoneName = '${privateEndpointName}.blob.core.windows.net'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2020-11-01' = {
    name: privateEndpointName
    tags: tagValues
    location: location
    properties: {
        privateLinkServiceConnections: [
            {
                name: privateEndpointName
                properties: {
                    privateLinkServiceId: storageAccountId
                    groupIds: groupIds
                    privateLinkServiceConnectionState: {
                        status: 'Approved'
                        description: 'Auto-Approved'
                        actionsRequired: 'None'
                    }
                }
            }
        ]
        subnet: {
            id: subnetId
        }
    }
}

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = {
    name: privateDnsZoneName
    tags: tagValues
    location: 'global'
}
