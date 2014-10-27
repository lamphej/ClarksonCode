;James Lamphere
;0274872
;CS341 Lab 3


(define make-window
  (lambda (x-size y-size foreground-color background-color)
    (let ((window (make-graphics-device 'x)))				; this is for UNIX 
	(begin
	  (graphics-set-coordinate-limits window 0 0 x-size y-size)
	  (set-foreground-color window foreground-color)
	  (set-background-color window background-color)
	  (graphics-clear window)
	  window))))

(define kill-window
  (lambda (window)
    (graphics-close window)))

(define set-foreground-color
  (lambda (window color)
    (graphics-operation window 'set-foreground-color color)))

(define set-background-color
  (lambda (window color)
    (graphics-operation window 'set-background-color color)))

(define draw-point
  (lambda (window x1 y1)
    (graphics-operation window 'draw-point x1 y1)))

(define draw-line
  (lambda (window x1 y1 x2 y2)
    (graphics-operation window 'draw-line x1 y1 x2 y2)))

(define draw-ellipse
  (lambda (window x-left y-top x-right y-bottom)
    (graphics-operation window 'draw-ellipse x-left y-top x-right y-bottom)))

(define draw-circle
  (lambda (window x-center y-center radius)
    (graphics-operation window 'draw-circle x-center y-center radius)))

(define draw-polygon
  (lambda (window vector-points)
    (graphics-operation window 'fill-polygon vector-points)))


;Function that returns the next point the player should move to.  Makes sure it is an "ok"
;move before returning to the helper function.
(define makeMove
  (lambda (x y)
        (define newPoint (cons (+ x (select-random '(-1 0 1))) (+ y (select-random '(-1 0 1)))))
		(if (eq? (isGood (car newPoint) (cdr newPoint)) #f) (makeMove x y) newPoint)
))

;Function to determine if a point is inside the bounds of our window.
(define isGood
  (lambda (x y)
		(if (or (< y 0) (< x 0) (> x 500) (> y 500)) #f #t)))

;My game loop, the recurses, creates new points, and changes color randomly.
(define game-helper
  (lambda (window x y homeX homeY)
    (define newPoint (makeMove x y))
    (set-foreground-color window (select-random '("red" "white" "blue")))
    (draw-point window (car newPoint) (cdr newPoint))
	(if (eq? (is-done (car newPoint) (cdr newPoint) homeX homeY) #f) (game-helper window (car newPoint) (cdr newPoint) homeX homeY) 'Done)))

;Function to select random item from list, used for color
(define select-random
  (lambda (ls)
    (let ((len (length ls)))
      (list-ref ls (random len)))))

;Function to determine if player is at the home point.
(define is-done
  (lambda (x y homeX homeY)
	(if (and (= x homeX) (= y homeY)) #t #f)))

;This is the function you call, ie (game 0 0 500 500) to start at (0,0) with home at (500, 500)
(define game
  (lambda (initX initY homeX homeY)
    (define theWindow (make-window 500 500 0 0))
    (game-helper theWindow initX initY homeX homeY)
))
