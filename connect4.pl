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
|   |   |   |   |   |   |   | 6
|   |   |   |   |   |   |   | 5 
|   |   |   |   |   |   |   | 4
|   |   |   |   |   |   |   | 3
|   |   |   | X |   |   |   | 2
|   |   |   | O |   |   |   | 1

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
                    [E,E,E,E,E,E,E],
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

set_players(N) :-
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

human_playing(M) :-
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
    Index is (R - 1) * 7 + C,
    nth1(Index, B, V)
    . 

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
% applies a move on the given board
% (put mark M in square S on board B and return the resulting board B2)
%


%.......................................
% game_over
%.......................................

%.......................................
% make_move
%.......................................
% requests next move from human/computer, 
% then applies that move to the given board
%

%.......................................
% moves
%.......................................
% retrieves a list of available moves (empty squares) on a board.
%


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

output_winner(B) :-
    write('No winner.')
    .

output_board(B) :-
    nl,
    write('  1   2   3   4   5   6   7'), nl,
    write('-----------------------------'), nl,
    output_rows(B, 6),
    write('-----------------------------'), nl.

output_rows([], _).
output_rows([Row | Rest], RowNum) :-
    write('|'),
    output_row(Row),
    format(' ~d~n', [RowNum]), % Ajoute le numéro de la ligne
    NewRowNum is RowNum - 1,
    output_rows(Rest, NewRowNum).

output_row([]) :-
    write('').
output_row([E | Rest]) :-
    output_cell(E),
    output_row(Rest).

output_cell(E) :-
    blank_mark(E), !,
    write('   |').
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

output_square2(S, M) :- 
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

output_value(D,S,U) :- 
    true
    .
