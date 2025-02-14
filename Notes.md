```powershell
dotnet new webapi --use-controllers --no-openapi --framework net8.0 --use-program-main --output backendservices

dotnet new gitignore

dotnet new sln
dotnet sln add .\backendservices\

dotnet new classlib -f net8.0 --name workhelpers
dotnet sln add .\workhelpers\

dotnet add .\backendservices\backendservices.csproj reference .\workhelpers\workhelpers.csproj

```