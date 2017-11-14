-module(records).
-export([repairman/1, 
	  first_robot/0,
	  car_factory/1,
	  admin_panel/1,
	  adult_section/1]).
-include("records.hrl").

repairman(Rob) ->
    Details = Rob#robot.details,
    NewRob = Rob#robot{details=["Repaired by repairman"|Details]},
    {repaired, NewRob}.

first_robot()->
	#robot{name="Megatron",
	       type=handmade,
	       details=["Moved by a dude inside"]}.

car_factory(CorpName)->
	#robot{name=CorpName,hobbies="building cars"}.

%% Can use records in function heads to filter
admin_panel(#user{name=Name,group=admin})->
	Name ++ " is allowed";
admin_panel(#user{name=Name})->
	Name ++ " is not allowed".

adult_section(U = #user{}) when U#user.age >= 18 ->
	allowed;
adult_section(_)->
	forbidden.

%Crusher = #robot{name="Crusher", hobbies=["crushing people","petting kittens"]}.
%Crusher#robot.hobbies. %% must retain the keyword to define type of variable

%NestedRobot = #robot{details=#user{name="ErNest"}}.
%NestedRobot#robot.details#user.name.


