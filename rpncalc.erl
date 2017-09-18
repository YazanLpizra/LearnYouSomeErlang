-module(rpncalc).
-export([evaluate/1]).

evaluate(Exp) ->
    evaluate(string:tokens(Exp," "), []).

evaluate(_, [X]) ->
    X;
evaluate([H|T], Stack) when string:to_integer(H) =/= {error,_} ->
    io:format("Head: ~s~n",[H]),
    io:format("Tail: ~p~n",[T]),
    io:format("Stack: ~p~n",[Stack]),
    evaluate(T, [list_to_integer(H)|Stack]);
evaluate([H|T], Stack) when string:to_float(H) =/= {error,_} ->
    io:format("Head: ~s~n",[H]),
    io:format("Tail: ~p~n",[T]),
    io:format("Stack: ~p~n",[Stack]),
    evaluate(T, [list_to_float(H)|Stack]);
evaluate([H|T], Stack) ->
    io:format("Head: ~s~n",[H]),
    io:format("Tail: ~p~n",[T]),
    io:format("Stack: ~p~n",[Stack]),
    X = H,
    Y = hd(Stack),
    NewT = tl(Stack),
    case H of
        "+" -> evaluate(T, [(X+Y)|NewT]);
        "-" -> evaluate(T, [(X-Y)|NewT]);
        "*" -> evaluate(T, [(X*Y)|NewT]);
        "/" -> evaluate(T, [(X/Y)|NewT])
    end.