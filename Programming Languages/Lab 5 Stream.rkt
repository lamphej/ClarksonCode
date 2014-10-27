;James Lamphere
;CS341 
;Lab 5
;Example run found at bottom

#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Streams (infinite lists)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/stream)

; macros (MIT Scheme to Racket)
; cons-stream ==> stream-cons
(define stream-null? stream-empty?)
(define stream-car stream-first)
(define stream-cdr stream-rest)
(define null-stream empty-stream)


; defining a stream (infinite list) of natural numbers
; uses "lazy" evaluation
(define naturals
  (let helper ((n 0))
       (stream-cons n
		    (helper (+ n 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mutators for stream and list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; my-stream->list
; constructs a list of the first n items from a stream
;
(define my-stream->list
  (lambda (stream n)
	  (cond ((stream-null? stream) '())
		((zero? n) '())
		(else (cons (stream-car stream)
			    (my-stream->list (stream-cdr stream) (- n 1)))))))

; list->stream
; constructs a stream from a list
;
(define list->stream
  (lambda (list)
	  (cond ((null? list) (stream))
		(else (stream-cons (car list)
				   (list->stream (cdr list)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; other functions on streams
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; adding two streams
(define stream-add
  (lambda (stream1 stream2)
	  (cond ((or (stream-null? stream1) (stream-null? stream2)) (stream))
		(else (stream-cons (+ (stream-car stream1) (stream-car stream2))
				   (stream-add (stream-cdr stream1) (stream-cdr stream2)))))))

; map function on streams
(define my-stream-map
  (lambda (f str)
    (cond ((stream-empty? str) '())
          (else (stream-cons (f (stream-first str))
                              (my-stream-map f (stream-rest str)))))))

; filter function on streams
(define my-stream-filter
  (lambda (test? str)
    (cond ((stream-empty? str) empty-stream)
          ((test? (stream-first str))
           (stream-cons (stream-first str)
                        (my-stream-filter test? (stream-rest str))))
          (else (my-stream-filter test? (stream-rest str))))))
           
    
; defining a stream of fibonacci numbers
;  FIB(n) = FIB(n-1) + FIB(n-2) if n > 1
;  FIB(1) = 1
;  FIB(0) = 0
(define fibonaccis
  (let run4ever ((n 0) (m 1))
    (stream-cons n
                 (run4ever m (+ n m)))))

; defining a stream of (positive) rational numbers
; a "rational" number is a pair (a . b) where a and b are positive integers
; note: the stream should not contain any repeats
; example:
;  (1 . 1) (1 . 2) (2 . 1) (1 . 3) (3 . 1) (1 . 4) (2 . 3) (3 . 2) (4 . 1) (1 . 5) ... 
(define rationals
  (let run4ever ((a 1) (b 1))
    (cond ((= b 1) (stream-cons (cons a b) (run4ever 1 (+ a 1))))
          ((= (gcd a b) 1) (stream-cons (cons a b) (run4ever (+ a 1) (- b 1))))
          (else (run4ever (+ a 1) (- b 1))))))

;;;;;;;;;;;
; test jig
;;;;;;;;;;;

(define test-me
  (lambda (n)
    (list (my-stream->list rationals n) 
          (my-stream->list fibonaccis n)
    	  (my-stream->list (my-stream-map sqr naturals) n)
          (my-stream->list (my-stream-filter even? fibonaccis) n))))

;> (test-me 15)
;'(((1 . 1) (1 . 2) (2 . 1) (1 . 3) (3 . 1) (1 . 4) (2 . 3) (3 . 2) (4 . 1) (1 . 5) (5 . 1) (1 . 6) (2 . 5) (3 . 4) (4 . 3))
;  (0 1 1 2 3 5 8 13 21 34 55 89 144 233 377)
;  (0 1 4 9 16 25 36 49 64 81 100 121 144 169 196)
;  (0 2 8 34 144 610 2584 10946 46368 196418 832040 3524578 14930352 63245986 267914296))

