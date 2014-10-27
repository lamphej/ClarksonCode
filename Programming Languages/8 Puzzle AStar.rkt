#lang racket
(require racket/gui/base)

;Racket implementation of "Slidey 8 piece puzzle game"
;Fails to solve sometimes, my algorithm gets stuck switching back and forth
;Usage: Simply click Run and then use the buttons on my GUI
;When it gets stuck theres nothing you can do but run it again and hope for the best
;Attempts to use A* algorithm

(define writeln
  (lambda (sentence)
    (display sentence)(newline)))

(define fronts '())
(define goalPuzzle '(1 2 3 4 5 6 7 8 0))
(define startPuzzle '(1 2 3 4 5 6 7 8 0))
(define previousNode '())

;(define prePreviousNode '())
;(define previousCount 1)

(define solvePuzzle
  (lambda ()
    (define shuffles (send shuffleSlider get-value))
    (set! previousNode '())
    (shufflePuzzle shuffles)
    
    ;(writeln "Start Puzzle")
    ;(showPuzzle startPuzzle)
    
    (sucessor startPuzzle)
    (define nxNode '())
    (set! nxNode (getNextNode))
    (define moveCount 1)
    
    (define solveHelper
      (lambda ()
        (if (sublist? nxNode goalPuzzle)
            (begin
              (writeln "Solved in x moves.")
              (writeln moveCount)
              (send moveLabel set-label (string-append "Move Count: " (number->string moveCount)))
              ;(showPuzzle nxNode)
              )
            (begin
              (set! moveCount (+ moveCount 1))
              (sucessor nxNode)
              (set! nxNode (getNextNode))
              ;(display ".")
              (displayPuzzle nxNode)
              ;(showPuzzle nxNode)
              (solveHelper)))))
    
    (solveHelper)))

(define sucessor
  (lambda (node)
    (define subNode '())
    (define getZeroLocation (+ (getItemIndex node 0) 1))
    (set! subNode node)
    (define boundry (boundries getZeroLocation))
    (set! fronts '())
    (define temp 420)
    (define shiftValue 10000)
    (if (<= (+ getZeroLocation 3) 9)
        (begin
          (set! temp (get-at-index subNode (getItemIndex node 0)))
          (set! shiftValue (get-at-index subNode (+ (getItemIndex node 0) 3)))
          (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
          (set! subNode (setItemAt subNode (+ (getItemIndex node 0) 3) temp))
          (set! fronts (append fronts (list (heuristic subNode))))
          (set! subNode '())
          (set! subNode node)
          )
        '())
    (if(>= (- getZeroLocation 3) 1)
       (begin
         (set! temp (get-at-index subNode (getItemIndex node 0)))
         (set! shiftValue (get-at-index subNode (- (getItemIndex node 0) 3)))
         (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
         (set! subNode (setItemAt subNode (- (getItemIndex node 0) 3) temp))
         (set! fronts (append fronts (list (heuristic subNode))))
         (set! subNode '())
         (set! subNode node)
         )
       '())
    (if (>= (- getZeroLocation 1) (get-at-index boundry 0))
        (begin
          (set! temp (get-at-index subNode (getItemIndex node 0)))
          (set! shiftValue (get-at-index subNode (- (getItemIndex node 0) 1)))
          (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
          (set! subNode (setItemAt subNode (- (getItemIndex node 0) 1) temp))
          (set! fronts (append fronts (list (heuristic subNode))))
          (set! subNode '())
          (set! subNode node)
          )
        '())
    (if (<= (+ getZeroLocation 1) (get-at-index boundry 1))
        (begin
          (set! temp (get-at-index subNode (getItemIndex node 0)))
          (set! shiftValue (get-at-index subNode (+ (getItemIndex node 0) 1)))
          (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
          (set! subNode (setItemAt subNode (+ (getItemIndex node 0) 1) temp))
          (set! fronts (append fronts (list (heuristic subNode))))
          (set! subNode '())
          (set! subNode node)
          )
        '())
    ))

(define getNextNode
  (lambda ()
    (define nxNode '())
    (define tNode '())
    (define nnHelper
            (lambda ()
              (define hrCost 100000)
                 (for ([i fronts])
                   (begin
                     (when (< (get-at-index i (- (length i) 1)) hrCost)
                         (begin
                           (set! hrCost (get-at-index i (- (length i) 1)))
                           (set! nxNode (getSublist i 0 (- (length i) 1)))
                           (set! tNode i)))))
                 (if (and (contains previousNode tNode) (contains fronts tNode))
                     (begin
                       (set! fronts (remove tNode fronts))
                       ;(set! previousNode (append previousNode (list tNode)))
                       (nnHelper))
                     (begin
                       (set! previousNode (append previousNode (list tNode)))
                       nxNode))
                 ))
    (nnHelper)))
       

(define shufflePuzzle
  (lambda (shuffles)
    (set! startPuzzle '(1 2 3 4 5 6 7 8 0))
    (define shuffleHelper
           (lambda (toDo completed)
             (if (= toDo completed) '()
                 (begin
                   (let ([node startPuzzle]
                         [subNode '()]
                         [direction (+ (random 4) 1)]
                         [temp 420]
                         [shiftValue 10000])
                     (let ([getZeroLocation (+ (getItemIndex node 0) 1)])
                       (let ([boundry (boundries getZeroLocation)])
                         (set! subNode node)
                         (cond ((and (<= (+ getZeroLocation 3) 9) (= direction 1))
                                (begin
                                  (set! temp (get-at-index subNode (getItemIndex node 0)))
                                  (set! shiftValue (get-at-index subNode (+ (getItemIndex node 0) 3)))
                                  (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
                                  (set! subNode (setItemAt subNode (+ (getItemIndex node 0) 3) temp))
                                  (set! startPuzzle subNode)
                                  '()))
                               ((and (>= (- getZeroLocation 3) 1) (= direction 2))
                                (begin
                                  (set! temp (get-at-index subNode (getItemIndex node 0)))
                                  (set! shiftValue (get-at-index subNode (- (getItemIndex node 0) 3)))
                                  (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
                                  (set! subNode (setItemAt subNode (- (getItemIndex node 0) 3) temp))
                                  (set! startPuzzle subNode)
                                  '()))
                               ((and (>= (- getZeroLocation 1) (get-at-index boundry 0)) (= direction 3))
                                (begin
                                  (set! temp (get-at-index subNode (getItemIndex node 0)))
                                  (set! shiftValue (get-at-index subNode (- (getItemIndex node 0) 1)))
                                  (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
                                  (set! subNode (setItemAt subNode (- (getItemIndex node 0) 1) temp))
                                  (set! startPuzzle subNode)
                                  '()))
                               ((and (<= (+ getZeroLocation 1) (get-at-index boundry 1)) (= direction 4))
                                (begin
                                  (set! temp (get-at-index subNode (getItemIndex node 0)))
                                  (set! shiftValue (get-at-index subNode (+ (getItemIndex node 0) 1)))
                                  (set! subNode (setItemAt subNode (getItemIndex node 0) shiftValue))
                                  (set! subNode (setItemAt subNode (+ (getItemIndex node 0) 1) temp))
                                  (set! startPuzzle subNode)
                                  '()))
                               ))))
                   (shuffleHelper toDo (+ completed 1))))))
    (shuffleHelper shuffles 0)))

(define showPuzzle
  (lambda (pz)
    (writeln (getSublist pz 0 3))
    (writeln (getSublist pz 3 6))
    (writeln (getSublist pz 6 9))
    (writeln "=======")))

(define boundries
  (lambda (location)
    (define lst '((1 2 3)
                  (4 5 6)
                  (7 8 9)))
    (define low 0)
    (define high 0)
    (for ([i lst])
      (when (contains i location)
          (begin
            (set! low (get-at-index i 0))
            (set! high (get-at-index i 2))))
          )
    (list low high)))

(define heuristic
  (lambda (node)
    (define herMisplaced 0)
    (define herDistance 0)
    (for ([i node])
      (unless (= i (get-at-index goalPuzzle (getItemIndex node i)))
          (begin
            (set! herMisplaced (+ herMisplaced 1))
            (set! herDistance (+ herDistance (abs (- (getItemIndex node i) (getItemIndex goalPuzzle i))))))))
    (define totalHerst (+ herMisplaced herDistance))
    (set! node (append node (list totalHerst)))
    node))

(define contains
  (lambda (ls elem)
    (cond 
      ( (null? ls) #f )
      ( (equal? (car ls) elem) #t )
      (else (contains (cdr ls) elem)))))

(define get-at-index
  (lambda (ls index)
    ;(writeln "get-at-index")
    ;(writeln ls)
    (if (= 0 index)
        (car ls)
        (get-at-index (cdr ls) (- index 1)))))

(define getSublist
  (lambda (ilist start finish)
    (define sublistHelper
      (lambda (ilist start finish index outList)
        (cond ((>= index start) (begin
                                  (if (< index finish)
                                      (sublistHelper (cdr ilist) start finish (+ index 1) (append outList (list (car ilist))))
                                      outList)))
              (else
               (sublistHelper (cdr ilist) start finish (+ index 1) outList)))
        ))
    (sublistHelper ilist start finish 0 '())))

(define getItemIndex
  (lambda (ilist item)
    (define iiHelper
      (lambda (ilist item index)
        (if (= (car ilist) item) index
            (iiHelper (cdr ilist) item (+ index 1)))))
    (iiHelper ilist item 0)))

(define setItemAt
  (lambda (ilist index newValue)
    (define siHelper
      (lambda (ii ind nv ci ol)
        (if (= ci ind) (append ol  (list nv) (cdr ii))
            (siHelper (cdr ii) ind nv (+ ci 1) (append ol (list (car ii)))))))
    (siHelper ilist index newValue 0 '())))

(define length
  (lambda (ls)
    (if (null? ls)
        0
        (+ 1 (length ( cdr ls))))))

(define sublist?
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) #t)
      ((null? ls2) #f)
      (else
      (if (eq? (car ls1) (car ls2))
          (sublist? (cdr ls1) (cdr ls2))
          (sublist? ls1 (cdr ls2)))))))


(define frame (new frame% [label "8-Puzzle Solver - James Lamphere"]
                   [width 350]
                   [height 300]))
(define canvas (new canvas% [parent frame]))
(define dc (send canvas get-dc))

(define add-button
  (lambda (buttonLabel buttonCallback)
    (new button% 
         [parent frame]
         [label buttonLabel]
         [callback (lambda (button event) (buttonCallback))])))

(add-button "Solve One" solvePuzzle)

(define shuffleSlider (new slider%
                    (label "Shuffles")
                    (parent frame)
                    (min-value 0)
                    (max-value 100)
                    (init-value 42)))

(define moveLabel (new message%
                     (parent frame)
                     (label "Move Count: 0")))

(define displayPuzzle
  (lambda (puzzle)
    (send dc clear)
    (send dc set-scale 5 5)
    (send dc draw-text (number->string (get-at-index startPuzzle 0)) 0 0)
    (send dc draw-text (number->string (get-at-index startPuzzle 1)) 10 0)
    (send dc draw-text (number->string (get-at-index startPuzzle 2)) 20 0)
   
    (send dc draw-text (number->string (get-at-index startPuzzle 3)) 0 10)
    (send dc draw-text (number->string (get-at-index startPuzzle 4)) 10 10)
    (send dc draw-text (number->string (get-at-index startPuzzle 5)) 20 10)
    
    (send dc draw-text (number->string (get-at-index startPuzzle 6)) 0 20)
    (send dc draw-text (number->string (get-at-index startPuzzle 7)) 10 20)
    (send dc draw-text (number->string (get-at-index startPuzzle 8)) 20 20)
    
    (send dc draw-text (number->string (get-at-index puzzle 0)) 40 0)
    (send dc draw-text (number->string (get-at-index puzzle 1)) 50 0)
    (send dc draw-text (number->string (get-at-index puzzle 2)) 60 0)
   
    (send dc draw-text (number->string (get-at-index puzzle 3)) 40 10)
    (send dc draw-text (number->string (get-at-index puzzle 4)) 50 10)
    (send dc draw-text (number->string (get-at-index puzzle 5)) 60 10)
    
    (send dc draw-text (number->string (get-at-index puzzle 6)) 40 20)
    (send dc draw-text (number->string (get-at-index puzzle 7)) 50 20)
    (send dc draw-text (number->string (get-at-index puzzle 8)) 60 20)
    ))
(send frame show #t)