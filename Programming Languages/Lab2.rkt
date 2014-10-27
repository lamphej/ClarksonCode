#lang racket

(define accumulate
  (lambda (op base f ls)
    (if (null? ls)
        base
        (op (f (car ls))
            (accumulate op base f (cdr ls))))))

(define length
  (lambda (ls)
    (if (null? ls)
        0
        (+ 1 (length ( cdr ls))))))

(define append
  (lambda (ls1 ls2)
    (accumulate cons ls1 (lambda (x) x) ls2)))

(define reverse
  (lambda (ls) 
    (reverse-helper ls '())))

(define reverse-helper
  (lambda (ls answer)
    (if (null? ls)
        answer
        (reverse-helper (cdr ls)
                        (cons (car ls) answer)))))

(define prefix?
  (lambda (ls1 ls2)
    (if (null? ls1)
        #t
        (if (eq? (car ls1) (car ls2))
            (prefix? (cdr ls1) (cdr ls2))
            #f))))

(define subsequence?
  (lambda (ls1 ls2)
    (if (null? ls1)
        #t
        (if (null? ls2)
            #f
        (if (prefix? ls1 ls2)
            (subsequence? (cdr ls1) (cdr ls2))
            (subsequence? ls1 (cdr ls2)))))))

(define sublist?
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) #t)
      ((null? ls2) #f)
      (else
      (if (eq? (car ls1) (car ls2))
          (sublist? (cdr ls1) (cdr ls2))
          (sublist? ls1 (cdr ls2)))))))

(define map
  (lambda (f ls)
    (accumulate cons '() f ls)))

(define filter
  (lambda (test ls)
	  (accumulate append '() (lambda (x) (if (test x) (list x) '())) ls)))

(define insert
  (lambda ( x lst cond?)
  (if (null? lst)
      (list x)
      (let ((y (car lst))
            (ys (cdr lst)))
        (if (cond? x y)
            (cons x lst)
            (cons y (insert x ys cond?)))))))
 
(define num-sort 
  (lambda (lst)
  (if (null? lst)
      '()
      (insert (car lst)
              (num-sort (cdr lst)) <=))))

(define sort
  (lambda (ls less?)
    (if (null? ls)
        '()
        (insert (car ls)
                (sort (cdr ls) less?) less?))))

(define make-sort
  (lambda (less?)
    (lambda (ls)
      (sort ls less?))))