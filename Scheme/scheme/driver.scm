(load "knights.scm")
(load "game.scm")
(load "tournament.scm")

 
     
 




(define (play) (jousting-game black-knight white-knight))

(define (tour) (double-elimination-tournament
		 (list yellow-knight black-knight white-knight joan-of-arc))
)

(display "--------------playing a game\n")
(play)
(display "--------------playing a tournmanet----------\n")
(tour)

(tournaments double-elimination-tournament 100 (list me black-knight joan-of-arc sir-lancelot))  



