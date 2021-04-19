#!/usr/bin/env escript
%% -*- coding: utf-8 -*-
%%! -setcookie monster
%%
-define(SELF_NODE, list_to_atom( "xquery_" ++ integer_to_list(rand:uniform(16#FFFFFFFFF)) ++ "@127.0.0.1")).
rmat( "~s\n", [ Res ])
 end.

main([ARG]) ->
  {ok, _} = net_kernel:start([?SELF_NODE, longnames]),
  try rpc:call( 'xqerl@127.0.0.1', xqerl, run, [ARG]) of
  Res -> printOutRes( Res )
  catch
    _ -> io:format( "~s\n", [ "ERROR! - failed to run escript"])
  end.
    

  


