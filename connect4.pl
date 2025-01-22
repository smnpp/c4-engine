%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Approche Logique de l Intelligence Artificielle
%%% H4302
%%% Final Project 
%%% Source : https://github.com/smnpp/c4-engine/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A Prolog Implementation of Connect 4
%%% using the minimax strategy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*

The following conventions are used in this program...

Single letter variables represent:

L - a list
N - a number, position, index, or counter
V - a value (usually a string)
A - an accumulator
H - the head of a list
T - the tail of a list

For this implementation, these single letter variables represent:

P - a player number (1 or 2)
B - the board position
R - row number
C - column number
M - a mark ('x' or 'o')

convention outputboard 
  1   2   3   4   5   6   7
|   |   |   |   |   |   |   | 1
|   |   |   |   |   |   |   | 2 
|   |   |   |   |   |   |   | 3
|   |   |   |   |   |   |   | 4
|   |   |   | X |   |   |   | 5
|   |   |   | O |   |   |   | 6

Variables with a numeric suffix represent a variable based on another variable.
(e.g. B2 is a new board position based on B)

For predicates, the last variable is usually the "return" value.
(e.g. opponent_mark(P,M), returns the opposing mark in variable M)

Predicates with a numeric suffix represent a "nested" predicate.

e.g. myrule2(...) is meant to be called from myrule(...) 
     and myrule3(...) is meant to be called from myrule2(...)


There are only two assertions that are used in this implementation

asserta( board(B) ) - the current board 
asserta( player(P, Type) ) - indicates which players are human/computer.

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

next_player(1, 2).      %%% determines the next player after the given player
next_player(2, 1).

inverse_mark('x', 'o'). %%% determines the opposite of the given mark
inverse_mark('o', 'x').

player_mark(1, 'x').    %%% the mark for the given player
player_mark(2, 'o').    

opponent_mark(1, 'o').  %%% shorthand for the inverse mark of the given player
opponent_mark(2, 'x').

blank_mark('e').        %%% the mark used in an empty square

maximizing('x').        %%% the player playing x is always trying to maximize the utility of the board position
minimizing('o').        %%% the player playing o is always trying to minimize the utility of the board position

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     MAIN PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


run :-
    hello,          %%% Display welcome message, initialize game

    play(1),        %%% Play the game starting with player 1

    goodbye         %%% Display end of game message
    .

run :-
    goodbye
    .


hello :-
    initialize,
%    cls,
    nl,
    nl,
    nl,
    write('Welcome to Connect 4.'),
    read_players,
    output_players
    .

initialize :-
    blank_mark(E),
    asserta(board(
                [
                    [E,E,E,E,E,E,E], 
                    [E,E,E,E,E,E,E],
                    [E,E,E,E,E,E,E], 
                    [E,E,E,E,E,E,E], 
                    [E,E,E,E,E,E,E], 
                    [E,E,E,E,E,E,E]
                ]
            )).

goodbye :-
    board(B),
    nl,
    nl,
    write('Game over: '),
    output_winner(B),
    retract(board(_)),
    retract(player(_,_)),
    read_play_again(V), !,
    (V == 'Y' ; V == 'y'), 
    !,
    run
    .

read_play_again(V) :-
    nl,
    nl,
    write('Play again (Y/N)? '),
    read(V),
    (V == 'y' ; V == 'Y' ; V == 'n' ; V == 'N'), !
    .

read_play_again(V) :-
    nl,
    nl,
    write('Please enter Y or N.'),
    read_play_again(V)
    .


read_players :-
    nl,
    nl,
    write('Number of human players? '),
    read(N),
    set_players(N)
    .

set_players(0) :- 
    asserta( player(1, computer) ),
    asserta( player(2, computer) ), !
    .

set_players(1) :-
    nl,
    write('Is human playing X or O (X moves first)? '),
    read(M),
    human_playing(M), !
    .

set_players(2) :- 
    asserta( player(1, human) ),
    asserta( player(2, human) ), !
    .

set_players(_) :-
    nl,
    write('Please enter 0, 1, or 2.'),
    read_players
    .


human_playing(M) :- 
    (M == 'x' ; M == 'X'),
    asserta( player(1, human) ),
    asserta( player(2, computer) ), !
    .

human_playing(M) :- 
    (M == 'o' ; M == 'O'),
    asserta( player(1, computer) ),
    asserta( player(2, human) ), !
    .

human_playing(_) :-
    nl,
    write('Please enter X or O.'),
    set_players(1)
    .

play(P) :-
    board(B), !,
    output_board(B), !,
    not(game_over(P, B)), !,
    make_move(P, B), !,
    next_player(P, P2), !,
    play(P2), !
    .


%.......................................
% square
%.......................................
% The mark in a square(N) corresponds to an item in a list, as follows:
square(B, R, C, V) :-
    nth1(R, B, L),     % Obtenir la ligne numéro Row
    nth1(C, L, V).      % Obtenir la colonne numéro Col dans cette ligne


% Remplace un élément dans une liste
replace(L, I, V, NL) :-
    nth1(I, L, _, TempL),             
    nth1(I, NL, V, TempL).

% Met à jour une square spécifique dans la grille
update_square(B, R, C, V, NB) :-
    nth1(R, B, L, RestB),           % Extraire la ligne à modifier
    replace(L, C, V, NL),           % Modifier la colonne dans la ligne
    nth1(R, NB, NL, RestB).         % Reconstruire le plateau

%.......................................
% win
%.......................................
% Players win by having their mark in one of the following square configurations:
%
/*
win(B, P) :- 
    between(1, 6, R),
    between(1, 4, C),
    square(B, R, C, P),
    square(B, R, C + 1, P),
    square(B, R, C + 2, P),
    square(B, R, C + 3, P)
    .
win(B, P) :-
    between(1, 3, R), 
    between(1, 7, C),
    square(B, R, C, P),
    square(B, R + 1, C, P),
    square(B, R + 2, C, P),
    square(B, R + 3, C, P)
    .
win(B, P) :-
    between(1, 3, R),
    between(1, 4, C),
    square(B, R, C, P),
    square(B, R + 1, C + 1, P),
    square(B, R + 2, C + 2, P),
    square(B, R + 3, C + 3, P)
	.
win(B, P) :-
    between(1, 3, R),
    between(4, 7, C),
    square(B, R, C, P),
    square(B, R + 1, C - 1, P),
    square(B, R + 2, C - 2, P),
    square(B, R + 3, C - 3, P)
	.
*/
%.......................................
% move
%.......................................

% move applique un coup en ajoutant un jeton dans une colonne donnée
move(B, C, M, NB) :-
    add_token(B, C, M, NB).


% Ajoute un jeton dans la première case vide de la colonne C
add_token(B, C, M, NB) :-
    add_token_row(B, C, M, NB, 6).


% Parcourt les lignes de bas en haut pour trouver la première case vide
add_token_row(B, C, M, NB, R) :-
    R > 0,
    square(B, R, C, e), % Vérifie si la case est vide
    update_square(B, R, C, M, NB). % Met à jour la case avec le jeton

% Si la case nest pas vide, on passe à la ligne supérieure
add_token_row(B, C, M, NB, R) :-
    R > 0,
    NR is R - 1,
    add_token_row(B, C, M, NB, NR).

% Si aucune case vide nest trouvée (colonne pleine)
add_token_row(_, _, _, _, 0) :-
    write('Erreur : La colonne est pleine.'), nl, fail.



%.......................................
% game_over
%.......................................

%.......................................
% make_move
%.......................................
% requests next move from human/computer, 
% then applies that move to the given board
%
% make_move(P, B, NB)
% Gère le tour du joueur P et applique le coup au plateau B, renvoyant le nouveau plateau NB.

make_move(P, B, NB) :-
    player(P, Type),  % Détermine si le joueur est humain ou ordinateur
    (Type = human -> request_move(P, B, NB) ; computer_move(P, B, NB)).

% Demande au joueur humain de choisir une colonne et applique le coup
request_move(P, B, NB) :-
    nl, write('Player '), write(P), write(', choose a column (1-7): '), nl,
    read(C),  % Lecture de l entrée utilisateur
    valid_column(C),  % Vérifie si la colonne est valide
    player_mark(P, M),  % Récupère le marqueur du joueur ('x' ou 'o')
    (   move(B, C, M, NB)  % Tente de jouer dans la colonne choisie
    ->  true
    ;   write('Invalid move. Column is full or out of range.'), nl,
        request_move(P, B, NB)  % Redemande si le coup est invalide
    ).

% Détermine le coup de l ordinateur et applique le coup
computer_move(P, B, NB) :-
    nl, write('Computer is thinking...'), nl,
    player_mark(P, M),
    find_best_move(B, M, C),  % Trouve la meilleure colonne (implémenter `find_best_move`)
    (   move(B, C, M, NB)
    ->  format('Computer plays in column ~w.~n', [C])
    ;   write('Computer made an invalid move.') % Cas improbable
    ).

% Vérifie si une colonne est valide (entre 1 et 7)
valid_column(C) :-
    integer(C), between(1, 7, C).

% (À implémenter) Détermine la meilleure colonne pour un ordinateur
find_best_move(B, _, C) :-
    moves(B, ValidMoves),  % Liste des colonnes jouables
    random_member(C, ValidMoves).  % Choix aléatoire pour l instant


%.......................................
% moves
%.......................................
% retrieves a list of available moves (empty squares) on a board.
moves(B, ValidMoves) :-
    findall(C, column_playable(B, C), ValidMoves).

% Vérifie si une colonne C est jouable (contient au moins une case vide)
column_playable(B, C) :-
    between(1, 7, C),          % C est une colonne valide (entre 1 et 7)
    square(B, 1, C, e).        % La première ligne de la colonne est vide



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output_players :- 
    nl,
    player(1, V1),
    write('Player 1 is '),   %%% either human or computer
    write(V1),

    nl,
    player(2, V2),
    write('Player 2 is '),   %%% either human or computer
    write(V2), 
    !
    .


output_winner(B) :-
    win(B,x),
    write('X wins.'),
    !
    .

output_winner(B) :-
    win(B,o),
    write('O wins.'),
    !
    .

output_winner(_) :-
    write('No winner.')
    .

% Affiche le plateau avec les numéros de lignes croissants (1 à 6)
output_board(B) :-
    nl,
    write('  1   2   3   4   5   6   7'), nl,
    write('-----------------------------'), nl,
    output_rows(B, 1),  % Commence la numérotation des lignes à 1
    write('-----------------------------'), nl.

% Affiche chaque ligne du plateau
output_rows([], _). 
output_rows([Row | Rest], RowNum) :-
    write('|'),
    output_row(Row, 7),   
    format(' ~d~n', [RowNum]), 
    NewRowNum is RowNum + 1,  
    output_rows(Rest, NewRowNum). 

% Affiche une ligne donnée
output_row([], 0).  % Cas de base : aucune colonne restante dans la ligne

output_row([E | Rest], ColNum) :-
    output_cell(E), 
    NewColNum is ColNum - 1,  
    output_row(Rest, NewColNum). 

% Affiche une cellule
output_cell(E) :-
    format(' ~w |', [E]).


output_board :-
    board(B),
    output_board(B), !
    .

output_square(B,S) :-
    square(B,S,M),
    write(' '), 
    output_square2(S,M),  
    write(' '), !
    .

output_square2(S, E) :- 
    blank_mark(E),
    write(S), !              %%% if square is empty, output the square number
    .

output_square2(_, M) :- 
    write(M), !              %%% if square is marked, output the mark 
    .

output_value(D,S,U) :-
    D == 1,
    nl,
    write('Square '),
    write(S),
    write(', utility: '),
    write(U), !
    .

output_value(_,_,_) :- 
    true
    .
