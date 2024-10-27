:- use_module(library(lists)).
:- use_module(library(system)).
:- consult(rules_about_move).
:- consult(board_display).
:- consult(game_over).

play_game(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent,WinningRow) :-
    % Check if the current player has valid moves left
    has_value_in_sublists(Player, Board) ->
        (get_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent),
        DeltaRow_ is abs(DeltaRow),
        DeltaCol_ is abs(DeltaCol),
        ((DeltaRow_=2,DeltaCol_=2; DeltaRow_=2, DeltaCol_=0; DeltaRow_=0, DeltaCol_=2) ->
            move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace),
            CheckWin is 1
         ;
            capture_piece(Board, Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, NewBoard),
            CheckWin is 2
        ),

        display_game(NewBoard),

        % Check if the player has reached the first row.
        game_over(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,WinningRow,NewBoard,Winner))
    ;
        % The player has no valid moves left, so the opponent wins
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl.