NAME
====

study_dijkstra

SYNOPSYS
========

``` bash
   $ mkdir ebin
   $ perl Makefile.pl
   $ make
   $ erl -pa ebin
```

``` erlang
   > l(study_dijkstra).
   > Nodes = study_dijkstra("data/node_and_link.data").
   > study_dijkstra:find(syd, per, Nodes).
   {ok,{per,[{paths,[per,adl,mel,cbr]},{length,50}]}}
   >
```
