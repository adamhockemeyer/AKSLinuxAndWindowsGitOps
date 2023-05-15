
Deploy Bicep file
``` bash
az deployment sub create --name aks-deployment --template-file main.bicep --location eastus
```

Connect to AKS cluster
``` bash
az aks get-credentials --resource-group aks-win-rg --name <name>
```

Verify AKS and pull from ACR
``` bash
az aks check-acr --name MyManagedCluster --resource-group MyResourceGroup --acr myacr.azurecr.io
```