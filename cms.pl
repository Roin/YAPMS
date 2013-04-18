%% maze solving algorithm by Florian Kanngießer (7353550) and Christian Burkard (4206853)
% To get some example querries check the bottom of this file in the Examples section.


%% Call: maze(+MazeList, +Start, +Goal, -ShortestPath)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Start: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              Goal: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              ShortestPath: A list containing the shortest path which solves the maze.
%
%   This is the "API" function. This function starts the maze solving algorithm.
%   It finds the shortest path for a given maze, given some start and goal coordinates.
%%
maze(MazeList, Start, Goal, ShortestPath) :-
    isValidStartField(MazeList, Start),!,
    isValidGoalField(MazeList, Goal),!,
    getShortestPath(MazeList, Start, Goal, ShortestPath).


%% Call: getShortestPath(+MazeList, +Start, +Goal, -ShortestPath)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Start: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              Goal: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              ShortestPath: A list containing the shortest path which solves the maze.
%
%   Calls the findAllPaths/4 function and determines its shorteset path.
%   This path is printed to screen then.
%%
getShortestPath(MazeList, Start, Goal, ShortestPath) :-
    findAllPaths(MazeList, Start, Goal, AllPaths),
    findShortestPath(AllPaths, ShortestPath, PathLength),!,
    nl,
    write('##############################################################################'),nl,
    write('Shortest Path with length '),
    write(PathLength),
    write(' is: '),nl,
    write(ShortestPath),nl,
    write('##############################################################################'),nl.


%% Call: findShortestPath(+Paths, -ShortestPath, -PathLength)
%                Paths: A list containing paths.
%                ShortestPath: The shortest path in the list Paths
%                PathLength: The length of the shortest path in Paths
%   
%   Finds the shortest path and length from a given list containing possible solution paths.
%%
findShortestPath([CurPath|[]], CurPath, Min) :-
    length(CurPath, Min).

findShortestPath([CurPath|RestPath], ShortestPath, Min) :-
    findShortestPath(RestPath, NewPath, NewMin),
    length(CurPath, CurMin),
    (
        (CurMin =< NewMin, ShortestPath = CurPath, Min = CurMin)
        ;
            (CurMin >= NewMin, ShortestPath = NewPath, Min = NewMin)
            ).




%% Call: findAllPaths(+MazeList, +Start, +Goal, +AllPaths)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Start: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              Goal: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              AllPaths: A list that contains any possible path through the maze.
%
%   Finds any possible solution through the maze by calling the check function until no new solution is found.
%   This is done by the swi prolog built-in findall/3 function.
%%
findAllPaths(MazeList, Start, Goal, AllPaths) :-
    findall(Path, check(MazeList, Start, Goal, [Start], Path), AllPaths).


%% Call: check(+MazeList, +Start, +Goal, +Visited, -Path)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Start: A tupel containing the starting coordinates. Ex.: (1,1) for starting on the top left position.
%              Goal: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              [Start]: The visited list, that contains the already visited nodes of the maze, is initialized with the start position.
%              Path: A list that contains a valid path, in form of coordinates, through the maze.
%
%   Finds a path through the maze by checking whether the current coordinate is the goal.
%   If not it starts looking to the right-hand coordinate, then bottom, left-hand and finally the top coordinate.
%   The first coordinate which is walkable (0) and not already in the visited list will be moved to.
%%               

% Check current position for the goal
check(MazeList, (CurRow, CurColumn), (Goal1, Goal2), Visited, Path) :-
    CurRow =:= Goal1,
    CurColumn =:= Goal2,
    isValidField(MazeList, (CurRow, CurColumn)),
    reverse(Visited, Path).


% check east unvisited
check(MazeList, (CurRow, CurColumn), Goal, Visited, Path) :-
    CurColumnI is CurColumn + 1,
    isValidField(MazeList, (CurRow, CurColumn)),
    isNotVisited((CurRow, CurColumnI), Visited),
    move(MazeList, (CurRow, CurColumnI), Goal, Visited, Path).


% check south unvisited
check(MazeList, (CurRow, CurColumn), Goal, Visited, Path):-
    CurRowI is CurRow + 1,
    isValidField(MazeList, (CurRow, CurColumn)),
    isNotVisited((CurRowI,CurColumn), Visited),
    move(MazeList, (CurRowI, CurColumn), Goal, Visited, Path).



% check west unvisited
check(MazeList, (CurRow, CurColumn), Goal, Visited, Path) :-
    CurColumnI is CurColumn - 1,
    isValidField(MazeList, (CurRow, CurColumn)),
    isNotVisited((CurRow,CurColumnI),Visited),
    move(MazeList, (CurRow,CurColumnI), Goal, Visited, Path).


% check north unvisited
check(MazeList, (CurRow, CurColumn), Goal, Visited, Path) :-
    CurRowI is CurRow - 1,
    isValidField(MazeList, (CurRow, CurColumn)),
    isNotVisited((CurRowI,CurColumn), Visited),
    move(MazeList, (CurRowI, CurColumn), Goal, Visited, Path).


%% Call: move(+MazeList, (+CurRow, +CurColumn), +Goal, +Visited, -Path)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              CurRow: Y-coordinate of the current position.
%              CurColumn: X-coordinate of the current position.
%              Goal: A tupel containing the coordinates to the exit of the maze. Ex.: (5,5).
%              Visited: The visited list, that contains the already visited nodes of the maze.
%              Path: A list that contains the path which was taken to reach the current possition
%
%   move performs the actual move to a new field of the maze.
%   It appends the coordinates of the new field to the visited list.
move(MazeList, (CurRow, CurColumn), Goal, Visited, Path) :-
    check(MazeList, (CurRow, CurColumn), Goal, [(CurRow, CurColumn)|Visited], Path).

%% Call: isNotVisited((+Row, +Column), +Visited)
%               Row: The Y-coordinate of the tested field.
%               Column: The X-coordinate of the tested field.
%               Visited: The list that contains all already visited positions in the maze.
%
%   Tests if the given coordinate is already in the visited list.
%   Actually works like the negated swi prolog build-in member/2 function. (But we didn't know it before)
%
%   Is TRUE if the field was not visited, yet.
%%
isNotVisited((Row, Column), Visited) :-
    \+isVisited(Row, Column, Visited).

isVisited(_, _, []) :-
    false.

isVisited(Row, Column, [(X,Y)|_]) :-
    Row =:= X,
    Column =:= Y.

isVisited(Row, Column, [_|Visited]) :-
    isVisited(Row, Column, Visited).


%% Call: isValidField(+MazeList, +Coordinate)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Coordinate: A tupel containing the coordinates which will be checked.
%
%   Is TRUE if the field is a valid (walkable) position in the maze.
%%
isValidField(Maze, Coordinate) :-
    getValue(Maze, Coordinate, Value),
    Value =:= 0.

isValidStartField(Maze, (Row, Column)) :-
    isValidField(Maze, (Row, Column)).

isValidStartField(_, (Row, Column)) :-
    write('Start ('),
    write(Row),
    write(','),
    write(Column),
    write(') is not walkable.'),nl,
    false.

isValidGoalField(Maze, (Row, Column)) :-
    isValidField(Maze, (Row, Column)).

isValidGoalField(_, (Row, Column)) :-
    write('Goal ('),
    write(Row),
    write(','),
    write(Column),
    write(') is not walkable.'),nl,
    false.

%% Call: getValue(+MazeList, +Coordinate, -Value)
%              MazeList: A list containing the maze. See examples on the bottom for the format.
%              Coordinate: A tupel containing the coordinates which will be checked.
%              Value: The value of the maze's field with coordinates given by Coordinate.
%
%   Gets the value of a given field in the maze.
%%
getValue(MazeList, Coordinate, Value) :-
    inRow(MazeList, 1, 1, Coordinate, Value).

inRow([Row|_], CurRow, CurColumn, (GoalRow, GoalColumn), Value) :-
    CurRow =:= GoalRow,
    inColumn(Row, CurRow, CurColumn, (GoalRow, GoalColumn), Value).

inRow([_|RestMaze], CurRow, CurColumn, (GoalRow, GoalColumn), Value) :-
    CurRow < GoalRow,
    CurRowI is CurRow+1,
    inRow(RestMaze, CurRowI, CurColumn, (GoalRow, GoalColumn), Value).

inColumn([Element|_], _, CurColumn, (_, GoalColumn), Element) :- 
    CurColumn =:= GoalColumn.

inColumn([_|RestList], CurRow, CurColumn, (GoalRow, GoalColumn), Value) :-
    CurColumn < GoalColumn,
    CurColumnI is CurColumn+1,
    inColumn(RestList, CurRow, CurColumnI, (GoalRow, GoalColumn), Value).


%%
%       E X A M P L E S
%%

%% Here you can find some examples for the maze solving algorithm.
%  To use them append them to your maze/4 function call.
%  This can look like: 
%            ex1(Maze),maze(Maze,(2,1), (6,6), Path).

%% Example query ex1:
%  ex1(Maze),maze(Maze,(1,6),(6,2),X).
%  ex1(Maze),maze(Maze,(2,5),(4,4),X).
ex1([
[1,1,1,1,1,0],
[0,0,0,0,0,0],
[0,0,0,1,1,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,1,0]]).

%% Example query ex2:
%  ex2(Maze),maze(Maze,(2,4),(4,4),X).
%  ex2(Maze),maze(Maze,(5,6),(2,1),X).
ex2([
[1,1,1,1,1,0],
[0,0,0,0,0,0],
[0,0,0,1,1,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,0,0]]).

%% Example query ex3:
%  ex3(Maze),maze(Maze,(2,3),(5,5),X).
%  ex3(Maze),maze(Maze,(6,2),(3,1),X).
ex3([
[1,1,1,1,0,1],
[0,0,0,1,0,0],
[0,1,0,0,0,0],
[1,1,0,0,1,0],
[1,1,0,0,0,0],
[1,0,0,0,0,0]]).

%% Example query ex4:
%  ex4(Maze),maze(Maze,(1,1),(5,8),X).
%  ex4(Maze),maze(Maze,(13,1),(3,9),X).
ex4([
[0,0,1,1,1,0,0,0,0,0,0,0,1],
[1,0,1,1,1,0,1,1,0,1,1,0,1],
[1,0,0,0,0,0,1,1,0,1,1,0,1],
[1,0,1,0,1,0,1,1,0,1,1,0,1],
[0,0,1,0,0,0,1,0,0,0,1,0,1],
[1,1,1,0,1,0,0,0,1,0,1,0,1],
[1,0,1,0,0,1,1,1,1,0,1,0,1],
[0,0,1,0,0,0,1,1,1,0,1,0,1],
[1,0,1,0,1,0,0,0,1,0,1,0,1],
[0,0,0,0,1,1,1,0,0,0,1,0,1],
[1,0,1,0,0,0,1,1,1,1,1,0,1],
[0,0,1,0,1,0,0,0,0,0,0,0,1],
[0,1,1,0,1,1,1,1,1,1,1,1,1]]).


