;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname tick_functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; tick_functions.rkt - Functions that deal with the next element of the kind on clock tick

(require "provide.rkt")
(require "constants.rkt")
(require "data_structures.rkt")
(require "collision.rkt")

;; Make everything available for the main file
(provide (all-defined-out))

;(define (next-game g) g) ;stub
;; Game -> Game
;; produces the next game stage: move all invaders, missiles and tank, or wait for restart
; (define (next-game g) (make-game empty empty T0 score)) ; stub

(define (next-game g)
  (cond [(and (string? g) (string=? g "GAME OVER")) "GAME OVER"]
        [(is-game-over? (game-invaders g)) "GAME OVER"]
        [else
         (colide
         (invade-more
         (make-game
          (next-invaders (game-invaders g))
          (next-missiles (game-missiles g))
          (next-tank (game-tank g))
          (game-counter g)
          )))]))

;; (listof Invader) -> (listof Invader) or "GAME OVER"
;; Parse the invaders. If there is a GAME OVER invader, finish the game
(define (parse-invaders loi)
  (cond [(empty? loi) empty]
        [(and (string? (first loi)) (string=? (first loi) "GAME OVER")) "GAME OVER"]
        [else (cons (first loi) (parse-invaders (rest loi)))]))

;; Game -> Game
;; produces an extra invader every time the counter reaches INVADER-RATE
;(define (invade-more g) g) ;stub
(define (invade-more g)
  (cond [(and (string? g) (string=? g "GAME OVER")) g]
        [(string? (game-invaders g)) "GAME OVER"]
        [else
         (if (> (add1 (game-counter g)) (invade-limit g))
             (add-extra-invader g)
             (add1-to-counter g)
             )]))


;; Game -> Game
;; increments the game counter to decide when to create a new invader
(define (add1-to-counter g)
  (make-game
   (game-invaders g)
   (game-missiles g)
   (game-tank g)
   (add1 (game-counter g))))

;; Game -> Game
;; inserts a generated invader in the list of invader
;(define (add-extra-invader g) g); stub
(define (add-extra-invader g)
  (make-game
   (append (game-invaders g) (generate-invaders 1))
   (game-missiles g)
   (game-tank g)
   0))

(define (invade-limit g)
  (if (> (count-score (game-invaders g) 0) INVADE-RATE)
      1
      (- INVADE-RATE (count-score (game-invaders g) 0))))

;; Number -> (listof Invaders)
;; generates a list with "Number" new invaders in a random x position and top of screen
(define (generate-invaders n)
  (cond [(zero? n) empty]
        [else (cons RANDOM-INVADER (generate-invaders (sub1 n)))]))

(define RANDOM-INVADER                     
  (make-invader
   (+ (random (- WIDTH INVADER-WIDTH/2)) INVADER-WIDTH/2)
   INVADER-TL
   (* RANDOM-SIGN INVADER-X-SPEED)))


;; Game -> Number
;; Count the amount of hit invaders in the tick round
(define (count-hits g) 0) ; A STUB just to see if everything else compiles
;; !!!

#;
(define (next-game g)
  (cond [(and (string? g) (string=? g "GAME OVER")) "GAME OVER"]
        [else
         (make-game (next-invader 
         (fn-for-loinvader (game-invaders s))
         (fn-for-lom (game-missiles s))
         (fn-for-tank (game-tank s))
         (fn-for-counter (game-counter s))))]))



;; Tank -> Tank
;; interp. produces the next tank
;; When the tank reaches a border, it inverts it's position
;(define (next-tank t) #false) ; stub

(check-expect (next-tank (make-tank 50 1)) (make-tank (+ 50 TANK-SPEED) 1))
(check-expect (next-tank (make-tank (- TANK-LL 1) -1)) (make-tank (+ (- TANK-LL 1) TANK-SPEED) 1))
(check-expect (next-tank (make-tank (+ TANK-RL 1) 1)) (make-tank (- (+ TANK-RL 1) TANK-SPEED) -1))
(check-expect (next-tank (make-tank 50 -1)) (make-tank (- 50 TANK-SPEED) -1))

(define (next-tank t)
  (cond [(and (>= TANK-LL (tank-x t)) (= (tank-dir t) TANK-GO-LEFT)) ; tank passing the left limit going left
         (make-tank (+ (tank-x t) TANK-SPEED) TANK-GO-RIGHT)] ; Switch direction
        [(and (<= TANK-RL (tank-x t)) (= (tank-dir t) TANK-GO-RIGHT))  ; tank passing the right limit going right
         (make-tank (+ (tank-x t) (* TANK-GO-LEFT TANK-SPEED)) TANK-GO-LEFT)] ; Switch direction
        [else ; in any other case, just keep the movement
         (make-tank (+ (tank-x t) (* (tank-dir t) TANK-SPEED)) (tank-dir t))]))


;; Invader -> Invader
;; produces the next invader for on-tick
;(define (next-invader i) #false) ; stub

(check-expect (next-invader (make-invader ; Invader in the middle going right
                             (/ WIDTH 2)
                             (/ HEIGHT 2)
                             (* 1 INVADER-X-SPEED)))
              (make-invader (+ (/ WIDTH 2) (* 1 INVADER-X-SPEED))
                            (+ (/ HEIGHT 2) (* 1 INVADER-Y-SPEED))
                            (* 1 INVADER-X-SPEED)))
(check-expect (next-invader (make-invader ; Invader in the middle going left
                             (/ WIDTH 2)
                             (/ HEIGHT 2)
                             (* -1 INVADER-X-SPEED)))
              (make-invader (+ (/ WIDTH 2) (* -1 INVADER-X-SPEED))
                            (+ (/ HEIGHT 2) (* 1 INVADER-Y-SPEED))
                            (* -1 INVADER-X-SPEED)))
(check-expect (next-invader (make-invader ; Invader in the left limit going right
                             INVADER-LL
                             (/ WIDTH 2)
                             (* 1 INVADER-X-SPEED)))
              (make-invader (+ INVADER-LL (* 1 INVADER-X-SPEED))
                            (+ (/ WIDTH 2) (* 1 INVADER-Y-SPEED))
                            (* 1 INVADER-X-SPEED))) 
(check-expect (next-invader (make-invader ; Invader in the left limit going left -> Switch direction
                             INVADER-LL
                             (/ HEIGHT 2)
                             (* -1 INVADER-X-SPEED)))
              (make-invader (+ INVADER-LL (* 1 INVADER-X-SPEED))
                            (+ (/ HEIGHT 2) (* 1 INVADER-Y-SPEED))
                            (* 1 INVADER-X-SPEED))) 
(check-expect (next-invader (make-invader ; Invader in the right limit going right -> switch direction
                             INVADER-RL
                             (/ HEIGHT 2)
                             (* 1 INVADER-X-SPEED)))
              (make-invader (+ INVADER-RL (* -1 INVADER-X-SPEED))
                            (+ (/ HEIGHT 2) (* 1 INVADER-Y-SPEED))
                            (* -1 INVADER-X-SPEED)))
(check-expect (next-invader (make-invader ; Invader in the right limit going left
                             INVADER-RL
                             (/ HEIGHT 2)
                             (* -1 INVADER-X-SPEED)))
              (make-invader (+ INVADER-RL (* -1 INVADER-X-SPEED))
                            (+ (/ HEIGHT 2) (* 1 INVADER-Y-SPEED))
                            (* -1 INVADER-X-SPEED)))
(check-expect (next-invader (make-invader ; Invader in the bottom limit
                             (/ WIDTH 2)
                             INVADER-BL
                             (* 1 INVADER-X-SPEED)))
              "GAME OVER") 
              
(define (next-invader i)
  (cond [(string? i) i] ; Covers both "GAME OVER" and "HIT"
        [(<= INVADER-BL (invader-y i)) ;; Invader landing
         "GAME OVER"]
        [(>= INVADER-LL (invader-x i))  ;; Invader in the left limit
         (if (negative? (invader-dx i)) ;; going left?
             (make-invader (+ (invader-x i) (* 1 INVADER-X-SPEED))
                           (+ (invader-y i) (* 1 INVADER-Y-SPEED))
                           (* 1 INVADER-X-SPEED)) ;; make it go right
             ;; Not going left
             (make-invader (+ (invader-x i) (* 1 INVADER-X-SPEED))
                           (+ (invader-y i) (* 1 INVADER-Y-SPEED))
                           (* 1 INVADER-X-SPEED)))] ;; just keep going right
        [(<= INVADER-RL (invader-x i))  ;; Invader in the right limit
         (if (positive? (invader-dx i)) ;; going right?
             (make-invader (+ (invader-x i) (* -1 INVADER-X-SPEED))
                           (+ (invader-y i) (* 1 INVADER-Y-SPEED))
                           (* -1 INVADER-X-SPEED)) ;; make it go left
             ;; Not going right
             (make-invader (+ (invader-x i) (* -1 INVADER-X-SPEED))
                           (+ (invader-y i) (* 1 INVADER-Y-SPEED))
                           (* -1 INVADER-X-SPEED)))] ;; just keep going left        
        [else ;; In the middle going anyhere, doesn't matter that much
         (make-invader (+ (invader-x i) (invader-dx i))
                       (+ (invader-y i) (* 1 INVADER-Y-SPEED))
                       (invader-dx i))]))

;; (listof Invader) -> (listof Invader)
;; Moves all invaders
(define (next-invaders loi)
 (cond [(empty? loi) empty]
       [else (cons (next-invader (first loi))
                           (next-invaders (rest loi)))]))

(define (is-game-over? loi)
  (cond [(empty? loi) #false]
        [(is-str-game-over? (first loi)) #true]
        [else (is-game-over? (rest loi))]))

(define (is-str-game-over? i) (and (string? i) (string=? i "GAME OVER")))

;; Missile -> Missile
;; produce the next missile for on-tick
;(define (next-missile m) #false) ;stub

(check-expect (next-missile (make-missile (/ WIDTH 2) (/ HEIGHT 2)))
              (make-missile (/ WIDTH 2) (- (/ HEIGHT 2) MISSILE-SPEED)))
(check-expect (next-missile (make-missile (/ WIDTH 2) (- MISSILE-TL 1))) #false)
(check-expect (next-missile (make-missile (/ WIDTH 2) (+ MISSILE-TL MISSILE-SPEED 0.5)))
              (make-missile (/ WIDTH 2) (+ MISSILE-TL 0.5)))

(define (next-missile m)
  (cond [(false? m) #false]                                                    ;out of the screen
        [(string? m) "HIT"]                                                    ;hitted an invader
        [(>= MISSILE-TL (- (missile-y m) MISSILE-SPEED)) #false]               ;exiting the screen
        [else (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED))]))  ;going up on the screen


;; (listof Missile) -> (listof Missile)
;; produce the next missiles for on tick
;(define (next-missiles lom) empty) ; stub

(check-expect (next-missiles (list
              (make-missile 240 100)
              (make-missile 140 200)
              (make-missile 40 300)
              (make-missile 80 400)
              (make-missile 70 280)
              (make-missile 290 450)
              (make-missile 190 50)
              (make-missile 10 20)))
(list
              (make-missile 240 (- 100 MISSILE-SPEED))
              (make-missile 140 (- 200 MISSILE-SPEED))
              (make-missile 40 (- 300 MISSILE-SPEED))
              (make-missile 80 (- 400 MISSILE-SPEED))
              (make-missile 70 (- 280 MISSILE-SPEED))
              (make-missile 290 (- 450 MISSILE-SPEED))
              (make-missile 190 (- 50 MISSILE-SPEED))
              (make-missile 10 (- 20 MISSILE-SPEED))
              ))

(define (next-missiles lom)
 (cond [(empty? lom) empty]
       [else (cons (next-missile (first lom))
                           (next-missiles (rest lom)))]))
