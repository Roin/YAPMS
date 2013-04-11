% maze([[0, 0, 0, 1, 0], [0, 1, 1, 1, 0], [0, 0, 1, 0 , 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0]], (1, 1), (5, 3),X).
%maze(MAZELIST, START, ZIEL) :- 
%findpath(MAZELIST, START, WALKABLE).

maze(MAZELIST, START, ZIEL, SHORTESTPATH) :-
    getShortestPath(MAZELIST, START, ZIEL, SHORTESTPATH).

getShortestPath(MAZELIST, START, ZIEL, SHORTESTPATH) :-
    findAllPaths(MAZELIST, START, ZIEL, ALLPATHS),
    %write('ALLPATHS: '),
    %write(ALLPATHS),nl,
    initShortest(ALLPATHS, INITMIN),
    findShortestPath(ALLPATHS, INITMIN, _, PATHLENGTH, SHORTESTPATH),!,
    nl,
    write('##############################################################################'),nl,
    write('Shortest Path with length '),
    write(PATHLENGTH),
    write(' is: '),nl,
    write(SHORTESTPATH),nl,
    write('##############################################################################'),nl.


initShortest([FIRST|_], MIN) :-
    length(FIRST, MIN).

findShortestPath([CURPATH|[]], OLDMIN, _, CURMIN, CURPATH) :-
    length(CURPATH, CURMIN),
    CURMIN =< OLDMIN.

findShortestPath([_|[]], OLDMIN, OLDPATH, OLDMIN, OLDPATH).


findShortestPath([CURPATH|RESTPATHS], OLDMIN, _, NEWMIN, NEWPATH) :-
    length(CURPATH, CURMIN),
    CURMIN =< OLDMIN,
    findShortestPath(RESTPATHS, CURMIN, CURPATH, NEWMIN, NEWPATH).

findShortestPath([_|RESTPATHS], OLDMIN, OLDPATH, NEWMIN, NEWPATH) :-
    findShortestPath(RESTPATHS, OLDMIN, OLDPATH, NEWMIN, NEWPATH).






findAllPaths(MAZELIST, START, ZIEL, ALLPATHS) :-
    findall(PATH, check(MAZELIST, START, ZIEL, [START], PATH), ALLPATHS).

%findAllPaths(_, _, _, _).

    

% found our goal
check(MAZELIST, (CURROW, CURCOLUMN), (ZIEL1, ZIEL2), VISITED, PATH) :-
    CURROW =:= ZIEL1,
    CURCOLUMN =:= ZIEL2,
    getValue(MAZELIST, (CURROW, CURCOLUMN) , VALUE),
    VALUE =:= 0,
    reverse(VISITED, PATH),
    %write('Walked Path: '),
    %write(PATH),nl,
    true.


% check east unvisited
check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, PATH) :-
    CURCOLUMNI is CURCOLUMN+1,
    getValue(MAZELIST, (CURROW, CURCOLUMNI) , VALUE),
    VALUE =:= 0,
    isNotVisited((CURROW, CURCOLUMNI), VISITED),
    move(MAZELIST, (CURROW, CURCOLUMNI), ZIEL, VISITED, PATH).


% check south unvisited
check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, PATH):-
    CURROWI is CURROW + 1,
    getValue(MAZELIST, (CURROWI,CURCOLUMN),VALUE),
    VALUE =:= 0,
    isNotVisited((CURROWI,CURCOLUMN), VISITED),
    move(MAZELIST, (CURROWI, CURCOLUMN), ZIEL, VISITED, PATH).



% check west unvisited
check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, PATH) :-
    CURCOLUMNI is CURCOLUMN - 1,
    getValue(MAZELIST, (CURROW, CURCOLUMNI), VALUE),
    VALUE =:= 0,
    isNotVisited((CURROW,CURCOLUMNI),VISITED),
    move(MAZELIST, (CURROW,CURCOLUMNI), ZIEL, VISITED, PATH).


% check north unvisited
check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, PATH) :-
    CURROWI is CURROW - 1,
    getValue(MAZELIST, (CURROWI, CURCOLUMN),VALUE),
    VALUE =:= 0,
    isNotVisited((CURROWI,CURCOLUMN), VISITED),
    move(MAZELIST, (CURROWI, CURCOLUMN), ZIEL, VISITED, PATH).



% check west visited


% check south visited


% check east visited



% check north visited


move(MAZELIST, (CURROW, CURCOLUMN), ZIEL, VISITED, PATH) :-
    check(MAZELIST, (CURROW, CURCOLUMN), ZIEL, [(CURROW, CURCOLUMN)|VISITED], PATH).







isNotVisited((ROW, COLUMN), VISITED) :-
    \+isVisited(ROW, COLUMN, VISITED).

isVisited(_, _, []) :-
    false.

isVisited(ROW, COLUMN, [(X,Y)|_]) :-
    ROW =:= X,
    COLUMN =:= Y.

isVisited(ROW, COLUMN, [_|VISITED]) :-
    isVisited(ROW, COLUMN, VISITED).


getValue(MAZELIST, START, VALUE) :-
    inRow(MAZELIST, 1, 1, START, VALUE).

inRow([ROW|_], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), VALUE) :-
    CURROW =:= STARTROW,
    inColumn(ROW, CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), VALUE).

inRow([_|RESTMAZE], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), VALUE) :-
    CURROW < STARTROW,
    CURROWI is CURROW+1,
    inRow(RESTMAZE, CURROWI, CURCOLUMN, (STARTROW, STARTCOLUMN), VALUE).

inColumn([ELEMENT|_], _, CURCOLUMN, (_, STARTCOLUMN), ELEMENT) :- 
    CURCOLUMN =:= STARTCOLUMN.

inColumn([_|RESTLIST], CURROW, CURCOLUMN, (STARTROW, STARTCOLUMN), VALUE) :-
    CURCOLUMN < STARTCOLUMN,
    CURCOLUMNI is CURCOLUMN+1,
    inColumn(RESTLIST, CURROW, CURCOLUMNI, (STARTROW, STARTCOLUMN), VALUE).

myreverse([],[]).

myreverse([HEAD|TAIL], REVERSE) :-
    myreverse(TAIL, REVERSETAIL),
    append(REVERSETAIL, [HEAD], REVERSE).

%Examples:


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

