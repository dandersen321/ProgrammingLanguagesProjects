% This file contains some test mazes, you can add your own if you like

% Need to group the size facts or Prolog complains
mazeSize(small, 4, 7).
mazeSize(nobarrier, 4, 4).
mazeSize(unsolvable, 4, 4).
mazeSize(unknown, 7, 7).

% A small maze
maze(small, 1, 1, free).
maze(small, 1, 2, free).
maze(small, 1, 3, free).
maze(small, 1, 4, free).
maze(small, 1, 5, free).
maze(small, 1, 6, free).
maze(small, 1, 7, free).

maze(small, 2, 1, free).
maze(small, 2, 2, barrier).
maze(small, 2, 3, free).
maze(small, 2, 4, free).
maze(small, 2, 5, free).
maze(small, 2, 6, free).
maze(small, 2, 7, free).

maze(small, 3, 1, free).
maze(small, 3, 2, barrier).
maze(small, 3, 3, free).
maze(small, 3, 4, free).
maze(small, 3, 5, free).
maze(small, 3, 6, free).
maze(small, 3, 7, free).

maze(small, 4, 1, free).
maze(small, 4, 2, barrier).
maze(small, 4, 3, free).
maze(small, 4, 4, free).
maze(small, 4, 5, free).
maze(small, 4, 6, free).
maze(small, 4, 7, goal).

% A no barrier maze, it has no barrier facts, see the size facts above.
maze(nobarrier, 1, 1, free).
maze(nobarrier, 1, 2, free).
maze(nobarrier, 1, 3, free).
maze(nobarrier, 1, 4, free).

maze(nobarrier, 2, 1, free).
maze(nobarrier, 2, 2, free).
maze(nobarrier, 2, 3, free).
maze(nobarrier, 2, 4, free).

maze(nobarrier, 3, 1, free).
maze(nobarrier, 3, 2, free).
maze(nobarrier, 3, 3, free).
maze(nobarrier, 3, 4, free).

maze(nobarrier, 4, 1, free).
maze(nobarrier, 4, 2, free).
maze(nobarrier, 4, 3, free).
maze(nobarrier, 4, 4, goal).

% An unsolvable maze, it has a barrier at row 3
maze(unsolvable, 1, 1, free).
maze(unsolvable, 1, 2, free).
maze(unsolvable, 1, 3, free).
maze(unsolvable, 1, 4, free).

maze(unsolvable, 2, 1, free).
maze(unsolvable, 2, 2, free).
maze(unsolvable, 2, 3, free).
maze(unsolvable, 2, 4, free).

maze(unsolvable, 3, 1, barrier).
maze(unsolvable, 3, 2, barrier).
maze(unsolvable, 3, 3, barrier).
maze(unsolvable, 3, 4, barrier).

maze(unsolvable, 4, 1, free).
maze(unsolvable, 4, 2, free).
maze(unsolvable, 4, 3, free).
maze(unsolvable, 4, 4, goal).

% An unknown maze
maze(unknown, 1, 1, free).
maze(unknown, 1, 2, free).
maze(unknown, 1, 3, free).
maze(unknown, 1, 4, barrier).
maze(unknown, 1, 5, barrier).
maze(unknown, 1, 6, free).
maze(unknown, 1, 7, free).

maze(unknown, 2, 1, free).
maze(unknown, 2, 2, barrier).
maze(unknown, 2, 3, free).
maze(unknown, 2, 4, free).
maze(unknown, 2, 5, barrier).
maze(unknown, 2, 6, barrier).
maze(unknown, 2, 7, free).

maze(unknown, 3, 1, free).
maze(unknown, 3, 2, barrier).
maze(unknown, 3, 3, barrier).
maze(unknown, 3, 4, free).
maze(unknown, 3, 5, barrier).
maze(unknown, 3, 6, barrier).
maze(unknown, 3, 7, free).

maze(unknown, 4, 1, free).
maze(unknown, 4, 2, free).
maze(unknown, 4, 3, free).
maze(unknown, 4, 4, free).
maze(unknown, 4, 5, barrier).
maze(unknown, 4, 6, free).
maze(unknown, 4, 7, free).

maze(unknown, 5, 1, free).
maze(unknown, 5, 2, barrier).
maze(unknown, 5, 3, barrier).
maze(unknown, 5, 4, free).
maze(unknown, 5, 5, free).
maze(unknown, 5, 6, free).
maze(unknown, 5, 7, barrier).

maze(unknown, 6, 1, free).
maze(unknown, 6, 2, free).
maze(unknown, 6, 3, free).
maze(unknown, 6, 4, free).
maze(unknown, 6, 5, barrier).
maze(unknown, 6, 6, free).
maze(unknown, 6, 7, barrier).

maze(unknown, 7, 1, free).
maze(unknown, 7, 2, barrier).
maze(unknown, 7, 3, free).
maze(unknown, 7, 4, free).
maze(unknown, 7, 5, barrier).
maze(unknown, 7, 6, free).
maze(unknown, 7, 7, goal).
