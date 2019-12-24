:- dynamic(known/3).
:- discontiguous menuask/3.
:- discontiguous ask/2.

/* The expert system uses a series of well defined knowledge/rules to determine results,
 *  however this knowledge base is not 'complete' as I have only
 *  compiled a certain subset of the massive list of programming
 *  languages used as a reference from the following sources:
 *
 *  https://en.wikipedia.org/wiki/List_of_programming_languages_by_type
 *  https://en.wikipedia.org/wiki/Comparison_of_programming_languages_by_type_system
 *  https://en.wikipedia.org/wiki/Comparison_of_programming_languages#General_comparison
 */
language(cpp) :-
    type_system_checking(static), type_system_typed(weak), type_system_expressions(explicit),
    compiled(yes),
    single_dispatch(yes),
    imperative(yes), functional(yes), procedural(yes), generic(yes), object_oriented(yes).

language(python) :-
    type_system_checking(dynamic), type_system_typed(strong), type_system_expressions(implicit),
    interpretor(yes), compiled(yes),
    imperative(yes), functional(yes), procedural(yes), generic(yes), reflective(yes), event_driven(yes), object_oriented(yes),
    single_dispatch(yes),
    tracing_mechanism(yes).

language(golang) :-
    type_system_checking(static), type_system_typed(strong), type_system_expressions(implicit),
    compiled(yes),
    imperative(yes), procedural(yes), reflective(yes), event_driven(yes),
    tracing_mechanism(yes), reference_counting(yes).

language(java) :-
    type_system_checking(static), type_system_typed(strong), type_system_expressions(explicit),
    compiled(yes),
    functional(yes), procedural(yes), generic(yes), reflective(yes), event_driven(yes), object_oriented(yes),
    single_dispatch(yes),
    tracing_mechanism(yes), reference_counting(yes).

language(csharp):-
    type_system_checking(static), type_system_typed(weak), type_system_expressions(implicit),
    compiled(yes),
    functional(yes), procedural(yes), generic(yes), reflective(yes), event_driven(yes), object_oriented(yes),
    single_dispatch(yes),
    tracing_mechanism(yes), reference_counting(yes).

language(ruby) :-
    type_system_checking(dynamic), type_system_typed(strong), type_system_expressions(implicit),
    imperative(yes), functional(yes), reflective(yes), object_oriented(yes),
    tracing_mechanism(yes), reference_counting(yes),
    single_dispatch(yes).

language(rust) :-
    type_system_checking(static), type_system_typed(strong), type_system_expressions(implicit),
    compiled(yes),
    imperative(yes), functional(yes), procedural(yes), generic(yes), object_oriented(yes),
    single_dispatch(yes).

language(javascript) :-
    type_system_checking(dynamic), type_system_typed(strong), type_system_expressions(implicit),
    imperative(yes), functional(yes), procedural(yes), reflective(yes), event_driven(yes),
    tracing_mechanism(yes), reference_counting(yes).

language(common_lisp) :-
    type_system_checking(dynamic), type_system_typed(strong), type_system_expressions(implicit),
    compiled(yes),
    functional(yes), object_oriented(yes),
    multiple_dispatch(yes),
    tracing_mechanism(yes).

% generic output here when a language that either doesn't exist or
% whose qualities is unknown to the knowledge base is referred here
language(available_languages_incompatible).

% menuasks are used to get information that is applicable to all
% languages, each language must have 1 of the values available in their
% type_system
type_system_typed(X) :- menuask(type_system_typed, X, [strong, weak]).
type_system_checking(X) :- menuask(type_system_checking, X, [static, dynamic]).
type_system_expressions(X) :- menuask(type_system_expressions, X, [implicit, explicit]).

% the following paradigms will only be referenced once to see if any
% language matches to the specified results
imperative(X) :- ask(imperative, X).
functional(X) :- ask(functional, X).
object_oriented(X) :- ask(object_oriented, X).
generic(X) :- ask(generic, X).
procedural(X) :- ask(procedural, X).
reflective(X) :- ask(reflective, X).
event_driven(X) :- ask(event_driven, X).

tracing_mechanism(X) :- ask(tracing_mechanism, X).
reference_counting(X) :- ask(referencing_counting, X).

interpretor(X) :- ask(interpretor, X).
compiled(X) :- ask(bytecode_compiled, X).

single_dispatch(X) :- ask(single_dispatch, X).
multiple_dispatch(X) :- ask(multiple_dispatch, X).

% The following last few lines of code are generic output/input
% validation sourced from:
% http://www.paulbrownmagic.com/blog/simple_prolog_expert.html

% Remember what I've been told is correct
ask(Attr, Val) :- known(yes, Attr, Val), !.
menuask(Attr, Val, _) :- known(yes, Attr, Val), !.
% % Remember what I've been told is wrong
ask(Attr, Val) :- known(_, Attr, Val), !, fail.
menuask(Attr, Val, _) :- known(_, Attr, Val), !, fail.
% Remember when I've been told an attribute has a different value
ask(Attr, Val) :- known(yes, Attr, V), V \== Val, !, fail.
menuask(Attr, Val, _) :- known(yes, Attr, V), V \== Val, !, fail.
% % I don't know this, better ask!
ask(Attr, Val) :- write(Attr:Val), write('? '), read(Ans), asserta(known(Ans, Attr, Val)), Ans == yes.
menuask(Attr, Val, List) :- write('What is the value for '), write(Attr), write('? '), nl,
                            write(List), nl,
                            read(Ans),
                            check_val(Ans, Attr, Val, List),
                            asserta(known(yes, Attr, Ans)),
                            Ans == Val.
check_val(Ans, _, _, List) :- member(Ans, List), !.
check_val(Ans, Attr, Val, List) :- write(Ans), write(' is not a known answer, please try again.'), nl,
                                   menuask(Attr, Val, List).

go :- language(Programming_Language),
    write('You should be using: '), write(Programming_Language), nl.
