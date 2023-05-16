FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

COPY *.sln .
COPY src/eShopModernizedWebForms/ ./src/eShopModernizedWebForms/
RUN nuget restore
RUN msbuild src/eShopModernizedWebForms/eShopModernizedWebForms.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/src/eShopModernizedWebForms/obj/Docker/publish/. ./