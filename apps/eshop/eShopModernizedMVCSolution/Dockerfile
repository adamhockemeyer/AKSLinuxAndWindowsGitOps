FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

COPY *.sln .
COPY src/eShopModernizedMVC/ ./src/eShopModernizedMVC/
RUN nuget restore
RUN msbuild src/eShopModernizedMVC/eShopModernizedMVC.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/src/eShopModernizedMVC/obj/Docker/publish/. ./