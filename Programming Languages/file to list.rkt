#lang racket

; file->list
; reads a file of characters into a list
;
(define file->list
  (lambda (filename) 
    (let ((input-port (open-input-file filename))) 
      (letrec 
	((build-input-list 
	   (lambda () 
	     (let ((current-char (read-char input-port))) 
	       (if (eof-object? current-char) 
		 (begin (close-input-port input-port) 
			'()) 
		 (cons current-char (build-input-list))))))) 
	(build-input-list)))))

; list->file
; writes a list of characters to a file
;
(define list->file
  (lambda (filename ls) 
    (let((output-port (open-output-file filename #:exists 'replace)))
      (letrec
          ((build-output-file
            (lambda (ls)
              (cond ((null? ls)
                     (close-output-port output-port))
                    (else
                     (write-char (car ls) output-port)
                     (build-output-file (cdr ls)))))))
           (build-output-file ls)))))

;file->stream
(define file->stream
  (lambda (filename)
    (let ((input-port (open-input-file filename)))
      (letrec
          ((build-input-list
            (lambda ()
              (let ((current-char (read-char input-port)))
                (if (eof-object? current-char)
                     (begin (close-input-port input-port) 
			empty-stream) 
		 (cons current-char (build-input-list))))))) 
	(build-input-list)))))
                           
                           
                           
  ; my-stream->list
; constructs a list of the first n items from a stream
;
(define my-stream->list
  (lambda (stream n)
	  (cond ((stream-empty? stream) '())
		((zero? n) '())
		(else (cons (stream-first stream)
			    (my-stream->list (stream-rest stream) (- n 1)))))))                         

(define list->stream
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
  
(define remove-newlines
  (lambda (stream)
    (stream-map (lambda (x) (if (char=? x #\newline)  #\space x)) stream)))
    