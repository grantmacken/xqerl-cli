#!/usr/bin/env escript
%% -*- coding: utf-8 -*-
%%! -setcookie monster
-define(SELF_NODE, list_to_atom( "run_" ++ integer_to_list(rand:uniform(16#FFFFFFFFF)) ++ "@127.0.0.1")).
% compile then run a main module with single arg
main([Mod, Arg1, Arg2, Arg3 ]) ->
  {ok, _} = net_kernel:start([?SELF_NODE, longnames]),
  BaseName = filename:basename(Mod),
  Source = "./code/src/" ++ BaseName,
  Comp = rpc:call( 'xqerl@127.0.0.1', xqerl, compile, [Source]),
  Map = #{<<"arg1">> => list_to_binary(Arg1), <<"arg2">> => list_to_binary(Arg2), <<"arg3">> => list_to_binary(Arg3)},
  Res = rpc:call( 'xqerl@127.0.0.1', xqerl, run, [Comp,Map]), 
  io:format( "~s\n", [ Res ]).

  


