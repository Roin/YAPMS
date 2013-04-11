% Try a move in an "Up" direction, assumes X and Y are bound.
try(X, Y, NextX, NextY) :- NextX is X, NextY is Y - 1.

% Make one move, fails if landed on a boundary or a barrier, otherwise
% succeeds and establishes a new X and Y.
moveOne(Maze, X, Y, NextX, NextY) :- 
  try(X, Y, NextX, NextY), mazeSize(Maze, MaxRows, MaxCols), 
  NextX =< MaxCols, NextX > 0, NextY =< MaxRows, NextY > 0,
  % Note that \+ is negation by failure, that is the goal succeeds if
  % there is no maze fact that is a barrier at the NextX, NextY coordinates.
  \+ maze(Maze, NextX, NextY, barrier).

% move(Maze, List, NewList, X, Y, GoalX, GoalY) - moves, and keep on moving 
% until the GoalX and GoalY coordinates are reached. List is the list of 
% previous moves (important to check that the current move is not one
% previously made), NewList will be bound to the list of successful moves
% in a solved maze.
%
% Base case, done, when X and Y are the goal coordinates, in which case, bind
% the incoming List to the outgoing List.
move(_, List, List, X, Y, X, Y).
% Recursive case...
move(Maze, List, NewList, X, Y, GoalX, GoalY) :- true.

% memberOf(H, L), is H a member of list L? 
% succeeds if true, fails if false
% Recursive case
memberOf(H, [X|T]) :- X \== H, memberOf(H, T).

% visit(H, L, NL), fails if H is a member of L, otherwise suceeds
% and binds NL to the L with H inserted. 
% Base case - H is not in the empty list so add it.
visit(H, [], [H]). 
% Recursive case still needed.

% printCell(Maze, List, X, Y) - helper goal for printMaze, printCell
% prints a single cell in the maze.
% Print a barrier.
printCell(Maze, _, X, Y) :- maze(Maze, X, Y, barrier), write('x').
% Upper left corner
printCell(_, _, 0, 0) :- write('+').
% Right boundary
printCell(_, _, 0, _) :- write('|').
% Left boundary
printCell(Maze, _, X, _) :- mazeBoundary(Maze, _, X), write('|').
% Last case, part of the maze, print a blank.
printCell(_, _, _, _) :- write(' ').

%printMaze(Maze, List) - formatted printout of the Maze with a trail 
%through it given by the List.
printMaze(Maze, List) :- true.

%printList(List) - formatted print of the list of successful moves
% Base case end of list
printList([]) :- writeln('').

%solve(Maze) - Solve the maze!
solve(Maze) :- true.
