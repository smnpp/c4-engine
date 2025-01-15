% Test toutes les fonctionnalités demandées
test_all :-
    write('=== Test 1: Affichage d\'un tableau vide ==='), nl,
    test_affichage_tableau_vide, nl,
    write('=== Test 2: Affichage d\'un tableau initialisé aléatoirement ==='), nl,
    test_affichage_tableau_aleatoire, nl,
    write('=== Test 3: Modification d\'une case dans un tableau ==='), nl,
    test_modification_case, nl,
    write('=== Test 4: Lecture d\'une case dans un tableau ==='), nl,
    test_lecture_case, nl.

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
