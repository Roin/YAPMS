% maze([[0, 0, 0, 1, 0], [0, 1, 1, 1, 0], [0, 0, 1, 0 , 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0]], (1, 1), (5, 3), X).
%maze(MAZELIST, START, ZIEL, X) :-
%findpath(MAZELIST, START, WALKABLE, X).

maze(MAZELIST, START, ZIEL, X) :-
    check(MAZELIST, START, ZIEL, START, X).

% TODO maybe add X to VISITED
check(MAZELIST, (CURROW, CURCOLUMN), (ZIEL1, ZIEL2), VISITED, X) :-
    CURROW =:= ZIEL1,
    CURCOLUMN =:= ZIEL2,
    getValue(MAZELIST, (CURROW, CURCOLUMN) , VALUE),
    VALUE =:= 0,
    X = (CURROW, CURCOLUMN).


% check east unvisited
check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, X) :-
    CURCOLUMNI is CURCOLUMN+1,
    getValue(MAZELIST, (CURROW, CURCOLUMNI) , VALUE),
    VALUE =:= 0,
    isNotVisited(CURROW, CURCOLUMNI, VISITED),
    move(MAZELIST, (CURROW, CURCOLUMNI), ZIEL, VISITED, X).


% check south unvisited



% check west unvisited


% check north unvisited


% check west visited


% check south visited


% check east visited



% check north visited


move(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, X) :-
    maze(MAZELIST, (CURROW, CURCOLUMN), ZIEL, [(CURROW, CURCOLUMN)|VISITED], X).
    






%findpath(MAZELIST, START, WALKABLE, X) :-
% STARTROW = START1,
% STARTCOLUMN = START2,
% getValue(MAZELIST, START, X).

isNotVisited(ROW, COLUMN, VISITED) :-
    \+isVisited(ROW, COLUMN, VISITED).

isVisited(ROW, COLUMN, []) :-
    false.

isVisited(ROW, COLUMN, [(X,Y)|VISITED]) :-
    ROW =:= X,
    COLUMN =:= Y.

isVisited(ROW, COLUMN, [_|VISITED]) :-
    isVisited(ROW, COLUMN, VISITED).


getValue(MAZELIST, START, X) :-
    inRow(MAZELIST, 1, 1, START, X).

inRow([Row|_], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), X) :-
    CURROW =:= STARTROW,
    inColumn(Row, CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), X).

inRow([_|RestMaze], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), X) :-
    CURROW < STARTROW,
    CURROWI is CURROW+1,
    inRow(RestMaze, CURROWI, CURCOLUMN, (STARTROW, STARTCOLUMN), X).

inColumn([Element|_], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), Element) :-
    CURCOLUMN =:= STARTCOLUMN.

inColumn([_|RestList], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), X) :-
    CURCOLUMN < STARTCOLUMN,
    CURCOLUMNI is CURCOLUMN+1,
    inColumn(RestList, CURROW, CURCOLUMNI, (STARTROW, STARTCOLUMN), X).
