%returns the nth element from the list
nth([F|_],1,F).
nth([_|R],N,M) :- N > 1, N1 is N-1, nth(R,N1,M).

%returns true if cell is empty: gets the cell value at (StartRow,StartColumn) and returns whether the value is 0
isempty(Maze,StartRow,StartColumn) :- nth(Maze,StartRow,Line),nth(Line,StartColumn,Y), Y == 0.

%returns the head of the list
head([Elem|_],Elem).

%find accessible returns empty list if not in maze size (1 to N for row and column)
findaccessible(Maze, (StartRow,StartColumn), [], _) :- head(Maze,L),length(L,N), (StartColumn > N ; StartRow > N ; StartColumn < 1 ; StartRow < 1).

%find all empty cells and retain them in X. L retains the current found cells in order to avoid returning to visited positions.
findaccessible(Maze, (StartRow,StartColumn), X, L) :-
  %if cell is empty, retain position and add it to the list
  isempty(Maze,StartRow,StartColumn) -> (union(L,[(StartRow,StartColumn)],L1),X1 = [(StartRow,StartColumn)],

  %check right column and if element not visited, find all accessible cells from that point and unify the lists
  SR is StartRow, SC is StartColumn+1,(member((SR,SC),L) -> union(X1,[],X2) ; (findaccessible(Maze, (SR,SC), Tmp1, L1), union(X1,Tmp1,X2))),
  %check down row and if element not visited, find all accessible cells from that point and unify the lists
  SR2 is StartRow+1,SC2 is StartColumn, (member((SR2,SC2),L) -> union(X2,[],X3) ; (findaccessible(Maze, (SR2,SC2), Tmp2, L1), union(X2,Tmp2,X3))),
  %check left column and if element not visited, find all accessible cells from that point and unify the lists

  SR3 is StartRow, SC3 is StartColumn-1, (member((SR3,SC3),L) -> union(X3,[],X4) ; (findaccessible(Maze, (SR3,SC3), Tmp3, L1), union(X3,Tmp3,X4))),
  %check up row and if element not visited, find all accessible cells from that point and unify the lists
  SR4 is StartRow-1, SC4 is StartColumn, (member((SR4,SC4),L) -> union(X4,[],X) ; (findaccessible(Maze, (SR4,SC4), Tmp4, L1), union(X4,Tmp4,X)))) ; X = [].

%lists each result
%if no more results return false
%results(_,[]) :- fail.
%return the result or return the rest of the results
results(X,[Head|Rest]) :- X = Head ; results(X,Rest).

%accessible predicate that finds all empty accessible cells and then list each of them
accessible(Maze, (StartRow,StartColumn), X) :- findaccessible(Maze, (StartRow,StartColumn), Lst, []), !, results(X,Lst).

%accessible([[0, 0, 0, 1, 0], [0, 1, 1, 1, 0], [0, 0, 1, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0]], (1, 1), X).
%sample test run
%
%Lets check if we can make this work :-)
travel(A,A).
travel(A,C):-
	route(A,B),
	travelave(B,C).
travellog(A,A,[]).
travellog(A,C,[A-B|Steps]):-
	route(A,B),
	travellog(B,C,Steps),!.
solve(L):- start(A), finish(B),
	travellog(A,B,L).
travelsave(A,A,_).



























