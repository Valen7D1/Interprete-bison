(setq retorno 0)

(defun optionals(a &optional (b 5) (c 100))
(if ( <= b  c ) (progn (if ( = b  c ) (setq b ( / c  2 ))
	)
	(loop while ( < b  c ) do (setq a ( + a  c ))
	(print "Nuevo numero: ")
	(print a)
	(setq b ( + b  2 ))
	)
	) (progn (if ( > ( * b  2 )  c ) (setq retorno c) (setq retorno b))
	(print retorno)
	(return-from optionals retorno)
	))
	(return-from optionals a)
	)
 

(defun main() 
	(print "Vamos a probar los opcionales: ")
	(return-from main (optionals 0 100 ))
	
) (main)
