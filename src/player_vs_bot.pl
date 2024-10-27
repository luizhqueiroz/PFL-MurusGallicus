:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(between)).
:- consult(rules_about_move).
:- consult(bots_move).
:- consult(board_display).
:-consult(game_over).

play_game_against_Easy_bot(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent, PlayerControl,FinalRow) :-
    % Check if the current player has valid moves left
    (has_value_in_sublists(Player, Board) ->
        % Geting a valid move for current player.
        ((Player = PlayerControl) ->
            get_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent)
        ;
            generate_random_valid_move(Player, SoloPeace, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent, StartRow, StartCol, EndRow, EndCol)
        ),

        % Check the move type: move or capture
        ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2) ->
            move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace),
            CheckWin is 1
         ;
            % Capture: perform piece capture
            capture_piece(Board, Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, NewBoard),
            CheckWin is 2
        ),
        
        % Display the game board
        ((Player = PlayerControl) ->
            display_game(NewBoard), nl
            ;
            write('Type anything to see the Bots move.'), 
            read(Access),
            display_game(NewBoard), nl
        ),

        % Check if the player has reached the first row.
        game_over_P_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,PlayerControl,Winner)
    ;
        % The player has no valid moves left, so the opponent wins
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).

play_game_against_Hard_bot(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent, PlayerControl,FinalRow) :-
    % Check if the current player has valid moves left
    (has_value_in_sublists(Player, Board) ->
        % Geting a valid move for current player.
        ((Player = PlayerControl) ->
            get_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent),
            
            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2;DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2) ->
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace),
                CheckWin is 1
            ;
                capture_piece(Board, Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, NewBoard),
                CheckWin is 2
            )
        ;
            generate_smart_move(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent, DeltaRow, DeltaCol, Play),

            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2) ->
                [ _, _, StartRow, StartCol, EndRow, EndCol] = Play,
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace),
                CheckWin is 1
            ;
                [ _, _, StartRow, StartCol, EndRow, EndCol] = Play,
                % Capture: perform piece capture
                capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
                CheckWin is 2
            )
        ),

        ((Player = PlayerControl) ->
            display_game(NewBoard), nl
            ;
            write('Type anything to see the Bots move.'), 
            read(Access),
            display_game(NewBoard), nl
        ),

        % Check if the player has reached the first row.
        game_over_P_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,PlayerControl,Winner)
    ;
        % The player has no valid moves left, so the opponent wins
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).