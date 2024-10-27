:- use_module(library(random)).
:- use_module(library(system)).

print_main_menu:-
    write('     _________________________________________________________________________'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                              Murus Gallicus                             |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |  Choose the type of the game:                                           |'),nl,
    write('    |                                                                         |'),nl,
    write('    |      1- Player vs Player                                                |'),nl,
    write('    |      2- Player vs Bot                                                   |'),nl,
    write('    |      3- Bot vs Bot                                                      |'),nl,
    write('    |      0- Exit                                                            |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |_________________________________________________________________________|'),nl,nl.

print_board_row:-
    write('     _________________________________________________________________________'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                              Murus Gallicus                             |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |  The board size is defined as (Nrow) x (Nrow+1)                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |      Choose the number of rows:                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |_________________________________________________________________________|'),nl,nl.

print_choose_level_bot:-
    write('     _________________________________________________________________________'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                              Murus Gallicus                             |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |  Choose the level of the bot:                                           |'),nl,
    write('    |                                                                         |'),nl,
    write('    |      1- Random mode                                                     |'),nl,
    write('    |      2- Strategy mode                                                   |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |_________________________________________________________________________|'),nl,nl.

print_choose_your_piece:-
    write('     _________________________________________________________________________'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                              Murus Gallicus                             |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |  Choose the pieces that you wanna control:                              |'),nl,
    write('    |                                                                         |'),nl,
    write('    |      1- X/X Pieces                                                       |'),nl,
    write('    |      2- O/O Pieces                                                      |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |_________________________________________________________________________|'),nl,nl.    

print_bot_vs_bot:-
    write('     _________________________________________________________________________'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                              Murus Gallicus                             |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |  Choose the level of the two bots that will face each other:            |'),nl,
    write('    |                                                                         |'),nl,
    write('    |      1- Bot1(Random) vs Bot2(Strategy)                                  |'),nl,
    write('    |      2- Bot1(Strategy) vs Bot2(Random)                                  |'),nl,
    write('    |      3- Bot1(Random) vs Bot2(Random)                                    |'),nl,
    write('    |      4- Bot1(Strategy) vs Bot2(Strategy)                                |'),nl,
    write('    |                                                                         |'),nl,
    write('    |                                                                         |'),nl,
    write('    |_________________________________________________________________________|'),nl,nl.    