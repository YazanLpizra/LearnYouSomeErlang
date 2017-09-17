-module(recursion).
-export([fac/1, len/1, tail_fac/1, tail_len/1, duplicate/2, tail_reverse/1, sublist/2, zip/2]).

fac(N) when N>1 -> N*fac(N-1);
fac(_) -> 1.

tail_fac(N) -> tail_fac(N, 0).
tail_fac(N, Acc) when N>1 -> tail_fac(N-1, N*Acc);
tail_fac(N, Acc) when N==1 -> Acc.

len([]) -> 0;
len([_]) -> 1;
len([_|T]) -> 1+len(T).

tail_len(L) -> tail_len(L, 0).
tail_len([], _) -> 0;
tail_len([_], Acc) -> Acc+1;
tail_len([_|T], Acc) -> tail_len(T,Acc+1).

duplicate(Count, X) -> duplicate(Count, X, []).
duplicate(Count, X, Acc) when Count>1 -> duplicate(Count-1, X, [X|Acc]);
duplicate(_, X, Acc) -> [X|Acc].

tail_reverse(L) -> tail_reverse(L,[]).
tail_reverse([H|T], L) when length([H|T])>0 -> tail_reverse(T, [H|L]);
tail_reverse([], L) -> L.

sublist(L,Num) when length(L)<Num -> L;
sublist([],_)->[];
sublist(L,Num)->sublist(L,Num,[]).
sublist([H|T],Num,Acc) when length(Acc)<Num -> sublist(T,Num,Acc++[H]);
sublist([_|_],_,Acc) -> Acc.

zip(X,Y) -> zip(X,Y,[]).
zip([Xh|Xt], [Yh|Yt], Acc) -> 
    zip(Xt,Yt, Acc++[{Xh,Yh}]);
zip(X,Y,Acc) when length(X) == 0; length(Y) == 0 -> Acc.