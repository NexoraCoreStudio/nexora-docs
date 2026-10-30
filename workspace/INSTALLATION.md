# Fichiers racine du workspace

`build.ps1` et `README.md` sont les copies de référence des fichiers modifiés à la racine de NexoraCoreStudio. Ils sont versionnés dans nexora-docs pour ne pas créer de dépôt Git supplémentaire à la racine.

Après récupération de ce dépôt, copier ces deux fichiers dans le dossier parent commun de `nexora`, `nexora-fido`, `nexora-crypt`, `nexora-usb`, `nexora-installer` et `Nexora.Admin`. Le script doit être exécuté depuis cette racine, où se trouve déjà `Nexora.Dev.sln` ; il ne doit pas être lancé depuis ce sous-dossier documentaire.

```powershell
.\build.ps1 -Tests
```

Les rapports mentionnés par le README sont conservés dans `nexora-docs/audits` ; les exemplaires à la racine du workspace d'origine restent des copies locales. Les journaux, résultats TRX, binaires et fichiers temporaires de l'audit ne font pas partie de ces sources versionnées.
