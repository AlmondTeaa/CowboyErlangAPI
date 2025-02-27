-module(toppage_h).

%cowboy_rest standard callbacks
-export([init/2]). 
-export([allowed_methods/2]).
-export([content_types_provided/2]). %Goes in here when method is GET

%custom callbacks
-export([show_data_json/2]).
-export([show_html/2]).

init(Req, State)->
  {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
  {[<<"GET">>,<<"POST">>], Req, State}.

content_types_provided(Req, State) ->
  {[
    {{<<"application">>, <<"json">>,[]},show_data_json},
    {{<<"text">>, <<"html">>,[]},show_html}
  ], Req, State}.

show_data_json(Req, State) ->
  Priv_directory = code:priv_dir(admin_id),
  {ok, JsonData_utf8} = file:read_file(Priv_directory ++ "/id.json"),
  Endpoint = list_to_binary(cowboy_req:path_info(Req)),
  JsonData = jsx:decode(JsonData_utf8,[{return_maps,true}]),

  case Endpoint of
    <<>> -> 
    io:format("Json contains the following data:~n~p~n",[JsonData]),
    {JsonData_utf8,Req,State};
    _ -> 
    io:format("Value of the key ~p is ",[Endpoint]),
    io:format("~p~n",[maps:get(Endpoint,JsonData)]),
    {maps:get(Endpoint,JsonData),Req, State}
  end.

%  case maps:is_key(Endpoint,JsonData) of
%     true ->  io:format("~p~n",[Endpoint]),
%              io:format("~p~n", [maps:is_key(Endpoint,JsonData)]),
%              {maps:get(Endpoint,JsonData),Req, State};
%     false -> io:format("~p~n",[Endpoint]),
%              io:format("~p~n", [maps:is_key(Endpoint,JsonData)]),
%              {JsonData_utf8,Req,State}
%  end.
          
show_html(Req, State) ->
  Priv_directory = code:priv_dir(admin_id),
  {ok, Binary} = file:read_file(Priv_directory ++ "/index.html"),
  {Binary, Req, State}.
