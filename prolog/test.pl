% Load the maze.pl file
?- consult(maze).
% Load the solve.pl file
?- consult(solve).

% Should print a '+'
?- printCell(small, [], 0, 0).

% Solve the small maze
?- solve(small).
