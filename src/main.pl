:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(between)).
:- consult(menu_prints).
:- consult(player_vs_player).
:- consult(player_vs_bot).
:- consult(bot_vs_bot).
:- consult(board_display).

% Set a new random seed for random number generation.
set_new_random_seed :-
    now(Time),
    Seed is Time mod 30269,
    setrand(Seed).

% Define the row limits for the game board.
rowLimits(MinRow,MaxRow) :-
    MinRow = 6,
    MaxRow = 12.


% Entry point for the game
play :-
    nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,
    set_new_random_seed, % Ensure that the random bot does not play the same initial moves all games.
    repeat,  % This will repeat until a valid GameMode is entered.
   
    % Print the main menu and read the users choice of game mode.
    print_main_menu,
    read(GameMode),

    % Check the users input and take appropriate actions.
    (checkInput(GameMode) -> true ; write('Invalid option!'), nl, nl, fail).

% Check user input for the game mode.
checkInput(0):-
    write('Exiting...').

% Check user input for player vs. player game modes.
checkInput(1) :-
    initial_state(R, C, Board),
    display_game(Board),
    play_game(Board, R, C, 'X/X', ' X ', 'O/O', ' O ',R).


% Check user input for player vs. bot game modes.
checkInput(2) :-
    print_choose_level_bot, 
    read(BotLevel),
    ((BotLevel = 1) ->
        repeat,
        print_choose_your_piece,
        read(PlayerControl),
        ((PlayerControl = 1 ; PlayerControl = 2)->
            initial_state(R, C, Board),
            display_game(Board),
            ((PlayerControl = 1)->
                play_game_against_Easy_bot(Board, R, C, 'X/X', ' X ', 'O/O', ' O ','X/X',R)
            ;
                play_game_against_Easy_bot(Board, R, C, 'X/X', ' X ', 'O/O', ' O ','O/O',R)
            )
        ;
            write('Invalid option. Please try again.'),nl,nl,fail)
    ; 
    ((BotLevel = 2)->
        repeat,
        print_choose_your_piece,
        read(PlayerControl),
        ((PlayerControl = 1 ; PlayerControl = 2)->
            initial_state(R, C, Board),
            display_game(Board),
            ((PlayerControl = 1)->
                play_game_against_Hard_bot(Board, R, C, 'X/X', ' X ', 'O/O', ' O ','X/X',R)
            ;
                play_game_against_Hard_bot(Board, R, C, 'X/X', ' X ', 'O/O', ' O ','O/O',R)
            )
        ;
        write('Invalid option. Please try again.'),nl,nl,fail)
    )
    ;
    write('Invalid option!'), nl,
    checkInput(2)).


% Check user input for bot vs. bot game modes.
checkInput(3):-
    repeat,
    print_bot_vs_bot, 
    read(BotsGame),
    (bot_Game(BotsGame) -> true;  write('Invalid option!'), nl, fail).


% Handle bot vs. bot game modes.
bot_Game(1) :-
    % Easy Bot vs. Hard Bot
    initial_state(R, C, Board),
    display_game(Board),
    play_game_Easy_vs_Hard(Board, R, C, 'X/X', ' X ', 'O/O', ' O ',R).

bot_Game(2) :-
    % Hard Bot vs. Easy Bot
    initial_state(R, C, Board),
    display_game(Board),
    play_game_Hard_vs_Easy(Board, R, C, 'X/X', ' X ', 'O/O', ' O ',R).

bot_Game(3) :-
    % Easy Bot vs. Easy Bot
    initial_state(R, C, Board),
    display_game(Board),
    play_game_Easy_vs_Easy(Board, R, C, 'X/X', ' X ', 'O/O', ' O ',R).

bot_Game(4) :-
    % Hard Bot vs. Hard Bot
    initial_state(R, C, Board),
    display_game(Board),
    play_game_Hard_vs_Hard(Board, R, C, 'X/X', ' X ', 'O/O', ' O ',R).      
    
