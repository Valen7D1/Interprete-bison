(setq a 0)
(setq b 0)
(setq c 0)


(defun main() 
	(setq d ( - ( + ( * 5  7 )  ( / 36  4 ) )  (mod 65  5 ) ))
	(setq a 0)
	(setq b 1)
	(setq c 0)
	(loop while ( or ( <= c  d )  ( < b  d ) ) do (setq a ( + a  b ))
	(setq c ( + c  a ))
	(setq b ( + a  b ))
	)
	(print "Resultados: ")
	(print c)
	(return-from main c)
	
) (main)
