;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname collision) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require "provide.rkt")
(require "constants.rkt")
(require "data_structures.rkt")
(require "collision_test_data.rkt")

;; Make everything available for the main file
(provide (all-defined-out))

;; Missile Invader -> Boolean
;; Determines if there is a hit from a missile and an invader
;;(define (bullseye? m i) #false) ; stub

(check-expect (bullseye? (make-missile 100 100) (make-invader 100 100 (* -1 INVADER-X-SPEED))) #true)
(check-expect (bullseye? (make-missile 100 100) (make-invader 90 89 (* 1 INVADER-X-SPEED))) #false)
(check-expect (bullseye? (make-missile 100 100) (make-invader 90 90 (* -1 INVADER-X-SPEED))) #true)
(check-expect (bullseye? (make-missile 100 100) (make-invader 91 91 (* 1 INVADER-X-SPEED))) #true)
(check-expect (bullseye? (make-missile 100 100) (make-invader 110 110 (* -1 INVADER-X-SPEED))) #true)
(check-expect (bullseye? (make-missile 100 100) (make-invader 110 111 (* -1 INVADER-X-SPEED))) #false)

(define (bullseye? m i)
  (cond
    [(and (missile? m) (invader? i))
      [and (<= (abs (- (missile-x m) (invader-x i))) 10) (<= (abs (- (missile-y m) (invader-y i))) 10)]]
    [else #false]))

;; Game -> Game
;; treats the collision of the missiles and invaders
; (define (colide g) g);stub
(define (colide g)
  (cond [(and (string? g) (string=? g "GAME OVER")) g]
        [(empty? (game-missiles g)) g] ;No active missiles
        [(empty? (game-invaders g)) g] ;Nobody to be hit
        [else (make-game
               (missiles-attack (game-missiles g) (game-invaders g))
               (invaders-hit (game-invaders g) (game-missiles g))
               (game-tank g)
               (game-counter g)
               )]))

;; Missile (listof Invader) -> (listof Invader)
;; filters the invader list identifiying eventually hit invaders
;(define (missile-attack m loi) loi); stub

(check-expect (missile-attack TM1 (list I1 I2 I3 I4 I5))
              (list I1 I2 I3 I4 I5))

(define (missile-attack m loi)
  (cond [(false? m) loi]
        [(string? m) loi]
        [(empty? loi) empty]
        [else
         (if
          (bullseye? m (first loi))
          (cons "HIT" (missile-attack m (rest loi)))
          (cons (first loi) (missile-attack m (rest loi))))]))

(define (missiles-attack lom loi)
  (cond [(empty? lom) loi]
        [else (missile-attack (first lom) (missiles-attack (rest lom) loi))]))

;; Invader (listof Missile) -> (listof Missile)
;; filters the missile list identifying eventually blown missiles
;(define (invader-hit i lom) lom); stub

(check-expect (invader-hit TI05 (list TM1)) (list "HIT"))
(check-expect (invader-hit TI03 (list TM3)) (list "HIT"))
(check-expect (invader-hit TI05 TLOM07) (list "HIT" TM2 TM3 TM4 TM5))

(define (invader-hit i lom)
    (cond [(string? i) lom]       ; Won't affect missiles if it is a string
          [(empty? lom) empty]
          [else
           (if
             (bullseye? (first lom) i)
             (cons "HIT" (invader-hit i (rest lom)))
             (cons (first lom) (invader-hit i (rest lom))))]))

(check-expect (invaders-hit TLOI18 TLOM15) (list "HIT" "HIT"))
(define (invaders-hit loi lom)
  (cond [(empty? loi) lom]
        [else (invader-hit (first loi) (invaders-hit (rest loi) lom))]))

;; (listof Invader) 0 -> Integer
;; Counts the amount of invaders killed. Start calling with accumulator zero
(define (count-score loi acc)
  (cond [(empty? loi) acc]
        [else (if (is-hit? (first loi))
                  (count-score (rest loi) (+ acc 1))
                  (count-score (rest loi) acc))]))

(define (is-hit? i)
  (cond [(empty? i) #false]
        [(and (string? i) (string=? i "HIT")) #true]
        [else #false]))