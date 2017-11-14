-module(kitchen).
-export([init/1, store2/2, take2/2, fridge2/1]).

fridge1() ->
	receive
		{Sender, {store, _Food}} ->
			Sender ! {self(), ok},
			fridge1();
		{Sender, {take, _Food}} ->
			Sender ! {self(), not_found},
			fridge1();
		terminate ->
			ok
	end.

fridge2(FoodList) ->
	receive
		{From, {store, Food}} ->
			From ! {self(), ok},
			fridge2([Food | FoodList]);
		{From, {take, Food}} ->
			case lists:member(Food, FoodList) of
				true ->
					From ! {self(), {ok, Food}},
					fridge2(lists:delete(Food, FoodList));
				false ->
					From ! {self(), not_found},
					fridge2(FoodList)
			end;
		terminate ->
			ok
	end.

store(Pid, Food) ->
	Pid ! {self(), {store, Food}},
	receive
		{Pid, Msg} -> Msg
	end.

take(Pid, Food) ->
	Pid ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
	end.

store2(Pid, Food) ->
	Pid ! {self(), {store, Food}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

take2(Pid, Food) ->
	Pid ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

init(FoodList) ->
	spawn(?MODULE, fridge2, [FoodList]).
