FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

COPY *.sln .
COPY src/eShopWCFService/ ./src/eShopWCFService/
RUN nuget restore
RUN msbuild src/eShopWCFService/eShopWCFService.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true

FROM mcr.microsoft.com/dotnet/framework/wcf:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/src/eShopWCFService/obj/Docker/publish/. ./