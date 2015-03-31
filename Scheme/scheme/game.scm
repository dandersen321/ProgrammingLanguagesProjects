;keeps pitting the two knights against each other
;until one knight wins (no draws allowled)
(define (jousting-game knight1 knight2)
  (let ((results (joust knight1 knight2)))
   (if (equal? (car results) (cadr results))
        (jousting-game knight1 knight2)
        (if(equal? (car results) #t)
            1
            2
         )
     )
  ) 
)

;does one joust in a jousting-game
;it will return a list of which knights were unhorsed (if any)
(define (joust player1 player2)
    (display "---JOUST---")(newline)
    (let*
      (
       (player1List (player1))
       (player2List (player2))
       (knight1Print(printKnight player1List)) ;will be void but needed to call the print function
       (knight2Print (printKnight player2List)) ;will be void but needed to call the print function
       (player1Unhorsed (if (or (unhorsed? (car player2List) (cadr player1List) (caddr player2List)) ;2nd's shield, 1st's lance, 2nd's name
                                (ducked? (car player1List) (cadr player2List) (caddr player2List)) ;1st's shield, 2nd's lance, 2nd's name
                            )
                            #t
                            #f
                        )
        )
       
       (player2Unhorsed (if (or (unhorsed? (car player1List) (cadr player2List) (caddr player1List))
                                (ducked? (car player2List) (cadr player1List) (caddr player1List))
                             )
                            #t
                            #f
                         ) 
       )
      )
      (display "---END JOUST---")(newline)
      (list player1Unhorsed player2Unhorsed)
    )
)

;prints the knights name, shield position, and lance position for a particular joust
(define (printKnight knightList)
  (display " holds shield ")
  (display (car knightList))
  (display " and aims lance ")
  (display (cadr knightList))
  (display ".\n")
)

;determines whether the knight passed in was unhorsed given his shield position and
;his opponent's lance position
(define (unhorsed? shield lance knight)
    (cond ((and (equal? shield "low") (equal? lance "high"))
                (display knight)(display " was unhorsed")(newline)#t)
          ((and (equal? shield "high") (equal? lance "low"))
                (display knight)(display " was unhorsed")(newline)#t)
          (else #f))
)

;determines whether the knight passed in was unhorsed given his lance position and
;his opponent's shield position
(define (ducked? shield lance knight)
  (begin 
    (cond ((and (equal? shield "duck") (equal? lance "high"))
                (display knight)(display "  was cowardly unhorsed")(newline)#t)
          (else #f))
  )
)