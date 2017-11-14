%% *.hrl files are header files. 

%% Records are like classes. Treated by erlang as tuples, not supported natively/are a compiler trick
%% In REPL, need to use c/1 and rr/1 on the module to compile it and make the records available

-record(robot,{name,
	       type=industrial,
	       hobbies,
	       details=[]
	 }).

-record(user, {id,
	       name,
	       group,
	       age}).