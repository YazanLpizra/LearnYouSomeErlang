-module(hhfuns).
-export([even/1, filter/2, reduce/3, reduce_reverse/1, reduce_filter/2 , reduce_map/2]).

% one() -> 1.
% two() -> 2.
% add(X,Y) -> X() + Y().

% increment([]) -> [];
% increment([H|T]) -> [H+1|increment(T)].

% decrement([]) -> [];
% decrement([H|T]) -> [H-1|decrement(T)].

% map(_,[]) -> [];
% map(F,[H|T]) ->
%     [F(H)|map(F, T)].

% incr(X) -> X+1.
% decr(X) -> X-1.

% %% anonymous functions
% a() ->
%     Secret = "pony",
%     fun() -> Secret end.
% b(F) -> 
%     "A/0's password is "++F().

%% Anon functions generally cant be recursive because they cant call themselves
% Erlang 17.0 allows named anon fn's to now support recursion
% PrepareRoom = fun(Room) ->
%     io:format("Alarm set in room ~s~n",[Room]),
%     fun Loop() -> 
%         io:format("Alarm tripped in room ~s! Call Batman!~n",[Room]),
%         timer:sleep(500),
%         Loop()
%     end
% end.

%% only keep even numbers
even(L) -> lists:reverse(even(L,[])).
even([H|T], Acc) when H rem 2 == 0 -> even(T,[H|Acc]);
even([_|T],Acc) -> even(T,Acc);
even([],Acc) -> Acc.

filter(Pred, L) -> lists:reverse(filter(Pred,L,[])).
filter(_,[],Acc)->Acc;
filter(Pred,[H|T],Acc)->
    case Pred(H) of
        true -> filter(Pred, T,[H|Acc]);
        false -> filter(Pred, T,Acc)
end.

reduce(_, [], Acc) -> Acc;
reduce(Pred,[H|T],Acc) -> reduce(Pred, T, Pred(Acc, H)).
%% hhfuns:reduce(fun(A,H) when A>H->A; (A,H)->H  end, [1,2,34,5],0).

%% implementing reverse, map, filter with reduce
reduce_reverse(L) -> reduce(fun(A,H)-> [H|A] end,L,[]).

reduce_filter(Pred, L) -> reduce_reverse(reduce(fun(A,H) -> 
    case Pred(H) of 
        true-> [H|A]; 
        false->A
    end 
end, L, [])).

reduce_map(Pred,L)-> reduce_reverse(reduce(fun(A,H)-> [Pred(H)|A] end, L,[])).