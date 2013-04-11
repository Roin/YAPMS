% This file contains some test mazes, you can add your own if you like

% Need to group the size facts or Prolog complains
mazeSize(small, 4, 7).
mazeSize(nobarrier, 10, 10).
mazeSize(unsolvable, 4, 4).
mazeSize(sparse, 7, 7).
mazeSize(unknown, 8, 8).

% A small maze
maze(small, 1, 2, barrier).
maze(small, 1, 3, barrier).
maze(small, 2, 2, barrier).
maze(small, 5, 1, barrier).

% A no barrier maze, it has no barrier facts, see the size facts above.

% An unsolvable maze, it has a barrier at column 3
maze(unsolvable, 3, 1, barrier).
maze(unsolvable, 3, 2, barrier).
maze(unsolvable, 3, 3, barrier).
maze(unsolvable, 3, 4, barrier).

% A big sparse maze, easy to solve
maze(sparse, 1, 3, barrier).
maze(sparse, 3, 4, barrier).
maze(sparse, 2, 1, barrier).
maze(sparse, 7, 6, barrier).
maze(sparse, 6, 2, barrier).
maze(sparse, 4, 6, barrier).
maze(sparse, 2, 5, barrier).

% A big unknown maze, can it be solved?
maze(unknown, 3, 1, barrier).
maze(unknown, 3, 2, barrier).
maze(unknown, 3, 3, barrier).
maze(unknown, 3, 4, barrier).
maze(unknown, 2, 1, barrier).
maze(unknown, 2, 3, barrier).
maze(unknown, 7, 6, barrier).
maze(unknown, 6, 2, barrier).
maze(unknown, 6, 7, barrier).
maze(unknown, 5, 8, barrier).
maze(unknown, 4, 6, barrier).
maze(unknown, 5, 2, barrier).
maze(unknown, 6, 4, barrier).
maze(unknown, 7, 3, barrier).
maze(unknown, 8, 2, barrier).
maze(unknown, 4, 4, barrier).
maze(unknown, 5, 4, barrier).
