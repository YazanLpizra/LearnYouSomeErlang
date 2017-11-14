-module(multiproc).
-compile(export_all).

sleep(T) ->
	receive
	after T -> 
		ok
	end.

%% 'after 0' is a special case. BEAM will keep trying to parse input to match the receive clauses before 'timing out' 
flush() ->
	receive
		_ -> 
			flush()
	after 0 ->
		ok
	end.

important() ->
	receive
		{Priority, Message} when Priority > 10 ->
			[Message | important()]
		after 0 ->
			normal()
		end.

normal() ->
	receive 
		{_, Message} ->
			[Message, normal()]
	after 0 ->
		[]
	end.

