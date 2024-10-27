:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(between)).

% Predicate to get a players move input
get_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent) :-
    repeat,
    format('Player ~w, enter your move (start row, start col, end row, end col): ', [Player]), nl,
    write('Start row: '), read(StartRow), nl,
    write('Start Col'),read(StartCol), nl,
    write('End row'),read(EndRow), nl,
    write('End Col'),read(EndCol), nl,
    (valid_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board,  NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent); write('Invalid move, try again.'), nl, fail).

% Predicate to select a piece at a specific row and column on the board.
select_piece(Board, Row, Col, Piece) :-
    nth1(Row, Board, BoardRow),  % Select the row using nth1/3
    nth1(Col, BoardRow, Piece).  % Select the element in the row using nth1/3

% Predicate to remove a piece at a specific row and column on the board.
remove_piece(Board, Row, Col, NewBoard) :-
    nth1(Row, Board, BoardRow),     % Select the row using nth1/3
    replace(BoardRow, Col, '   ', NewRow), % Replace the element in the row using replace/4
    replace(Board, Row, NewRow, NewBoard). % Replace the row in the board using replace/4

% Predicate to change the value of a cell at a specific row and column in the board.
change_cell(Board, Row, Col, NewValue, NewBoard) :-
    nth1(Row, Board, OldRow),        % Select the row using nth1/3
    replace(OldRow, Col, NewValue, ModifiedRow),  % Replace the element in the row using replace/4
    replace(Board, Row, ModifiedRow, NewBoard).  % Replace the row in the board using replace/4

% Predicate to make a move. It will replace the piece in the start position with an empty cell and place the piece in the middle and in the end position.
move(Board, StartRow, StartCol, EndRow, EndCol, NewBoard, Player, SoloPeace) :-
    % Remove the Piece of the Initial Square.
    remove_piece(Board, StartRow, StartCol, TempBoard),
    
    % Calculate the middle row and column.
    MiddleRow is (StartRow + EndRow) // 2,
    MiddleCol is (StartCol + EndCol) // 2,
    
    % Check if the middle position is empty or if contains a SoloPeace.
    select_piece(Board, MiddleRow, MiddleCol, MiddlePiece),
    (MiddlePiece == '   ' -> change_cell(TempBoard, MiddleRow, MiddleCol, SoloPeace, IntermediateBoard);
        MiddlePiece == SoloPeace -> change_cell(TempBoard, MiddleRow, MiddleCol, Player, IntermediateBoard)
    ),

    % Check if the destination position is empty or if contains a SoloPeace.
    select_piece(IntermediateBoard, EndRow, EndCol, DestinationPiece),
    (DestinationPiece == '   ' -> change_cell(IntermediateBoard, EndRow, EndCol, SoloPeace, NewBoard);
        DestinationPiece == SoloPeace -> change_cell(IntermediateBoard, EndRow, EndCol, Player, NewBoard)
    ).

% Helper predicate to replace an element in a list at a given position.
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    I1 is I - 1,
    replace(T, I1, X, R).

% Rules of the game to make sure the move that player inserted is valid.
valid_move(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent) :-
    % Check if the move is within bounds.
    
    ((StartRow >= 1, 
    StartRow =< NumRow,
    StartCol >= 1, 
    StartCol =< NumCol,
    EndRow >= 1, 
    EndRow =< NumRow,
    EndCol >= 1, 
    EndCol =< NumCol) -> true; write('Out of the board! '), fail),

    % Check if the starting cell has a piece of the player ('X/X' or 'O/O' depending on the player who is moving)
    select_piece(Board, StartRow, StartCol, InitialPiece),
    ((InitialPiece == Player) -> true; write('This is not a piece you can move! '), fail),

    % Calculate the absolute row and column differences between start and end positions
    DeltaRow is EndRow - StartRow,
    DeltaCol is EndCol - StartCol,
    
    % Ensure that the move is either orthogonal or diagonal (DeltaRow and DeltaCol are 0, 1, or 2)
    ((DeltaRow =:= 0, DeltaCol =:= 2;  % Orthogonal
      DeltaRow =:= 2, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= 2, DeltaCol =:= 2;  % Diagonal
      DeltaRow =:= 2, DeltaCol =:= -2; % Diagonal
      DeltaRow =:= -2, DeltaCol =:= 2; % Diagonal
      DeltaRow =:= 0, DeltaCol =:= -2;  % Orthogonal
      DeltaRow =:= -2, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= -2, DeltaCol =:= -2) -> % Diagonal
        
        % Calculate the middle row and column.
        MiddleRow is (StartRow + EndRow) // 2,
        MiddleCol is (StartCol + EndCol) // 2,

        % Check if the destination position is empty or if contains a SoloPeace.
        select_piece(Board, EndRow, EndCol, DestinationPiece),
        ((DestinationPiece = '   '; DestinationPiece == SoloPeace) -> true; write('There is something in your destination! '), fail),

        % Check if the intermedium cell is empty or contains a SoloPeace.
        select_piece(Board, MiddleRow, MiddleCol, MiddlePiece),
        ((MiddlePiece == '   ' ; MiddlePiece == SoloPeace) -> true; write('Something is blocking your move! '), fail)
    ;
     (DeltaRow =:= 0, DeltaCol =:= 1;  % Orthogonal
      DeltaRow =:= 1, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= 1, DeltaCol =:= 1;
      DeltaRow =:= 1, DeltaCol =:= -1;
      DeltaRow =:= -1, DeltaCol =:= 1;
      DeltaRow =:= 0, DeltaCol =:= -1;  % Orthogonal
      DeltaRow =:= -1, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= -1, DeltaCol =:= -1) ->

        % Check if the adjacent cell contains a SoloOpponent piece.
        select_piece(Board, EndRow, EndCol, DestinationPiece),
        ((DestinationPiece == SoloOpponent) -> true; write('There is no opponent piece to be sacrificied! '), fail)
    ;
    write('You cannot move like this! '), fail
    ).

valid_move_bot(Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, Board, NumRow, NumCol, DeltaRow, DeltaCol, SoloOpponent) :-
    % Check if the move is within bounds.
    
    StartRow >= 1, 
    StartRow =< NumRow,
    StartCol >= 1, 
    StartCol =< NumCol,
    EndRow >= 1, 
    EndRow =< NumRow,
    EndCol >= 1, 
    EndCol =< NumCol,

    % Check if the starting cell has a piece of the player ('X/X' or 'O/O' depending on the player who is moving)
    select_piece(Board, StartRow, StartCol, InitialPiece),
    InitialPiece == Player,

    % Calculate the absolute row and column differences between start and end positions
    DeltaRow is EndRow - StartRow,
    DeltaCol is EndCol - StartCol,
    
    % Ensure that the move is either orthogonal or diagonal (DeltaRow and DeltaCol are 0, 1, or 2)
    ((DeltaRow =:= 0, DeltaCol =:= 2;  % Orthogonal
      DeltaRow =:= 2, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= 2, DeltaCol =:= 2;
      DeltaRow =:= 2, DeltaCol =:= -2; % FAZER ABS???
      DeltaRow =:= -2, DeltaCol =:= 2;
      DeltaRow =:= 0, DeltaCol =:= -2;  % Orthogonal
      DeltaRow =:= -2, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= -2, DeltaCol =:= -2) -> 
        
        % Calculate the middle row and column.
        MiddleRow is (StartRow + EndRow) // 2,
        MiddleCol is (StartCol + EndCol) // 2,

        % Check if the destination position is empty or if contains a SoloPeace.
        select_piece(Board, EndRow, EndCol, DestinationPiece),
        (DestinationPiece = '   '; DestinationPiece == SoloPeace),

        % Check if the intermedium cell is empty or contains a SoloPeace.
        select_piece(Board, MiddleRow, MiddleCol, MiddlePiece),
        (MiddlePiece == '   ' ; MiddlePiece == SoloPeace)
    ;
     (DeltaRow =:= 0, DeltaCol =:= 1;  % Orthogonal
      DeltaRow =:= 1, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= 1, DeltaCol =:= 1;
      DeltaRow =:= 1, DeltaCol =:= -1;
      DeltaRow =:= -1, DeltaCol =:= 1;
      DeltaRow =:= 0, DeltaCol =:= -1;  % Orthogonal
      DeltaRow =:= -1, DeltaCol =:= 0;  % Orthogonal
      DeltaRow =:= -1, DeltaCol =:= -1) ->

        % Check if the adjacent cell contains a SoloOpponent piece.
        select_piece(Board, EndRow, EndCol, DestinationPiece),
        (DestinationPiece == SoloOpponent)
    ;
    fail
    ).

% Rule to check if a value is present in any sublist of a list of lists
has_value_in_sublists(Value, [Sublist | _]) :- has_value(Value, Sublist).
has_value_in_sublists(Value, [_ | Tail]) :- has_value_in_sublists(Value, Tail).

has_value(Value, [Value | _]).
has_value(Value, [_ | Tail]) :- has_value(Value, Tail).

capture_piece(Board, Player, SoloPeace, StartRow, StartCol, EndRow, EndCol, NewBoard) :-
    remove_piece(Board, StartRow, StartCol, TempBoard),
    change_cell(TempBoard, StartRow, StartCol, SoloPeace, IntermediateBoard),
    remove_piece(IntermediateBoard, EndRow, EndCol, NewBoard).