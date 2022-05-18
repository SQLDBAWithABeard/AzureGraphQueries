// get me a list of resource, resource group and the resource tags and the resourcegroup tags
resources
| join kind=inner (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions/resourcegroups'
    | project subscriptionId, resourceGroup,rgtags=tags)
on subscriptionId, resourceGroup
|limit 10
| project-away subscriptionId1, resourceGroup1
| project name, type, subscriptionId,resourceGroup,resourcebilling=tags['billing'],rgbilling=rgtags['billing']
