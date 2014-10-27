#lang racket

(define stream-null? stream-empty?)
(define stream-car stream-first)
(define stream-cdr stream-rest)
(define null-stream empty-stream)

(define test-me
  (lambda (n)
    (formatter "hollow.txt" "out.txt" n)))

(define formatter 
  (lambda (input-filename output-filename line-length)
    (stream->file output-filename
      (right-justify line-length
        (trimEndingSpaces
         (insert-newlines line-length
          (remove-extra-spaces
            (remove-newlines
              (file->stream input-filename)))))))))

(define right-justify
  (lambda (line-length str)
    (define helper
      (lambda (prevChar strr)
        (cond
          ((stream-null? strr) (stream))
          ((equal? prevChar #\newline)
           (stream-append (stream-append (justify line-length strr) (stream-cons #\newline (stream)))
                          (helper 'Z strr)))
          (else
           (helper (stream-car strr) (stream-cdr strr))))))
    (helper #\newline str)))

(define findMinimumSpaces
  (lambda (str)
    (define helper
      (lambda (strr lowestCount prevChar)
        (cond
          ((or (stream-null? strr) (equal? (stream-car strr) #\newline)) lowestCount)
          ((and (not (equal? prevChar #\space)) (equal? (stream-car strr) #\space))
           (helper (stream-cdr strr) (min (count-chars-to-next-char strr) lowestCount) (stream-car strr)))
          (else
           (helper (stream-cdr strr) lowestCount (stream-car strr))))))
  (helper str 420 'Z)))

(define justify
  (lambda (line-length str)
    (cond
      ((stream-null? str) (stream))
      ((< (count-chars-to-next-newline str) line-length)
       (justify line-length (insert-space str)))
      (else
       (toNextLine str)))))

(define toNextLine
  (lambda (str)
    (cond
      ((stream-null? str) (stream))
      ((equal? (stream-car str) #\newline) (stream))
      (else
       (stream-cons (stream-car str) (toNextLine (stream-cdr str)))))))

(define remove-extra-spaces
  (lambda (str)
    (cond ((stream-null? str) str)
	  ((char=? (stream-first str) #\space)
	   (stream-cons 
	    #\space
	    (remove-extra-spaces
	     (trim-spaces (stream-rest str)))))
	  (else
	   (stream-cons
	    (stream-first str)
	    (remove-extra-spaces (stream-rest str)))))))

(define remove-newlines
  (lambda (str)
    (stream-map
     (lambda (c)
       (case c
	 ((#\return #\newline) #\space)
	 (else c)))
     str)))

;Count minimum spaces
;if minimum, insert

(define insert-newlines 
  (lambda (line-length str)
    (letrec
      ((insert 
        (lambda (str count)
	  (if (stream-null? str)
	      str
	      (let ((n (count-chars-to-next-space str)))
	        (if (and (< count line-length) 
		         (<= (+ n count) line-length))
		    (stream-cons
		      (stream-car str)
		      (insert (stream-cdr str) (+ count 1)))
		    (stream-cons
		      #\newline
		      (insert (trim-spaces str) 0))))))))
      (insert (trim-spaces str) 0))))


(define insert-space
  (lambda (str)
    (define helper
      (lambda (strr prevChar)
        (cond ((stream-null? strr) (stream))
              ((and (not (equal? prevChar #\space)) (equal? (count-chars-to-next-char strr) (findMinimumSpaces str)))
               (stream-cons #\space strr))
              (else
               (stream-cons (stream-car strr) (helper (stream-cdr strr) (stream-car strr)))))))
    (helper str #\')))

(define trim-spaces 
  (lambda (str)
    (cond ((stream-null? str) (stream))
	  ((char=? (stream-car str) #\space)
	   (trim-spaces (stream-cdr str)))
	  (else str))))

(define trimEndingSpaces
  (lambda (str)
    (cond ((stream-null? str) (stream))
          ((and (equal? (stream-car str) #\space) (equal? (stream-car (stream-cdr str)) #\newline))
           (trimEndingSpaces (stream-cdr str)))
          (else
           (stream-cons (stream-car str) (trimEndingSpaces (stream-cdr str)))))))

(define count-chars-to-next-space 
  (lambda (str)
    (letrec
      ((count-ahead
        (lambda (str count)
	  (cond ((stream-null? str) count)
	        ((char=? (stream-car str) #\space) count)
	        (else (count-ahead (stream-cdr str) (+ count 1)))))))
      (count-ahead str 0))))

(define count-chars-to-next-char 
  (lambda (str)
    (letrec
      ((count-ahead
        (lambda (str count)
	  (cond ((stream-null? str) count)
	        ((not (char=? (stream-car str) #\space)) count)
	        (else (count-ahead (stream-cdr str) (+ count 1)))))))
      (count-ahead str 0))))

(define count-chars-to-next-newline
  (lambda (str)
    (letrec
      ((count-ahead
        (lambda (str count)
	  (cond ((stream-null? str) count)
	        ((char=? (stream-car str) #\newline) count)
	        (else (count-ahead (stream-cdr str) (+ count 1)))))))
      (count-ahead str 0))))


(define file->stream 
  (lambda (filename)
    (let ((in-port (open-input-file filename)))
      (letrec
        ((build-input-stream
          (lambda ()
            (let ((ch (read-char in-port)))
              (if (eof-object? ch)
                  (begin
                    (close-input-port in-port)
                    (stream))
                  (stream-cons ch (build-input-stream)))))))
        (build-input-stream)))))

(define stream->file
  (lambda (filename stream) 
    (let((output-port (open-output-file filename #:exists 'replace)))
      (letrec
          ((build-output-file
            (lambda (stream)
              (cond ((stream-empty? stream)
                     (close-output-port output-port))
                    (else
                     (write-char (stream-first stream) output-port)
                     (build-output-file (stream-rest stream)))))))
           (build-output-file stream)))))