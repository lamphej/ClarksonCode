
% my_list(+Item)
% Decides if Item is a list.
%
my_list([X|Y]).

% my_member(+Item,+List)
% Decides if Item is a member of List.
%
my_member(X, [X|Y]).
my_member(X, [Y|Z]):-
	my_member(X, Z).

% my_length(+As,-N)
% Returns the length of list As in the variable N.
%
my_length([], 0).
my_length([_|L], N):-
	my_length(L, M),
	N is M+1.

% my_append(+As,+Bs,-Cs)
% Returns the append of two lists As and Bs in the list Cs.
%
my_append([], X, X).
my_append([X|Y],Z,[X|W]):-
	my_append(Y, Z, W).

% my_reverse(+As,-Bs)
% Returns the reverse of list As in the list Bs.
%
my_reverse(As, Bs):-
	reverse(As,Xs\[]).
reverse([], Xs\Xs).
reverse([A|As], Xs\Ys):-
	reverse(As,Xs\[A|Ys]).

% my_prefix(+Pattern,+List)
% Decides if Pattern is a prefix of List.
%
my_prefix([],Bs).
my_prefix([A|As],[A|Bs]):-
	my_prefix(As,Bs).

% my_subsequence(+Pattern,+List)
% Decides if Pattern is a subsequence (consecutive) of List.
%
my_subsequence([], _).
my_subsequence([X|Y], Z):-
	my_member(X, Z),
	my_subsequence(Y, Z).

% my_delete(+Item,+List,-Answer)
% Deletes all occurrences of Item from List and returns the result in Answer.
%
my_delete(_,[],[]).
my_delete(T,[T|L], R):-
	my_delete(T, L, R).
my_delete(T,[H|L],[H|R]):-
	my_delete(T,L,R).


