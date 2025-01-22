% Test toutes les fonctionnalités demandées
test_all :- 
    write('=== Test 1: Affichage d\'un tableau vide ==='), nl,
    test_affichage_tableau_vide, nl,
    write('=== Test 2: Affichage d\'un tableau initialisé aléatoirement ==='), nl,
    test_affichage_tableau_aleatoire, nl,
    write('=== Test 3: Modification d\'une case dans un tableau ==='), nl,
    test_modification_case, nl,
    write('=== Test 4: Lecture d\'une case dans un tableau ==='), nl,
    test_lecture_case, nl,
    write('=== Test 5: Ajouter un jeton dans une colonne vide ==='), nl,
    test_ajout_jeton_colonne_vide, nl,
    write('=== Test 6: Ajouter plusieurs jetons dans la même colonne ==='), nl,
    test_ajout_plusieurs_jetons, nl,
    write('=== Test 7: Tenter d\'ajouter un jeton dans une colonne pleine ==='), nl,
    test_colonne_pleine, nl,
    write('=== Test 8: Joueur humain effectuant un coup ==='), nl,
    test_make_move_human, nl,
    write('=== Test 9: Joueur ordinateur effectuant un coup ==='), nl,
    test_make_move_computer, nl,
    write('=== Test 10: Colonnes jouables sur un plateau vide ==='), nl,
    test_moves_plateau_vide, nl,
    write('=== Test 11: Colonnes jouables après quelques mouvements ==='), nl,
    test_moves_colonnes_partiellement_remplies, nl,
    write('=== Test 12: Victoire horizontale ==='), nl,
    test_win_horizontal, nl,
    write('=== Test 13: Victoire verticale ==='), nl,
    test_win_vertical, nl,
    write('=== Test 14: Victoire diagonale ascendante ==='), nl,
    test_win_diagonal_asc, nl,
    write('=== Test 15: Victoire diagonale descendante ==='), nl,
    test_win_diagonal_desc, nl,
    write('=== Test 16: Fin de partie - Victoire ==='), nl,
    test_game_over_victory, nl,
    write('=== Test 17: Fin de partie - Match nul ==='), nl,
    test_game_over_draw, nl,
    write('=== Test 18: Fin de partie - Jeu en cours ==='), nl,
    test_game_over_continue, nl.

% Test combiné pour les victoires
test_victory :- 
    write('=== Test de Victoires ==='), nl,
    write('Test 1 : Victoire horizontale'), nl,
    test_win_horizontal, nl,
    write('Test 2 : Victoire verticale'), nl,
    test_win_vertical, nl,
    write('Test 3 : Victoire diagonale ascendante'), nl,
    test_win_diagonal_asc, nl,
    write('Test 4 : Victoire diagonale descendante'), nl,
    test_win_diagonal_desc, nl.

% Test combiné pour game_over
test_game_over_all :-
    write('=== Tests de Fin de Partie ==='), nl,
    write('Test 1 : Fin par Victoire'), nl,
    test_game_over_victory, nl,
    write('Test 2 : Fin par Match Nul'), nl,
    test_game_over_draw, nl,
    write('Test 3 : Jeu en Cours'), nl,
    test_game_over_continue, nl.


% Test 1: Affichage d un tableau vide
test_affichage_tableau_vide :-
    initialize, board(B),
    write('Affichage du tableau vide :'), nl,
    output_board(B).

% Test 2: Affichage d un tableau initialisé aléatoirement
test_affichage_tableau_aleatoire :-
    % Générer un tableau aléatoire
    random_tableau(6, 7, ['o', 'x', 'e'], RandomBoard),
    write('Affichage du tableau initialisé aléatoirement :'), nl,
    output_board(RandomBoard).

% Générer un tableau aléatoire
random_tableau(Rows, Cols, Values, Board) :-
    findall(Row, (
        between(1, Rows, _),
        findall(Value, (
            between(1, Cols, _),
            random_member(Value, Values)
        ), Row)
    ), Board).

% Test 3: Modification d une square dans un tableau
test_modification_case :-
    initialize, board(B),
    write('Tableau avant modification :'), nl,
    output_board(B),
    update_square(B, 2, 3, 'x', NB),
    write('Tableau après modification de la case (2,3) avec \'x\' :'), nl,
    output_board(NB).

% Test 4: Lecture d une square dans un tableau
test_lecture_case :-
    initialize, board(B),
    square(B, 1, 2, V),
    format('Valeur de la case (1,2) dans le tableau : ~w~n', [V]).

% Test 5: Ajouter un Jeton dans une Colonne Vide
test_ajout_jeton_colonne_vide :-
    initialize, board(B),
    write('Tableau avant ajout de \'x\' dans la colonne 4 :'), nl,
    output_board(B),
    move(B, 4, 'x', NB),
    write('Tableau après ajout de \'x\' dans la colonne 4 :'), nl,
    output_board(NB).

% Test 6: Ajouter Plusieurs Jetons dans la Même Colonne
test_ajout_plusieurs_jetons :-
    initialize, board(B),
    write('Tableau avant ajout de jetons :'), nl,
    output_board(B),
    move(B, 4, 'x', NB1),
    move(NB1, 4, 'o', NB2),
    move(NB2, 4, 'x', NB3),
    write('Tableau après ajout de 3 jetons dans la colonne 4 :'), nl,
    output_board(NB3).

% Test 7: Tenter d’Ajouter un Jeton dans une Colonne Pleine
test_colonne_pleine :-
    initialize, board(B),
    move(B, 4, 'x', NB1),
    move(NB1, 4, 'o', NB2),
    move(NB2, 4, 'x', NB3),
    move(NB3, 4, 'o', NB4),
    move(NB4, 4, 'x', NB5),
    move(NB5, 4, 'o', NB6),
    write('Tableau après remplissage de la colonne 4 :'), nl,
    output_board(NB6),
    write('Tenter d\'ajouter un jeton supplémentaire dans la colonne 4 :'), nl,
    (   move(NB6, 4, 'x', _)
    ->  write('Erreur : le test a échoué, un jeton a été ajouté dans une colonne pleine.'), nl
    ;   write('Test réussi : impossible d\'ajouter un jeton dans une colonne pleine.'), nl).

% Test 8: Joueur Humain Effectuant un Coup
test_make_move_human :-
    initialize, board(B),
    asserta(player(1, human)),  % Le joueur 1 est un humain
    write('Test : Tour d\'un joueur humain (choisissez une colonne entre 1 et 7).'), nl,
    make_move(1, B, NB),  % Appelle la fonction make_move
    write('Résultat du plateau après le coup :'), nl,
    output_board(NB).

% Test 9: Joueur Ordinateur Effectuant un Coup
test_make_move_computer :-
    initialize, board(B),
    asserta(player(2, computer)),  % Le joueur 2 est un ordinateur
    write('Test : Tour de l\'ordinateur.'), nl,
    make_move(2, B, NB),  % Appelle la fonction make_move
    write('Résultat du plateau après le coup :'), nl,
    output_board(NB).

% Test 10: Colonnes Jouables sur un Plateau Vide
test_moves_plateau_vide :-
    initialize, board(B),
    moves(B, ValidMoves),
    write('Colonnes jouables sur un plateau vide : '), write(ValidMoves), nl.

% Test 11: Colonnes Jouables Après Quelques Mouvements
test_moves_colonnes_partiellement_remplies :-
    % Matrice spéciale prédéfinie
    Board = [
        [o, e, e, x, e, e, e],
        [o, e, e, o, e, e, e],
        [x, e, x, x, e, e, e],
        [x, e, x, o, e, e, e],
        [o, o, x, o, e, e, e],
        [x, o, o, x, o, x, e]
    ],
    write('Matrice spéciale prédéfinie :'), nl,
    output_board(Board),  % Affiche la matrice initiale
    moves(Board, ValidMoves),  % Détermine les colonnes jouables
    write('Colonnes jouables après quelques mouvements : '), write(ValidMoves), nl.

% Test 12 : victoire horizontale
test_win_horizontal :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [x, x, x, x, e, e, e]
    ],
    output_board(Board),
    (   win(Board, 'x')
    ->  write('Test Horizontal : Réussi'), nl
    ;   write('Test Horizontal : Échoué'), nl).

% Test 13 : victoire verticale
test_win_vertical :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [x, e, e, e, e, e, e],
        [x, e, e, e, e, e, e],
        [x, e, e, e, e, e, e],
        [x, e, e, e, e, e, e]
    ],
    output_board(Board),
    (   win(Board, 'x')
    ->  write('Test Vertical : Réussi'), nl
    ;   write('Test Vertical : Échoué'), nl).

% Test 14 : victoire diagonale ascendante
test_win_diagonal_asc :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, x, e, e, e],
        [e, e, x, e, e, e, e],
        [e, x, e, e, e, e, e],
        [x, e, e, e, e, e, e]
    ],
    output_board(Board),
    (   win(Board, 'x')
    ->  write('Test Diagonale Ascendante : Réussi'), nl
    ;   write('Test Diagonale Ascendante : Échoué'), nl).

% Test 15 : victoire diagonale descendante
test_win_diagonal_desc :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, x, e, e, e, e, e],
        [e, e, x, e, e, e, e],
        [e, e, e, x, e, e, e],
        [e, e, e, e, x, e, e]
    ],
    output_board(Board),
    (   win(Board, 'x')
    ->  write('Test Diagonale Descendante : Réussi'), nl
    ;   write('Test Diagonale Descendante : Échoué'), nl).


% Test 16 : pour game_over avec une victoire
test_game_over_victory :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [e, e, e, e, e, e, e],
        [x, x, x, x, e, e, e]
    ],
    output_board(Board),
    (   game_over(Board, Winner)
    ->  format('Test Victory: Winner is ~w~n', [Winner])
    ;   write('Test Victory: Failed'), nl).

% Test 17 : pour game_over avec un match nul
test_game_over_draw :-
    Board = [
        [x, o, x, o, x, o, x],
        [o, x, o, x, o, x, o],
        [x, o, x, o, x, o, x],
        [o, x, o, x, o, x, o],
        [x, o, x, o, x, o, x],
        [o, x, o, x, o, x, o]
    ],
    output_board(Board),
    (   game_over(Board, Winner)
    ->  format('Test Draw: Result is ~w~n', [Winner])
    ;   write('Test Draw: Failed'), nl).

% Test 18 : pour game_over sans fin de partie
test_game_over_continue :-
    Board = [
        [e, e, e, e, e, e, e],
        [e, x, e, e, e, e, e],
        [e, o, e, e, e, e, e],
        [o, x, e, e, e, e, e],
        [x, o, e, o, e, e, e],
        [o, x, x, x, o, e, x]
    ],
    output_board(Board),
    (   game_over(Board, _)
    ->  write('Test Continue: Failed'), nl
    ;   write('Test Continue: Passed'), nl).
