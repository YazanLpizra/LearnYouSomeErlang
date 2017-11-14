-module(road).
-compile(export_all).

main() ->
    File = "road.txt",
    {ok, Bin} = file:read_file(File),
    parse_map(Bin).


group_vals([],Acc)->
    lists:reverse(Acc);
group_vals([A,B,C|T],Acc) ->
    group_vals(T,[{A,B,C}|Acc]).

parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
parse_map(Str) when is_list(Str) ->
    Values = [list_to_integer(X) || X <- string:tokens(Str,"\r\n\t ")],
    group_vals(Values,[]). 

shortest_path({A,B,X},{{DistA,PathA},{DistB,PathB}})->
    OptA1 = {DistA+A, [{a,A}|PathA]};
    OptA2 = {DistB+X+B, [{x,X},{b,B}|PathB]};
    OptB1 = {DistB+B, [{a,A}|PathB]};
    OptB2 = {DistA+X+A, [{x,X},{a,A}|PathA]};
    {erlang:min(OptA1,OptA2),erlang:min(OptB1,OptB2)}.

optimal_path(Map) ->
    {A,B} = lists:foldl(
            fun shortest_step/2,
            {{0,[]},{0,[]}}
            Map
        ),