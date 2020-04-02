#lang info
(define collection "font-finder")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/font-finder.scrbl" ())))
(define pkg-desc "Minimal utilities for locating font files on your computer")
(define version "0.1")
(define pkg-authors '(dstorrs))
