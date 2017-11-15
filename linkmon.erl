-module(linkmon).
-compile(export_all).

myproc() ->
	timer:sleep(5000),
	exit(reason).

%% link/1 takes a Pid and links the current process to that Pid. (use unlink/1 for opposite). 
%% when one of the linked processes fails, it sends a special message out to the linked processes to kill and restart them
%% > link(spawn(fun myproc/0)).
%% The above will link the calling process to myproc. in 5 seconds when myproc fails, so will the caller

%% ex1
chain(0) ->
	receive 
		_ -> ok
	after 2000 ->
		exit("chain dies here")
	end;

chain(N) ->
	Pid = spawn(fun() -> chain(N-1) end),
	link(Pid),
	receive
		_ ->
			ok
	end.

%% ex2
start_critic() ->
	spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
	Pid ! {self(), {Band, Album}},
	receive
		{Pid, Criticism} -> Criticism
	after 2000 ->
		 timeout
	end.

critic() ->
	receive
		{From, {"band1", "album1"}} ->
			From ! {self(), "they're great!"};
		{From, {"band2", "album2"}} ->
			From ! {self(), "they suck"};
		{From, {_band, _album}} ->
			From ! {self(), "... get out"}
	end,
	critic().

%% problem here is that if the critic goes down, we have no way to restart it
%% solution is using a monitoring process to supervise and restart it as neccessary

%% ex3
start_critic2() ->
	spawn(?MODULE, restarter, []).

restarter() ->
	process_flag(trap_exit, true), % convert exit signals to messages that can be passed
	Pid = spawn_link(?MODULE, critic, []), % spawn a critic
	register(critic, Pid), % give the Pid a global static atom/name. is cleared when process dies
	receive
		{'EXIT', Pid, normal} ->  % not a crash
			ok;
		{'EXIT', Pid, shutdown} -> % manual termination, not a crash
			ok;
		{'EXIT', Pid, _} -> % wasn't me!
			restarter()
	end.

judge2(Band, Album) -> % we dont need 'Pid' anymore. we can just use global static name 'critic'
	critic ! {self(), {Band, Album}},
	Pid = whereis(critic), % fetch pid behind process name
	receive
		{Pid, Criticism} -> Criticism
	after 2000 ->
		      timeout
	end.

%% problem with this is that between sending the critic the message and checking the Pid of `critic`
%%  (line 73,74) the critic can die or restart. 
%% if it restarts after the `whereis` function, the code crashes because Pid doesnt exist
%% if it restarts before the `whereis` function, the `whereis` function gets a different Pid and the receive block in judge2 will never match
%% possible solution is to use a refernce

%% ex4
start_critic3() ->
	spawn(?MODULE, restarter3, []).

restarter3() ->
	process_flag(trap_exit, true), % convert exit signals to messages that can be passed
	Pid = spawn_link(?MODULE, critic3, []), % spawn a critic3
	register(critic, Pid), % give the Pid a global static atom/name. is cleared when process dies
	receive
		{'EXIT', Pid, normal} ->  % not a crash
			normal;
		{'EXIT', Pid, shutdown} -> % manual termination, not a crash
			shurdown;
		{'EXIT', Pid, _} -> % wasn't me!
			restarter()
	end.

critic3() ->
	receive
		{From, Ref, {"band1", "album1"}} ->
			From ! {Ref, "garbage!"};
		{From, Ref, {"band2", "album2"}} ->
			From ! {Ref, "meh"};
		{From, Ref, {_band, _album}} ->
			From ! {Ref, "nope. leave"}
	end,
	critic3().
	
judge3(Band, Album) ->
	Ref = make_ref(),
	critic ! {self(), Ref, {Band, Album}},
	receive 
		{Ref, Criticism} -> Criticism
	after 2000 ->
		timeout
	end.