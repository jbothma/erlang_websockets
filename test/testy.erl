-module(testy).

-include_lib("eunit/include/eunit.hrl").

-define(JSON_LOGIN(Username, Password),
        {struct,
         [{action,<<"login">>},
          {data,
           [{struct,[{nick,<<Username>>}]},
            {struct,[{password,<<Password>>}]}
           ]
          }
         ]
        }).


bob_test() ->
    {ok, Pid} = test_client:connect("192.168.56.101", 8000),
    Term = ?JSON_LOGIN("bob", "pass"),
    JSON = mochijson2:encode(Term),
    Msg = list_to_binary(JSON),
    test_client:send({text, Msg}),
    {text, Reply} = test_client:recv(),
    ReplyJSON = binary_to_list(Reply),
    ReplyTerm = mochijson2:decode(ReplyJSON),
    ?debugVal(ReplyTerm).
