;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

(require "constants.rkt")
(require "render.rkt")
(require "data_structures.rkt")
(require "tick_functions.rkt")
(require "handle_key.rkt")

;; ==================
;; World function
(define (main g)
  (big-bang g                  ; Game
    (on-tick next-game)        ; Game -> Game
    (to-draw render-game)      ; Game -> Image
    (on-key handle-key)        ; Game KeyEvent -> Game
    )) ; Record the session  
