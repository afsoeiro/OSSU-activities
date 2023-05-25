;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require "data_structures.rkt")
(require "constants.rkt")
(require "provide.rkt")
(require "collision.rkt")

;; Make everything available for the main file
(provide (all-defined-out))

;; Tank Image -> Image
;; renders the Tank on the current screen
;(define (render-tank t b) BACKGROUND) ;stub
(check-expect (render-tank T0 BACKGROUND)
              (place-image TANK (tank-x T0) TANK-Y BACKGROUND))
(check-expect (render-tank T1 BACKGROUND)
              (place-image TANK (tank-x T1) TANK-Y BACKGROUND))

(define (render-tank t b)
  (place-image TANK (tank-x t) TANK-Y b))

;; (listof Invader) Image -> Image
;; renders the Invaders on the given screen
;(define (render-invaders loi b) BACKGROUND) ;stub
(define (render-invaders loi b)
  (if (empty? loi)
      b
      (render-invader (first loi) (render-invaders (rest loi) b))))

(define (render-invader i b)
  (if (string? i)
      b
      (place-image INVADER (invader-x i) (invader-y i) b)))

;; (listof Missile) Image -> Image
;; renders the missiles on the current screen
;(define (render-missiles lom b) BACKGROUND) ;stub
(define LOM1 (list
              (make-missile 240 100)
              (make-missile 140 200)))

(define LOM2 (list
              (make-missile 100 240)
              (make-missile 200 140)))

(define LOM3 (list
              (make-missile 240 100)
              (make-missile 140 200)
              (make-missile 40 300)
              (make-missile 80 400)
              (make-missile 70 280)
              (make-missile 290 450)
              (make-missile 190 50)
              (make-missile 10 20)))

(define LOM4 (list
              (make-missile 100 240)
              (make-missile 200 140)
              (make-missile 140 30)
              (make-missile 200 80)
              (make-missile 170 280)
              (make-missile 45 290)
              (make-missile 50 190)
              (make-missile 210 20)))

(check-expect (render-missiles LOM1 BACKGROUND)
              (place-image MISSILE 240 100
                           (place-image MISSILE 140 200
                                        BACKGROUND)))

(check-expect (render-missiles LOM2 BACKGROUND)
              (place-image MISSILE 100 240
                           (place-image MISSILE 200 140
                                        BACKGROUND)))

(check-expect (render-missiles LOM3 BACKGROUND)
              (place-image MISSILE 240 100
                           (place-image MISSILE 140 200
                                        (place-image MISSILE 40  300 
                                                     (place-image MISSILE 80  400
                                                                  (place-image MISSILE 70  280
                                                                               (place-image MISSILE 290 450
                                                                                            (place-image MISSILE 190 50
                                                                                                         (place-image MISSILE 10 20
                                                                                                                      BACKGROUND)))))))))

(check-expect (render-missiles LOM4 BACKGROUND)
              (place-image MISSILE 100 240
                           (place-image MISSILE 200 140
                                        (place-image MISSILE 140 30 
                                                     (place-image MISSILE 200 80
                                                                  (place-image MISSILE 170 280
                                                                               (place-image MISSILE 45 290
                                                                                            (place-image MISSILE 50 190
                                                                                                         (place-image MISSILE 210 20
                                                                                                                      BACKGROUND)))))))))



;; (listof Missile) Image -> Image
;; Render the missiles in the current screen background
(define (render-missiles lom b)
  (cond [(empty? lom) b]
        [else
         (render-missile (first lom)
          (render-missiles (rest lom) b))]))

(define (render-missile m b)
  (if (or (false? m) (string? m))
      b
      (place-image
       MISSILE
       (missile-x m)
       (missile-y m)
       b)))


;; Game Image -> Image
;; renders the player's current score
;(define (render-score g b) b) ; stub
(define (render-score g b)
  (above/align "right"
               (score-line (game-invaders g))
               b))

(define (score-line loi)
  (text (string-append "Score: " (number->string (count-score loi 0))) 18 "olive"))

;; Game -> Image
;; renders the game image
;(define (render-game g) BACKGROUND) ; stub
(define (render-game g)
  (cond [(and (string? g) (string=? g "GAME OVER"))
         GAME-OVER-IMG]
        [else
         (render-score g
                       (render-invaders (game-invaders g)
                                        (render-missiles (game-missiles g)
                                                         (render-tank (game-tank g) BACKGROUND))))]))
