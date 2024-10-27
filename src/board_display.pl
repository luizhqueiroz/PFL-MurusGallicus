:- use_module(library(lists)).

% Predicate to set the initial state of the game board.
initial_state(R, C, Board) :-
    repeat,
    print_board_row,
    write('Nrows'),
    read(R),
    rowLimits(MinRow,MaxRow),
    (
        ((R >= MinRow),(R =< MaxRow));          % Check if the input is within the limits.
        format('The number of rows must be between ~w and ~w', [MinRow, MaxRow]), nl, 
        fail),
    C is R + 1,           % Calculate the number of columns.
    board(R, C, Board).   % Generate the game board.
    
% Define the game board with R rows and C columns.
board(R, C, [FirstRow|Rest]) :-
    create_first_row(C, FirstRow), % Create the first row.
    create_rest_rows(R, C, Rest).  % Create the remaining rows.

create_rest_rows(R, C, Rest) :-
    create_rows(R-2, C, Middle),       % Create the middle rows.
    create_last_row(C, LastRow),       % Create the last row.
    appends(Middle, [LastRow], Rest).  % Append the middle and last rows.

% Create R rows with C columns.
create_rows(0, _, []).
create_rows(R, C, [Row | Rest]) :-
    R > 0,
    R1 is R - 1,
    create_cols(C, Row), % Create a row with C columns.
    create_rows(R1, C, Rest).

% Create C columns with empty cells.
create_cols(0, []).
create_cols(C, ['   '| B]) :-
    C > 0,
    C1 is C - 1,
    create_cols(C1, B).

% Create the first row with X/X (Roman pieces).
create_first_row(0, []).
create_first_row(C, ['X/X'|T]) :- 
    C > 0,
    C1 is C - 1,
    create_first_row(C1, T).


% Create the last row with O/O (Gaul pieces).
create_last_row(0, []).
create_last_row(C, ['O/O'|T]) :-
    C > 0,
    C1 is C - 1,
    create_last_row(C1, T).

% Append two lists.
appends([], B, B).
appends([X|A], B, [X|C]) :- 
    appends(A, B, C).


% Display the game board.
display_game(Board) :-
    nl,nl,nl,nl,nl,
    write('\t     '),
    print_header(Board, 1), % Print the column headers.
    print_lists(Board, 1),  % Print the board cells.
    nl.

% Print the column headers
print_header([H|T], C) :-
    length(H,N), % Get the length of the first row (number of columns).
    write(C), % Print the column number.
    write('         '),
    C1 is C + 1,
    (C < N -> print_header([H|T], C1); nl, write('\t-'),print_space(N)).

% Print a nested list
print_lists([], _).
print_lists([H|T], Row) :-
    write('     '),
    write(Row), % Print the row number.
    write('\t|   '),
    Row1 is Row + 1,
    print_list(H), % Print the cells in the row.
    length(H,N),
    write('\t-'),
    print_space(N),
    print_lists(T, Row1).

% Print a list.
print_list([]).
print_list([H|T]) :-
    write(H),
    (T = [] -> write('   |   '), nl; write('   |   ')),
    print_list(T).

% Print a horizontal line to separate rows.
print_space(0) :- nl.
print_space(C) :-
    write('----------'),
    C1 is C - 1,
    print_space(C1).

board([
    ['X/X','X/X','X/X','X/X','X/X','X/X','X/X','X/X'],
    ['   ','   ','   ','   ','   ','   ','   ','   '],
    ['   ','   ','   ','   ','   ','   ','   ','   '],
    ['   ','   ','   ','   ','   ','   ','   ','   '],
    ['   ','   ','   ','   ','   ','   ','   ','   '],
    ['   ','   ','   ','   ','   ','   ','   ','   '],
    ['O/O','O/O','O/O','O/O','O/O','O/O','O/O','O/O']
    ]).    