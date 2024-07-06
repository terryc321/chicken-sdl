

;; (load "data.scm")
;; (import (prefix data "data:"))
(load "grid.scm")

;; (d:initial-state)
;; (d:hole s)
;; (d:gold s)
;; (d:up s)
;; (d:left s)
;; (d:down s)
;; (d:right s)
;; visually must move left as wall of values to cross over before solution can be found ...
;;

(module data
    ( ;; exports 
     initial-state
     up
     down
     left
     right

     hole
     gold

     wid
     hgt
     xy
     
     show ;; unlikely we need this as 
     )

  
  (import scheme)
  (import (chicken base)) ;;call/cc
  (import (chicken format))
  (import (chicken pretty-print))
  (import srfi-1)
  (import simple-loops)
  (import matchable)

  ;; grid procedures use g: 
  (import (prefix grid "g:"))

  
  (define start-grid
    (lambda()
      (call-with-input-file "data.txt"
	(lambda (port)
	  (read port)))))

  (define initial-state
    (lambda ()
      `((hole (18 23))
	(gold (36 1))
	(grid ,(start-grid)))))

  (define state-hole (lambda (state) (second (assoc 'hole state))))
  (define state-hole-x (lambda (state) (first (state-hole state))))
  (define state-hole-y (lambda (state) (second (state-hole state))))
  
  (define state-gold (lambda (state) (second (assoc 'gold state))))
  (define state-gold-x (lambda (state) (first (state-gold state))))
  (define state-gold-y (lambda (state) (second (state-gold state))))

  (define state-grid (lambda (state) (second (assoc 'grid state))))
  (define state-grid-width (lambda (state) (second (assoc 'width (state-grid state)))))
  (define state-grid-height (lambda (state) (second (assoc 'height (state-grid state)))))
  (define state-grid-xy (lambda (state x y) (g:xy (state-grid state) x y)))
  
      

  (define make-state (lambda (hole-x hole-y gold-x gold-y grid)
		      `((hole (,hole-x ,hole-y))
			(gold (,gold-x ,gold-y))
			(grid ,grid))))
  
  ;; assuming a unique key ? replace only one
  (define replace-one-key (lambda (ass key val)
			    (cond
			     ((null? ass) '())
			     (#t (let ((pair (car ass)))
				   (cond
				    ((and (pair? pair) (equal? key (car pair)))
				     (cons (list key val) (cdr ass)))
				    (#t (cons pair (replace-one-key (cdr ass) key val)))))))))
  ;; shorter name
  ;; change arguments around
  (define rplace (lambda (key val ass) (replace-one-key ass key val)))


  ;; can go up if y > 1 
  (define func-up
    (lambda (state)
      (let* ((hole (state-hole state))	     (gold (state-gold state))
	     (hole-x (first hole))	     (hole-y (second hole))
	     (gold-x (first gold))	     (gold-y (second gold))
	     (grid (state-grid state)))
      (call/cc
       (lambda (exit) 
	 (cond
	  ((> hole-y 1)
	   (format #t " hole-y > 1  ~%")		 
	   (let* ((x hole-x)(y hole-y)(x2 x)(y2 (- y 1)))
	     (let ((expr (g:xy grid x y))
		   (expr2 (g:xy grid x2 y2)))
	       (format #t "expr : ~A ~%" expr)
	       (format #t "expr2 : ~A ~%" expr2)		     
	       (match expr (('used used 'size size)
			    (format #t "match expr : ~A : used=~a : size = ~a ~%" expr used size)
			    (match expr2 (('used used2 'size size2)
					  (format #t "<inner expr2 match okay>  ~%")
					  (cond
					   ((and (<= used size2) (<= used2 size))
					    (format #t "<inner expr2 match okay>  ~%")
					    
					    (let ((gcopy (g:copy grid)))
					      (g:xy! gcopy x y `(used ,used2 size ,size))
					      (g:xy! gcopy x2 y2 `(used ,used size ,size2))

					      (set! hole-x x2)
					      (set! hole-y y2)
					      
					      ;; hole is at x , y
					      ;; gold is at x2 y2 ... gold is now at x y
					      (cond ((and (= x2 gold-x) (= y2 gold-y))
						     (set! gold-x x)
						     (set! gold-y y)))
					      
					      (exit (make-state hole-x hole-y gold-x gold-y gcopy))))
					   (#t
					    (format #t "will not fit , moving ~a into ~a ~%" used2 size)
					    (exit (list "will not fit " used2 size))
					    ))))))))))
	 #f)))))


  (define func-down
    (lambda (state)
      (let* ((hole (state-hole state))	     (gold (state-gold state))
	     (hole-x (first hole))	     (hole-y (second hole))
	     (gold-x (first gold))	     (gold-y (second gold))
	     (grid (state-grid state))
	     (width (g:wid grid))
	     (height (g:hgt grid)))
      (call/cc
       (lambda (exit) 
	 (cond
	  ((< hole-y height)
	   (format #t " hole-y < height  ~%")		 
	   (let* ((x hole-x)(y hole-y)(x2 x)(y2 (+ y 1)))
	     (let ((expr (g:xy grid x y))
		   (expr2 (g:xy grid x2 y2)))
	       (format #t "expr : ~A ~%" expr)
	       (format #t "expr2 : ~A ~%" expr2)		     
	       (match expr (('used used 'size size)
			    (format #t "match expr : ~A : used=~a : size = ~a ~%" expr used size)
			    (match expr2 (('used used2 'size size2)
					  (format #t "<inner expr2 match okay>  ~%")
					  (cond
					   ((and (<= used size2) (<= used2 size))
					    (format #t "<inner expr2 match okay>  ~%")
					    
					    (let ((gcopy (g:copy grid)))
					      (g:xy! gcopy x y `(used ,used2 size ,size))
					      (g:xy! gcopy x2 y2 `(used ,used size ,size2))

					      (set! hole-x x2)
					      (set! hole-y y2)
					      
					      ;; hole is at x , y
					      ;; gold is at x2 y2 ... gold is now at x y
					      (cond ((and (= x2 gold-x) (= y2 gold-y))
						     (set! gold-x x)
						     (set! gold-y y)))
					      
					      (exit (make-state hole-x hole-y gold-x gold-y gcopy))))
					   (#t
					    (format #t "will not fit , moving ~a into ~a ~%" used2 size)
					    (exit (list "will not fit " used2 size))
					    ))))))))))
	 #f)))))


  
  (define func-left
    (lambda (state)
      (let* ((hole (state-hole state))	     (gold (state-gold state))
	     (hole-x (first hole))	     (hole-y (second hole))
	     (gold-x (first gold))	     (gold-y (second gold))
	     (grid (state-grid state))
	     (width (g:wid grid))
	     (height (g:hgt grid)))
      (call/cc
       (lambda (exit) 
	 (cond
	  ((> hole-x 1)
	   (format #t " hole-x > 1  ~%")		 
	   (let* ((x hole-x)(y hole-y)(x2 (- x 1))(y2 y))
	     (let ((expr (g:xy grid x y))
		   (expr2 (g:xy grid x2 y2)))
	       (format #t "expr : ~A ~%" expr)
	       (format #t "expr2 : ~A ~%" expr2)		     
	       (match expr (('used used 'size size)
			    (format #t "match expr : ~A : used=~a : size = ~a ~%" expr used size)
			    (match expr2 (('used used2 'size size2)
					  (format #t "<inner expr2 match okay>  ~%")
					  (cond
					   ((and (<= used size2) (<= used2 size))
					    (format #t "<inner expr2 match okay>  ~%")
					    
					    (let ((gcopy (g:copy grid)))
					      (g:xy! gcopy x y `(used ,used2 size ,size))
					      (g:xy! gcopy x2 y2 `(used ,used size ,size2))

					      (set! hole-x x2)
					      (set! hole-y y2)
					      
					      ;; hole is at x , y
					      ;; gold is at x2 y2 ... gold is now at x y
					      (cond ((and (= x2 gold-x) (= y2 gold-y))
						     (set! gold-x x)
						     (set! gold-y y)))
					      
					      (exit (make-state hole-x hole-y gold-x gold-y gcopy))))
					   (#t
					    (format #t "will not fit , moving ~a into ~a ~%" used2 size)
					    (exit (list "will not fit " used2 size))
					    ))))))))))
	 #f)))))


  (define func-right
    (lambda (state)
      (let* ((hole (state-hole state))	     (gold (state-gold state))
	     (hole-x (first hole))	     (hole-y (second hole))
	     (gold-x (first gold))	     (gold-y (second gold))
	     (grid (state-grid state))
	     (width (g:wid grid))
	     (height (g:hgt grid)))
      (call/cc
       (lambda (exit) 
	 (cond
	  ((< hole-x width)
	   (format #t " hole-x < width  ~%")		 
	   (let* ((x hole-x)(y hole-y)(x2 (+ x 1))(y2 y))
	     (let ((expr (g:xy grid x y))
		   (expr2 (g:xy grid x2 y2)))
	       (format #t "expr : ~A ~%" expr)
	       (format #t "expr2 : ~A ~%" expr2)		     
	       (match expr (('used used 'size size)
			    (format #t "match expr : ~A : used=~a : size = ~a ~%" expr used size)
			    (match expr2 (('used used2 'size size2)
					  (format #t "<inner expr2 match okay>  ~%")
					  (cond
					   ((and (<= used size2) (<= used2 size))
					    (format #t "<inner expr2 match okay>  ~%")
					    
					    (let ((gcopy (g:copy grid)))
					      (g:xy! gcopy x y `(used ,used2 size ,size))
					      (g:xy! gcopy x2 y2 `(used ,used size ,size2))

					      (set! hole-x x2)
					      (set! hole-y y2)
					      
					      ;; hole is at x , y
					      ;; gold is at x2 y2 ... gold is now at x y
					      (cond ((and (= x2 gold-x) (= y2 gold-y))
						     (set! gold-x x)
						     (set! gold-y y)))
					      
					      (exit (make-state hole-x hole-y gold-x gold-y gcopy))))
					   (#t
					    (format #t "will not fit , moving ~a into ~a ~%" used2 size)
					    (exit (list "will not fit " used2 size))
					    ))))))))))
	 #f)))))




  (define state-show
    (lambda (state)
      (let* ((g (state-grid state))
	     (wid (g:wid g))
	     (hgt (g:hgt g)))
	(format #t "~%")
	(letrec ((foo (lambda (x y)
			(cond
			 ((> x wid)
			  (format #t "~%")
			  (foo 1 (+ y 1)))
			 ((> y hgt) #f)
			 (#t (let ((expr (g:xy g x y)))
			       (match expr
				 (('used used 'size size)
				  (format #t "~a/~a " used size)
				  (foo (+ x 1) y)))))))))
	  (foo 1 1)
	  #f))))
 


  ;; export aliases
  (define up func-up)
  (define down func-down)
  (define left func-left)
  (define right func-right)

  (define hole state-hole)
  (define gold state-gold)
  (define show state-show)

  (define wid state-grid-width)
  (define hgt state-grid-height)
  (define xy state-grid-xy)
  
    
);; data module

