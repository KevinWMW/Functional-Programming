# Welcome to Kevin Wu's report for the COM2008 Functional Programming Assignment

Designing the scoreBoard algorithm:

We need to access the two open ends to calculate the score.
We can access this by using data Player = P1 | P2 deriving (Eq, Show)
We also need to check if a domino is the last one to played from our hand.
We can do this by using conditionals. Conditionals must have an else statement

Designing canPlay function:

- Check the two ends of the given domino
- Check the two ends of the given board
-

Dictionary:

deriving: we want the compiler to generate instances of the eq and show classes for our pair types

Eq: allows instances to be tested for equality
Show: allows instances to be converted into string

Todo:

- Analyse PlayDomsMatch code
- Implement canPlay predicate
