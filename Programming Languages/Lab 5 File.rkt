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