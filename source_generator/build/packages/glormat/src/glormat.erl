-module(glormat).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([format/3, replace/3, debug/3, then/3, then_debug/3, assert_ok/1]).

-spec format(binary(), binary(), binary()) -> {ok, binary()} | {error, nil}.
format(Format_string, Label, Data) ->
    To_replace = <<<<"{"/utf8, Label/binary>>/binary, "}"/utf8>>,
    Contains_label = begin
        _pipe = Format_string,
        gleam_stdlib:contains_string(_pipe, To_replace)
    end,
    case Contains_label of
        true ->
            {ok, gleam@string:replace(Format_string, To_replace, Data)};

        false ->
            {error, nil}
    end.

-spec replace(binary(), binary(), binary()) -> {ok, binary()} | {error, nil}.
replace(Format_string, Label, Data) ->
    format(Format_string, Label, Data).

-spec debug(binary(), binary(), any()) -> {ok, binary()} | {error, nil}.
debug(Format_string, Label, Data) ->
    format(Format_string, Label, gleam@string:inspect(Data)).

-spec then({ok, binary()} | {error, nil}, binary(), binary()) -> {ok, binary()} |
    {error, nil}.
then(Result, Label, Data) ->
    _pipe = fun(Format_string) -> format(Format_string, Label, Data) end,
    _pipe@1 = gleam@result:map(Result, _pipe),
    gleam@result:flatten(_pipe@1).

-spec then_debug({ok, binary()} | {error, nil}, binary(), any()) -> {ok,
        binary()} |
    {error, nil}.
then_debug(Result, Label, Data) ->
    then(Result, Label, gleam@string:inspect(Data)).

-spec assert_ok({ok, binary()} | {error, nil}) -> binary().
assert_ok(Result) ->
    {ok, String} = case Result of
        {ok, _} -> Result;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Assertion pattern match failed"/utf8>>,
                        value => _assert_fail,
                        module => <<"glormat"/utf8>>,
                        function => <<"assert_ok"/utf8>>,
                        line => 94})
    end,
    String.
