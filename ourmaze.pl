% maze([[0, 0, 0, 1, 0], [0, 1, 1, 1, 0], [0, 0, 1, 0 , 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0]], (1, 1), (5, 3), X).
%maze(MAZELIST, START, ZIEL, X) :- 
%findpath(MAZELIST, START, WALKABLE, X).

maze(MAZELIST, START, ZIEL, X) :-
    move(MAZELIST, START, ZIEL, X).

move(MAZELIST, (CurRow, CurColumn), (ZIEL1, ZIEL2), X) :-
    CurRow =:= ZIEL1,
    CurColumn =:= ZIEL2,
    getValue(MAZELIST, (CurRow, CurColumn) , VALUE),
    VALUE =:= 0,
    X = (CurRow, CurColumn).

moveeast(X) :-true.

movesouth(X) :-true.

movewest(X) :-true.

movenorth(X) :-true.


findpath(MAZELIST, START, WALKABLE, X) :-
    %    StartRow = START1,
    %    StartColumn = START2,
    getValue(MAZELIST, START, X).

getValue(MAZELIST, START, X) :-
    inRow(MAZELIST, 1, 1, START, X).

inRow([Row|_], CurRow, CurColumn, (StartRow, StartColumn), X) :-
    CurRow =:= StartRow,
    inColumn(Row, CurRow, CurColumn, (StartRow, StartColumn), X).

inRow([_|RestMaze], CurRow, CurColumn, (StartRow, StartColumn), X) :-
    CurRow < StartRow,
    CurRowI is CurRow+1,
    inRow(RestMaze, CurRowI, CurColumn, (StartRow, StartColumn), X).

inColumn([Element|_], CurRow, CurColumn, (StartRow, StartColumn), Element) :- 
    CurColumn =:= StartColumn.

inColumn([_|RestList], CurRow, CurColumn, (StartRow, StartColumn), X) :-
    CurColumn < StartColumn,
    CurColumnI is CurColumn+1,
    inColumn(RestList, CurRow, CurColumnI, (StartRow, StartColumn), X).
