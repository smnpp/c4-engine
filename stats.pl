%====================================================
%                 STATISTIQUES DES IA
%====================================================

% Nombre de parties à jouer pour les statistiques
num_games(20).

%====================================================
%              Lancer les statistiques
%====================================================
run_stats :-
    num_games(N),
    write('Comparaison des IA sur '), write(N), write(' parties :'), nl, nl,
    compare_algorithms(random, minimax, N, Results1),
    compare_algorithms(minimax, alphabeta, N, Results2),
    compare_algorithms(alphabeta, random, N, Results3),
    display_all_results([Results1, Results2, Results3]).

%====================================================
%         Comparer Deux IA sur Plusieurs Parties
%====================================================
compare_algorithms(IA1, IA2, NumGames, results(IA1, IA2, Wins1, Wins2, Draws, AvgTime1, AvgTime2, AvgMoves1, AvgMoves2)) :-
    compare_games(IA1, IA2, NumGames, 0, 0, 0, 0, 0, 0, 0, Wins1, Wins2, Draws, TotalTime1, TotalTime2, TotalMoves1, TotalMoves2),
    AvgTime1 is TotalTime1 / NumGames,
    AvgTime2 is TotalTime2 / NumGames,
    AvgMoves1 is TotalMoves1 / NumGames,
    AvgMoves2 is TotalMoves2 / NumGames.

%====================================================
%   Simulation des parties et enregistrement des scores
%====================================================
compare_games(_, _, 0, Wins1, Wins2, Draws, TotalTime1, TotalTime2, TotalMoves1, TotalMoves2, Wins1, Wins2, Draws, TotalTime1, TotalTime2, TotalMoves1, TotalMoves2).

compare_games(IA1, IA2, N, Wins1, Wins2, Draws, TotalTime1, TotalTime2, TotalMoves1, TotalMoves2, FinalWins1, FinalWins2, FinalDraws, FinalTime1, FinalTime2, FinalMoves1, FinalMoves2) :-
    statistics(runtime, [Start1|_]),
    play_stat_game(IA1, IA2, Winner, Moves),
    statistics(runtime, [End1|_]),
    Time is End1 - Start1,
    update_scores(Winner, IA1, IA2, Wins1, Wins2, Draws, NewWins1, NewWins2, NewDraws),
    NewTotalTime1 is TotalTime1 + (Winner == IA1 -> Time ; 0),
    NewTotalTime2 is TotalTime2 + (Winner == IA2 -> Time ; 0),
    NewTotalMoves1 is TotalMoves1 + (Winner == IA1 -> Moves ; 0),
    NewTotalMoves2 is TotalMoves2 + (Winner == IA2 -> Moves ; 0),
    N1 is N - 1,
    compare_games(IA1, IA2, N1, NewWins1, NewWins2, NewDraws, NewTotalTime1, NewTotalTime2, NewTotalMoves1, NewTotalMoves2, FinalWins1, FinalWins2, FinalDraws, FinalTime1, FinalTime2, FinalMoves1, FinalMoves2).

%====================================================
%       Joue une Partie entre Deux IA
%====================================================
play_stat_game(IA1, IA2, Winner, Moves) :-
    retractall(board(_)),
    initialize,
    board(B),
    play_stat_turn(1, B, IA1, IA2, Winner, 0, Moves).

play_stat_turn(_, B, _, _, Winner, Moves, Moves) :- win(B, Winner), !.
play_stat_turn(_, B, _, _, draw, Moves, Moves) :- board_full(B), !.

play_stat_turn(Player, B, IA1, IA2, Winner, MoveCount, Moves) :-
    (Player == 1 -> IA = IA1 ; IA = IA2),
    make_move2(IA, Player, B, NB),
    next_player(Player, NextPlayer),
    MoveCount1 is MoveCount + 1,
    play_stat_turn(NextPlayer, NB, IA1, IA2, Winner, MoveCount1, Moves).

%====================================================
%   Mise à jour des scores en fonction du gagnant
%====================================================
update_scores(Winner, IA1, IA2, Wins1, Wins2, Draws, NewWins1, NewWins2, NewDraws) :-
    (   Winner == IA1 -> NewWins1 is Wins1 + 1, NewWins2 = Wins2, NewDraws = Draws
    ;   Winner == IA2 -> NewWins2 is Wins2 + 1, NewWins1 = Wins1, NewDraws = Draws
    ;   NewDraws is Draws + 1, NewWins1 = Wins1, NewWins2 = Wins2
    ).

%====================================================
%         AFFICHAGE DES RÉSULTATS
%====================================================
display_all_results(Results) :-
    nl, write('===== Comparaison des IA ====='), nl,
    write('IA1\tIA2\tVictoires IA1\tVictoires IA2\tNulles'), nl,
    display_match_results(Results),
    nl, write('===== Performances Individuelles ====='), nl,
    write('IA\tTemps Moyen (ms)\tCoups Moyens'), nl,
    display_individual_performance(Results).

% Affiche les résultats de comparaison entre IA
display_match_results([]).
display_match_results([results(IA1, IA2, Wins1, Wins2, Draws, _, _, _, _)|Rest]) :-
    format('~w\t~w\t~d\t~d\t~d~n', [IA1, IA2, Wins1, Wins2, Draws]),
    display_match_results(Rest).

% Affiche les performances individuelles des IA
display_individual_performance([]).
display_individual_performance([results(IA, _, _, _, _, AvgTime1, _, AvgMoves1, _)|Rest]) :-
    format('~w\t~2f ms\t~2f~n', [IA, AvgTime1, AvgMoves1]),
    display_individual_performance(Rest).
display_individual_performance([results(_, IA, _, _, _, _, AvgTime2, _, _, AvgMoves2)|Rest]) :-
    format('~w\t~2f ms\t~2f~n', [IA, AvgTime2, AvgMoves2]),
    display_individual_performance(Rest).

