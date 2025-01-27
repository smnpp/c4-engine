### README : Implémentation de Puissance 4 en Prolog

#### Aperçu
Ce projet propose une implémentation en Prolog du célèbre jeu **Puissance 4**. Il comprend un moteur de jeu polyvalent qui supporte :
- Partie **Joueur contre Joueur**.
- Partie **Joueur contre Ordinateur**.
- Simulation **Ordinateur contre Ordinateur** utilisant trois stratégies d'intelligence artificielle :
  - **Coups aléatoires**.
  - **Algorithme Minimax**.
  - **Élagage Alpha-Bêta**.

Un ensemble de tests complet est inclus pour valider les fonctionnalités, couvrant les règles du jeu, la gestion du plateau et les comportements de l'IA.

---

### Fonctionnalités
1. **Gameplay interactif** :
   - Partie entièrement jouable via une interface en ligne de commande.
   - Les joueurs peuvent choisir de jouer en tant que `X` ou `O`.

2. **Intelligence Artificielle** :
   - Les joueurs IA utilisent des algorithmes stratégiques :
     - Minimax pour un gameplay optimal.
     - Élagage Alpha-Bêta pour des performances améliorées.
   - L'IA donne la priorité aux coups gagnants et bloque les menaces adverses.

3. **Mécanismes de jeu** :
   - Valide les coups en tenant compte des limites du plateau et de la capacité des colonnes.
   - Détecte la fin de la partie via :
     - Alignements horizontaux, verticaux ou diagonaux.
     - Match nul si le plateau est plein.

4. **Tests** :
   - Une suite de tests robuste valide :
     - Les manipulations et visualisations du plateau.
     - Les mécanismes de jeu, tels que les conditions de victoire et de match nul.
     - Les comportements de l'IA (par exemple, prioriser les coups gagnants ou bloquer les menaces).

---

### Fichiers
#### 1. `connect4.pl`
Ce fichier contient la logique principale du jeu :
- Initialisation, représentation du plateau et validation des coups.
- Algorithmes d'IA (Minimax, Élagage Alpha-Bêta).
- Fonctions utilitaires pour évaluer les états du plateau.
- Vérifications de fin de partie (victoire ou match nul).

#### 2. `test.pl`
Ce fichier contient la suite de tests :
- Valide les fonctionnalités individuelles comme les mises à jour du plateau, la légalité des coups et la détection des victoires.
- Inclut des tests spécifiques pour vérifier les comportements stratégiques de l'IA.

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
   - Indiquer le nombre de joueurs humains (0, 1 ou 2).
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

### Comportement de l'IA
#### Stratégies Minimax et Alpha-Bêta
- La fonction d'utilité évalue les états du plateau en tenant compte de :
  - Victoires immédiates (+1000).
  - Défaites imminentes (-1000).
  - Scores intermédiaires basés sur des alignements (par exemple, trois jetons alignés).
- L'élagage Alpha-Bêta optimise Minimax en réduisant les calculs inutiles.

#### Priorités de l'IA
1. Jouer un coup gagnant si possible.
2. Bloquer un coup gagnant de l'adversaire.
3. Optimiser les alignements pour les prochains tours.

---

### Améliorations possibles
1. **Interface** :
   - Développer une interface graphique pour améliorer l'expérience utilisateur.

2. **IA** :
   - Ajouter une personnalisation de la profondeur pour l'algorithme Minimax.
   - Expérimenter des modèles d'apprentissage machine pour des stratégies adaptatives.

3. **Tests** :
   - Ajouter des scénarios plus complexes pour évaluer le comportement de l'IA, comme des situations de double menace.

4. **Performance** :
   - Optimiser le calcul de l'utilité pour des profondeurs de recherche importantes.

5. **Personnalisations** :
   - Permettre aux utilisateurs de modifier la taille du plateau (par exemple, 8x8) ou les conditions de victoire (par exemple, 5 jetons alignés).

---

Ce projet démontre la puissance de Prolog dans la création d'un jeu interactif et stratégique. La conception modulaire et les tests approfondis en font une excellente base pour des développements et des améliorations futurs.