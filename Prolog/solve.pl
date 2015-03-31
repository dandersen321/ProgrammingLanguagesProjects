%-----------------------------------------------------------------------
% The try predicate tries to move down, then left
% if down fails, then right if left fails, etc.
% By reordering the rules, the direction of the
% search in the maze can be changed.
%-----------------------------------------------------------------------
% Down
try(Row, Col, ToRow, Col) :- ToRow is Row + 1.
% Left
try(Row, Col, Row, ToCol) :- ToCol is Col + 1.
% Right
try(Row, Col, Row, ToCol) :- ToCol is Col - 1.
% Up
try(Row, Col, ToRow, Col) :- ToRow is Row - 1.

%-----------------------------------------------------------------------
% The memberOf(X, L) predicate suceeds if X is a member of list L.
%-----------------------------------------------------------------------
memberOf(H, [H|_]). 
memberOf(H, [X|T]) :- X \== H, memberOf(H, T).

%-----------------------------------------------------------------------
% The visit(X, L, NL) predicate suceeds if X is not a member of List L,
% and adds X to list L creating list NL.  If X is already in the list L
% it fails.
%-----------------------------------------------------------------------
visit(H, [], [H]). 
visit(X, [H|T], [H|NL]) :- X \== H, visit(X, T, NL).

%-----------------------------------------------------------------------
% The printCell(Maze, List, Row, Col) predicate prints an individual cell 
% in the maze, if Row, Col is a
%   - barrier then print an x
%   - a corner then print a +
%   - a top or bottom boundary then print a -
%   - a side boundary then print a |
%   - in the list of visited celss, then print a *
%   - by default print a blank
%-----------------------------------------------------------------------
% Print a barrier if it is there.
printCell(Maze, _, Row, Col) :- maze(Maze, Row, Col, barrier), write('x').
% Upper left corner
printCell(_, _, 0, 0) :- write('+').
% Upper right corner
printCell(Maze, _, Row, 0) :- mazeBoundary(Maze, Row, 0), write('+').
% Lower left corner
printCell(Maze, _, 0, Col) :- mazeBoundary(Maze, 0, Col), write('+').
% Lower right corner
printCell(Maze, _, Row, Col) :- mazeBoundary(Maze, Row, Col), write('+').
% Right boundary
printCell(_, _, 0, _) :- write('-').
% Left boundary
printCell(Maze, _, Row, _) :- mazeBoundary(Maze, Row, 0), write('-').
% Top boundary
printCell(_, _, _, 0) :- write('|').
% Bottom boundary
printCell(Maze, _, _, Col) :- mazeBoundary(Maze, 0, Col), write('|').
% Member of the list
printCell(_, L, Row, Col) :- memberOf([Row,Col], L), write('*').
% Default
printCell(_, _, _, _) :- write(' ').

%----------------CUSTOM PRINT MAZE FUNCTIONS-------------------------------------
printList([]):- true.
%recurisvely prints through a given list, printing the head and then recursively calling the function on the tail
printList([H|T]) :- write(H), write('\n'), printList(T).
printMaze(Maze,List) :- printMazeHelper(Maze, List, 0, 0).

%iterates through each cell in the maze and prints the corresponding value
printMazeHelper(Maze, List, Row, Col):- printCell(Maze, List, Row, Col), mazeSize(Maze, MaxRowSize, MaxColSize), nextCellValues(Row, Col, MaxRowSize, MaxColSize, NewRow, NewCol), printMazeHelperShouldContinue(NewRow, NewCol, MaxRowSize, MaxColSize, Continue), (Continue = true -> printMazeHelper(Maze, List, NewRow, NewCol); write('+')), !.

%fails if the printMaze has printed all of the maze
printMazeHelperShouldContinue(Row, Col, MaxRowSize, MaxColSize, Continue):-
( Row =< MaxRowSize
    -> Continue = true
    ;  (Col =< MaxColSize
		-> Continue = true
	; Continue = false)
     ).

%used when iterating through every cell of a maze to print it, it will add one to the column, unless we have reached the end of the columns at which point the cols start back at 0 and we move down a row (i.e. we are printing starting at the top-left and going column by column on that row and then down a row).
nextCellValues(Row, Col, MaxRowSize, MaxColSize, NewRow, NewCol) :-
(  Col =< MaxColSize
    -> NewCol is Col + 1,
	   NewRow is Row
    ;  NewCol is 0,
	   NewRow is Row + 1,
	   write('\n')
     ).
%------------------------SOLVE MAZE FUNCTIONS-------------------------------------
%succeeds when the either the row is 0 or greater than the maxRowSize, or if the col is 0 or greater than the maxColSize
mazeBoundary(Maze, 0, Col):- mazeSize(Maze, MaxRowSize, MaxColSize), Col > MaxColSize .
mazeBoundary(Maze, Row, 0):- mazeSize(Maze, MaxRowSize, MaxColSize), Row > MaxRowSize.
mazeBoundary(Maze, Row, Col):- Row == 0, Col == 0.
mazeBoundary(Maze, Row, Col):- mazeSize(Maze, MaxRowSize, MaxColSize), Row > MaxRowSize, Col > MaxColSize.

%solves the maze, it will start at (0,1) and the first move will be to (1,1). It will ten continue to solve the maze from (1,1) trying down, left, right, up respectively and if none of those paths work, it will fail because the maze is unsolvable.
%it it calls the solveHelper function for its recursion, and will be true if the solveHelper ever reaches a Cell that is the goal cell.
solve(Maze):- solveHelper(Maze, [], 0,1), !.

%recursive function base case, succeeds if current row and col is on the goal cell, then prints the moveList and the solved maze if the maze was solved
solveHelper(Maze, GoodList, Row, Col):- maze(Maze, Row, Col, goal), printList(GoodList),printMaze(Maze, GoodList).
%recursive worker function for solving the maze. it will first try different directions in solving the maze, it will then check if the direction it chose was valid (within maze boundary and not on a barrier), and if it was a valid move it will visit that cell.  if the cell has already been visited it fails. if the cell was not visited, it adds it to the visited list then continues the recursion at the new cell position. 
solveHelper(Maze, GoodList, Row, Col):- try(Row, Col, NewRow, NewCol), isInBounds(Maze, NewRow, NewCol), visit([NewRow, NewCol], GoodList, ReturnList), solveHelper(Maze, ReturnList, NewRow, NewCol).

%checks if the current row and col are valid, fails if not valid
isInBounds(Maze, Row, Col):- maze(Maze, Row, Col, goal).
isInBounds(Maze, Row, Col):- maze(Maze, Row, Col, free).