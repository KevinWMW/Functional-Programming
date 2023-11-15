
{- This is Week 2 of Haskell Programming Exercises-}



{- n :: Int
n = a `div` length xs
 where
 a = 10
 xs = [1, 2, 3, 4, 5]
-}

-- Exercise 2 --


second :: [a] -> a
second xs = head (tail xs)

pair :: a -> b -> (a, b)
pair x y = (x,y)

palin :: Eq a => [a] -> Bool
palin xs = reverse xs == xs

double :: Num a => a -> a
double x = x*2


-- Exercise 3 --

halve :: [a] -> ([a],[a])

halve xs = splitAt n xs where n = length xs `div` 2


-- squareNums :: (Num b, Enum b) => b -> [(b, b)]
-- squareNums n = [ (x,y) | x <- [1..n], y <- [1..x] ]

-- Exercise 4 --

euclidean :: (Int, Int) -> (Int, Int) -> Float
euclidean (x1, y1) (x2, y2) = sqrt (fromIntegral ((x2-x1)^2 + (y2-y1)^2))

-- Exercise 5 --
-- Define a function that uses library functions to return the first word in a string. For
-- example:
-- > firstWord "a test string"
-- "a"
-- >firstWord " the trickier test string"
-- “the”

firstWord :: String -> String

firstWord input = takeWhile (/= ' ') (dropWhile (== ' ') input)


-- Exercise 6 --

-- Write a new function, safeTail, that instead of generating an error when the input is an
-- empty list (as tail does), simply returns an empty list. See if you can provide two different
-- solutions:

safeTail :: [a] -> [a]
safeTail xs | null xs = []
            | otherwise = tail xs



ed



-- Exercise 9 --
-- Write a function that returns all the odd items in a list using the library function filter and
-- an appropriate where clause
-- oddItems :: [Int] -> [Int]

oddItems :: [Int] -> [Int]

oddItems = filter xs where xs = odd

-- oddItems xs = filter isOdd xs where isOdd n = n `mod` 2 /= 0 --


--- Exercise 11 --


-- You suck, please use list comprehension for this. --




-- Exercise 12 --





-- Exercise 21 --

sumThese :: [a] -> a



-- sumThese xs = sum xs

-- sum is a library function therefore we use ' at the end to highlight that it's a different function compared to the library one.
-- However, since I am dumb asf, I used These to denote a different function instead. 
-- sumThese xs = foldr (+) 0 xs
-- sumThese [] = 0
-- sumThese (x:xs) = x + sumThese xs 

