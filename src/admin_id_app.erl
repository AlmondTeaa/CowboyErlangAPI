%%%-------------------------------------------------------------------
%% @doc admin_id public API
%% @end
%%%-------------------------------------------------------------------

-module(admin_id_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_',[
            {"/[...]",toppage_h,[]}
        ]
    }]),
    Priv_directory = code:priv_dir(admin_id),

    {ok,_} = cowboy:start_tls(https, [{port,8443},
            {certfile, Priv_directory ++ "/ssl/certificate.pem"},
            {keyfile, Priv_directory ++ "/ssl/key.pem"}],
            #{env => #{dispatch => Dispatch}}
            ),

    admin_id_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(https).

%% internal functions
