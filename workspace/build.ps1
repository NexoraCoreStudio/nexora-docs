[CmdletBinding()]
param([switch]$Tests,[switch]$Run,[switch]$MakeInstaller)
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$sln = Join-Path $root 'Nexora.Dev.sln'
if (!(Get-Command dotnet -ErrorAction SilentlyContinue)) { throw 'SDK .NET 8 requis.' }
& dotnet restore $sln
if ($LASTEXITCODE -ne 0) { throw 'Restore .NET echoue.' }
& dotnet build $sln -c Release --no-restore
if ($LASTEXITCODE -ne 0) { throw 'Build .NET echoue.' }
$adminProject = Join-Path $root 'Nexora.Admin\Nexora.Admin.csproj'
& dotnet build $adminProject -c Release -o (Join-Path $root 'artifacts\admin-build')
if ($LASTEXITCODE -ne 0) { throw 'Build Nexora Admin echoue.' }
if ($Tests) {
    foreach ($test in @(
        'nexora-fido\Nexora.Fido.Tests\Nexora.Fido.Tests.csproj',
        'nexora-usb\Nexora.Usb.Tests\Nexora.Usb.Tests.csproj',
        'nexora\Nexora.Tests\Nexora.Tests.csproj',
        'nexora-crypt\Nexora.Crypt.Tests\Nexora.Crypt.Tests.csproj',
        'nexora-fido\Nexora.SecretManager.VaultSecretStore.Tests\Nexora.SecretManager.VaultSecretStore.Tests.csproj'
    )) {
        if ($test -like '*Nexora.Crypt.Tests*' -or $test -like '*Nexora.SecretManager.VaultSecretStore.Tests*') {
            & dotnet run --project (Join-Path $root $test) -c Release --no-build
        } else {
            & dotnet test (Join-Path $root $test) -c Release --no-build --no-restore --logger trx --results-directory (Join-Path $root 'TestResults') --blame-hang-timeout 60s --blame-hang-dump-type none
        }
        if ($LASTEXITCODE -ne 0) { throw "Tests echoues : $test" }
    }
}
if ($Run) {
    & dotnet run --project (Join-Path $root 'nexora\Nexora.Gui\Nexora.Gui.csproj') -c Release --no-build
    if ($LASTEXITCODE -ne 0) { throw 'Demarrage de Nexora echoue.' }
}
if ($MakeInstaller) {
    & (Join-Path $root 'nexora-installer\publish.ps1') -MakeInstaller
    if ($LASTEXITCODE -ne 0) { throw 'Publication installateur echouee.' }
}
