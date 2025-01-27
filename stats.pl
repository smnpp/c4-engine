% Définir le nombre de parties pour les statistiques.
:- dynamic num_games/1.
num_games(10). % Par défaut, 20 parties.

%.......................................
% run_statistics
%.......................................
% Point d entrée pour générer les statistiques.
run_stats :-
    num_games(Num),
    write('Comparaison des IA sur '), write(Num), write(' parties :'), nl,
    compare_algorithms(random, minimax, Num, ResultsRM),
    display_results('Random vs Minimax', ResultsRM),
    compare_algorithms(random, alphabeta, Num, ResultsRA),
    display_results('Random vs AlphaBeta', ResultsRA),
    compare_algorithms(minimax, alphabeta, Num, ResultsMA),
    display_results('Minimax vs AlphaBeta', ResultsMA).

%.......................................
% compare_algorithms
%.......................................
% Joue plusieurs parties entre deux algorithmes d IA.
compare_algorithms(IA1, IA2, NumGames, Results) :-
    compare_algorithms(IA1, IA2, NumGames, 0, 0, 0, Results).

compare_algorithms(_, _, 0, Wins1, Wins2, Draws, results(Wins1, Wins2, Draws)).
compare_algorithms(IA1, IA2, NumGames, Wins1, Wins2, Draws, Results) :-
    NumGames > 0,
    play_game(IA1, IA2, Winner),
    update_scores(Winner, Wins1, Wins2, Draws, NewWins1, NewWins2, NewDraws),
    RemainingGames is NumGames - 1,
    compare_algorithms(IA1, IA2, RemainingGames, NewWins1, NewWins2, NewDraws, Results).

%.......................................
% play_game
%.......................................
% Joue une partie entre deux algorithmes d IA et retourne le gagnant.
play_game(IA1, IA2, Winner) :-
    % Initialise le plateau.
    initialize,
    retractall(player(_, _)),
    asserta(player(1, IA1)),
    asserta(player(2, IA2)),
    play_stat_game(Winner).

%.......................................
% play_stat_game
%.......................................
% Simule une partie pour les statistiques et détermine le gagnant.
play_stat_game(Winner) :-
    initialize,       % Initialise le plateau
    board(B),
    play_stat_turn(1, B, Winner).

% Joue un tour pour un joueur et vérifie si la partie est terminée.
play_stat_turn(Player, B, Winner) :-
    game_over(B, Winner),  % Si la partie est terminée, on récupère le gagnant
    !.
play_stat_turn(Player, B, Winner) :-
    make_move(Player, B),  % Joue un coup pour le joueur actuel
    board(NewBoard),       % Met à jour le plateau
    next_player(Player, NextPlayer),
    play_stat_turn(NextPlayer, NewBoard, Winner). % Passe au prochain joueur

% update_scores
%.......................................
% Met à jour les scores en fonction du gagnant.
update_scores(1, Wins1, Wins2, Draws, NewWins1, Wins2, Draws) :-
    NewWins1 is Wins1 + 1.
update_scores(2, Wins1, Wins2, Draws, Wins1, NewWins2, Draws) :-
    NewWins2 is Wins2 + 1.
update_scores(draw, Wins1, Wins2, Draws, Wins1, Wins2, NewDraws) :-
    NewDraws is Draws + 1.

%.......................................
% display_results
%.......................................
% Affiche les résultats d une comparaison entre deux algorithmes.
display_results(Matchup, results(Wins1, Wins2, Draws)) :-
    write('=== Résultats pour '), write(Matchup), write(' ==='), nl,
    write('IA1 Wins : '), write(Wins1), nl,
    write('IA2 Wins : '), write(Wins2), nl,
    write('Draws    : '), write(Draws), nl, nl.
