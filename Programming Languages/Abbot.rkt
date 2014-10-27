#lang racket
;James Lamphere
;0274872
;Assignment 1 Submission
;Run Log
;===========
;> (who)
;(whos on first)
;(right on)
;(no whos on second)
;(first base)
;(what are the names)
;(whats on second whos on first i dont know on third)
;(who is on third)
;(first base)
;(whats on second)
;(sure)
;(whats on third)
;(i told you whats on second)
;(what)
;(sure)
;(i dont know)
;(third base)
;(idontknow is where?)
;(im trying to tell you)
;(why?)
;(im trying to tell you)
;(whats on first)
;(hes on second)
;(why second)
;(now calm down)
;(Im Done)
;'(That was fun)
;> 
(define who
  (lambda ()
    (whos-on-first-loop '())))

(define whos-on-first-loop 
  (lambda (old-context)
    (let ((costellos-line (read)))
      (let ((new-context (get-context costellos-line old-context)))
        (let ((strong-reply (try-strong-cues costellos-line)))
          (let ((weak-reply (try-weak-cues costellos-line new-context))) 
            (cond ((not (null? strong-reply))
                   (writeln strong-reply)
                   (whos-on-first-loop (get-context strong-reply new-context)))
                  ((not (null? weak-reply))
                   (writeln weak-reply)
                   (whos-on-first-loop (get-context weak-reply new-context)))
                  ((wants-to-end? costellos-line)
                   (wrap-it-up))
                  (else 
                   (writeln (hedge))
                   (whos-on-first-loop new-context)))))))))

(define hedge
  (lambda ()
    (select-any-from-list *hedges*)))

(define get-context
  (lambda (sentence old_context)
    (check-context *context-words* sentence old_context)))

(define writeln
  (lambda (sentence)
    (display sentence)(newline)))

(define wants-to-end?
  (lambda (sentence)
    (if (sublist? '(Im Done) sentence) #t #f)))

(define *done-words*
  '((Were done here) (Game over) (That was fun)))

(define wrap-it-up
  (lambda ()
    (select-any-from-list *done-words*)))

(define sublist?
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) #t)
      ((null? ls2) #f)
      (else
      (if (eq? (car ls1) (car ls2))
          (sublist? (cdr ls1) (cdr ls2))
          (sublist? ls1 (cdr ls2)))))))

(define *strong-cues*
  '( ( ((the names) (their names))
       ((whos on first whats on second i dont know on third)
        (whats on second whos on first i dont know on third)) )
     
     ( ((suppose) (lets say) (assume))
       ((okay) (why not) (sure) (it could happen)) )
     
     ( ((i dont know))
       ((third base) (hes on third)) )
     ))


(define try-strong-cues
  (lambda (sentence)
    (check-cues *strong-cues* sentence)
    ))

(define try-weak-cues
  (lambda (sentence context)
    (check-weak-cues *weak-cues* sentence context)
    ))

(define check-context
  (lambda (ls sentence old_context)
    (cond ((null? ls) old_context)
          ((any-good-fragments? (car (car ls)) sentence) (cdr (car ls)))
          (else (check-context (cdr ls) sentence old_context)))))

(define check-cues
  (lambda (ls sentence)
    (cond ((null? ls) '())
          ((any-good-fragments? (car (car ls)) sentence) (select-any-from-list (car (cdr (car ls)))))
          (else (check-cues (cdr ls) sentence)))))

(define check-weak-cues
  (lambda (ls sentence context)
    (cond ((null? ls) '())
          ((any-good-fragments? (car (car ls)) sentence) (check-weak-context (cdr (car ls)) context))
          (else (check-weak-cues (cdr ls) sentence context)))))

(define check-weak-context
  (lambda (ls context)
    (cond ((null? ls) '())
          ((sublist? context (car (car ls))) (select-any-from-list (car (cdr (car ls))))) ;Editing this line
          (else (check-weak-context (cdr ls) context)))))

(define any-good-fragments? 
  (lambda (list-of-cues sentence)
    (if (null? list-of-cues) #f
    (if (sublist? (car list-of-cues) sentence) #t
        (any-good-fragments? (cdr list-of-cues) sentence)))))

(define *hedges*
  '((its like im telling you)
    (now calm down)
    (take it easy)
    (its elementary lou)
    (im trying to tell you)
    (but you asked)))

(define *context-words*
  `( ( ((first)) first-base )
     ( ((second)) second-base )
     ( ((third)) third-base )))

(define select-any-from-list
  (lambda (ls)
    (let ((len (length ls)))
      (list-ref ls (random len))))) 

(define *weak-cues*
  '( ( ((who) (whos) (who is))
       ((first-base)
           ((thats right) (exactly) (you got it)
	    (right on) (now youve got it)))
       ((second-base third-base)
           ((no whos on first) (whos on first) (first base))) )
     ( ((what) (whats) (what is))
       ((first-base third-base)
	   ((hes on second) (i told you whats on second)))
       ((second-base)
	   ((right) (sure) (you got it right))) )
     ( ((whats the name) (what's the name))
       ((first-base third-base)
	   ((no whats the name of the guy on second)
	    (whats the name of the second baseman)))
       ((second-base)
	((now youre talking) (you got it))))
   ))