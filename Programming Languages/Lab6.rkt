#lang racket
(require racket/gui/base)
(require racket/include)

(define writeln
  (lambda (sentence)
    sentence))

(define red-pen (make-object pen% "RED" 2 'solid))

(define window
  (lambda (x y)
    (define frame (new frame% [label "Lab 6"]
                       [width x]
                       [height y]))
    (define canvas (new canvas% [parent frame]))
    (define dc (send canvas get-dc))
    (define get-dc
      (lambda ()
        dc))
    (send frame show #t)))

(define point
  (lambda (window x y)
    (let ( (window window) (x x) (y y) (animation null) )
      
      (define point?
        (lambda ()
        #t))
      
      (define draw
        (lambda ()
          (define dc (window 'get-dc))
          (send dc set-pen red-pen)
          (send dc draw-point x y)
          (send dc set-scale 5 5)
          (send dc draw-text "1" 0 0)
          (send dc draw-text "2" 10 0)
          (send dc draw-text "3" 20 0)))
      
      (draw))))

(define rectangle
  (lambda (point1 point2)
    (cons point1 point2)))

(define polygon
  (lambda (point1 point2)
    (cons point1 point2)))

(define point?
  (lambda (obj)
    (obj 'point?)))

(define rectangle?
  (lambda (obj)
    (obj 'rectangle?)))

(define polygon?
  (lambda (obj)
    (obj 'polygon?)))

(define animate-me
  (lambda ()
    (define w (window 500 500))
    (define p (point w 50 50))
    (p 'draw)))