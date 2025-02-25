```powershell
dotnet new webapi --use-controllers --no-openapi --framework net8.0 --use-program-main --output backendservices

dotnet new gitignore

dotnet new sln
dotnet sln add .\backendservices\

dotnet new classlib -f net8.0 --name workhelpers
dotnet sln add .\workhelpers\

dotnet add .\backendservices\backendservices.csproj reference .\workhelpers\workhelpers.csproj

dotnet add .\anotherbackendservice\anotherbackendservice.csproj reference .\workhelpers\workhelpers.csproj        
Reference `..\workhelpers\workhelpers.csproj` added to the project.

dotnet user-secrets init  

dotnet user-secrets set "ConnectionStrings:Database" "Host=localhost;Port=5432;Database=sample-database;Username=sa_ss;"

# Inside workhelpers
dotnet ef migrations add InitialCreate --startup-project ..\anotherbackendservice\anotherbackendservice.csproj

dotnet ef database update --startup-project ..\anotherbackendservice\anotherbackendservice.csproj

```

https://stenbrinke.nl/blog/configuration-and-secret-management-in-dotnet/


Now after initializing docker in the project, we look at launchsettings.json file and describe its changes.

AFter looking at launch settings let's examine the csproj file. Only one detail, of target being llinux is added there
currently. Now we will look at the docker file. 

It has the APP_UID non root user. Here is the reasoning why:
[Andrew Lock's article](https://andrewlock.net/exploring-the-dotnet-8-preview-updates-to-docker-images-in-dotnet-8/)