# Fichiers racine du workspace

`build.ps1`, `Nexora.Dev.sln`, `README.md` et `version.txt` sont les copies de référence des fichiers à la racine de NexoraCoreStudio. Ils sont versionnés dans nexora-docs pour ne pas créer de dépôt Git supplémentaire à la racine.

Après récupération de ce dépôt, copier ces quatre fichiers dans le dossier parent commun de `nexora`, `nexora-fido`, `nexora-crypt`, `nexora-usb`, `nexora-installer` et `Nexora.Admin`. Le script doit être exécuté depuis cette racine ; il ne doit pas être lancé depuis ce sous-dossier documentaire. Les tests fonctionnels de l'installateur sont inclus dans la solution et dans `build.ps1 -Tests`.

```powershell
.\build.ps1 -Tests
```

Les rapports mentionnés par le README sont conservés dans `nexora-docs/audits` ; les exemplaires à la racine du workspace d'origine restent des copies locales. Les journaux, résultats TRX, binaires et fichiers temporaires de l'audit ne font pas partie de ces sources versionnées.
