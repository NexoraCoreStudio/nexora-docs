# Correctifs de l'audit — 30 octobre 2026

Les six défauts concrets de l'audit initial ont été corrigés dans les sources. Les modifications locales préexistantes de l'interface sont conservées. L'application installée, les coffres utilisateur et les dépôts distants n'ont pas été mis à jour.

## Changements

1. **Présence FIDO** : la continuation n'est publiée qu'après approbation et signature réussie. Un refus, une nouvelle commande ou une erreur invalide la continuation. Elle expire après 30 secondes. Les identifiants résidents dont la politique exige une vérification utilisateur ne sont plus accessibles en héritant de la politique plus faible d'un autre identifiant.
2. **Identité TLS** : les erreurs de nom d'hôte et de certificat absent sont rejetées. La chaîne doit se terminer exactement sur l'autorité configurée ; le simple assouplissement pour une autorité intermédiaire ne suffit plus à accepter une autre chaîne. L'usage serveur TLS est vérifié. Le modèle existant sans consultation de révocation en ligne est conservé.
3. **Parsing USB/IP** : les opérations inconnues sont rejetées, les en-têtes et identifiants de bus sont validés. L'import et la première requête périphérique peuvent partager une lecture TCP. Le parsing respecte la quantité de données réellement reçue ; les tailles négatives ou supérieures à 1 Mio sont refusées avant allocation.
4. **Échec d'écriture du coffre** : la révision et le contenu chiffré sont restaurés en cas d'échec de commit. La session restaure son document et son enveloppe depuis le dernier état authentifié enregistré, y compris les autorisations Windows. Une nouvelle tentative peut réussir après libération du fichier.
5. **Certificats** : l'expiration d'un certificat enfant est bornée par celle de son émetteur. Une horloge injectable permet de tester les frontières temporelles et une CA vieillissante. Une initialisation interrompue peut reprendre à partir de la racine existante, sans la remplacer.
6. **Dépendances** : Tmds.DBus.Protocol est fixé explicitement à 0.21.3 dans l'application, Admin et l'installateur. L'audit NuGet avec dépendances transitives ne signale plus de vulnérabilité connue dans ces graphes à la date de vérification.

## Compléments

- `build.ps1 -Tests` compile aussi Nexora Admin dans `artifacts/admin-build`, pour éviter de remplacer un exécutable actif. Les suites xUnit produisent des TRX et sont surveillées pour les blocages.
- L'installateur cible explicitement Windows, ce qui corrige les avertissements de plateforme pour ses accès au registre.
- Le gestionnaire de création de clé ne porte plus de `async` sans `await`.
- Le README indique les projets actuels, la source de version et les commandes correctes pour les suites exécutables.

## Validation

- xUnit : **85 tests réussis sur 85**, aucun ignoré — FIDO 47, USB 24, configuration GUI 14. Soit 22 tests supplémentaires par rapport aux 63 tests initiaux.
- Tests fonctionnels du coffre et intégration coffre/FIDO exécutés séparément. Les régressions de sauvegarde sont exercées sur les formats v1 et v2, avec verrouillage du fichier, suppression refusée, autorisation refusée et nouvelle tentative.
- Compilation Release de la solution, compilation DEV et compilation séparée d'Admin dans un dossier isolé.
- Audit NuGet de la solution et d'Admin, dépendances transitives comprises : aucune vulnérabilité signalée.

Les preuves sont les journaux `correction-*.log`, `correction-packages.json`, `correction-admin-packages.json` et les TRX dans `audit-results` / `TestResults`. Les fichiers `audit-*` antérieurs restent l'état historique avant correction.

## Limites conservées

Les tests avec pilote USB/IP réel, WebAuthn dans un navigateur, mise à jour/installation en VM, récupération sur un autre PC et l'ensemble des parcours graphiques restent à effectuer avant distribution. Les avertissements de chargement XAML pour des fenêtres construites avec des arguments et certains avertissements historiques de nullabilité USB ne sont pas assimilés à des pannes corrigées. Le modèle de menace de `ARCHITECTURE.md` reste valable : l'isolation matérielle, la protection contre les processus du même compte et l'anti-rollback ne sont pas apportées par ces correctifs.

La compilation Admin habituelle a rencontré un verrou d'une instance active ; la compilation vers un dossier isolé a réussi. La politique PowerShell du poste exige une autorisation de processus pour exécuter le script non signé ; aucune politique persistante du système n'a été modifiée.
