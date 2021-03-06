(defun missionaries-cannibals (numMis numCan)
  (if (< numMis numCan) (error "Yikes, the missionaries are outnumbered by the cannibals! Make sure the missionaries are equal to or greater than the number of cannibals to start."))
  (setq initial (createstate 0 0 numMis numCan))
  (solution initial 1)
  (print "COMPLETE"))
(defun createstate (westm westc eastm eastc)
  (list westm westc eastm eastc (+ eastm eastc)))
(defun goalcheck (state)
  (setq eastm (car (subseq state 2 3)))
  (setq eastc (car (subseq state 3 4)))
  (if (= (+ eastm eastc) 0) T nil))
(defun heuristic (state boatm boatc)
  (setq eastm (car (subseq state 2 3)))
  (setq eastc (car (subseq state 3 4)))
  (+ (- eastm boatm) (- eastc boatc)))
(defun solution (state direction)
  (if (eql (goalcheck state) nil)
    (progn
      (setq westm (car state))
      (setq westc (car (subseq state 1 2)))
      (setq eastm (car (subseq state 2 3)))
      (setq eastc (car (subseq state 3 4)))
      (if (= direction 1)
	(progn
	  (setq results (movewest state 6))
	  (setq newstate (createstate (+ westm (car results)) (+ westc (car (cdr results))) (- eastm (car results)) (- eastc (car (cdr results)))))
	  (print (concatenate 'string "Move " (write-to-string (car results)) " missionaries and " (write-to-string (car (cdr results))) " cannibal(s) west.")))
	(progn
	  (setq results (moveeast state 6))
	  (setq newstate (createState (- westm (car results)) (- westc (car (cdr results))) (+ eastm (car results)) (+ eastc (car (cdr results)))))
	  (print (concatenate 'string "Move " (write-to-string (car results)) " missionaries and " (write-to-string (car (cdr results))) " cannibal(s) east."))))
      (print "New State:        West        East")
      (print (concatenate 'string "                 M:" (write-to-string (car newstate)) "         M:" (write-to-string (car (subseq newstate 2 3)))))
      (print (concatenate 'string "                 C:" (write-to-string (car (cdr newstate))) "         C:" (write-to-string (car (subseq newstate 3 4)))))
      (print "- - - - - - - - - - - - - - - - - - - - - - -")
      (solution newstate (* -1 direction)))))
(defun movewest (state boatsize)
  (setq least_heuristic (car (subseq state 4)))
  (setq boatm 0)
  (setq boatc 0)
  (setq limit (min boatsize (car (subseq state 4))))
  (setq bestm 0)
  (setq bestc 0)
  (do ((i 1 (+ i 1)))
    ((> i limit) 'done)
    (progn
      (if (= (mod i 2) 1)
	(setf boatm (+ boatm 1))
	(progn
	  (if (>= (- (car (subseq state 3 4)) (+ boatc 1)) 0)
	    (setf boatc (+ boatc 1))
	    (setf boatm (+ boatm 1)))))
      (if (< (heuristic state boatm boatc) least_heuristic)
	(progn
	  (setf least_heuristic (heuristic state boatm boatc))
	  (setf bestm boatm)
	  (setf bestc boatc)))))
  (list bestm bestc))
(defun moveeast (state boatsize)
  (if (> (car state) (car (cdr state)))
    (setq least_east 1)
    (setq least_east boatsize))
  (setq boatm 1)
  (setq boatc 0)
  (setq bestm 1)
  (setq bestc 0)
  (do ((i 1 (+ i 1)))
    ((> i (- boatsize 1)) 'done)
    (if (= (mod i 2) 1)
      (setf boatc (+ boatc 1))
      (setf boatm (+ boatm 1)))
    (if (>= (- (car state) boatm) (- (car (cdr state)) boatc))
      (progn
	(if (< (+ boatm boatc) least_east)
	  (progn
	    (setf bestm boatm)
	    (setf bestc boatc)
	    (setf least_east (+ bestm bestc)))))))
  (list bestm bestc))
(progn
  (print "Enter the number of missionaries:")
  (setq numMis (read))
  (loop while (not (numberp numMis)) do
        (print "Please make sure to enter a non-null integer.")
        (print "Enter the number of missionaries:")
        (setf numMis (read))
        (if (eql numMis nil) (setf numMis "a")))
  (print "Enter the number of cannibals:")
  (setq numCan (read))
  (loop while (not (numberp numCan)) do
        (print "Please make sure to enter a non-null integer.")
        (print "Enter the number of cannibals:")
        (setf numCan (read))
        (if (eql numCan nil) (setf numCan "a")))
  (missionaries-cannibals numMis numCan))
