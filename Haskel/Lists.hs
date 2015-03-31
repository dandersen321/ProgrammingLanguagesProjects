module Lists where

--creates a list from 1 to n
countingNumbers:: (Num t, Enum t) => t -> [t]
countingNumbers n = [1 .. n]

--creates a list of even numbers between 1 to n
--by creating a list of [1..floor(n/2)] and then multiplying each element
--by 2 (via the lambda in the map function)
evenNumbers :: Int -> [Int]
evenNumbers n = map(\x -> x * 2) [1..(quot n 2)]

--creates a list of prime numbers between 1 to n
primeNumbers :: Integral t => t -> [t]
primeNumbers n = [ x | x <- [1..n], isPrime x] 

--boolean function to determine whether a given number is prime
--used in its "parent" function primeNumbers
isPrime :: Integral a => a -> Bool
isPrime 1 = False
isPrime n = (isPrimeRec n (n-1))

--a recursive function that is called in isPrime
--this function will check whether the greatest common denominator (gcd)
--of a given number (n) has any gcd between n and 1.. (n-1) besides 1
--if it contains a non-one gcd than that number is not prime
isPrimeRec :: Integral a => a -> a -> Bool
isPrimeRec num subNum = 
	if(subNum <= 0)
		then True
	else 
		if( (gcd num subNum) == 1) 
			then
				isPrimeRec num (subNum-1)
			else
				False
				
--merges two sorted lists together to maintain ordering 
--from smallest to largest				
merge :: Ord a => [a] -> [a] -> [a]
merge [] [] = []
merge [] list2 = list2
merge list1 [] = list1 
merge (h1:list1) (h2:list2) = 
	if(h1>h2)
		then h2:(merge (h1:list1) list2)
		else h1:(merge (h2:list2) list1)

--takes the first n elements of myList and appends them to the back
--of myList
wrap :: (Num a, Eq a) => a -> [a1] -> [a1]
wrap 0 (h:myList) = h:myList
wrap k (h:myList) = wrap (k-1) (myList ++ [h])

--given a 2-tuple , it takes the subList of elements whose index falls
--between the two numbers by taking all elements up until the specified end (via a 
--take function) and then dropping all elements up until the specified beginning 
slice :: (Int, Int) -> [a] -> [a]
slice slicePair myList = (drop ((fst slicePair)-1) (take (snd slicePair) myList))

--creates subLists from 1 to n
subLists :: [a] -> [[a]]
subLists [] = []
subLists myList = subListsRec myList (length myList)

--the recursive function to subLists than will keep generating smaller subLists
--of myList until it gets to a sublist of length 1, each smaller sublist is placed at
--the front of the returned list
subListsRec :: [a] -> Int -> [[a]]
subListsRec myList 1 = [(slice (1, 1) myList)]
subListsRec myList end = subListsRec myList (end-1) ++ [(slice (1,end) myList )]

--takes a binary operator and applies it to every element in each list in the my2DList
listApply :: (b -> b -> b) -> [[b]] -> [b]	
listApply f my2DList = (map (myFoldR f) my2DList)

--right associate fold function that will keep applying the binary operator, f,
--until only one element remains
myFoldR :: (a -> a -> a) -> [a] -> a
myFoldR f (h:myList) = 
	if((length myList) == 0)
	then h
	else
		if((length myList) == 1)
		then (f h (head myList))
		else (f h (myFoldR f myList))