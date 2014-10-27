#lang racket
(define triangular
  (lambda (n)
    (if (= n 0)
        0
        (+ n (triangular (- n 1))))))

(define square-triangular
  (lambda (n)
    (if (= n 0)
        0
        (+ (* n n) (square-triangular ( - n 1))))))

(define generalized-triangular
  (lambda (n f)
    (if (= n 0)
        0
        (+ (f n) (generalized-triangular ( - n 1) f)))))

(define generic-triangular
  (lambda (f)
    (lambda (n)
      (generalized-triangular n f))))