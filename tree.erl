-module(tree).
-export([empty/0, insert/3, lookup/2, has_value/2]).

%% Assume node has format of {node, {Key, Value, SmallerNode, LargerNode}}

empty() -> {node, 'nil'}.

%% Key, Value, NodeToCompare
insert(K, V, {node, 'nil'}) -> 
    {node, {K,V,{node,'nil'},{node,'nil'}}};
insert(NewKey, NewVal, {node, {Key,Value,SmallerNode,LargerNode}}) when NewKey < Key -> 
    {node, {Key,Value,insert(NewKey,NewVal,SmallerNode),LargerNode}};
insert(NewKey, NewVal, {node, {Key,Value,SmallerNode,LargerNode}}) when NewKey > Key -> 
    {node, {Key,Value,SmallerNode,insert(NewKey,NewVal,LargerNode)}};
insert(Key, Value, {node, {Key,_,SmallerNode,LargerNode}}) -> 
    {node, {Key,Value,SmallerNode, LargerNode}}.

lookup(_, {node, 'nil'}) -> 
    undefined;
lookup(Key, {node, {Key, Value, _, _}}) ->
    {ok, Value};
lookup(K, {node, {Key, _, SmallerNode, _}}) when K < Key ->
    lookup(K,SmallerNode);
lookup(K, {node, {Key, _, _, LargerNode}}) when K > Key ->
    lookup(K,LargerNode).

% when an exeption is thrown, the recursion breaks, and control is retuirned to the calling funcvtion. if this calling fnvtion has a try-catch, we can g straight to the catch to control success logic. weird right?
    % intersetong implications when you just wrap your recursive calls with a try-catch handling caller function.
has_value(Val, Tree) ->
    try 
        has_value1(Val, Tree) 
    of 
        false -> not_found
    catch 
        true -> found_it
    end.

has_value1(_, {node, 'nil'}) -> 
    false;
has_value1(Val, {node, {_, Val, _, _}}) ->
    throw(true);
has_value1(Val, {node, {_,_, SmallerNode, LargerNode}}) ->
    has_value1(Val, SmallerNode),
    has_value1(Val, LargerNode).