# Architecture multi-dépôts

- `nexora-fido`: CTAP2, authentificateur, clés privées et stockages, tests et service mTLS.
- `nexora-usb`: CTAPHID, périphérique HID, USB/IP et `VhciController`; dépend de `nexora-fido`.
- `nexora`: application Avalonia `Nexora.Gui`, `Nexora.Manager`, tests GUI; dépend des deux composants.
- `nexora-installer`: installeur Avalonia avec charge utile intégrée, dépend de la publication de `nexora`.
- `nexora-docs`: documentation.
- `.github`: profil de l'organisation GitHub.

Les dossiers repos sont des clones **frères**, sans copie des bibliothèques. Chaque dépôt a sa propre solution, ses propres tests, son workflow CI et son `.gitignore`.
Les références `ProjectReference` vers les clones frères sont **volontaires** pour le développement local et pour la CI. Il faut cloner les dépendances et les disposer au même niveau avant compilation.

```text
NexoraCoreStudio/
  nexora/
  nexora-fido/
  nexora-usb/
  nexora-installer/
  nexora-docs/
  .github/
  Nexora.Dev.sln
```

Matrice des dépendances : `FIDO -> SecretManager`; `USB -> FIDO`; `Nexora GUI -> USB + SecretManager`; `Installer -> application publiée`.

Cette distribution n'inclut pas de pilotes Windows. Elle conserve le système `usbip-win2` installé et signé par l'utilisateur ; ne pas exécuter d'installateur de pilote inconnu.

**Usage de sécurité** : authentificateur logiciel; pas de stockage matériel des secrets. PIN de GUI et CTAP2 sont indépendants. Ne jamais publier `config.json`, `*.key`, `*.cred`, `pin.bin`, des sauvegardes ou des certificats privés.
