# Windows Containers on AKS

![Bicep to ARM](https://github.com/adamhockemeyer/AKSLinuxAndWindowsGitOps/actions/workflows/bicep-to-arm.yml/badge.svg)

This repo has examples on running (legacy) .NET Framework MVC, WebForms, WCF apps on Windows containers on AKS (Azure Kubernetes Service)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fadamhockemeyer%2FAKSLinuxAndWindowsGitOps%2Fmain%2Fbicep%2Fazuredeploy.json)

3 Primary Folders:
* **apps**
    * 3 Apps taken from: https://github.com/dotnet-architecture/eShopModernizing/
* **bicep**
    * Infrastructure as Code (AKS, ACR, KeyVault, Flux Extensions)
* **flux-config**
    * Kustomizations and yaml files for GitOps