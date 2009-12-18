-module(codebreaker).
-export([mark/2]).

-include_lib("eunit/include/eunit.hrl").

non_positional_test_() ->
  [
    ?_assertEqual([],         mark([r,y,g,b], [c,c,c,c])),
    ?_assertEqual([m],        mark([r,y,g,b], [b,c,c,c])),
    ?_assertEqual([m,m],      mark([r,y,g,b], [b,g,c,c])),
    ?_assertEqual([m,m,m],    mark([r,y,g,b], [b,g,y,c])),
    ?_assertEqual([m,m,m,m],  mark([r,y,g,b], [b,g,y,r]))
  ].

mark(Secret, Guess) ->
  m(Secret, Guess, []).

m(_, [], Matches) ->
  Matches;

m(Secret, [H | T], Matches) ->
  case lists:member(H, Secret) of
    true ->
      m(Secret, T, [m | Matches]);
    false ->
      m(Secret, T, Matches)
  end.
