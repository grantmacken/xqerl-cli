#!/usr/bin/env escript
%% -*- coding: utf-8 -*-
%%! -setcookie monster
-define(SELF_NODE, list_to_atom( "call_" ++ integer_to_list(rand:uniform(16#FFFFFFFFF)) ++ "@127.0.0.1")).
% call a xqerl module function
%  Module  Function   Arg
% 'xqldb_db' 'exists' 'uri' 

main([Mod, Func, Arg]) ->
  {ok, _} = net_kernel:start([?SELF_NODE, longnames]),
  Bin = list_to_binary(Arg),
  Res = rpc:call( 
          'xqerl@127.0.0.1', 
          list_to_atom(Mod), 
          list_to_atom(Func), 
          [Bin]), 
  % io:format( "~s\n", [ Res ] ),
  io:format( "~p\n", Res ).

  


