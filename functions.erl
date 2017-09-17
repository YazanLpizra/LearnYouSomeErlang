-module(functions).
-export([head/1,second/1,areEqual/2,valid_time/1,wrong_age/1,heh_fine/0,help_me/1]).

head([H|_]) -> H.
second([_,X|_]) -> X.

areEqual(X,X) -> true;
areEqual(_,_) -> false.

valid_time({Date={Y,M,D}, Time={H,Min,S}}) ->
    io:format("The date tuple (~p) says today is: ~p/~p/~p,~n",[Date,Y,M,D]),
    io:format("The time tuple (~p) indicates: ~p:~p.~p~n",[Time, H,Min, S]).

% problem with above is that any tuple that fits the structure will pass. solution is to use guards
%% Important point about guards. you can use built-in funcitons, but not user defined funtions as guards
wrong_age(X) when x < 16; X > 104 -> 
    true;
wrong_age(_) ->
    false.

%% in erlang, IF's are called guard clauses. not the same as standard if statements

heh_fine()->
    if 1 =:=1 ->
        works
    end,
    if 1=:=2; 1=:=1 ->
        works
    end,
    if 1=:=2, 1=:=1 ->
        fails;
        true -> default_value
    end.

help_me(Animal)->
    Talk = if Animal == cat -> "meow";
              Animal == tree -> "silent bark";
              Animal == dog -> "loud bark";
              true -> "default"
            end,
    {Animal, "says "++Talk ++ "!"}.

insert(X,[])->
    [X];
insert(X,Set)->
    case lists:member(X,Set) of
        true -> Set;
        false -> [X|Set]
    end.

beach(Temp)->
    case Temp of
        {celcius, N} when N >= 20, N =< 45 -> 'celcius Favorable';
        {kelvin, N} when N >= 293, N =< 318 -> 'kelvin Favroable';
        {fahrenheit, N} when N >= 20, N =< 45 -> 'Murica Favorable';
        _ -> 'gtfo the beach'
    end.

        