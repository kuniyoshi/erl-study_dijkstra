-module(study_dijkstra).
-export([read/1, find/3]).
-include_lib("eunit/include/eunit.hrl").
-define(MAX_NODES, 30).

read(Filename) ->
    {ok, Nodes} = file:consult(Filename),
    Nodes.

find(From, To, Nodes) ->
    Prop = solve(From, From, []),
    find_acc(From, To, Nodes, [{From, Prop}], undefined).

find_acc(_From, _To, _Nodes, _Solved, Path) when Path =/= undefined ->
    {ok, Path};
find_acc(_From, _To, _Nodes, Solved, undefined = Path) when length(Solved) > ?MAX_NODES ->
    Path;
find_acc(_From, _To, Nodes, Solved, undefined = Path) when length(Solved) =:= length(Nodes) ->
    Path;
find_acc(From, To, Nodes, Solved, undefined) ->
    Paths = paths(Nodes, Solved),
    SolvedNode = lists:nth(1, lists:sort(fun({_A, A}, {_B, B}) -> proplists:get_value(length, A) < proplists:get_value(length, B) end, Paths)),
    case SolvedNode of
        {To, _Prop} ->
            find_acc(From, To, Nodes, [SolvedNode | Solved], SolvedNode);
        _ ->
            find_acc(From, To, Nodes, [SolvedNode | Solved], undefined)
    end.

solve(From, From, []) ->
    [{paths, []}, {length, 0}].

paths(Nodes, Solved) ->
    Ids = proplists:get_keys(Solved),
    paths_acc(Nodes, Solved, Ids, []).

paths_acc(_Nodes, _Solved, [], Paths) ->
    Paths;
paths_acc(Nodes, Solved, [Id | Ids], Paths) ->
    Neighbors = proplists:get_value(Id, Nodes),
    Neighbors2 = lists:filter(fun({N, _L}) -> not proplists:is_defined(N, Solved) end, Neighbors),
    Shortest = lists:sublist(lists:sort(fun({_A, A}, {_B, B}) -> A < B end, Neighbors2), 1, 1),
    case Shortest of
        [] ->
            paths_acc(Nodes, Solved, Ids, Paths);
        [{ShortestName, ShortestLength}] ->
            Prop = proplists:get_value(Id, Solved),
            Path = [{paths, [ShortestName | proplists:get_value(paths, Prop)]},
                    {length, lists:sum([ShortestLength, proplists:get_value(length, Prop)])}],
            paths_acc(Nodes, Solved, Ids, [{ShortestName, Path} | Paths])
    end.
