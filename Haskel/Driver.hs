import Lists 

{- testIt takes as input a String and a test, prints the String and
   evaluates the test.
-}
testIt :: (Show t) => (String, t) -> IO ()
testIt (s,f) = do 
  putStr "\n" 
  putStr s
  putStr "\n"
  print (f)

{- main executes a sequence of tests. Each test is an ordered pair
   of (String, t), where t is the test. Add tests as you like or
   remove tests if you like.
-}
main = do 
  mapM testIt [
    ("countingNumbers 3", countingNumbers 3),
    ("evenNumbers 10", evenNumbers 10),
    ("primeNumbers 20", primeNumbers 20),
    ("merge (primeNumbers 20) (evenNumbers 10)", merge (primeNumbers 20) (evenNumbers 10)),
    ("merge (evenNumbers 20) (primeNumbers 10)", merge (evenNumbers 20) (primeNumbers 10)),
    ("slice (1,3) (countingNumbers 20)", slice (1,3) (countingNumbers 20)),  
    ("slice (17,22) (countingNumbers 20)", slice (17,22) (countingNumbers 20)),
    ("wrap 5 (countingNumbers 10)", wrap 5 (countingNumbers 10)),
    ("wrap 10 (countingNumbers 10)", wrap 10 (countingNumbers 10))
    ]
  mapM testIt [
    ("subLists (countingNumbers 5)", subLists (countingNumbers 5))
    ]
  mapM testIt [
    ("listApply (+) (subLists (countingNumbers 5))", listApply (+) (subLists (countingNumbers 5)))
    ]