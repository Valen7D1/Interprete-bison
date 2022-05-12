(setq winner 10)
(setq vector (make-array 16))


(defun main() 
	(setq cont 0)
	(loop while ( < cont  winner ) do (setf (aref vector cont) cont)
	(setq cont ( + cont  1 ))
	)
	(setq i 0)
(loop while ( < i  10 ) do (print (aref vector i))
	 (setq i ( + i  1 )))
	(if ( < ( + ( - (aref vector 0)  (aref vector 1) )  15 )  17 ) (return-from main ( - 1 ))
	)
	(return-from main 0)
	
) (main)
