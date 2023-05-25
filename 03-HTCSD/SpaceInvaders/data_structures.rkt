;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname data_structures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; data_structures.rkt - Data structures used in the game

(require "provide.rkt")
(require "constants.rkt")

;; Make everything available for the main file
(provide (all-defined-out))


(define-struct game (invaders missiles tank counter))
;; Game is one of:
;; - "GAME OVER"
;; - (make-game (listof Invader) (listof Missile) Tank Score Counter)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position
;;         a game over anouncement with hit "R" to restart
;;         counter is a counter for ticks, that counts from 1 to INVADE-RATE

#;
(define (fn-for-game g)
  (cond [(and (string? g) (string=? g "GAME OVER"))
         ...]
        [else
         (fn-for-lom (game-missiles s))
         (fn-for-counter (game-counter s))
         (fn-for-loinvader (game-invaders s))
         (fn-for-tank (game-tank s))]))

(define-struct invader (x y dx))
;; Invader is one of:
;;  - "HIT"
;;  - "GAME OVER"
;;  - (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick
;;         When "HIT", the player must score and the invader disappear
;;         When "GAME OVER" the invader landed and the player lost the game

(define I1 (make-invader 150 100 (* 1 INVADER-X-SPEED)))           ; not landed, moving right
(define I2 (make-invader 150 HEIGHT (* -1 INVADER-X-SPEED)))       ; exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) (* 1 INVADER-X-SPEED))) ; > landed, moving right
(define I4 "HIT")                                                  ; invader hit by a missile
(define I5 "GAME OVER")                                            ; invader landed on Earth


#;
(define (fn-for-invader i)
  (cond [(and (string? i) (string=? i "HIT")) ...]
        [(and (string? i) (string=? i "GAME OVER")) ...]
        [else ... (invader-x invader) (invader-y invader) (invader-dx invader)]))

(define-struct missile (x y))
;; Missile is one of:
;; - #false  
;; - "HIT"  
;; - (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates, #false when exited screen and "HIT" when killed an invader

(define M1 (make-missile 150 300))                               ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
(define M4 #false)                                               ;exit screen without hitting an invader
(define M5 "HIT")                                                ;hit an invader

#;
(define (fn-for-missile m)
  (cond [(false? m) ...]
        [(and (string? m) (string=? "HIT" m)) ...]
        [else ... (missile-x m) (missile-y m)]))

(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank CTR-X 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left
(define TGL (make-tank CTR-X -1))  ; tank going left
(define TGR (make-tank CTR-X 1))  ; tank going right


#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))

(define NEW-GAME (make-game empty empty (make-tank (/ WIDTH 2) 1) 0))