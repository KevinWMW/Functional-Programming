{- 
   DomsMatch: code to play a dominoes match between two players.
   
   The top level function is domsMatch - it takes five arguments:
       games - the number of games to play
       target - the target score to reach
       player1, player2 - two DomsPlayer functions, representing the two players
       seed - an integer to seed the random number generator
   The function returns a pair showing how many games were won by each player.

   The functions of type DomsPlayer must take four arguments:
       The current Hand
       The current Board
       The Player (which will be one of P1 or P2)
       The current Scores
   The function returns a tuple containing the Domino to play and End to play it on.

   You should add your functions and any additional types that you require to your own copy of
   this file. Before you submit, make sure you update this header documentation to remove these
   instructions and replace them with authorship details and a brief summary of the file contents.

   Similarly, remember you will be assessed not *just* on correctness, but also code style,
   including (but not limited to) sensible naming, good functional decomposition, good layout,
   and good comments.
 -}


--  DATATYPES 
-- The key datatypes are provided for you in the file DomsMatch.hs. You should not change these datatypes. 
-- These are: 
-- • Domino – representing a domino tile. 
-- • DominoBoard – which contains a current board state – either the initial (that is, empty) board, or the 
-- current state, represented by: the left-most domino (with left-most pips in the first position in the 
-- tuple), the right-most domino (with right-most pips in the second position in the tuple), and the 
-- history of the game. 
-- • History – the layout of the board from left at the start of the list to right at the end of the list, where 
-- each domino is combined with which player played it and which turn at which it was played. 
-- • Player – essentially two labels to identify the individual players. 
-- • End – indicating the end at which a tile is placed. 
-- • Scores – a tuple of scores representing (player 1’s score, player 2’s score) 
-- • MoveNum – to keep track of what was played when. 
-- • Hand – a set of dominos 
-- • DomsPlayer – this is the type of a function. A function of this type will return the move that it will 
-- make given the current Hand, Board, and Scores (Player is also an argument, indicating which player 
-- this player is, which may be useful if you wish to refer to the History when deciding on your move.) 
-- You can add extra datatypes if you wish.


 {- 
    This is Kevin's Code, hope you enjoy
 -}

module DomsMatch where
  import System.Random
  import Data.List
  import Data.Ord (comparing)


  -- types used in this module
  type Domino = (Int, Int) -- a single domino
  {- Board data type: either an empty board (InitState) or the current state as represented by
      * the left-most domino (such that in the tuple (x,y), x represents the left-most pips)
      * the right-most domino (such that in the tuple (x,y), y represents the right-most pips)
      * the history of moves in the round so far
    -}
  data Board = InitState | State Domino Domino History deriving (Eq, Show)
  {- History should contain the *full* list of dominos played so far, from leftmost to
      rightmost, together with which player played that move and when they played it
    -}
  type History = [(Domino, Player, MoveNum)]
  data Player = P1 | P2 deriving (Eq, Show)
  data End = L | R deriving (Eq, Show)
  type Scores = (Int, Int) -- P1’s score, P2’s score
  type MoveNum = Int
  type Hand = [Domino]
  {- DomsPlayer is a function that given a Hand, Board, Player and Scores will decide
      which domino to play where. The Player information can be used to "remember" which
      moves in the History of the Board were played by self and which by opponent
    -}
  type DomsPlayer = Hand -> Board -> Player -> Scores -> (Domino, End)

  {- domSet: a full set of dominoes, unshuffled -}
  domSet = [ (l,r) | l <- [0..6], r <- [0..l] ]

  {- shuffleDoms: returns a shuffled set of dominoes, given a number generator
      It works by generating a random list of numbers, zipping this list together
      with the ordered set of dominos, sorting the resulting pairs based on the random
      numbers that were generated, then outputting the dominos from the resulting list.
    -}
  shuffleDoms :: StdGen -> [Domino]
  shuffleDoms gen = [ d | (r,d) <- sort (zip (randoms gen :: [Int]) domSet)]

  {- domsMatch: play a match of n games between two players,
      given a seed for the random number generator
      input: number of games to play, number of dominos in hand at start of each game,
            target score for each game, functions to determine the next move for each
            of the players, seed for random number generator
      output: a pair of integers, indicating the number of games won by each player
    -}
  domsMatch :: Int -> Int -> Int -> DomsPlayer -> DomsPlayer -> Int -> (Int, Int)
  domsMatch games handSize target p1 p2 seed
      = domsGames games p1 p2 (mkStdGen seed) (0, 0)
        where
        domsGames 0 _  _  _   wins               = wins
        domsGames n p1 p2 gen (p1_wins, p2_wins)
          = domsGames (n-1) p1 p2 gen2 updatedScore
            where
            updatedScore
              | playGame handSize target p1 p2 (if odd n then P1 else P2) gen1 == P1 = (p1_wins+1,p2_wins)
              | otherwise                                            = (p1_wins, p2_wins+1)
            (gen1, gen2) = split gen
            {- Note: the line above is how you split a single generator to get two generators.
                Each generator will produce a different set of pseudo-random numbers, but a given
                seed will always produce the same sets of random numbers.
              -}

  {- playGame: play a single game (where winner is determined by a player reaching
        target exactly) between two players
      input: functions to determine the next move for each of the players, player to have
            first go, random number generator 
      output: the winning player
    -}
  playGame :: Int -> Int -> DomsPlayer -> DomsPlayer -> Player -> StdGen -> Player
  playGame handSize target p1 p2 firstPlayer gen
      = playGame' p1 p2 firstPlayer gen (0, 0)
        where
        playGame' p1 p2 firstPlayer gen (s1, s2)
          | s1 == target = P1
          | s2 == target = P2
          | otherwise
              = let
                    newScores = playDomsRound handSize target p1 p2 firstPlayer currentG (s1, s2)
                    (currentG, nextG) = split gen
                in
                playGame' p1 p2 (if firstPlayer == P1 then P2 else P1) nextG newScores

  {- playDomsRound: given the starting hand size, two dominos players, the player to go first,
      the score at the start of the round, and the random number generator, returns the score at
      the end of the round.
      To complete a round, turns are played until either one player reaches the target or both
      players are blocked.
    -}
  playDomsRound :: Int -> Int -> DomsPlayer -> DomsPlayer -> Player -> StdGen -> (Int, Int) -> (Int, Int)
  playDomsRound handSize target p1 p2 first gen scores
      = playDomsRound' p1 p2 first (hand1, hand2, InitState, scores)
        where
        -- shuffle the dominoes and generate the initial hands
        shuffled = shuffleDoms gen
        hand1 = take handSize shuffled
        hand2 = take handSize (drop handSize shuffled)
        {- playDomsRound' recursively alternates between each player, keeping track of the game state
            (each player's hand, the board, the scores) until both players are blocked -}
        playDomsRound' p1 p2 turn gameState@(hand1, hand2, board, (score1,score2))
          | (score1 == target) || (score2 == target) || (p1_blocked && p2_blocked) = (score1,score2)
          | turn == P1 && p1_blocked = playDomsRound' p1 p2 P2 gameState
          | turn == P2 && p2_blocked = playDomsRound' p1 p2 P1 gameState
          | turn == P1               = playDomsRound' p1 p2 P2 newGameState
          | otherwise                = playDomsRound' p1 p2 P1 newGameState
            where
            p1_blocked = blocked hand1 board
            p2_blocked = blocked hand2 board
            (domino, end)          -- get next move from appropriate player
                | turn == P1 = p1 hand1 board turn (score1, score2)
                | turn == P2 = p2 hand2 board turn (score1, score2)
                                    -- attempt to play this move
            maybeBoard             -- try to play domino at end as returned by the player
                | turn == P1 && not (elem domino hand1) = Nothing -- can't play a domino you don't have!
                | turn == P2 && not (elem domino hand2) = Nothing
                | otherwise = playDom turn domino board end
            newGameState           -- if successful update board state (exit with error otherwise)
                | maybeBoard == Nothing = error ("Player " ++ show turn ++ " attempted to play an invalid move.")
                | otherwise             = (newHand1, newHand2, newBoard,
                                            (limitScore score1 newScore1, limitScore score2 newScore2))
            (newHand1, newHand2)   -- remove the domino that was just played
                | turn == P1 = (hand1\\[domino], hand2)
                | turn == P2 = (hand1, hand2\\[domino])
            score = scoreBoard newBoard (newHand1 == [] || newHand2 == [])
            (newScore1, newScore2) -- work out updated scores
                | turn == P1 = (score1+score,score2)
                | otherwise  = (score1,score2+score)
            limitScore old new     -- make sure new score doesn't exceed target
                | new > target = old
                | otherwise    = new
            Just newBoard = maybeBoard -- extract the new board from the Maybe type

  -- SCORING A BOARD 
  -- The first function you must implement is scoreBoard. scoreBoard takes a Board and a Bool as arguments, 
  -- where the Bool is True if the domino just played was the last domino from the hand, and False otherwise, and 
  -- returns the score that would be received by creating this board state. For example, if the first player played 
  -- (4,5), the board would contain just this domino, and so would score 3 (three threes – unless for some weird 
  -- reason you were playing with an initial hand size of 1, in which case the score would be 2). If the next domino 
  -- played was a (5,1) (which could only be played to the right end), the score on this board ([(4,5)(5,1)]) would 
  -- be 1 (4+1 = 5; one five – again, unless you were playing with an initial hand size of 2...). 

  scoreBoard :: Board -> Bool -> Int
  scoreBoard _ _ = 0
  ScoreBoard board bool = Scoreboard' 

  blocked :: Hand -> Board -> Bool
  blocked _ _ = True

  playDom :: Player -> Domino -> Board -> End -> Maybe Board
  playDom _ _ _ _ = Nothing



  -- Checks if the either left or right of the domino matches the end on the board
  -- canPlay: a predicate (function that returns True or False) given a Domino, an End and a Board, returns 
  -- True if the domino can be played at the given end of the board.
  -- canPlay :: Domino -> End -> Board -> Bool
  canPlay :: Domino -> End -> Board -> Bool
  canPlay domino end board = 
    canPlay' domino end
    where
      canPlay' domino end 
        | fst domino || snd domino == fst end || snd end = True
        | otherwise = False

