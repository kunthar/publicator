%%%-------------------------------------------------------------------
%%% @author Huseyin Yilmaz <huseyin@huseyin-work>
%%% @copyright (C) 2013, Huseyin Yilmaz
%%% @doc Rest interface application interface for publicator
%%%
%%% @end
%%% Created : 06 Jul 2013 by Huseyin Yilmaz <huseyin@huseyin-work>
%%%-------------------------------------------------------------------
-module(http).

%% API
-export([start/0, stop/0]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts rest server
%% @end
%%--------------------------------------------------------------------
-spec start() -> ok.
start() ->
    ok = s_utils:ensure_started(crypto),
    ok = s_utils:ensure_started(ranch),
    ok = s_utils:ensure_started(cowlib),
    ok = s_utils:ensure_started(cowboy),
    ok = s_utils:ensure_started(jiffy),
    ok = s_utils:ensure_started(http).

%%--------------------------------------------------------------------
%% @doc
%% Stops rest server
%% @end
%%--------------------------------------------------------------------
-spec stop() -> ok.
stop() ->
    ok = application:stop(http),
    ok = application:stop(cowboy),
    ok = application:stop(cowlib),
    ok = application:stop(ranch),
    ok = application:stop(jiffy),
    ok = application:stop(crypto).


%%%===================================================================
%%% Internal functions
%%%===================================================================
