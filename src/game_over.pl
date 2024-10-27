:- use_module(library(lists)).
:- use_module(library(system)).


% Check the game over conditions and determine the winner between two human-players.
game_over(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner):-
    % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', EndRow =:= 1, CheckWin =:= 1 ; Player == 'X/X', EndRow =:= WinningRow,CheckWin =:= 1) -> 
            format('Player controlling the ~w pieces wins by reaching the opponents first row!', [Player]), nl,
            Winner = Player
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player == 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> NextOpponent = 'X/X' ; NextOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, NextOpponent, NextSoloOpponent,WinningRow)
    ).

% Game over conditions for Player vs. Easy Bot.
game_over_P_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,PlayerControl,Winner):-
    % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', EndRow =:= 1, CheckWin =:= 1 ; Player == 'X/X', EndRow =:= WinningRow,CheckWin =:= 1) -> 
            format('Player controlling the ~w pieces wins by reaching the opponents first row!', [Player]), nl,
            Winner = Player
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player == 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> NextOpponent = 'X/X' ; NextOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_against_Easy_bot(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, NextOpponent, NextSoloOpponent,PlayerControl,WinningRow)
    ).

% Game over conditions for Player vs. Hard Bot.
game_over_P_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,PlayerControl,Winner):-
    % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', CheckWin =:= 1, EndRow =:= 1 ; Player == 'X/X', CheckWin =:= 1, EndRow =:= WinningRow) ->
            format('Player controlling the ~w pieces wins by reaching the opponent´s first row!', [Player]), nl
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player = 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> OtherOpponent = 'X/X' ; OtherOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_against_Hard_bot(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, OtherOpponent, NextSoloOpponent, PlayerControl,WinningRow)
    ).

% Game over conditions for Easy Bot vs. Easy Bot.
game_over_EB_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner):-
    % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', CheckWin =:= 1, EndRow =:= 1 ; Player == 'X/X', CheckWin =:= 1, EndRow =:= WinningRow) ->
            format('Player controlling the ~w pieces wins by reaching the opponent´s first row!', [Player]), nl
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player = 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> OtherOpponent = 'X/X' ; OtherOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_Easy_vs_Easy(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, OtherOpponent,NextSoloOpponent,WinningRow)).             


% Game over conditions for Easy Bot vs. Hard Bot.
game_over_EB_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner):-
     % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', CheckWin =:= 1, EndRow =:= 1 ; Player == 'X/X', CheckWin =:= 1, EndRow =:= WinningRow) ->
            format('Player controlling the ~w pieces wins by reaching the opponent´s first row!', [Player]), nl
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player = 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> OtherOpponent = 'X/X' ; OtherOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_Easy_vs_Hard(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, OtherOpponent,NextSoloOpponent,WinningRow)).    

% Game over conditions for Hard Bot vs. Easy Bot.
game_over_HB_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner):-
     % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', CheckWin =:= 1, EndRow =:= 1 ; Player == 'X/X', CheckWin =:= 1, EndRow =:= WinningRow) ->
            format('Player controlling the ~w pieces wins by reaching the opponent´s first row!', [Player]), nl
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player = 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> OtherOpponent = 'X/X' ; OtherOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_Hard_vs_Easy(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, OtherOpponent,NextSoloOpponent,WinningRow)).  

% Game over conditions for Hard Bot vs. Hard Bot.
game_over_HB_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner):-
     % Check if the current player has won by reaching the opponents first row.
    ((Player == 'O/O', CheckWin =:= 1, EndRow =:= 1 ; Player == 'X/X', CheckWin =:= 1, EndRow =:= WinningRow) ->
            format('Player controlling the ~w pieces wins by reaching the opponent´s first row!', [Player]), nl
        ;
            % Check for win/draw conditions and update Player based on game rules.

            % Switch to the other player for the next turn.
            (Player = 'X/X' -> NextPlayer = 'O/O' ; NextPlayer = 'X/X'),
            (SoloPeace = ' X ' -> NextSoloPeace = ' O ' ; NextSoloPeace = ' X '),
            (Opponent = 'O/O' -> OtherOpponent = 'X/X' ; OtherOpponent = 'O/O'),
            (SoloOpponent = ' O ' -> NextSoloOpponent = ' X '; NextSoloOpponent = ' O '),

            % Continue the game with the other player.
            play_game_Hard_vs_Hard(NewBoard, NumRow, NumCol, NextPlayer, NextSoloPeace, OtherOpponent,NextSoloOpponent,WinningRow)).              