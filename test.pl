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
    test_colonne_pleine, nl.

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

