// get me a list of resource, resource group and the resource tags and the resourcegroup tags

$query = "
resources
| join kind=inner (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions/resourcegroups'
    //| where tags['billing'] == ''
    | project subscriptionId, resourceGroup,rgtags=tags)
on subscriptionId, resourceGroup
//|limit 10
| project-away subscriptionId1, resourceGroup1
| project subscriptionId,resourceGroup, name,rgbilling=rgtags['billing'], resourcebilling=tags['billing'], type
"

$date = Get-Date -Format yyyyMMdd-HHmmss
$filename = './output/rgsandtags-{0}.xlsx' -f $date


$pageSize = 1000
$iteration = 0
$searchParams = @{
    Query = $query
    First = $pageSize
}

$results = do {
    $iteration += 1
    Write-Verbose "Iteration #$iteration" -Verbose
    $pageResults = Search-AzGraph @searchParams
    $searchParams.Skip += $pageResults.Count
    $pageResults
} while ($pageResults.Count -eq $pageSize)
$results.Count
$results | Export-Excel -Path $filename -WorksheetName 'Rgs and Tags' -AutoSize -AutoFilter
