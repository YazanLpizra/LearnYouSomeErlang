-module(rpncalc).
-export([evaluate/1]).

evaluate(Exp) ->
    evaluate(string:tokens(Exp," "), []).

evaluate([], [X]) ->
    X;
evaluate([H|T], Stack) ->
    io:format("Head: ~s~n",[H]),
    io:format("Tail: ~p~n",[T]),
    io:format("Stack: ~p~n",[Stack]),
    io:format("===== ~n"),

    try 
        evaluate(T, [list_to_integer(H)|Stack])
    catch 
        error:badarg ->
            try
                evaluate(T, [list_to_float(H)|Stack])
            catch
                error:badarg ->
                    {X,Stack2} = pop(Stack),
                    {Y,Stack3} = pop(Stack2),
                    case H of
                        "+" -> evaluate(T, [(Y+X)|Stack3]);
                        "-" -> evaluate(T, [(Y-X)|Stack3]);
                        "*" -> evaluate(T, [(Y*X)|Stack3]);
                        "/" -> evaluate(T, [(X/Y)|Stack3]);
                        "(" -> evaluate(eval_sub_exp(T, [H,X,Y|Stack3]))
                    end
            end
    end.
      
pop([H|T]) -> {H, T}.

eval_sub_exp(T, Stack) ->
    {SubExp, NewTail} = lists:splitwith(fun(X) -> X =/= ")" end, T),

    io:format("sub exp: ~p~n",SubExp),
    io:format("New Tail: ~p~n",NewTail),
    io:format("===== ~n"),

    SubExpResult = evaluate(SubExp),
    {tl(NewTail), [SubExpResult|Stack]}.