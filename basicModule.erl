-module(basicModule).
-export([add/2, greet_and_add_two/1]).
-define(sub(X,Y), X-Y).


add(A,B)->
    A+B.

hello() -> 
    io:format("Hello, world!~n").

greet_and_add_two(X)->
    hello(),
    add(X, ?sub(4,2)).

% use pattern matching to define methods that are based on different args
greet(male, Name) ->
    io:format("Hello, Mr. ~s!", [Name]).

greet(female, Name) ->
    io:format("Hello, Mrs. ~s!", [Name]).
    
greet(_, Name) ->
    io:format("Hello, ~s!", [Name]).

