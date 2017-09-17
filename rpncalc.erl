-module(rpncalc).
-export([evaluate/1]).

evaluate(Exp) ->
    evaluate(Exp, []).

evaluate([], [X]) ->
    X;
evaluate([H|T], Stack)->
    try
        string:to_float(H)
    of
        {Num, _} -> 
            evaluate(T, [Num|Stack])
    catch
        {error, _} -> 
            X = H,
            Y = hd(Stack),
            NewT = tl(Stack),
            case H of
                "+" -> evaluate(T, [X+Y|NewT]);
                "-" -> evaluate(T, [X-Y|NewT]);
                "*" -> evaluate(T, [X*Y|NewT]);
                "/" -> evaluate(T, [X/Y|NewT])
            end
    end.