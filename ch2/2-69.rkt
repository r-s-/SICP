#lang racket

;; Exercise 2.68.  The encode procedure takes as arguments a message
;; and a tree and produces the list of bits that gives the encoded message.

;; this problem is not so bad once you realize we have the functions
;; make-code-tree and adjoin-set availible to us.

;; first not that the list is given in order and the first 2 elements
;; are the smallest. 

;; we take the smallest 2 elements via car s/ car(cdr s) (or cadr s)
;; use adjoin set to create the new pair.

;; we add that pair into the correct location by using the already defined
;; adjoin-set. we must make sure to pass the set WITHOUT the first 2 elements
;; make to the successive-merge as we are adding in the value of those summed.

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge s)
  (if (null? s)
      `()
      (if (null? (cdr s))
          (car s)
          (successive-merge
               (adjoin-set (make-code-tree (car s) (car (cdr s)))
                           (cddr s))))))
                             
(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

;; huffman tree
(define (make-leaf symbol weight)
  (list `lead symbol weight))

(define (leaf? object)
  (eq? (car object) `lead))

(define (symbol-leaf x)
  (cadr x))

(define (weight-leaf x)
  (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree)
  (car tree))

(define (right-branch tree)
  (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (make-leaf-set pairs)
  (if (null? pairs)
      `()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair) ;; sym
                               (cadr pair)) ;; freq
                    (make-leaf-set (cdr pairs))))))


(define sample-tree
  (make-code-tree (make-leaf `A 4)
                  (make-code-tree
                   (make-leaf `B 2)
                   (make-code-tree (make-leaf `D 1)
                                   (make-leaf `C 1)))))

;; tests
(generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))
(equal? (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1))) sample-tree) ;;t

