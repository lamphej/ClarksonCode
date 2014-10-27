#lang racket

(require data/queue)

(define length
  (lambda (ls)
    (if (null? ls)
        0
        (+ 1 (length (cdr ls))))))

(define contains
  (lambda (ls elem)
    (cond 
      ( (null? ls) #f )
      ( (equal? (car ls) elem) #t )
      (else (contains (cdr ls) elem)))))

; Returns the index of the given element in the list.
(define list-ref
  (lambda (ls elem)
    (define helper
      (lambda (rem index)
        (cond
          ( (null? ls) null )
          ( (equal? (car rem) elem) index )
          (else (helper (cdr rem) (+ index 1))))))
    (helper ls 0)))

(define get-at-index
  (lambda (ls index)
    (if (= 0 index)
        (car ls)
        (get-at-index (cdr ls) (- index 1)))))

(define place-element-at-index
  (lambda (ls elem index)
    (if (= 0 index)
        (cons elem (cdr ls))
        (cons (car ls) (place-element-at-index (cdr ls) elem (- index 1))))))

(define pick-random-from-list
  (lambda (ls)
    (get-at-index ls (random (length ls)))))

(define get-element-at-posn
  (lambda (puzzle posn)
    (get-at-index (get-at-index puzzle (cdr posn)) (car posn))))

(define posn
  (lambda (x y)
    (cons x y)))

(define place-element-at-posn
  (lambda (puzzle elem p)
    (if (zero? (cdr p))
        (cons (place-element-at-index (car puzzle) elem (car p)) (cdr puzzle))
        (cons (car puzzle) (place-element-at-posn (cdr puzzle) elem (posn (car p) (- (cdr p) 1)))))))

(define swap-elements
  (lambda (puzzle p1 p2)
    (define a (get-element-at-posn puzzle p1))
    (define b (get-element-at-posn puzzle p2))
    (place-element-at-posn 
     (place-element-at-posn puzzle a p2)
     b p1)))
  
(define puzzle '( (3 4 7) (0 8 5) (6 2 1) ))

(define print-puzzle
  (lambda (puzzle)
    (write '-------)
    (newline)
    (for ([i puzzle])
      (write i)
      (newline))
    (write '-------)
    (newline)))

(define print-puzzles
  (lambda (ls)
    (for ([p ls])
      (print-puzzle p))))

; Returns the position of the given element (number).
(define get-posn-of-elem
  (lambda (puzzle elem)
    (cond
      ( (contains (car puzzle) elem)
        (posn (list-ref (car puzzle) elem) 0))
      ( (contains (cadr puzzle) elem)
        (posn (list-ref (cadr puzzle) elem) 1))
      (else
        (posn (list-ref (car (cdr (cdr puzzle))) elem) 2)))))

;; Returns the list of possible moves for the given puzzle
(define get-possible-moves
  (lambda (puzzle)
    (define zero-pos (get-posn-of-elem puzzle 0))
    (cond
      ( (equal? zero-pos (posn 0 0)) '(right down) )
      ( (equal? zero-pos (posn 1 0)) '(right down left) )
      ( (equal? zero-pos (posn 2 0)) '(down left) )
      ( (equal? zero-pos (posn 0 1)) '(up right down) )
      ( (equal? zero-pos (posn 1 1)) '(up right down left) )
      ( (equal? zero-pos (posn 2 1)) '(up down left) )
      ( (equal? zero-pos (posn 0 2)) '(up right) )
      ( (equal? zero-pos (posn 1 2)) '(up right left) )
      ( (equal? zero-pos (posn 2 2)) '(up left) )
      (else (write 'ERROR!)))))

(define perform-move
  (lambda (puzzle direction)
    (define zero-pos (get-posn-of-elem puzzle 0))
    (case direction
      ( (up) (swap-elements puzzle zero-pos (posn (car zero-pos) (- (cdr zero-pos) 1))) )
      ( (down) (swap-elements puzzle zero-pos (posn (car zero-pos) (+ (cdr zero-pos) 1))) )
      ( (left) (swap-elements puzzle zero-pos (posn (- (car zero-pos) 1) (cdr zero-pos))) )
      ( (right) (swap-elements puzzle zero-pos (posn (+ (car zero-pos) 1) (cdr zero-pos))) )
      (else (write 'ERROR!!)))))
        

(define do-random-move
  (lambda (puzzle)
    (perform-move puzzle (pick-random-from-list (get-possible-moves puzzle)))))

(define shuffle
  (lambda (puzzle numMoves)
    (if (<= numMoves 0)
        puzzle
        (begin
          (print-puzzle puzzle)
          (shuffle (do-random-move puzzle) (- numMoves 1))))))

; Returns all possible next puzzles. (all next moves)
(define get-possible-next-puzzles
  (lambda (puzzle)
    (define helper
      (lambda (remMoves)
        (cond
          ( (null? remMoves) '() )
          (else (cons (perform-move puzzle (car remMoves)) (helper (cdr remMoves)))))))
    (helper (get-possible-moves puzzle))))

(define solved-puzzle '((0 1 2) (3 4 5) (6 7 8)))

; A node contains a puzzle and it's parent puzzle.
; if parent is null, this node is the root.
; Basically, a linked-list.
(define node
  (lambda (puzzle parent)
    (let ( (puzzle puzzle) (parent parent) )
     
      ; Returns the list of puzzles, as going up by parents.
      (define as-list
        (lambda (node)
          (cond
            ( (null? node) '() )
            (else (cons (node 'get-puzzle) (as-list (node 'get-parent)))))))
      
      ; Returns the path to this node, from the root.
      (define get-path
        (lambda ()
          (reverse (as-list dispatch))))
            
          
     ; (define get-parent parent)
     ; (define get-puzzle puzzle)
      
      (define dispatch
        (lambda msg
          (case (car msg)
            ( (get-parent) parent)
            ( (get-puzzle) puzzle)
            ( (as-list) (as-list dispatch))
            ( (get-path) (get-path))
            ( else (write 'ERROR)))))
      dispatch)))  
  

; Solves the puzzle, using BFS.
(define solve
  (lambda (puzzle)
    (define helper
      (lambda (q)
        (define current (dequeue! q))
        (cond
          ( (equal? (current 'get-puzzle) solved-puzzle) current )
          (else 
           (for ([p (get-possible-next-puzzles (current 'get-puzzle))])
             (define n (node p current))
             (enqueue! q n))
           (helper q)))))
      (define que (make-queue))
      (enqueue! que (node puzzle null))
      (helper que)))

(define playPuzzle
  (lambda ()
    (define puzzle (shuffle solved-puzzle 3))
    (solve puzzle)))



