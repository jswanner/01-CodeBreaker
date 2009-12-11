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

positional_test_() ->
  [
    ?_assertEqual([p],        mark([r,y,g,b], [r,c,c,c])),
    ?_assertEqual([p,p],      mark([r,y,g,b], [r,y,c,c])),
    ?_assertEqual([p,p,p],    mark([r,y,g,b], [r,y,c,b])),
    ?_assertEqual([p,p,p,p],  mark([r,y,g,b], [r,y,g,b]))
  ].

mixed_test_() ->
  [
    ?_assertEqual([p,m],      mark([r,y,g,b], [r,b,c,c])),
    ?_assertEqual([p,p,m],    mark([r,y,g,b], [r,y,c,g])),
    ?_assertEqual([p,m,m],    mark([r,y,g,b], [r,b,c,y])),
    ?_assertEqual([p,p,m,m],  mark([r,y,g,b], [r,y,b,g]))
  ].

mark(Secret, Guess) ->
  {P_matches, NewGuess} = p(Secret, Guess, [], []),
  M_matches = m(Secret, NewGuess, []),
  lists:flatten([P_matches | M_matches]).

m(_, [], Matches) ->
  Matches;

m(Secret, [H | T], Matches) ->
  case lists:member(H, Secret) of
    true ->
      m(Secret, T, [m | Matches]);
    false ->
      m(Secret, T, Matches)
  end.

p(_, [], Matches, NewGuess) ->
  {Matches, NewGuess};

p([Hsecret | Tsecret], [Hguess | Tguess], Matches, NewGuess) ->
  case Hsecret == Hguess of
    true ->
      p(Tsecret, Tguess, [p | Matches], NewGuess);
    false ->
      p(Tsecret, Tguess, Matches, [Hguess | NewGuess])
  end.
