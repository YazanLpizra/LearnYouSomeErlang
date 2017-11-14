-module(dolphins).
-compile(export_all).

dolphin1() ->
	receive
		{SenderPID, do_a_flip} ->
			SenderPID ! "How about no?";
		{SenderPID, fish} ->
			SenderPID ! "So long and thnaks for all the fish!";
		_ ->
			io:format("heh, suck it!")
	end.

dolphin3() ->
	receive
		{Sender, flip} ->
			Sender ! "How about no?",
			dolphin3();
		{Sender, fish}->
			Sender ! "Thanks!";
		_ ->
			io:format("Heh, we're smarter than humans!~n"),
			dolphin3()
	end.
