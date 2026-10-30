# NexoraCoreStudio — Workspace multi-dépôts

Ce workspace regroupe les dépôts et projets suivants :

```text
NexoraCoreStudio/
├── nexora/               # Avalonia GUI + Nexora Manager
├── nexora-installer/     # Installateur Avalonia + publish.ps1
├── nexora-fido/          # CTAP2 + gestion des secrets + tests
├── nexora-usb/           # CTAPHID, USB/IP + tests
├── nexora-crypt/         # Coffre chiffré et tests Windows
├── Nexora.Admin/         # Application Admin active
├── nexora-dev/           # Extension de diagnostic DEV
├── nexora-docs/          # Documentation
└── .github/              # Profil public de l'organisation
```

Fichiers à la racine : `Nexora.Dev.sln` (développement coordonné), `build.ps1` (Windows), `README.md` et `.gitignore`. **Ne pas pousser ces fichiers racine comme un septième dépôt sans choix explicite**.

Sur GitHub, crée cinq dépôts de code/documentation ainsi que le dépôt spécial `.github`, puis pousse chaque contenu dans le dépôt du même nom. Les dossiers `nexora-fido` et `nexora-usb` doivent être placés **au même niveau** que `nexora` pour que les `ProjectReference` fonctionnent.

Depuis Windows 11, dans ce dossier :

```powershell
.\build.ps1 -Tests
.\build.ps1 -Run
.\build.ps1 -MakeInstaller
```

`build.ps1 -Tests` compile également Admin dans `artifacts/admin-build`, sans remplacer son exécutable actif. Les tests xUnit produisent des rapports TRX dans `TestResults`. Les suites fonctionnelles exécutables sont lancées avec `dotnet run`.

Pour tester uniquement le coffre : `dotnet run --project nexora-crypt/Nexora.Crypt.Tests -c Release`. Pour FIDO : `dotnet test nexora-fido/Nexora.Fido.sln -c Release`. Pour le code USB, cloner en plus `nexora-fido`.

La version de l'application est définie dans `nexora/Nexora.Gui/Nexora.Gui.csproj` (actuellement 1.6.0). Admin possède sa propre version. Aucun pilote USB/IP n'est inclus. Consulter `AUDIT_2026-10-30.md` pour l'état initial et `CORRECTIONS_2026-10-30.md` pour les correctifs et leurs validations. Les tests matériels et les parcours d'installation en VM restent nécessaires avant distribution.

**Important** : aucune clé privée ou certificat utilisateur n'est embarqué. N'utilise pas le code source comme sauvegarde des identifiants FIDO2. Avant de créer les dépôts publics, vérifier les licences et origines des composants Open Source incorporés, et réaliser une revue de sécurité (source dérivé de `keinPlan/virtual-fido`, licence non identifiée automatiquement).
