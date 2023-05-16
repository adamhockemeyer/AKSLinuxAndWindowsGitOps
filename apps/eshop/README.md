https://github.com/dotnet-architecture/eShopModernizing/


az acr build --image eshop/mvc:latest --registry acr54uvnxvfxeua6 --platform windows --file Dockerfile .
az acr build --image eshop/webforms:latest --registry acr54uvnxvfxeua6 --platform windows --file Dockerfile .
az acr build --image eshop/wcfservice:latest --registry acr54uvnxvfxeua6 --platform windows --file Dockerfile .
