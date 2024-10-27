:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(between)).
:- consult(bots_move).
:- consult(board_display).
:- consult(game_over).

% Define a predicate to play a game between two easy-level bots.
play_game_Easy_vs_Easy(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent,FinalRow):-
    % Check if the current bot has any valid moves.
    (has_value_in_sublists(Player, Board) ->
        % Generate a random valid move for the current bot.
        generate_random_valid_move(Player, SoloPeace, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent, StartRow, StartCol, EndRow, EndCol),

        % Check if its a regular move (2 squares) or a capture (1 square)
        ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
            move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
            CheckWin is 1 % Variable to compare if its a move or a capture.
         ;
            % Predicate to make the capture of a opponent piece.
            capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
            CheckWin is 2 % Variable to compare if its a move or a capture.
        ),
        
        % Display the updated game board.
        format('Type anything to see the Bot ~w move.',[Player]), 
        read(Access),
        display_game(NewBoard), nl,

        % Check if the current bot has reached the first opponents row.
        game_over_EB_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,Winner)
    ;
        % If the current bot has no valid moves left, the opponent wins.
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).

% Define a predicate to play a game between easy bot(Roman) and hard bot(Gaul).
play_game_Easy_vs_Hard(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent,FinalRow):-
    % Check if the current bot has any valid moves.
    (has_value_in_sublists(Player, Board) ->
        ((Player = 'X/X')->
            % Generate a random valid move for the Roman bot.
            generate_random_valid_move(Player, SoloPeace, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent, StartRow, StartCol, EndRow, EndCol),
            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
                CheckWin is 1 % Variable to compare if its a move or a capture.
            ;
                % Predicate to make the capture of a opponent piece.
                capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
                CheckWin is 2 % Variable to compare if its a move or a capture.
            )
        ;
            % Generate a stategy valid move for the Gaul bot.
            generate_smart_move(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent,DeltaRow,DeltaCol,Play),

            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
                [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
                CheckWin is 1 % Variable to compare if its a move or a capture.
            ;
                [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
                % Predicate to make the capture of a opponent piece.
                capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
                CheckWin is 2 % Variable to compare if its a move or a capture.
            )
        ),
        
        % Display the updated game board.
        format('Type anything to see the Bot ~w move.',[Player]), 
        read(Access),
        display_game(NewBoard), nl,

        % Check if the current bot has reached the first opponents row.
        game_over_EB_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,Winner)
    ;
        % If the current bot has no valid moves left, the opponent wins.
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).


% Define a predicate to play a game between hard bot(Roman) and easy bot(Gaul).
play_game_Hard_vs_Easy(Board, NumRow, NumCol, Player, SoloPeace, Opponent, SoloOpponent,FinalRow):-
    % Check if the current bot has any valid moves.
    (has_value_in_sublists(Player, Board) ->
        ((Player = 'O/O')->
            % Generate a random valid move for the Gaul bot.
            generate_random_valid_move(Player, SoloPeace, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent, StartRow, StartCol, EndRow, EndCol),
            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
                CheckWin is 1   % Variable to compare if its a move or a capture.
            ;
                % Predicate to make the capture of a opponent piece.
                capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
                CheckWin is 2   % Variable to compare if its a move or a capture.
            )
        ;
            % Generate a stategy valid move for the Roman bot.
            generate_smart_move(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent,DeltaRow,DeltaCol,Play),

            ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
                [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
                move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
                CheckWin is 1   % Variable to compare if its a move or a capture.
            ;
                [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
                % Predicate to make the capture of a opponent piece.
                capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
                CheckWin is 2   % Variable to compare if its a move or a capture.
            )
        ),
        
        % Display the updated game board.
        format('Type anything to see the Bot ~w move.',[Player]), 
        read(Access),
        display_game(NewBoard), nl,

        % Check if the current bot has reached the first opponents row.
        game_over_HB_Vs_EB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,Winner)
    ;
        % If the current bot has no valid moves left, the opponent wins.
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).

% Define a predicate to play a game between two hard-level bots.
play_game_Hard_vs_Hard(Board, NumRow, NumCol, Player, SoloPeace, Opponent,SoloOpponent,FinalRow):-
    % Check if the current bot has any valid moves.
    (has_value_in_sublists(Player, Board) ->
        % Generate a stategy valid move for the current bot.
        generate_smart_move(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent,DeltaRow,DeltaCol,Play),
        ((DeltaRow=2,DeltaRow=2; DeltaRow=2, DeltaCol=0; DeltaRow=0, DeltaCol=2; DeltaRow = -2,DeltaRow = -2; DeltaRow = -2, DeltaCol=0; DeltaRow=0, DeltaCol = -2; DeltaRow = 2, DeltaCol = -2; DeltaRow= -2, DeltaCol = 2)->
            [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
            move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace), % Predicate to make the move.
            CheckWin is 1  % Variable to compare if its a move or a capture.
         ;
            [ _, _, StartRow, StartCol, EndRow, EndCol]= Play,
            % Predicate to make the capture of a opponent piece.
            capture_piece(Board,Player,SoloPeace,StartRow,StartCol,EndRow,EndCol,NewBoard),
            CheckWin is 2  % Variable to compare if its a move or a capture.
        ),
        
        % Display the updated game board.
        format('Type anything to see the Bot ~w move.',[Player]), 
        read(Access),
        display_game(NewBoard), nl,

        % Check if the current bot has reached the first opponents row.
        game_over_HB_Vs_HB(Player,NumRow, NumCol, SoloPeace, Opponent, SoloOpponent,EndRow,CheckWin,FinalRow,NewBoard,Winner)
    ;
        % If the current bot has no valid moves left, the opponent wins.
        format('Player ~w has no valid moves left. Player ~w wins!', [Player, Opponent]), nl
    ).