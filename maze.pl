start(a).
finish(u).
route(a,g).
route(g,l).
route(l,s).
route(s,a).
route(l,u).
travel(A,A).
travel(A,C) :- route(A,B),travel(B,C).
solve :- start(A),finish(B), travel(A,B).
travellog(A,A,[]).
travellog(A,C,[A-B|Steps]) :-
route(A,B), travellog(B,C,Steps).
solve(L) :- start(A), finish(B),
travellog(A,B,L).
