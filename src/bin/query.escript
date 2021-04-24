#!/usr/bin/env escript
%% -*- coding: utf-8 -*-
%%! -setcookie monster
%%
-define(SELF_NODE, list_to_atom( "xquery_" ++ integer_to_list(rand:uniform(16#FFFFFFFFF)) ++ "@127.0.0.1")).

xqError( RES ) ->
  Msg =  "ERROR: " ++ binary_to_list(element(3,RES)) ++ "\n",
  io:format( "~s\n", [ Msg ]).

printOutRes( Res ) ->
  case Res of
   Etup when is_tuple(Etup), element(1, Etup) == xqError  -> xqError(Etup);
   Number when is_number(Number) -> io:format( "~p\n", [ Res ]);
   Binary when is_binary(Binary)  -> io:format( "~s\n", [ 'binary' ]);
   List when is_list(List)  -> io:format( "~s\n", [ 'list' ]);
   _  -> io:format( "~p\n",[ Res ])
 end.

main([ARG]) ->
  {ok, _} = net_kernel:start([?SELF_NODE, longnames]),
  try rpc:call( 'xqerl@127.0.0.1', xqerl, run, [ARG]) of
  Res -> printOutRes( Res )
  catch
    _ -> io:format( "~s\n", [  "error: failed to run query" ])
  end.
