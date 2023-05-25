;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname constants) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require "provide.rkt")
(require 2htdp/image)

;; Make everything available for the main file
(provide (all-defined-out))

;; ==================
;; Assessory funtions without parameters

;; (nothing) -> -1 or 1
;; generates either -1 or 1, in a pseudo-random manner
(define RANDOM-SIGN
  (expt -1 (random 2)))

;; ==================
;; Constants:

(define WIDTH  300)
(define HEIGHT 500)
(define CTR-X (/ WIDTH 2))
(define CTR-Y (/ HEIGHT 2))

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define TANK-WIDTH/2 (/ (image-width TANK) 2))

(define TANK-LL TANK-WIDTH/2)                               ;tank's left limit on screen

(define TANK-RL (- WIDTH TANK-WIDTH/2))                     ;tank's right limit on screen

(define TANK-Y (- HEIGHT TANK-HEIGHT/2))

(define TANK-GO-LEFT -1)
(define TANK-GO-RIGHT 1)

(define INVADER-WIDTH/2 (/ (image-width INVADER) 2))

(define INVADER-HEIGHT/2 (/ (image-height INVADER) 2))

(define INVADER-LL (/ (image-width INVADER) 2)) ; Invader left limit

(define INVADER-RL (- WIDTH INVADER-WIDTH/2)) ; Invader right limit

(define INVADER-TL (/ (image-height INVADER) 2)) ; Invader Top Limit

(define INVADER-BL (- HEIGHT INVADER-TL)) ; Invader bottom limit

(define MISSILE (ellipse 5 15 "solid" "red"))

(define MISSILE-BL (- HEIGHT (image-height TANK))) ; Missile bottom limit

(define MISSILE-TL (/ (image-height MISSILE) 2))   ; Missile top limit

(define GAME-OVER-IMG (place-image
   (above
    (text "GAME OVER" 40 "darkred")
    (text "Press 'R' to restart" 18 "black"))
   CTR-X
   CTR-Y
   BACKGROUND))