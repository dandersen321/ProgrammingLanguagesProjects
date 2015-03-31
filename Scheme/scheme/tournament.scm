;takes a list of knights and fights them off only one knight is left
;a knight may lose 1 time in this tournament and still be able to win
(define (double-elimination-tournament knightList)
  (if (null? knightList)
      knightList
      ;the joustUntilVector returns a list of 1 element, the winning knightPair (knight, knightlosses)
      ;the car car then gets the knight out of this list of a winning knightPair
      ;the getOrdinal then returns the index (based index (1-based) of the winning knight in the knightList given 
      ;I misinterpreted the instructions (I did it differently and then changed my code to match your expected input and output) which is why this look so ugly :(
      (getOrdinal 1 knightList (car (car (joustUntilVictor (map intializeKnightPair knightList) 1)))) ;the 1 is the number of times a knight can lose and still be in the tourney
   )
)

;takes a list of knights and fights them off only one knight is left
;a knight may lose 3 time in this tournament and still be able to win
(define (quadruple-elimination-tournament knightList)
  (if (null? knightList)
      knightList
      (getOrdinal 1 knightList (car (car (joustUntilVictor (map intializeKnightPair knightList) 3)))) ;the 3 is the number of times a knight can lose and still be in the tourney
   )
)

;takes a list of knights and fights them off only one knight is left
;losses-to-elimination is the number of losses at which a knight drops out of the tourney
(define (tournament losses-to-elimination knightList)
  (if (null? knightList)
      knightList
      (getOrdinal 1 knightList (car (car (joustUntilVictor (map intializeKnightPair knightList) (- losses-to-elimination 1)))))
   )
)


;constructor that pairs a knight with zero (the zero represents the number of times that knight has lost in the tourney)
(define (intializeKnightPair knight)
  (list knight 0)
)

;this function will keep fighting off knights until one knight is left
;who has not lost more than the maxLoseNumber of times
;it works by doing a joustingRound (each knight does one complete joust)
;note that before the joustingRound the knights are sorted so those
;with the fewest number of loses fight those with fewer number of loses and vice versa
;this helps ensure equality because knights will fight other knights of relatively equal "strength"
(define (joustUntilVictor listOfKnightPairs maxLoseNumber)
  (if (equal? (length listOfKnightPairs) 1)
      listOfKnightPairs
      ;this next line reorders the knights according to their lose ranking and then does another jousting round (the number of jousts to do is the integer division of the length of the knights with 2)
      (joustUntilVictor (joustingRound (sortListOfKnightPairs listOfKnightPairs) maxLoseNumber 0 (truncate (/ (length listOfKnightPairs)2))) maxLoseNumber)
  )
)

;this is one joustingRound where each knight in the listOfKnights will fight once
(define (joustingRound listOfKnightPairs maxLoseNumber joustsDone joustsToDo)
  (if (or (equal? joustsDone joustsToDo)(equal? (length listOfKnightPairs) 1))
    listOfKnightPairs
    (begin
       (let*
            (
              (knight1 (car (car listOfKnightPairs)))
              (knight1Loses (cadr (car listOfKnightPairs)))
              (knight2 (car (cadr listOfKnightPairs)))
              (knight2Loses (cadr (cadr listOfKnightPairs)))
              (results (jousting-game knight1 knight2))
            )  
          (if (equal? results 1)
              (if (equal? knight2Loses maxLoseNumber) ;this happens when first knight wins
                  (joustingRound (append (cddr listOfKnightPairs) (list (list knight1 knight1Loses)) ) maxLoseNumber (+ 1 joustsDone) joustsToDo) ;loser knight has dropped out of tourney
                  (joustingRound (append (cddr listOfKnightPairs) (list (list knight1 knight1Loses)) (list (list knight2 (+ 1 knight2Loses))) ) maxLoseNumber (+ 1 joustsDone) joustsToDo) ;loser knight gets 1 added to his loses before he gets put back in the tourney
              )
               
              (if (equal? (cadr (car listOfKnightPairs)) maxLoseNumber) ;this happens when second knight wins
                  (joustingRound (append (cddr listOfKnightPairs) (list (list knight2 knight2Loses)) ) maxLoseNumber (+ 1 joustsDone) joustsToDo) ;loser knight has dropped out of tourney
                  (joustingRound (append (cddr listOfKnightPairs) (list (list knight2 knight2Loses)) (list (list knight1 (+ 1 knight1Loses))) ) maxLoseNumber (+ 1 joustsDone) joustsToDo) ;loser knight gets 1 added to his loses before he gets put back in the tourney
              )
           )
           
       )
    )
   )
)

;sorts the knights according to their lose number (recursive insertion sort)
(define (sortListOfKnightPairs listOfKnightPairs)
  (if (equal? (length listOfKnightPairs) 1)
      listOfKnightPairs
      (insert (car listOfKnightPairs) (sortListOfKnightPairs (cdr listOfKnightPairs)))
  )
)

;the insertion for the insertion sort when sorting knights according to their lose number
(define (insert elemToInsert listOfKnightPairs)
  (if (null? listOfKnightPairs)
      (list elemToInsert)
      (if (< (cadr elemToInsert) (cadr (car listOfKnightPairs)))
         (append (list elemToInsert) listOfKnightPairs)
         (append (list (car listOfKnightPairs)) (insert elemToInsert (cdr listOfKnightPairs)))
      )
  )
)

;n is the number of tournaments that will be done
;style is the type of tournament (e.x. double-elimination-tournament)
;knightList is the list of knights competing in the tourney
;this function will run the tourney n times and get the results
;it will then print the knights in order of the place they got in the tourney
;it will then return the knight's scores (in the order they were given in knightList (i.e. not ordered by rank))
;NOTE: this function assumes there can be no duplicate knights i.e. there can't be two sir-lancelots
(define (tournaments style n knightList)
  (let 
      (
      (listOfKnightPairResults (tournamentsRecursion (map intializeKnightPair knightList) n style))
      )
      (newline)(display "---RESULTS---")(newline)
      (displayTournamentResults (sortListOfKnightPairs listOfKnightPairResults))
      (display "---END RESULTS---")(newline)(newline)
      (getScoresFromKnightPairs listOfKnightPairResults)
  )
)

;listOfKnightPairs is a list of knights paired with their win score
;keeps fighting the knights n number of times with the given style
(define (tournamentsRecursion listOfKnightPairs n style)
  (if (equal? n 0)
    listOfKnightPairs
    ;this next line gets the index (1-based) of the winning knight from the style function, then subtracts one to convert it back to a 0-based index system
    ;and then gets the winning knight using the index and passes that to addToWinningKnight which adds one to that knight's win-record
    (tournamentsRecursion (addToWinningKnight listOfKnightPairs (car (list-ref listOfKnightPairs (- (style (getKnightsFromKnightPairs listOfKnightPairs)) 1)))) (- n 1) style)
  )
)

;adds one to the score of the knight that won
(define (addToWinningKnight listOfKnightPairs winningKnight)
  (if (equal? (length listOfKnightPairs) 0)
      listOfKnightPairs
      (if (equal? (car (car listOfKnightPairs)) winningKnight)
        (append (list (list (car (car listOfKnightPairs)) (+ 1 (cadr (car listOfKnightPairs))))) (addToWinningKnight (cdr listOfKnightPairs) winningKnight))
        (append (list (list (car (car listOfKnightPairs)) (cadr (car listOfKnightPairs)))) (addToWinningKnight (cdr listOfKnightPairs) winningKnight))
      )
  )
)

;returns a list of knights from a list of knight pairs
(define (getKnightsFromKnightPairs listOfKnightPairs)
  (if (equal? (length listOfKnightPairs) 0)
     listOfKnightPairs
     (append (list (car (car listOfKnightPairs))) (getKnightsFromKnightPairs (cdr listOfKnightPairs)))
   )
)

;returns a list of scores from a list of knight pairs
(define (getScoresFromKnightPairs listOfKnightPairs)
  (if (equal? (length listOfKnightPairs) 0)
     listOfKnightPairs
     (append (list (cadr (car listOfKnightPairs))) (getScoresFromKnightPairs (cdr listOfKnightPairs)))
   )
)

;gets the list of knights that competed in the tourney and
;displays them in order (from lowest to highest)
(define (displayTournamentResults sortedListOfKnightPairs)
  (if (equal? (length sortedListOfKnightPairs) 1)
      (begin
         (display (caddr ((car (car sortedListOfKnightPairs)))))
         (display " won this tournament")
         (display " with ")(display (cadr (car sortedListOfKnightPairs)))(display " wins!")
         (newline)
       )
      (begin
         (display (caddr ((car (car sortedListOfKnightPairs)))))
         (display " placed ")(display (length sortedListOfKnightPairs))(display " in the tournament")
         (display " with ")(display (cadr (car sortedListOfKnightPairs)))(display " wins!")
         (newline)
         (displayTournamentResults (cdr sortedListOfKnightPairs))
      )
   )
)


;sorry, I misinterpreted the instructions so I had to change things to return the ordinal rather
;than the actual knight, this function gets the knightlist and returns the index (1-based)
;position of that knight
(define (getOrdinal index knightList knightToSearchFor)
  (if (equal? (car knightList) knightToSearchFor)
    index
    (getOrdinal (+ 1 index) (cdr knightList) knightToSearchFor)
  )
)