
;; load the module , import the module with prefix
;; can we rename some imports
;;
;; (load "grid.scm")
;; (import (prefix grid "grid:"))
;;
;;
;; *** chicken scheme modules ***
;; name of module
;; exports from this module
;; body of module
;; 
(module grid
    (mk
     wid
     hgt
     xy
     xy!
     show
     copy)
  
  (import scheme)  
  (import (chicken base))
  (import (chicken format))
  (import (chicken pretty-print))
  (import srfi-1) 
  
  (define make-grid
    (lambda (wid hgt)
      (let ((top (make-vector (+ hgt 2) 0)))
	(letrec ((foo (lambda (i)
			(cond
			 ((< i 1) #t)
			 (#t (let ((vec (make-vector (+ wid 2) 0)))
			       (vector-set! top i vec)
			       (foo (- i 1))))))))
	  (foo hgt)
	  `((type grid) (width ,wid) (height ,hgt) (data ,top))))))

  (define grid-width
    (lambda (grid)  (second (assoc 'width grid))))
  
  (define grid-height
    (lambda (grid)  (second (assoc 'height grid))))

  (define grid-data
    (lambda (grid)  (second (assoc 'data grid))))

  (define grid-onboard?
    (lambda (grid x y)
      (let ((wid (grid-width grid))
	    (hgt (grid-height grid)))
	(and (>= x 1) (<= x wid)
	     (>= y 1) (<= y hgt)))))

  (define grid-xy
    (lambda (grid x y)
      (let ((wid (grid-width grid))
	    (hgt (grid-height grid))
	    (data (grid-data grid)))
	(cond
	 ((grid-onboard? grid x y)
	  (vector-ref (vector-ref data y) x))
	 (#t (error (format #f "grid-xy offboard ~a ~a fpr ~a ~a" x y  wid hgt)))))))

  (define grid-xy!
    (lambda (grid x y z)
      (let ((wid (grid-width grid))
	    (hgt (grid-height grid))
	    (data (grid-data grid)))
	(cond
	 ((grid-onboard? grid x y)
	  (vector-set! (vector-ref data y) x z))
	 (#t (error (format #f "grid-xy! offboard ~a ~a fpr ~a ~a" x y  wid hgt)))))))


  (define grid-show
    (lambda (grid)
      (let ((wid (grid-width grid))
	    (hgt (grid-height grid)))
	(format #t "~%")
	(letrec ((foo (lambda (x y)
			(cond
			 ((> x wid)
			  (format #t "~%")
			  (foo 1 (+ y 1)))
			 ((> y hgt) #f)
			 (#t (let ((val (grid-xy grid x y)))
			       (format #t "~a " val)
			       (foo (+ x 1) y)))))))
	  (foo 1 1)
	  #f))))


  ;; create a duplicate of grid 
  (define grid-copy
    (lambda (grid)
      (let* ((wid (grid-width grid))
	     (hgt (grid-height grid))
	     (res (make-grid wid hgt)))	  
	(letrec ((foo (lambda (x y)
			(cond
			 ((> x wid)
			  (foo 1 (+ y 1)))
			 ((> y hgt) #f)
			 (#t (let ((val (grid-xy grid x y)))
			       (grid-xy! res x y val)
			       (foo (+ x 1) y)))))))
	  (foo 1 1)
	  res))))


  
  ;; shorter aliases for export
  (define mk make-grid)
  (define wid grid-width)
  (define hgt grid-height)
  (define xy grid-xy)
  (define xy! grid-xy!)
  (define show grid-show)
  (define copy grid-copy)
  
  );; module grid

