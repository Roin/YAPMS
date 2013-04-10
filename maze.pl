:start(a).
finish(q).
route(a,d).
route(d,i).
route(i,p).
route(p,q).
route(l,d).
route(q,v).
route(v,d).
route(a,g).
route(g,l).
route(l,s).
route(s,u).
travel(A,A).
travel(A,C) :- route(A,B),travelsafe(B,C).
%solve :- start(A),finish(B), travel(A,B).
travellog(A,A,[]).
travellog(A,C,[A-B|Steps]) :-
route(A,B), travellog(B,C,Steps),!.
solve(L) :- start(A), finish(B),
travellog(A,B,L).
travelsafe(A,A,_).
travelsafe(A,C,Closed) :-
route(A,B), \+ member(B,Closed),
travelsafe(B,C,[B|Closed]).






