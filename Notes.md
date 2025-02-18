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
dotnet ef database update --startup-project ..\anotherbackendservice\anotherbackendservice.csproj
```