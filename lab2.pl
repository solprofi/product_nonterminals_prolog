terminal(a).
terminal(b).
terminal(c).
terminal(d).

nonterminal(ss).
nonterminal(ee).
nonterminal(aa).
nonterminal(bb).
nonterminal(dd).
nonterminal(xx).

p(ss,[[aa,b,bb,ee],[aa,dd,c,bb,ee],[aa,dd,e,ee]]).
p(ee,[[a],[b,ee,c]]).
p(aa,[[d],[a,aa]]).
p(bb,[[c],[b,bb]]).
p(dd,[[d,dd]]).
p(xx,[[ss,a],[dd,b]]).

solver(Nonterminal, [], SetOfProduct).
solver(Nonterminal, [Symbol|List], SetOfProduct) :-
    terminal(Symbol), solver(Nonterminal, List, SetOfProduct);
    nonterminal(Symbol),
    member(Symbol, SetOfProduct),
    solver(Nonterminal, List, SetOfProduct).

solver2(Nonterminal, [], SetOfProduct) :- false.
solver2(Nonterminal, [Symbol|List], SetOfProduct) :-
    solver(Nonterminal, Symbol, SetOfProduct), !;
    solver2(Nonterminal, List, SetOfProduct), !.

nonterminal_is_product(N, SetOfProduct) :-
   p(N, X), solver2(N, X, SetOfProduct).

find_product_nonterminals(SetOfProduct, Ans) :-
    findall(N, (nonterminal_is_product(N, SetOfProduct), \+ member(N, SetOfProduct)), X),
    length(X, L),
    (
        (
            L > 0,
            append(SetOfProduct, X, Res),
            find_product_nonterminals(Res, Ans)
        );
        (
            L == 0,
            append([], SetOfProduct, Ans)
        )
    ).

main :- find_product_nonterminals([], Ans)