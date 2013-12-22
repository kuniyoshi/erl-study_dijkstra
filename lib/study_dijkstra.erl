-module(study_dijkstra).
-export([import/1, make/1]).

import(Filename) ->
    {ok, Nodes} = file:consult(Filename),
    Nodes.

make(Node) ->
    spawn(?MODULE, wait, Node).
