### Authenticate to Azure 
$Conn = Get-AutomationConnection -Name 'AzureRunAsConnection'
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

### Selecting subscription to use
$subscriptionID = Get-AutomationVariable –Name ‘subscription-id’ # Automation variable for Subscription ID
Select-AzureRmSubscription –SubscriptionId $subscriptionID

### Set cluster variables
$resourceGroup = “ “ #Name of existing resource group
$storageAccount = “ “ #Name of exisitng storage account that will be used by HDInsight cluster
$containerName = “ “ #Name of existing container for storing objects
$storageAccountKey = (Get-AzureRmStorageAccountKey –Name $storageAccount –ResourceGroupName $resourceGroup)[0].value 
$clusterName = “la-hdinsight-cluster“ #Enter desired cluster name for HDInsight cluster

### Setting cluster credentials
$clusterCreds = Get-AutomationPSCredential –Name ‘cluster-admin’ 	   #Automation credential for Cluster Admin
$sshCreds = Get-AutomationPSCredential –Name ‘ssh-user’ #Automation credential for user to SSH into cluster
$clusterType = “Hadoop” #Use any supported cluster type (Hadoop, HBase, Storm, etc.)
$clusterOS = “Linux”
$clusterWorkerNodes = 2
$clusterNodeSize = “Standard_D1_v2”
$location = Get-AzureRmStorageAccount –StorageAccountName $storageAccount –ResourceGroupName $resourceGroup | %{$_.Location}

### Provision HDInsight cluster
New-AzureRmHDInsightCluster –ClusterName $clusterName –ResourceGroupName $resourceGroup –Location $location –DefaultStorageAccountName “$storageAccount.blob.core.windows.net” –DefaultStorageAccountKey $storageAccountKey -DefaultStorageContainer $containerName –ClusterType $clusterType –OSType $clusterOS –Version “3.5” –HttpCredential $clusterCreds –SshCredential $sshCreds –ClusterSizeInNodes $clusterWorkerNodes –HeadNodeSize $clusterNodeSize –WorkerNodeSize $clusterNodeSize