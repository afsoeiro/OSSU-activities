;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname handle_key) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; handle_key.rkt - Handles the user's keyboard input

(require 2htdp/universe)
(require "provide.rkt")
(require "constants.rkt")
(require "data_structures.rkt")

;; Make everything available for the main file
(provide (all-defined-out))


;; Game KeyEvent -> Game
;; handles keypress on game
;(define (handle-key g k) (make-game empty empty T0 0 0)) ;stub

(check-expect (handle-key "GAME OVER" " ")
              "GAME OVER")

(check-expect (handle-key "GAME OVER" "R")
              (make-game empty empty T0 0))

(check-expect (handle-key (make-game empty empty TGL 0) "right")
              (make-game empty empty TGR 0))

(check-expect (handle-key (make-game empty empty TGR 0) "right")
              (make-game empty empty TGR 0))

(check-expect (handle-key (make-game empty empty TGR 0) "left")
              (make-game empty empty TGL 0))

(check-expect (handle-key (make-game empty empty TGL 0) "left")
              (make-game empty empty TGL 0))


(define (handle-key g k)
  (cond [(string? g)
          (if (and (string=? g "GAME OVER") (or (key=? k "R") (key=? k "r")))
          NEW-GAME
          g)]
        [else
         (cond
           [(key=? k "left")
            (turn-tank g TANK-GO-LEFT)]
           [(key=? k "right")
            (turn-tank g TANK-GO-RIGHT)]
           [(key=? k " ") (shoot-canon g)]       ;SHOOT CANON
           [else
            g])]))

(define (turn-tank g direction)
  (make-game
             (game-invaders g)
             (game-missiles g)
             (make-tank (tank-x (game-tank g)) direction)
             (game-counter g)))

(define (shoot-canon g)
  (make-game
             (game-invaders g)
             (cons (make-missile (tank-x (game-tank g)) MISSILE-BL)  (game-missiles g))
             (game-tank  g)
             (game-counter g)))