-module(codebreaker).
-export([mark/2]).

-include_lib("eunit/include/eunit.hrl").

positional_test_() ->
  [
    ?_assertEqual([p],        mark([r,y,g,b], [r,c,c,c])),
    ?_assertEqual([p,p],      mark([r,y,g,b], [r,y,c,c])),
    ?_assertEqual([p,p,p],    mark([r,y,g,b], [r,y,c,b])),
    ?_assertEqual([p,p,p,p],  mark([r,y,g,b], [r,y,g,b]))
  ].

mark(Secret, Guess) ->
  p(Secret, Guess, [], []).

p(_, [], Matches, NewGuess) ->
  Matches;

p([Hsecret | Tsecret], [Hguess | Tguess], Matches, NewGuess) ->
  case Hsecret == Hguess of
    true ->
      p(Tsecret, Tguess, [p | Matches], NewGuess);
    false ->
      p(Tsecret, Tguess, Matches, [Hguess | NewGuess])
  end.
