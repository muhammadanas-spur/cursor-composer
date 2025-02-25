# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM base AS local_dev_with_https
USER root
ADD certs/custom-sample-ca.crt /usr/local/share/ca-certificates/custom-sample-ca.crt
#RUN chmod 644 /Certs/anotherbackendservice.pfx
RUN chmod 644 /usr/local/share/ca-certificates/custom-sample-ca.crt && update-ca-certificates
#USER $APP_UID

# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["anotherbackendservice/anotherbackendservice.csproj", "anotherbackendservice/"]
COPY ["workhelpers/workhelpers.csproj", "workhelpers/"]
RUN dotnet restore "./anotherbackendservice/anotherbackendservice.csproj"
COPY . .
WORKDIR "/src/anotherbackendservice"
RUN dotnet build "./anotherbackendservice.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./anotherbackendservice.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "anotherbackendservice.dll"]