### README : Implémentation de Puissance 4 en Prolog

#### Aperçu
Ce projet propose une implémentation en Prolog du célèbre jeu **Puissance 4**. Il comprend un moteur de jeu polyvalent qui supporte :
- Partie **Joueur contre Joueur**.
- Partie **Joueur contre Ordinateur**.
- Simulation **Ordinateur contre Ordinateur** utilisant trois stratégies d'intelligence artificielle :
  - **Coups aléatoires** (Random).
  - **Algorithme Minimax**.
  - **Élagage Alpha-Bêta**.

Un ensemble de tests complet est inclus pour valider les fonctionnalités, couvrant les règles du jeu, la gestion du plateau et les comportements de l'IA. Une fonctionnalité de **statistiques** permet également de comparer la performance des différentes IA.

---

### Fonctionnalités
1. **Gameplay interactif** :
   - Partie entièrement jouable via une interface en ligne de commande.
   - Les joueurs peuvent choisir de jouer en tant que `X` ou `O`.

2. **Intelligence Artificielle** :
   - Les joueurs IA utilisent des algorithmes stratégiques :
     - **Random** pour jouer un coup aléatoire.
     - **Minimax** pour un gameplay optimal en simulant plusieurs coups à l'avance.
     - **Élagage Alpha-Bêta** pour une optimisation des performances.
   - L'IA donne la priorité aux coups gagnants et bloque les menaces adverses.

3. **Mécanismes de jeu** :
   - Valide les coups en tenant compte des limites du plateau et de la capacité des colonnes.
   - Détecte la fin de la partie via :
     - Alignements horizontaux, verticaux ou diagonaux.
     - Match nul si le plateau est plein.

4. **Statistiques** :
   - Comparaison des IA en exécutant plusieurs parties :
     - Nombre de victoires et défaites.
     - Nombre de matchs nuls.
     - Temps moyen de calcul par IA.
     - Nombre moyen de coups joués par partie.

5. **Tests** :
   - Une suite de tests robuste valide :
     - Les manipulations et visualisations du plateau.
     - Les mécanismes de jeu, tels que les conditions de victoire et de match nul.
     - Les comportements de l'IA (par exemple, prioriser les coups gagnants ou bloquer les menaces).

---

### Fichiers
#### 1. `connect4.pl`
Ce fichier contient la logique principale du jeu :
- Initialisation, représentation du plateau et validation des coups.
- Algorithmes d'IA (**Random, Minimax, Alpha-Bêta**).
- Fonction d'évaluation des états du plateau pour les stratégies IA.
- Vérifications de fin de partie (victoire ou match nul).

#### 2. `test.pl`
Ce fichier contient la suite de tests :
- Valide les fonctionnalités individuelles comme les mises à jour du plateau, la légalité des coups et la détection des victoires.
- Inclut des tests spécifiques pour vérifier les comportements stratégiques de l'IA.

#### 3. `stats.pl`
Ce fichier permet d'exécuter des **simulations** pour comparer les performances des différentes IA :
- Il exécute un nombre défini de parties (**par défaut 20**) entre deux IA choisies.
- Il génère des **statistiques détaillées**, notamment :
  - Nombre de victoires de chaque IA.
  - Nombre de matchs nuls.
  - Temps moyen par IA pour choisir un coup.
  - Nombre moyen de coups par partie.

---

### Utilisation
#### Lancer le jeu
1. Charger le jeu dans Prolog :
   ```prolog
   ?- [connect4].
   ```

2. Démarrer le jeu :
   ```prolog
   ?- run.
   ```

3. Suivre les instructions à l'écran pour :
   - Indiquer le nombre de joueurs humains (**0, 1 ou 2**).
   - Si un ou deux joueurs IA sont présents, choisir leur stratégie (**Random, Minimax, Alpha-Bêta**).
   - Jouer en entrant les numéros des colonnes.

#### Lancer les tests
1. Charger le fichier de tests :
   ```prolog
   ?- [test].
   ```

2. Lancer tous les tests :
   ```prolog
   ?- test_all.
   ```

3. Tester des scénarios spécifiques :
   - Pour vérifier si l'IA joue un coup gagnant :
     ```prolog
     ?- test_ia_win_next_move.
     ```
   - Pour vérifier si l'IA bloque l'adversaire :
     ```prolog
     ?- test_ia_block_opponent.
     ```

---

### Comparaison des IA
#### Lancer les statistiques
1. Charger le module de statistiques :
   ```prolog
   ?- [stats].
   ```

2. Lancer la comparaison des IA :
   ```prolog
   ?- run_stats.
   ```

3. Spécifier les deux IA à comparer parmi :
   - **random** : IA jouant de manière aléatoire.
   - **minimax** : IA utilisant l'algorithme Minimax.
   - **alphabeta** : IA utilisant l'élagage Alpha-Bêta.

4. Exemple de résultats affichés :
   ```
   Comparaison des IA sur 20 parties :
   IA1          IA2          Victoires IA1   Victoires IA2   Nuls   Temps Moyen (ms)   Coups Moyens
   -----------------------------------------------------------------------------------------------
   Aléatoire    Minimax      2               18             0      50ms               40
   Minimax      Alpha-Bêta   9               11             0      120ms              38
   Alpha-Bêta   Aléatoire   20               0              0      30ms               36
   ```

---

### Comportement de l'IA
#### Stratégies Minimax et Alpha-Bêta
- La fonction d'évaluation évalue les états du plateau en tenant compte de :
  - **Victoire immédiate** → +1000 points.
  - **Défaite imminente** → -1000 points.
  - **Alignements partiels** (ex. trois jetons alignés avec possibilité d’extension).
- Minimax explore tous les coups possibles **sans optimisation**.
- Alpha-Bêta optimise Minimax en **réduisant les calculs inutiles** via l'élagage.

#### Priorités de l'IA
1. Jouer un coup gagnant **si possible**.
2. Bloquer un coup gagnant **de l'adversaire**.
3. Optimiser les alignements pour les prochains tours.

---

### Améliorations possibles
1. **Interface** :
   - Développer une **interface graphique** pour améliorer l'expérience utilisateur.

2. **IA** :
   - Ajouter un **paramètre de profondeur** pour l'algorithme Minimax.
   - Expérimenter **des modèles d'apprentissage machine** pour des stratégies adaptatives.

3. **Tests** :
   - Ajouter des scénarios plus complexes pour évaluer l'IA, comme des **situations de double menace**.

4. **Performance** :
   - Optimiser le calcul de l'utilité pour **réduire le temps de réflexion de l'IA**.

5. **Personnalisations** :
   - Permettre aux utilisateurs de modifier :
     - La **taille du plateau** (ex. 8x8).
     - Le **nombre de jetons alignés requis** pour gagner.

---

