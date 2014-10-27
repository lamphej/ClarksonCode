#lang racket

(define stream-null? stream-empty?)
(define stream-car stream-first)
(define stream-cdr stream-rest)
(define null-stream empty-stream)

(define file->stream
  (lambda (filename)
    (let ((port (open-input-file filename)))
      (letrec
	((build-input-stream
	  (lambda ()
	    (let ((c (read-char port)))
	      (if (eof-object? c)
		  (begin
		    (close-input-port port)
		    (stream))
		  (stream-cons 
		   c
		   (build-input-stream)))))))
	(build-input-stream)))))

(define remove-newlines
  (lambda (str)
    (stream-map
     (lambda (c)
       (case c
	 ((#\return #\newline) #\space)
	 (else c)))
     str)))

(define remove-extra-spaces
  (lambda (str)
    (cond ((null? str) str)
	  ((char=? (stream-car str) #\space)
	   (stream-cons 
	    #\space
	    (remove-extra-spaces
	     (trim-spaces (stream-cdr str)))))
	  (else
	   (stream-cons
	    (stream-car str)
	    (remove-extra-spaces (stream-cdr str)))))))

(define trim-spaces
  (lambda (str)
    (cond ((null? str) str)
	  ((char=? (stream-car str) #\space)
	   (trim-spaces (stream-cdr str)))
	  (else str))))

(define insert-double-spaces
  (lambda (str)
    (cond ((null? str) str)
	  ((end-of-sentence? (stream-car str))
	   (stream-cons 
	    (stream-car str)
	    (stream-cons
	     #\space
	     (stream-cons
	      #\space
	      (insert-double-spaces
	       (trim-spaces (stream-cdr str)))))))
	  (else
	   (stream-cons
	    (stream-car str)
	    (insert-double-spaces (stream-cdr str)))))))
	   
(define end-of-sentence?
  (lambda (c)
    (or (char=? c #\.) (char=? c #\!) (char=? c #\?))))

(define insert-newlines
  (lambda (line-length)
    (lambda (str)
      (letrec
        ((insert
	  (lambda (str count)
	    (if (null? str)
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
	(insert (trim-spaces str) 0)))))

(define count-chars-to-next-space
  (lambda (str)
    (letrec
      ((count-ahead
	(lambda (str count)
	  (cond ((null? str) count)
		((char=? (stream-car str) #\space) count)
		(else
		 (count-ahead (stream-cdr str) (+ count 1)))))))
      (count-ahead str 0))))

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

(define formatter
  (lambda (input-filename output-filename line-length)
    ((stream->file output-filename
     ((insert-newlines line-length)
      (insert-double-spaces
       (remove-extra-spaces
	(remove-newlines
	 (file->stream input-filename)))))))))