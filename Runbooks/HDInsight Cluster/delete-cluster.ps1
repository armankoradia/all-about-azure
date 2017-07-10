## Authenticate to Azure
$azureCreds = Get-AutomationPSCredential –Name ‘azure-admin’
Login-AzureRmAccount –Credential $azureCreds

### Selecting subscription
$subscriptionID = Get-AutomationVariable –Name ‘subscription-id’ #Automation variable for Subscription ID
Select-AzureRmSubscription –SubscriptionId $subscriptionID

### Deleting the HDInsight cluster
Remove-AzureRmHDInsightCluster –ClusterName “ “ #Give cluster name
