# Développement Windows

Pré-requis : Windows 11 x64, SDK .NET 8, pilotes USB/IP compatibles et signés déjà installés.

À partir de la racine `NexoraCoreStudio` :

```powershell
.\build.ps1 -Tests
.\build.ps1 -Run
.\build.ps1 -MakeInstaller
```

Ou directement :

```powershell
dotnet build .\Nexora.Dev.sln -c Release
dotnet run --project .\nexora\Nexora.Gui\Nexora.Gui.csproj -c Release
.\nexora-installer\publish.ps1 -MakeInstaller
```

L'installateur attendu après publication est `nexora/dist/Nexora-Setup.exe`.

Ne pas publier les dossiers de données de l'authentificateur dans un dépôt ou un artefact de build. Les identifiants déjà enregistrés ne sont pas présents dans le ZIP de sources.
