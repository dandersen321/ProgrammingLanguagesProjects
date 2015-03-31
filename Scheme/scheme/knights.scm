(#%require (only racket/base random))

;Sir Lancelot varies his attack and defense fairly evenly
(define (sir-lancelot)
  (let (
        (shield
    (case(random 10)
    ((0 1 2 3 ) "high") 
    ((4 5 6 7 ) "low")
    ((8 9) "duck")))
    (lance (if (>= (random 10) 5) "low" "high"))
    ) 
    (list shield lance "Sir Lancelot")
  )
)


;I choose to always duck (so I never get hit)
;90% of the time I aim low so as to avoid getting unhorsed by aiming high at a ducking knight however
;10% of the time I aim high so as to break a potential stalemate if the opposing knight's shield is always low and he never aims high
;this strategy is approved by Sir Jaime lannister
(define (me)
  (let 
    (
        (shield "duck")
        (lance (if (>= (random 10) 1) "low" "high"))
    ) 
    (list shield lance "Dylan of House Andersen")
  )
)
; ------------------------other knights-------------------

; The black knight prefers guile to courage, and
; so ducks and holds his shield low. He also likes
; to aim his lance low.
(define (black-knight) 
  (let (
    (shield (if (>= (random 10) 5) "low" "duck"))
    (lance (if (>= (random 10) 2) "low" "high"))
    ) 
    (list shield lance "Black knight")
  )
)

; The white knight rides high in the saddle and likes
; to hold his shield and lance high
(define (white-knight) 
  (let (
    (shield (if (>= (random 10) 2) "high" "low"))
    (lance (if (>= (random 10) 2) "high" "low"))
    ) 
    (list shield lance "White knight")
  )
)

; Joan of Arc tends to hold her lance high and her
; shield low.
(define (joan-of-arc)
  (let (
    (shield (if (>= (random 10) 8) "high" "low"))
    (lance (if (>= (random 10) 2) "high" "low"))
    ) 
    (list shield lance "Joan of Arc")
  )
)

; The yellow knight rarely does anything ducks often
; and holds his shield low.
(define (yellow-knight) 
  (let (
    (shield (if (>= (random 10) 1) "duck" "high"))
    (lance (if (>= (random 10) 1) "low" "high"))
    ) 
    (list shield lance "Yellow Knight")
  )
)
