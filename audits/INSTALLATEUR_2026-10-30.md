# Installateur Nexora : thème, contrôles et tests

Ce rapport conserve les résultats du prototype 1.5.5 avant son intégration à Nexora 1.6.0. Voir aussi les [notes de version 1.6.0](../releases/1.6.0.md).

## Résultat livré

Thème clair avec navigation bleu nuit, cartes de contrôle, actions bleues, textes français, version dynamique et contenu défilant. Le parcours distingue vérifications, configuration, copie et résultat. Les erreurs de lancement final restent visibles dans une boîte de dialogue. Un compte rendu peut être enregistré après installation. La fermeture de la fenêtre est empêchée pendant une opération de copie ou de désinstallation.

Un Setup autonome de validation a été généré dans `audit-results/installer-export/Nexora-Setup.exe` à la racine du workspace d'origine. Il n'a pas été publié. La version reste 1.5.5. Le SHA-256 de cet export est `096dd79d373c3309c5ea96b0c6d7fb8a3f9a0896a9ed846a9e41888c296b649e` ; son manifeste est dans le même dossier.

## Contrôles ajoutés ou renforcés

- Windows et architecture x64 ; paquet autonome contenant l'exécutable, l'assembly, la configuration runtime et coreclr.
- Analyse de l'archive et calcul SHA-256 de tous ses fichiers avant la copie, puis nouvelle vérification des fichiers copiés.
- Limites sur le manifeste, le nombre de fichiers, les tailles individuelles et le volume total décompressé.
- Rejet des doublons, traversées de chemins, noms Windows réservés, données de coffre, sauvegardes, clés et certificats dans le paquet.
- Rejet des dossiers système, partages réseau, racines de disque, jonctions et liens redirigés sur les chemins concernés.
- Validation de l'état d'une installation existante. Refus d'écraser un dossier inconnu ou un fichier non géré qui entre en collision avec le paquet.
- Détection d'une instance Nexora active à l'emplacement à mettre à jour et refus du déplacement implicite d'une installation déjà enregistrée.
- Détection des fichiers verrouillés ou en lecture seule. Test d'écriture temporaire supprimé à la fermeture, sans créer les fichiers de l'application.
- Calcul de l'espace nécessaire par volume, incluant extraction, copie, sauvegarde des fichiers remplacés et cache du Setup, avec une réserve de 64 Mio par volume.
- Contrôle séparé du périphérique VHCI présent et du client USB/IP au chemin effectivement utilisé par Nexora (`Program Files/USBip/usbip.exe`). La présence du client n'est pas une preuve de connexion matérielle réussie.
- USB/IP bloque la poursuite par défaut. Une option explicite permet d'installer seulement l'application, avec rappel de la limitation. L'état du pilote/client est relu avant l'installation si cette option n'est pas activée.
- Le code PnPUtil 3010 est traité comme un redémarrage requis, et non comme un échec générique.
- Mutex commun à l'installation et la désinstallation. Retour arrière des fichiers, de l'état, des raccourcis remplacés et de l'entrée de désinstallation en cas d'exception. Si la restauration échoue, les sauvegardes sont conservées et leur emplacement est indiqué.
- Version affichée et enregistrée issue du Setup exporté, suppression des libellés fixes 1.2 et de la modification du registre qui se produisait à la simple fermeture de l'assistant.

Les vérifications du moteur sont également exécutées dans le mode de mise à jour ; elles ne dépendent pas seulement de l'état des boutons de l'interface. Le mode de mise à jour n'installe pas de pilote.

## Tests exécutés

`build.ps1 -Tests` compile la solution et Admin puis lance toutes les suites, dont la nouvelle suite installateur. Cette dernière est aussi exécutée dans la CI Windows de nexora-installer.

| Vérification | Résultat |
|---|---|
| Tests xUnit existants | 85/85, aucun ignoré |
| Scénarios installateur | 17/17 |
| Tests coffre v1/v2 et intégration coffre/FIDO | Réussis |
| Compilation de l'installateur | Réussie, 0 avertissement sur la compilation finale dédiée |
| Export autonome Windows x64 | Réussi |
| `Nexora-Setup.exe --verify-package` | Code 0, 235 fichiers, 102 884 030 octets décompressés vérifiés |
| Interface réelle du Setup exporté | Bienvenue, diagnostic et configuration examinés |

Les 17 scénarios isolés couvrent : paquet valide, corruption, runtime manquant, manifeste absent, chemins interdits, doublons, destination interdite, dossier inconnu, état corrompu, installation neuve, mise à jour préservant le coffre et les fichiers non gérés, verrou de fichier, collision non gérée, rollback après écriture de l'état, rollback d'une installation neuve, espace insuffisant et jonction de répertoire réellement créée pour le test.

Les paquets des tests sont synthétiques et ne sont jamais exécutés. Le chemin de test du moteur désactive uniquement l'intégration Windows ; il conserve les vérifications du paquet, de la destination et de l'espace disque. Aucun raccourci, pilote ou enregistrement de désinstallation réel n'a été créé par ces tests.

Le diagnostic réel a d'abord détecté une application Nexora active et a désactivé Continuer. Lors du contrôle du Setup exporté, l'application n'était plus active : les vérifications du dossier existant, de l'espace et d'USB/IP ont réussi. L'agent n'a pas arrêté l'application utilisateur et n'a pas lancé l'installation sur ce dossier.

Journaux locaux : `installer-workspace-validation.log`, `installer-tests-build.log`, `installer-publish.log` et `installer-package-check.log`. Captures : `audit-results/installer-welcome.jpg` et `audit-results/installer-diagnostic.jpg`.

## Améliorations conseillées ensuite

1. **Signer le Setup et les exécutables avec Authenticode**, horodater la signature et la vérifier dans la chaîne de publication. Les SHA-256 du paquet ne remplacent pas une identité d'éditeur signée.
2. **Valider le parcours USB/IP complet en VM** : fournisseur et version du client supportés, installation du paquet officiel complet, UAC refusée, redémarrage demandé et première connexion FIDO2. Le contrôle PnP et la présence de l'exécutable ne prouvent pas que attach/detach fonctionnent.
3. **Tester l'intégration Windows et les interruptions fortes** : raccourcis, désinstallation, mise à jour depuis une version précédente, verrou antivirus, manque d'espace réel et coupure de processus/alimentation. Le rollback testé simule une exception contrôlée ; il ne valide pas la résistance à une coupure du système.
4. **Tester les petites résolutions et DPI 125/150/200 %**, navigation clavier et lecteur d'écran. La vue principale est défilante et les boutons de navigation restent hors du défilement, mais ces configurations ne sont pas toutes validées.
5. Envisager un journal d'installation persistant et un parcours de réparation dédié, ainsi qu'une gestion explicite des anciens fichiers qui ne sont plus présents dans une nouvelle version. Les fichiers non remplacés ne sont pas supprimés aveuglément.

La vérification réelle de l'installateur sur cette machine ne constitue pas une qualification pour tous les postes Windows. Aucun changement d'installation système, de pilote, de coffre utilisateur ou de paramètre de sécurité n'a été effectué par l'agent.
