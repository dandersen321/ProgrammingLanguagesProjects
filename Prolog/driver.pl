% Load the maze.pl file
?- consult(maze).
% Load the solve.pl file
?- consult(solve).
%?- consult(solution).

% Solve the small maze
?- solve(small).

?-solve(nobarrier).

?-solve(unsolvable).

?-solve(unknown).