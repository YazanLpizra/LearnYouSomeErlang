-module(errors).
-export([throws/1, errors/1, exits/1, whoa/0, catcher/2]).

% try catch syntax:
%     try Expression of
%         SuccessfulPatern1 [Guards] ->
%             Expression1;
%         SuccessfulPatern2 [Guards] ->
%             Expression2
%     catch
%         TypeOfError:ExceptionPattern1 ->
%             Expression3;
%         TypeOfError:ExceptionPattern2 ->
%             Expression4
%     after % like a 'finally' clause. always executed   
%         Expression5   
%     end.
% TypeOfError can be replaced with throw, exit, or error. Default is throw 
% Do NOT make the try clause tail recursive. messes with Erlang VM because it needs a reference if exception occurs 

throws(F) ->
    try F() of
        _ -> ok
    catch
        Throw -> {throw, caught, Throw}
    end.

exits(F) ->
    try F() of
        _ -> ok
    catch
        exit:Exit_Error -> {exit, caught, Exit_Error}
    end.

errors(F) ->
    try F() of
        _ -> ok
    catch
        error:Error -> {error, caught, Error}
    end.

talk() -> "Hello Moto".

whoa() ->
    try
        talk(),
        _Knight = "None shall pass",
        throw(up),
        _WillReturnThis = tequila
    of % The whole of clause can be eliminated if the result isnt needed
        tequila -> "hey! This worked!"
    catch
        Exception:Reason -> {caught, Exception, Reason} % {caught, throw, up}
    end.

% catch can capture both good and bad results. almost like a simple try-catch
catcher(X,Y) ->
    case catch X/Y of   
        {'EXIT', {badarith, _}} -> "uh oh!";
        N -> N
    end. 

% catch also has problems:
%     operator precedance
%         X = catch 2+2. % throws errors 
%         X = (catch 2+2). % works

%     stack traces can be mimicked and made impossible to distinguish between system errors and exits

%     can hide returned values if successes and errors return similar values
%         catch 1.
%         catch throw(1). 