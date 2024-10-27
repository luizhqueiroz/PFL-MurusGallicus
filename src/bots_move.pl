:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(between)).

% Generate a random valid move for a bot.
generate_random_valid_move(Player, SoloPeace, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent, StartRow, StartCol, EndRow, EndCol):-

    % Find a list of valid moves for the bot.
    valid_moves(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent, Moves),

    % Determine the number of valid moves.
    length(Moves, N),

    % Generate a random number between 1 and N.
    random(1, N, X),

    % Get the X-th random move from the list of valid moves.
    get_random_move(X, Moves, [DeltaRow, DeltaCol, StartRow, StartCol, EndRow, EndCol]).

% Get the X-th element from a list.
get_random_move(1, [Play| _], Play).
get_random_move(N, [ _| T], P) :- 
    N1 is N-1,
    get_random_move(N1,T,P).


% Generate a smart move for the bot
generate_smart_move(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent,DeltaRow,DeltaCol,Play) :-

    % Find a list of valid moves for the player.
    valid_moves(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent, Moves),

    % Execute a valid move from the list of valid moves according to the moves priorities.
    execute_valid_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play),

    % Extract DeltaRow_ and DeltaCol_ from the generated move.
    [DeltaRow_, DeltaCol_, StartRow, StartCol, EndRow, EndCol] = Play,

    % Calculate the absolute values of DeltaRow and DeltaCol.
    DeltaRow is abs(DeltaRow_),
    DeltaCol is abs(DeltaCol_).

% Execute a valid priority move for a bot.
execute_valid_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play):-
    % Select a move to reach the opponents first row.
   select_reach_first_row_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play).

execute_valid_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play):-
   % If no first-row moves are possible, select a move to capture an opponents piece.
   select_capture_opponent_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play).

execute_valid_move(Player, SoloPeace, Board, NumRow, NumCol, Moves, Play):-
    % If no capture moves are possible, generate a random valid move.
    generate_random_valid_move_smart(Player, SoloPeace, Board, Moves, Play).    

% Select a move to reach the opponents first row.
select_reach_first_row_move(_, _, _, _, _, [], Play) :- fail. % No moves to reach the final row, return false.

select_reach_first_row_move(Player, SoloPeace, Board, NumRow, NumCol, [Move | Rest], Play) :-
    % Extract the elements from the move list.
    [DeltaRow, DeltaCol, StartRow, StartCol, EndRow, EndCol] = Move,

    % Check if the move allows reaching the opponents first row.
    (Player = 'X/X', EndRow = NumRow-> (Play = Move); select_reach_first_row_move(Player, SoloPeace, Board, NumRow, NumCol, Rest, Play)).
    
select_reach_first_row_move(Player, SoloPeace, Board, NumRow, NumCol, [Move | Rest], Play) :-
    % Extract the elements from the move list.
    [DeltaRow, DeltaCol, StartRow, StartCol, EndRow, EndCol] = Move,

    % Check if the move allows reaching the opponents first row.
    (Player = 'O/O', EndRow = 1 -> (Play = Move)); select_reach_first_row_move(Player, SoloPeace, Board, NumRow, NumCol, Rest, Play).
    


% Select a move to capture the opponents piece.
select_capture_opponent_move(_, _, _, _, _, [], Play) :- fail. % No captures left, return false.

select_capture_opponent_move(Player, SoloPeace, Board, NumRow, NumCol, [Move | Rest],Play):-
    % Extract the elements from the move list.
    [DeltaRow, DeltaCol, StartRow, StartCol, EndRow, EndCol] = Move,

    DeltaRowAbs is abs(DeltaRow),
    DeltaColAbs is abs(DeltaCol),

    % Check if the move is a possible capture.
    ((DeltaRowAbs =:= 0, DeltaColAbs =:= 1; DeltaRowAbs =:= 1, DeltaColAbs =:= 1; DeltaRowAbs =:= 1, DeltaColAbs =:= 0) ->
        Play = Move
    ;
        select_capture_opponent_move(Player, SoloPeace, Board, NumRow, NumCol, Rest,Play)
    ).

% Generate a random valid move with a maximum delta of 2 in both row and column
generate_random_valid_move_smart(Player, SoloPeace, Board, Moves, Play) :-
    % Get the length of the valid moves list.
    length(Moves,N),

    % Generate a random number between 1 and N.
    random(1,N,X),

    % Get the X-th random move from the list of valid moves.
    get_random_move(X, Moves, Play).

% Find all valid moves for a player.
valid_moves(Player, SoloPeace, Board, NumRow, NumCol, SoloOpponent, Moves) :-
    findall(
        [DeltaRow, DeltaCol, StartRow, StartCol, EndRow, EndCol],
        (
            between(1, NumRow, StartRow),   % Iterate through possible start rows
            between(1, NumCol, StartCol),   % Iterate through possible start columns
            between(-2,2, DeltaRow),  % Iterate through possible delta rows
            between(-2, 2, DeltaCol),  % Iterate through possible delta columns
            EndRow is StartRow + DeltaRow,
            EndCol is StartCol + DeltaCol,
            valid_move_bot(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, _, _, SoloOpponent)
        ),
        Moves
    ).
