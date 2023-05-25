;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname collision_test_data) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; collision_test_data.rkt - Test data definitions. This file is to cluster less the files

(require "provide.rkt")
(require "constants.rkt")
(require "data_structures.rkt")

;; Make everything available for the main file
(provide (all-defined-out))

;; Test missiles
(define TM1 (make-missile (/ WIDTH 2) (/ HEIGHT 2)))                                      ; hits TI05 bullseye
(define TM2 (make-missile 50 50))                                                         ; misses all test invaders
(define TM3 (make-missile 150 290))                                                       ; hits TI03 bullseye
(define TM4 (make-missile 150 279))                                                       ; barely misses TI03
(define TM5 (make-missile 150 281))                                                       ; Hits TI03
(define TM6 #false)
(define TM7 "HIT")

;; Test list of missiles
(define TLOM01 empty)
(define TLOM02 (list TM6))
(define TLOM03 (list TM7))
(define TLOM04 (list TM6 TM7))
(define TLOM05 (list TM1 TM6 TM7))
(define TLOM06 (list TM7 TM6 TM1))
(define TLOM07 (list TM1 TM2 TM3 TM4 TM5))
(define TLOM08 (list TM1 TM2 TM3 TM4 TM5 TM6))
(define TLOM09 (list TM1 TM2 TM3 TM4 TM5 TM7))
(define TLOM10 (list TM6 TM1 TM2 TM3 TM4 TM5))
(define TLOM11 (list TM1 TM2 TM3 TM6 TM4 TM5))
(define TLOM12 (list TM1 TM2 TM3 TM4 TM5 TM7))
(define TLOM13 (list TM1 TM2 TM7 TM3 TM4 TM5))
(define TLOM14 (list TM7 TM1 TM2 TM3 TM4 TM5))
(define TLOM15 (list TM1 TM3))

;; Test invaders
(define TI01 "HIT")                                                                         ; invader hit by a missile
(define TI02 "GAME OVER")                                                                   ; invader landed on Earth
(define TI03 (make-invader 150 290 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI04 (make-invader 150 100 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI05 (make-invader (/ WIDTH 2) (/ HEIGHT 2) (* 1 INVADER-X-SPEED)))                 ; not landed, moving right
(define TI06 (make-invader 130 450 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI07 (make-invader 200 400 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI08 (make-invader 150 180 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI09 (make-invader 200 10 (* 1 INVADER-X-SPEED)))                                  ; not landed, moving right
(define TI10 (make-invader 150 (- HEIGHT INVADER-HEIGHT/2) (* -1 INVADER-X-SPEED)))         ; exactly landed, moving left

;; Test list of invaders
(define TLOI01 empty)
(define TLOI02 (list TI01))
(define TLOI03 (list TI02))
(define TLOI04 (list TI03))
(define TLOI05 (list TI01 TI03))
(define TLOI06 (list TI03 TI01))
(define TLOI07 (list TI02 TI03))
(define TLOI08 (list TI03 TI02))
(define TLOI09 (list TI01 TI02 TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10))
(define TLOI10 (list TI03 TI04 TI05 TI01 TI02 TI06 TI07 TI08 TI09 TI10))
(define TLOI11 (list TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10 TI01 TI02))
(define TLOI12 (list TI01 TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10))
(define TLOI13 (list TI03 TI04 TI05 TI06 TI01 TI07 TI08 TI09 TI10))
(define TLOI14 (list TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10 TI01))
(define TLOI15 (list TI02 TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10))
(define TLOI16 (list TI03 TI04 TI05 TI02 TI06 TI07 TI08 TI09 TI10))
(define TLOI17 (list TI03 TI04 TI05 TI06 TI07 TI08 TI09 TI10 TI02))
(define TLOI18 (list TI03 TI05))