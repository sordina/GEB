> import Data.List
> import Control.Monad.Logic

The MU-puzzle
=============

Formal Systems
--------------

ONE OF THE most central notions in this book is that of a formal system. The type of
formal system I use was invented by the American logician Emil Post in the 1920's, and
is often called a "Post production system". This Chapter introduces you to a formal
system and moreover, it is my hope that you will want to explore this formal system at
least a little; so to provoke your curiosity, I have posed a little puzzle.

> data Alphabet = M | I | U

> data Regex = Group    [Regex]
>            | List     [Alphabet] -- List is just a convenience function to avoid bulk 'Atom's
>            | Last      Regex
>            | Capture   Regex
>            | Plus      Regex
>            | Atom      Alphabet
>            | Reference Int
>            | Anything

> data Action = Append Regex Regex | Replace Regex Regex | Remove Regex

"Can you produce MU?" is the puzzle. To begin with, you will be supplied with a
string (which means a string of letters).* Not to keep you in suspense, that string will be
MI. Then you will be told some rules, with which you can change one string into another.
If one of those rules is applicable at some point, and you want to use it, you may, but
there is nothing that will dictate which rule you should use, in case there are several
applicable rules. That is left up to you-and of course, that is where playing the game of
any formal system can become something of an art. The major point, which almost
doesn't need stating, is that you must not do anything which is outside the rules. We
might call this restriction the "Requirement of Formality". In the present Chapter, it
probably won't need to be stressed at all. Strange though it may sound, though, I predict
that when you play around with some of the formal systems of Chapters to come, you
will find yourself violating the Requirement of Formality over and over again, unless you
have worked with formal systems before.

The first thing to say about our formal system-the MIU-system-is that it utilizes
only three letters of the alphabet: M, I, U. That means that the only strings of the MIU
system are strings which are composed of those three letters. Below are some strings of
the MIU-system:

MU
UIM
MUUMUU
UIIUMIUUIMUIIUMIUUIMUIIU

But although all of these are legitimate strings, they are not strings which are "in your
possession". In fact, the only string in your possession so far is MI. Only by using the
rules, about to be introduced, can you enlarge your private collection. Here is the first
rule:

RULE I: If you possess a string whose last letter is I, you can add on a U at the end.

> rule1 = Append (Last (Atom I)) (Atom U)

By the way, if up to this point you had not guessed it, a fact about the meaning of "string"
is that the letters are in a fixed order. For example, MI and IM are two different strings.
A string of symbols is not just a "bag" of symbols, in which the order doesn't make any
difference.

Here is the second rule:

RULE II: Suppose you have Mx. Then you may add Mxx to your collection.

> rule2 = Replace
>           (Group [Atom M, Capture (Plus (Anything))])
>           (Group [Atom M, Reference 1, Reference 1])

What I mean by this is shown below, in a few examples.

From MIU, you may get MIUIU.
From MUM, you may get MUMUM.
From MU, you may get MUU.

So the letter `x' in the rule simply stands for any string; but once you have decided which
string it stands for, you have to stick with your choice (until you use the rule again, at
which point you may make a new choice). Notice the third example above. It shows how,
once you possess MU, you can add another string to your collection; but you have to get
MU first! I want to add one last comment about the letter `x': it is not part of the formal
system in the same way as the three letters `M', `I', and `U' are. It is useful for us,
though, to have some way to talk in general about strings of the system, symbolically-and
that is the function of the `x': to stand for an arbitrary string. If you ever add a string
containing an 'x' to your "collection", you have done something wrong, because strings of
the MIU-system never contain "x" “s”!

Here is the third rule:

RULE III: If III occurs in one of the strings in your collection, you may make a new
string with U in place of III.

> rule3 = Replace (List [I,I,I]) (Atom U)

Examples:
From UMIIIMU, you could make UMUMU.
From MII11, you could make MIU (also MUI).
From IIMII, you can't get anywhere using this rule. (The three I's have to be consecutive.)
From MIII, make MU.

Don't, under any circumstances, think you can run this rule backwards, as in the
following example:

From MU, make MIII <- This is wrong.

Rules are one-way.

Here is the final rule.

RULE IV: If UU occurs inside one of your strings, you can drop it.

> rule4 = Remove (List [U,U])

From UUU, get U.
From MUUUIII, get MUIII.

There you have it. Now you may begin trying to make MU. Don't worry you don't get it.
Just try it out a bit-the main thing is for you to get the flavor of this MU-puzzle. Have
fun.
