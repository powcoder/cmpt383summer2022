**Note**: These notes are based in large part on chapter 7 of the excellent
book [Programming in Haskell, 2nd
edition](https://www.cs.nott.ac.uk/~pszgmh/pih.html) by Graham Hutton. You
should buy a copy!

## Haskell: Higher-order Functions

**Higher-order functions** are functions that take functions as inputs, or
return functions as outputs.

For instance, `twice` takes a function as input:

```haskell
twice :: (a -> a) -> a -> a
twice f x = f (f x)
```

```haskell
> twice (+1) 5
7
> twice (*2) 5
20
> twice reverse "apple"
"apple"
```

The type signature shows that that the passed-in function `f` takes a value of
type `a` as input, and returns a value of type `a` as output.

> **Note** `twice reverse x` returns `x` for any list `x`, since reversing a
> list twice gives the original list. Chapter 16 of the book mathematically
> gives a formal mathematical proof that this is true.

This function returns a function as a value:

```haskell
makeAdder :: Int -> (Int -> Int)
makeAdder n = (+) n

> plus2 = makeAdder 2
> plus2 10
12

```

Since Haskell functions are *curried* by default, we could also have written
it like this:

```haskell
makeAdder' :: Int -> Int -> Int
makeAdder' n = (+n)

> plus5 = makeAdder' 5
> plus5 23
28
```

The type signature `Int -> Int -> Int` says two arguments are needed, but
thanks to currying we can pass in only a single argument to make functions
like `plus5`.

> **Note** Haskell allows the ``'`` character in the name of a function. It
> doesn't have any special meaning to Haskell. Instead of `makeAdder'`, we
> could have used a name like `makeAdder2`.


### Example: the flip function

`flip` is a standard [Haskell] function that takes a two-input function `f` as
input, and returns a two-input function as output that does the same thing as
`f` except the order of its arguments is swapped.

For example:

```haskell
> (-) 10 6
4
> flip (-) 10 6
-4
```

`(-) x y` evaluates to `x - y`, while `flip (-) x y` evaluates to `y - x`.

The `map` function takes a function as its first input, and a list as its
second input. Using `flip`, we can change the order of these parameters:

```haskell
> map (+1) [2,3,4]
[3,4,5]
> flip map [2,3,4] (+1)
[3,4,5]
```

Here is an implementation of `flip`:

```haskell
flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x
```

The first input is a function with type signature `a -> b -> c`, i.e. a
function that takes two inputs of any type and returns an output of any type.
`flip f` has the type `b -> a -> c`, i.e. `flip f` is `f` with the order of
its parameters switched.


## Higher-order List Functions

A number of standard prelude functions have nice recursive definitions, and
it's instructive to create our own implementations.


### map

The standard `map f lst` functions applies `f` to each element of `lst`. For
example, `map f [a,b,c]` evaluates to the same thing as `[f a, f b, f c]`.

Here's a recursive implementation:

```haskell
mymap :: (a -> b) -> [a] -> [b]
mymap _ []     = []
mymap f (x:xs) = f x : mymap f xs

> mymap even [1..5]
[False,True,False,True,False]
> mymap (\n->n^2) [1..5]
[1,4,9,16,25]
```

### Challenge: double mapping

Implement a function called `doublemap f lst` that evaluates to a list that
has `f` applied *twice* to every element of `lst`,e .g. `doublemap f [a,b,c]`
evaluates to `[f f a, f f b, f f c]`. For example:

```haskell
> doublemap (*2) [1,2,3,4]
[4,8,12,16]
> doublemap tail ["apple","up","down"]
["ple","","wn"]
```

Include the most general type signature for `doublemap`.

### filter

The standard function `filter pred lst` returns a list containing all the
elements of `lst` that *satisfy* the predicate `pred`. For example:

```haskell
> filter (>2) [1,6,0,4,2]
[6,4]
> filter odd [1..10]
[1,3,5,7,9]
```

Here's a recursive implementation:

```haskell
myfilter :: (a -> Bool) -> [a] -> [a]
myfilter _ []     = []
myfilter p (x:xs) = if p x 
                    then x : (filter p xs)
                    else filter p xs

> myfilter even [1..10]
[2,4,6,8,10]
> myfilter (>=0) [0,2,-3,1,-1]
[0,2,1]
```

Functions with the type signature `a -> Bool` are called **predicate
functions**, or just **predicates**. If `p` is a predicate and `p x` evaluates
to `True`, we say **`x` satisfies `p`**. If instead `p x` evaluates to
`False`, we  say **`x` doesn't satisfy `p`**, or **`x` fails to satisfy `p`**.

So we say that `filter p lst` return all the elements in `lst` that satisfy
`p`.


### Challenge: removeIf

Implement a function called `removeIf pred lst` that evaluates to a list that
is the same as `lst`, but all elements satisfying `pred` have been *removed*.
`pred` is any function that takes one input and returns a `Bool`.

For example:

```haskell
> removeIf even [1,2,3,4]
[1,3]
> removeIf (\s -> length s < 3) ["a","one","or","two","three"]
["one","two","three"]
```

Make the implementation of `removeIf` as short as you can. Include the most
general type signature for `removeIf`.


### all

The standard function `all pred lst` returns `True` if the predicate `pred` is
satisfied by *all* the elements on `lst`, and `False` otherwise.

```haskell
myall :: (a -> Bool) -> [a] -> Bool
myall _ []     = True
myall f (x:xs) = f x && myall f xs

> myall even [1..5]
False
> myall (>0) [1..5]
True
```


### any

The standard function `any pred lst` returns `True` if one, or more, of the
elements in `lst` satisfy the predicate `pred`, and `False` otherwise.

```haskell
myany :: (a -> Bool) -> [a] -> Bool
myany _ []     = False
myany p (x:xs) = p x || myany p xs

> myany even [1..5]
True
> myany (=='e') "horse"
True
> myany (=='e') "frog"
False
```

### Challenge: none

Implement a function called `none pred lst` that evaluates to true if *no*
element on `lst` satisfies the predicate `pred` (any function that takes a
single input and returns a `Bool`).  If `lst` is empty, then `true` is
returned.

For example:

```haskell
> none even [1,3,5]
True
> none even [1,3,4,5]
False
> none even []
True
```

Include the most general type signature for the `none`.


### takeWhile

`takeWhile pred lst` is a standard Haskell function that returns a list of all
the elements at the *start* of `lst` that satisfy `pred`. For instance:

```haskell
isVowel c = c `elem` "aeiou"

> takeWhile isVowel "eat well!"
"ea"
```

Here's a recursive implementation:

```haskell
mytakeWhile :: (a -> Bool) -> [a] -> [a]
mytakeWhile _ []     = []
mytakeWhile p (x:xs) = if p x
                       then x : mytakeWhile p xs
                       else []

> mytakeWhile even [2,4,5,6,8]
[2,4]
> mytakeWhile odd [2,4,5,6,8]
[]
```

### dropWhile

`dropWhile pred lst` is a standard function that returns a list that is the
same as `lst` except all elements at the *start* of `lst` that satisfy `pred`
are removed.

For example:

```haskell
> dropWhile (==' ') "  this is a test"
"this is a test"
> dropWhile (<0) [-3,-2,0,-1,4]
[0,-1,4]
```

Here's a recursive implementation:

```haskell
mydropWhile :: (a -> Bool) -> [a] -> [a]
mydropWhile _ []     = []
mydropWhile p (x:xs) = if p x
                       then mydropWhile p xs
                       else x:xs

> mydropWhile even [2,4,7,8]
[7,8]
> mydropWhile even [3,2,4,7,8]
[3,2,4,7,8]
```

Here is a recursion-free implementation of inserting into a sorted list using
`takeWhile` and `dropWhile`:

```haskell
-- 
-- Returns a new list with x inserted into it such that it is sorted.
--
-- Assumes the input list is sorted.
--
insert :: Ord a => a -> [a] -> [a]
insert n lst = smalls ++ [n] ++ bigs
             where smalls = takeWhile (<n) lst
                   bigs   = dropWhile (<n) lst

> insert 4 [1..5]
[1,2,3,4,4,5]
> insert 'c' "abde"
"abcde"
```


### Challenge: changing a value of a function

Implement a function called `change_val f x y` that returns a new function
that does the same thing as `f` for every input, except if you pass this new
function `x` it will return `y`. Assume `f` is a function of type `a -> b`,
where both `a` and `b` satisfy `Eq`.

Here's an example of how to use `change_val`:

```haskell
> inverse x = 1 / x
> inverse 2
0.5
> inverse 3
0.3333333333333333
> inverse 0
Infinity

> inverse' = change_val inverse 0 0
> inverse' 0
0.0
> inverse' 2
0.5
> inverse' 3
0.3333333333333333
```

As part of your answer, include the most general type signature for the
`change_val`.


## Folding with foldr

The `foldr` function implements a recursive pattern that appears in many
functions. For example, thet standard recursive way of summing numbers in a
list looks like this:

```haskell
mysum :: Num a => [a] -> a
mysum []     = 0
mysum (x:xs) = x + mysum xs

> mysum [1..10]
55
> mysum [-2,2.1,9]
9.1
```

The step-by-step evaluation of `mysum [4,1,2]` goes like this:

```haskell
mysum [4,1,2]
= 4 + sum [1,2]
= 4 + (1 + sum [2])
= 4 + (1 + (2 + sum []))
= 4 + (1 + (2 + 0))
= 4 + (1 + 2)
= 4 + 3
= 7
```

Notice the expression `4 + (1 + (2 + 0))`. Because of the bracketing, the
individual sub-expressions are evaluated from right to left, and so this is an
example of a **right fold**.

`myprod lst` is implemented similarly to `mysum`, and calculates the *product*
of the elements on `lst`:

```haskell
myprod :: Num a => [a] -> a
myprod []     = 1
myprod (x:xs) = x * myprod xs

> myprod [1,2,4]
8
> myprod [1..5]
120
```

The implementations of `mysum` and `myprod`are very similar, with these
differences:

- `mysum` is renamed to `myprod`

- the base case for `mysum` returns 0, but for `myrpod` it returns 1

- the recursive case for `mysum` uses `+`, and for `myprod` it uses `*`

This suggests we could write a single function that takes the base case value
and the combining operation as input. The function that does this is called
**right fold**, or **fold right**:

```haskell
myfoldr :: (a -> b -> b) -> b -> [a] -> b
myfoldr _  emptyval []     = emptyval
myfoldr op emptyval (x:xs) = x `op` (myfoldr op emptyval xs)

> myfoldr (+) 0 [2,1,3,4]
10
> myfoldr (*) 1 [2,1,3,4]
24
> myfoldr (-) 0 [2,1,3,4]
0
```

`myfoldr` is a *right* fold, which means it evaluates operators starting at
the right. For example, to calculate the sum `1+2+3`, right fold calculates
`(1 + (2 + (3 + 0)))`.

We can think of sorting as fold. For instance, suppose we want to sort the
list `[7,1,8,2,4]` into ascending sorted order. A reasonable first guess is
there might be some `op` that would make this fold evaluate to a sorted list:

```
(7 op (1 op (8 op (2 op (4 op []))))    -- a right fold
```

What could `op` be? Clearly, it must take two inputs, and the first input is
always going to be a single number. The second input will be a list. If we
assume that list is in sorted order, then `op` should insert its first element
into the list at the proper place to ensure it is sorted. In previous notes,
we saw a function that did exactly that:


```haskell
-- 
-- Returns a new list with x inserted into it such that it is sorted.
--
-- Assumes the input list is sorted.
--
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys) | x <= y    = x:y:ys
                | otherwise = y : (insert x ys)

> insert 4 [1..5]
[1,2,3,4,4,5]
> insert 'c' "abde"
"abcde"
```

Using `myfoldr`, we can sort a list like this:

```haskell
> myfoldr insert [] [7,1,8,2,4]
[1,2,4,7,8]
> myfoldr insert "" "cheese please!"
" !aceeeeehlpss"
```

This is a variation of insertion sort:

```haskell
-- 
-- Returns s sorted copy of a list
--
isort :: Ord a => [a] -> [a]
isort = myfoldr insert []

> isort [7,1,8,2,4]
[1,2,4,7,8]
> isort "cheese please!"
" !aceeeeehlpss"
```

Notice that the equation defining `sort` does *not* explicitly mention it's
list parameter. If you prefer, you could write with a list parameter:

```haskell
isort lst = myfoldr insert [] lst
```

### Challenge: counting with fold

Implement a function called `fcount n lst` that calculates the number of times
`n` (an `Int`) occurs in `lst` (a list of `Int`s). Implement `fcount` with a
*single equation* that calls `foldr`.

Here's an example of how to use `fcount`:

```haskell
> fcount 3 [3,6,4,2,1,4]
1
> fcount 4 [3,6,4,2,1,4]
2
> fcount 5 [3,6,4,2,1,4]
0
```

Include the type signature for `fcount`.


### Deriving the type signature for foldr

The type signature of `myfoldr` can be tricky to understand. We can derive it
by looking at a concrete example. For instance, `myfoldr op 0 [4,1,2]`
evaluates to the same thing as:

```haskell
4 `op` (1 `op` (2 `op` 0))
```

Think about the type of `op`. It takes two inputs, and in general they could
be of *any* type `a` and *any* type `b`. The output of a call to `op` is
passed as the second parameter to another `op` call, and so the second
parameter and return type of `op` must be the same:

```haskell
op :: a -> b -> b
```

The initial value, 0 in this example, is passed as the second argument of an
`op`, and so it must be of type `b`.

What is the type of the list of values? From looking at the expression, every
list value is the first parameter of an `op`, and so those values must be of
type `a`. Thus the entire list is of type `[a]`.

Finally, what is the type of the return value? The last expression evaluated
is a call to `op`, and `op` returns a value of type `b`, and so the entire
fold returns a value of type `b`. Putting all this together, the final type
signature is:

```haskell
myfoldr :: (a -> b -> b) -> b -> [a] -> b
```

The standard [Haskell] `foldr` has an even more general type:

```haskell
> :type foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

The difference here is that the *third* input is of type `t a`, where `t`
satisfies the `Foldable` class. Basically, a `Foldable` is any list-like type
that works with `foldr`.


### foldr and the consed-out form of a list

What does `myfoldr (:) [] [2,1,3,4]` evaluate to?

A good way to approach this question is to re-write `[2,1,3,4]` in it's
**consed-out form**. The consed-out form of `[2,1,3,4]` is `2 : (1 : (3 : (4 :
[])))`. `:` is the *cons*, or *construction* operator, and `x:xs` evaluates to
a list that starts with `x` and is followed by the elements of `xs`.

`myfoldr (+) 0 [2,1,3,4]` can be re-written 
`myfoldr (+) 0 (2 : (1 : (3 : (4 : []))))`. 
You can think of `myfoldr` as replacing each `:` with `+`, and the `[]` with 0:
`2 + (1 + (3 + (4 + 0)))`.

Similarly, `myfoldr (-) 0 (2 : (1 : (3 : (4 : []))))` evaluates to the same
thing as `2 - (1 - (3 - (4 - 0)))`, which is 0.

From this point of view it is easy to see what `myfoldr (:) [] (2 : (1 : (3 :
(4 : []))))` evaluates to. Each `:` in the list is replaced by `:`, and the
`[]` is replaced by `[]` --- so there is no change. In other words, `myfoldr
(:) [] [2,1,3,4]` evaluates to `[2,1,3,4]`.


### Mapping a list with foldr

`foldr` can implement the standard `map` function. For the list `[1,2,3]`, a
right fold looks like this:

```haskell
1 op (2 op (3 op initVal))
```

To write `map` using `foldr`, we need to find an `op` and `initVal` that
transforms `1 op (2 op (3 op initVal))` into `[f 1, f 2, f 3]`. Looking just
at `3 op initVal`, we need this to evaluate to `[f 3]`. This suggests
`initVal` ought to be `[]`, and `op` is this:

```haskell
op x lst = (f x) : lst
```

Here's an implementation of `map` using foldr:

```haskell
mymap2 :: (a -> b) -> [a] -> [b]
mymap2 f xs = myfoldr op [] xs
              where op x accum = (f x) : accum
```


### Reversing a list with foldr

The standard list reverse function can implemented as a right fold.

For the list `[1,2,3]`, a right fold will look like this:

```haskell
1 op (2 op (3 op initVal))
```

To evaluate reverse using `foldr`, we need to find an `op` and `initVal` that
transforms `1 op (2 op (3 op initVal))` into `[3,2,1]`.  Looking at `3 op
initVal`, we want it to evaluate to `[3]`. That would give us `1 op (2 op
[3])`, and here we want `2 op [3]` to evaluate to `[3,2]`. So `op` appends its
first input to the *end* of its second input:

```haskell
op x accum = accum ++ [x]
```

The variable name `accum` is short for *accumulator*, the idea is that it is
the accumulation of the fold before the current call to `op`.

Here's an implementation of reverse using `foldr`:

```haskell
myrev :: [a] -> [a]
myrev xs = myfoldr op [] xs
           where op x accum = accum ++ [x]
```


### Filtering a list with foldr

The expression `filter even [1,2,3]` returns `[2]`, i.e. all the elements on
`[1,2,3]` that are even.

To evaluate `filter` using `foldr`, we need to find an `op` and `initVal` that
transforms `1 op (2 op (3 op initVal))` into `[2]`.  Intuitively, if we set
`initVal` to the empty list, then each `op` should *cons* the number onto the
passed-in list just when the number is even. So `op` should be defined like
this:

```haskell
op x acccum = if p x 
              then x : accum
              else accum
```

Here's an implementation of filter using `foldr`:

```haskell
myfilter2 :: (a -> Bool) -> [a] -> [a]
myfilter2 p xs = myfoldr op [] xs
                 where op x accum = if p x
                                    then x : accum
                                    else accum
```

## The `foldl` function

A **left fold** evaluates an expression from left to right. For example, the
sum of the list `[1,2,3]` can be represented as the left folded expression
`((0+1)+2)+3`, or `foldl (+) 0 [1,2,3]`.

Since `(+)` is commutative, `((0+1)+2)+3` evaluates to the same thing as the
right fold `1+(2+(3+0))`. But for non-commutative operators, the result can be
different. For instance, `(-)` is not commutative, and the right fold
`1-(2-(3-0))` equals 2, while the left fold `((0-1)-2)-3` equals -6.

Here's an implementation of fold left:

```haskell
myfoldl :: (a -> b -> a) -> a -> [b] -> a
myfoldl _  init []     = init
myfoldl op init (x:xs) = myfoldl op (init `op` x) xs
```

To get a taste for how fold left works, let's step through an example:

```haskell
myfoldl (+) 0 [1,2,3]
= myfoldl (+) (0 + 1) [2,3]
= myfoldl (+) ((0 + 1) + 2) [3]
= myfoldl (+) (((0 + 1) + 2) + 3) []
= (((0 + 1) + 2) + 3)
= ((1 + 2) + 3)
= (3 + 3)
= 6
```

The expression `(((0 + 1) + 2) + 3)` is key to understanding a left fold. It
shows how the operations are evaluated from left to right. It also helps us
understand why `myfoldl` has the type signature `(a -> b -> a) -> a -> [b] ->
a`. `(+)` has the type `a -> b -> a`. The first argument and the return type
are the same because the output of `(+)` is passed as the left argument to
another `(+)`. The initial value is passed as the left argument of `(+)`, so
those types are the same. The elements of the list are all passed as the
second argument to `(+)`, so the elements on the list must all be the same
type as this second argument. Finally, the return type must be the same as the
first argument to `(+)`.

The implementation of `myfoldr` is **tail recursive**, i.e. the *last* thing
the recursive equation does is call `myfoldr`. Tail recursive functions can be
automatically converted into a loop using a trick called **tail call
optimization**, and the result usually runs faster and uses less memory than
recursion.

An interesting consequence of these definitions of fold is that **`foldl` can
work with infinite lists** in some cases, thanks  to [Haskell]'s lazy
evaluation strategy. But `foldr` **cannot** work with infinite lists because
the first thing it does is recursively evaluate the rest of the list, and for
an infinite list this will go on forever.


## The composition operator

**Function composition** is a fundamental mathematical operation. For example,
if $f(n)=n^2$ and $g(n)=3n+1$, then $f(g(n))=f(3n+1)=(3n+1)^2$. In
mathematics, $f \circ g$ is called the **composition** of $f$ and $g$, and we
can write $(f \circ g)(n)=(3n+1)^2$. $f \circ g$ is a new function that
combines $f$ and $g$. If we want to give this new function a name, we could
write $h = f \circ g$.

In [Haskell], functions are composed with the `(.)` operator:

```haskell
f n = n^2
g n = 3*n+1
h = f . g
```

```haskell
> h 1
16
> h 2
49
```

The expression `f . g` evaluates to a new function that, when given an input,
first applies `g`, and then applies `f` to what `g` returns. You can think of
`f . g` as meaning "`f` after `g`".

The definition of `h` does *not* explicitly give an input parameter. We could
have written it as `h x = (f . g) x`, but the `x` isn't necessary. Defining
functions *without* parameters, e.g. `h = f . g`, is called [**point-free
style**](https://wiki.haskell.org/Pointfree). It is often used in [Haskell] to
shorten function definitions.

> **Note** The website [http://pointfree.io/](http://pointfree.io/) can
> convert [Haskell] definitions into point-free style.

How you bracket function call expressions matters. The expressions `f g 1` and
`f (g 1)` are different. `f g 1` is the same as `(f g) 1`, and in our case
this is an error because `f` expects an integer:

```haskell
> f g 1
<interactive>:73:1: error:
```

Putting `(g 1)` in brackets is necessary to evaluate `g 1` first:

```haskell
> f (g 1)
16
```

An equivalent way to evaluate `f (g 1)` is to compose `f` and `g` with `(.)`:

```haskell
> (f . g) 1
16
```

Here's the type of `(.)`:

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

The type signature tells us `(.)` takes *three* inputs: two functions and a
value. Note carefully the type variables. The input and output of each
function is precisely set up to match types. In the expression `f . g`, `g` is
applied first, and it's output is given as input to `f`. Thus the output of
`g` and the input of `f` must be the same type.

Recall the `twice` function, which takes a function `f` and an input `x`, and
calculates `f ( f  x ):`

```haskell
twice :: (a -> a) -> a -> a
twice f x = f (f x)

> twice (+1) 5
7
> twice (*2) 5
20
> twice reverse "apple"
"apple"
```

Using composition, we can define `twice` like this:

```haskell
twice :: (a -> a) -> a -> a
twice f = f . f
```

A fundamental fact about `(.)` is that it's **associative**. For any three
composable functions `f`, `g`, and `h`, the expressions `f . (g . h)` and `(f
. g) . h` return the **same** value for the same input. This means we can just
write `f . g . h` without using brackets.

**Example** This function gets all the even numbers from a list, squares them,
and then returns their sum:

```haskell
sumSquaresEven = sum . map (^2) . filter even
```

`(.)` greatly simplifies the definition. It's read from right to left: first
`filter even` is applied to the list, then `map (^2)` is applied the result of
the filter, and finally `sum` is applied to the result of the map.

Expressions like `sum . map (^2) . filter even` are sometimes called
**function pipelines**, because they apply a series of functions in order, one
after the other.

Another interesting property of `(.)` occurs with the `id` function:

```haskell
id :: a -> a
id x = x
```

`id` is the **identity function**, and`id x = x` for any value `x`:

```haskell
> id 5
5
> id "house"
"house"
> id [1..5]
[1,2,3,4,5]
```

For any function `f`, both `f . id` and `id . f` are equivalent to `f`. For
`(.)`, `id` acts like 1 in regular multiplication (i.e. for any number $n$,
$1\cdot n=n\cdot 1=n$).


### Challenge: counting values point free

Write a function called `count p lst` that returns the number of elements in
`lst` that satisfy predicate `p`. For example:

```haskell
> count even [1..10]
5
> count (=='e') "once upon a time"
2
```

Make your implementation of `count` as short and simple as possible. **Use
point-free style with a single equation**.

As part of your answer, include the most general type signature for `count`.

## Example: Binary string transmitter

See the textbook.

## Example: Voting algorithms

See the textbook.

[Haskell]: https://en.wikipedia.org/wiki/Haskell_(programming_language)
