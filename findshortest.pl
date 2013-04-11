shortestList([List|[]],List,Min):- 
    length(List, Min).

shortestList([Head|Rest], List, Min) :- 
    shortestList(Rest, NewList, NewMin), 
    length(Head, MyMin), 
    (
        (MyMin =< NewMin, List = Head, Min=MyMin)
        ;
            (NewMin =< MyMin, List = NewList, Min=NewMin)
            ). 
