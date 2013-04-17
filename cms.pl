% maze solving algorithm by Florian Kanngießer (MTR NR) and Christian Burkard (4206853)


%% Call: maze(MAZELIST, START, GOAL, SHORTESTPATH)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              START: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              GOAL: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              SHORTESTPATH: A list containing the shortest path which solves the maze.
%
%   This is the "API" function. This function starts the maze solving algorithm.
%   It finds the shortest path for a given maze, given some start and goal coordinates.
%%
maze(MAZELIST, START, GOAL, SHORTESTPATH) :-
    isValidField(MAZELIST, START),
    isValidField(MAZELIST, GOAL),
    getShortestPath(MAZELIST, START, GOAL, SHORTESTPATH).


%% Call: getShortestPath(MAZELIST, START, GOAL, SHORTESTPATH)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              START: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              GOAL: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              SHORTESTPATH: A list containing the shortest path which solves the maze.
%
%   Calls the findAllPaths/4 function and determines its shorteset path.
%   This path is printed to screen then.
%%
getShortestPath(MAZELIST, START, GOAL, SHORTESTPATH) :-
    findAllPaths(MAZELIST, START, GOAL, ALLPATHS),
    findShortestPath(ALLPATHS, SHORTESTPATH, PATHLENGTH),!,
    nl,
    write('##############################################################################'),nl,
    write('Shortest Path with length '),
    write(PATHLENGTH),
    write(' is: '),nl,
    write(SHORTESTPATH),nl,
    write('##############################################################################'),nl.


%% Call: findShortestPath(PATHS, SHORTESTPATH, PATHLENGTH)
%                PATHS: A list containing paths.
%                SHORTESTPATH: The shortest path in the list PATHS
%                PATHLENGTH: The length of the shortest path in PATHS
%   
%   Finds the shortest path and length from a given list containing possible solution paths.
%%
findShortestPath([CURPATH|[]], CURPATH, MIN) :-
    length(CURPATH, MIN).

findShortestPath([CURPATH|RESTPATH], SHORTESTPATH, MIN) :-
    findShortestPath(RESTPATH, NEWPATH, NEWMIN),
    length(CURPATH, CURMIN),
    (
        (CURMIN =< NEWMIN, SHORTESTPATH = CURPATH, MIN = CURMIN)
        ;
            (CURMIN >= NEWMIN, SHORTESTPATH = NEWPATH, MIN = NEWMIN)
            ).




%% Call: findAllPaths(MAZELIST, START, GOAL, ALLPATHS)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              START: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              GOAL: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              ALLPATHS: A list that contains any possible path through the maze.
%
%   Finds any possible solution through the maze by calling the check function until no new solution is found.
%   This is done by the swi prolog built-in findall/3 function.
%%
findAllPaths(MAZELIST, START, GOAL, ALLPATHS) :-
    findall(PATH, check(MAZELIST, START, GOAL, [START], PATH), ALLPATHS).


%% Call: check(MAZELIST, START, GOAL, [START], PATH)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              START: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              GOAL: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              [START]: The visited list, that contains the already visited nodes of the maze, is initialized with the start position.
%              PATH: A list that contains a valid path, in form of coordinates, through the maze.
%
%   Finds a path through the maze by checking whether the current coordinate is the goal.
%   If not it starts looking to the right-hand coordinate, then bottom, left-hand and finally the top coordinate.
%   The first coordinate which is walkable (0) and not already in the visited list will be moved to.
%%               

% Check current position for the goal
check(MAZELIST, (CURROW, CURCOLUMN), (GOAL1, GOAL2), VISITED, PATH) :-
    CURROW =:= GOAL1,
    CURCOLUMN =:= GOAL2,
    isValidField(MAZELIST, (CURROW, CURCOLUMN)),
    reverse(VISITED, PATH),
    %write('Walked Path: '),
    %write(PATH),nl,
    true.


% check east unvisited
check(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH) :-
    CURCOLUMNI is CURCOLUMN + 1,
    isValidField(MAZELIST, (CURROW, CURCOLUMN)),
    isNotVisited((CURROW, CURCOLUMNI), VISITED),
    move(MAZELIST, (CURROW, CURCOLUMNI), GOAL, VISITED, PATH).


% check south unvisited
check(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH):-
    CURROWI is CURROW + 1,
    isValidField(MAZELIST, (CURROW, CURCOLUMN)),
    isNotVisited((CURROWI,CURCOLUMN), VISITED),
    move(MAZELIST, (CURROWI, CURCOLUMN), GOAL, VISITED, PATH).



% check west unvisited
check(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH) :-
    CURCOLUMNI is CURCOLUMN - 1,
    isValidField(MAZELIST, (CURROW, CURCOLUMN)),
    isNotVisited((CURROW,CURCOLUMNI),VISITED),
    move(MAZELIST, (CURROW,CURCOLUMNI), GOAL, VISITED, PATH).


% check north unvisited
check(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH) :-
    CURROWI is CURROW - 1,
    isValidField(MAZELIST, (CURROW, CURCOLUMN)),
    isNotVisited((CURROWI,CURCOLUMN), VISITED),
    move(MAZELIST, (CURROWI, CURCOLUMN), GOAL, VISITED, PATH).


%% Call: move(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              CURROW: Y-coordinate of the current position.
%              CURCOLUMN: X-coordinate of the current position.
%              GOAL: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              VISITED: The visited list, that contains the already visited nodes of the maze.
%              PATH: A list that contains the path which was taken to reach the current possition
%
%   move performs the actual move to a new field of the maze.
%   It appends the coordinates of the new field to the visited list.
move(MAZELIST, (CURROW, CURCOLUMN), GOAL, VISITED, PATH) :-
    check(MAZELIST, (CURROW, CURCOLUMN), GOAL, [(CURROW, CURCOLUMN)|VISITED], PATH).

%% Call: isNotVisited((ROW, COLUMN), VISITED)
%               ROW: The Y-coordinate of the tested field.
%               COLUMN: The X-coordinate of the tested field.
%               VISITED: The list that contains all already visited positions in the maze.
%
%   Tests if the given coordinate is already in the visited list.
%   Actually works like the negated swi prolog build-in member/2 function. (But we didn't know it before)
%
%   Is TRUE if the field was not visited, yet.
%%
isNotVisited((ROW, COLUMN), VISITED) :-
    \+isVisited(ROW, COLUMN, VISITED).

isVisited(_, _, []) :-
    false.

isVisited(ROW, COLUMN, [(X,Y)|_]) :-
    ROW =:= X,
    COLUMN =:= Y.

isVisited(ROW, COLUMN, [_|VISITED]) :-
    isVisited(ROW, COLUMN, VISITED).


%% Call: isValidField(MAZELIST, COORDINATE)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              COORDINATE: A tupel containing the coordinates which will be checked.
%
%   Is TRUE if the field is a valid (walkable) position in the maze.
%%
isValidField(MAZE, COORDINATE) :-
    getValue(MAZE, COORDINATE, VALUE),
    VALUE =:= 0.

%% Call: getValue(MAZELIST, COORDINATE, VALUE)
%              MAZELIST: A list containing the maze. See examples on the bottom for the format.
%              COORDINATE: A tupel containing the coordinates which will be checked.
%              VALUE: The value of the maze's field with coordinates given by COORDINATE.
%
%   Gets the value of a given field in the maze.
%%
getValue(MAZELIST, COORDINATE, VALUE) :-
    inRow(MAZELIST, 1, 1, COORDINATE, VALUE).

inRow([ROW|_], CURROW, CURCOLUMN, (GOALROW, GOALCOLUMN), VALUE) :-
    CURROW =:= GOALROW,
    inColumn(ROW, CURROW, CURCOLUMN, (GOALROW, GOALCOLUMN), VALUE).

inRow([_|RESTMAZE], CURROW, CURCOLUMN, (GOALROW, GOALCOLUMN), VALUE) :-
    CURROW < GOALROW,
    CURROWI is CURROW+1,
    inRow(RESTMAZE, CURROWI, CURCOLUMN, (GOALROW, GOALCOLUMN), VALUE).

inColumn([ELEMENT|_], _, CURCOLUMN, (_, GOALCOLUMN), ELEMENT) :- 
    CURCOLUMN =:= GOALCOLUMN.

inColumn([_|RESTLIST], CURROW, CURCOLUMN, (GOALROW, GOALCOLUMN), VALUE) :-
    CURCOLUMN < GOALCOLUMN,
    CURCOLUMNI is CURCOLUMN+1,
    inColumn(RESTLIST, CURROW, CURCOLUMNI, (GOALROW, GOALCOLUMN), VALUE).


%% Here you can find some examples for the maze solving algorithm.
%  To use them append them to your maze/4 function call.
%  This can look like: 
%            ex1(MAZE),maze(MAZE,(2,1), (6,6), PATH).

ex1([
[1,1,1,1,1,0],
[0,0,0,0,0,0],
[0,0,0,1,1,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,1,0]]).

ex2([
[1,1,1,1,1,0],
[0,0,0,0,0,0],
[0,0,0,1,1,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,0,0]]).

ex3([
[1,1,1,1,0,1],
[0,0,0,1,0,0],
[0,1,0,0,0,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,0,0]]).

ex4([
[1,1,0,0,1,0,0,1,1,1,0,0,0,0,0,0,1,0,1,0,1,1,0,0,1,0],
[0,0,0,0,0,1,1,0,0,0,1,1,1,0,1,0,0,1,0,0,1,1,0,1,0,0],
[1,1,1,0,0,1,0,0,0,1,0,1,1,0,0,1,1,1,0,0,0,0,0,1,0,0],
[0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0],
[1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,0,1],
[0,0,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,0,0,0,0,1,0,0],
[1,1,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,1,1,1,1,1],
[0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0],
[1,1,0,0,0,0,0,1,1,1,1,0,0,0,1,1,0,0,0,1,0,0,0,0,1,1],
[0,0,0,1,1,0,0,1,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,1,0],
[1,1,0,0,0,0,1,1,0,1,1,1,0,0,0,1,1,1,0,0,1,1,1,1,0,0],
[0,0,0,0,1,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0],
[1,1,1,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,1],
[0,0,0,0,1,1,0,0,1,0,0,1,1,1,0,0,0,0,1,1,0,1,0,1,0,0],
[1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,0,0,1],
[0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1],
[1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,1,1,0,1,0,0,1,1,0,0,1],
[1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0],
[1,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0],
[1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
[0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1],
[1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0],
[0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1],
[0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0],
[1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0],
[0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0],
[0,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1],
[1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0]]).

