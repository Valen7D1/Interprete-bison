/* 
Grupo 16: Gonzalo Valenti Sanguino, Silvia Jarabo Alfonso 
100429486@alumnos.uc3m.es 100429028@alumnos.uc3m.es 
*/
 
%{                          // SECCION 1 Declaraciones de C-Yacc

#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para cadenas
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

char *mi_malloc (int) ;
char *genera_cadena (char *) ;
int yylex () ;
int yyerror () ;

char temp [2048] ;
char name [128];

char *int_to_string (int n)
{
    sprintf (temp, "%d", n) ;
    return genera_cadena (temp) ;
}

char *char_to_string (char c)
{
    sprintf (temp, "%c", c) ;
    return genera_cadena (temp) ;
}


%}

%union {                      // El tipo de la pila tiene caracter dual
    int valor ;               // - valor numerico de un NUMERO
    char *cadena ;            // - para pasar los nombres de IDENTIFES
}


%type   <cadena> axioma programa funcion varsControl secuenciaVar main cuerpoControl cuerpo expresion termino operando argumento forAsign argsControl multipleArgs nombre mainName asignArgs asignControl secuenciaGlob optionalArgs

%token <valor> NUMERO         // Todos los token tienen un tipo para la pila
%token <cadena> IDENTIF       // Identificador=variable
%token <cadena> INTEGER       // identifica la definicion de un entero
%token <cadena> STRING
%token <cadena> MAIN          // identifica el comienzo del proc. main
%token <cadena> WHILE         // identifica el bucle main
%token <cadena> FOR	       //identifica el bucle for
%token <cadena> PRINTF        // identifica los prints de expresiones
%token <cadena> PUTS          // identifica los prints de strs
%token <cadena> ELSE	       //identifica un else token 
%token <cadena> IF	       //identifica un if token 
%token <cadena> RETURN	       //identifica un return token



%right '='                    // es la ultima operacion que se debe realizar
%left OR
%left AND
%left NOTEQUAL EQUAL
%left LOWTHAN GREATHAN '<' '>'
%left '+' '-'                 // menor orden de precedencia
%left '*' '/' '%'               // orden de precedencia intermedio
%left SIGNO_UNARIO            // mayor orden de precedencia
%left '(' ')'

%%
                             // Seccion 3 Gramatica - Semantico

axioma:         	programa                  							{ printf(temp, "%s \n", $1) ; 
														$$ = genera_cadena (temp) ; }
	    	;	

programa: 		varsControl funcion main							{ sprintf(temp, "%s\n%s\n%s", $1, $2, $3); 
														$$ = genera_cadena (temp) ; }
	    	;
	    	
varsControl: 		/*lambda*/									{$$ = "";}
		|   	INTEGER secuenciaGlob varsControl						{ sprintf(temp, "%s\n%s", $2, $3); 
														$$ = genera_cadena (temp) ; }
		;
		
secuenciaGlob:		IDENTIF ';' 									{ sprintf(temp, "(setq %s 0)", $1);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' NUMERO  ';'  							{ sprintf(temp, "(setq %s %s)", $1, int_to_string($3));
														$$ = genera_cadena (temp) ; }
		|    	IDENTIF ',' secuenciaGlob							{ sprintf(temp, "(setq %s 0) %s", $1, $3);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' NUMERO ',' secuenciaGlob   						{ sprintf(temp, "(setq %s %s) %s", $1, int_to_string($3), $5);
														$$ = genera_cadena (temp) ; }
	        |	IDENTIF '[' NUMERO ']' ';'							{ sprintf(temp, "(setq %s (make-array %s))", $1, int_to_string($3));
														$$ = genera_cadena (temp) ; }
		|	IDENTIF '[' NUMERO ']'',' secuenciaGlob						{ sprintf(temp, "(setq %s (make-array %s))%s", $1, int_to_string($3), $6);
														$$ = genera_cadena (temp) ; }
		;

main:			mainName '('')''{' cuerpoControl '}' 						{ sprintf (name, "%s", $1) ;sprintf(temp, "(defun main() \n\t%s\n)", $5); 
														$$ = genera_cadena (temp) ; }
	    	;
	    	
mainName:		MAIN										{sprintf (name, "%s", $1);
														 $$ = genera_cadena (name) ; }
		;
	
funcion: 		/*lambda*/									{$$ = "";}
		| 	nombre '(' argsControl ')''{' cuerpoControl'}' funcion				{ sprintf(temp, "(defun %s(%s)\n%s)\n%s \n", $1, $3, $6, $8); 
														$$ = genera_cadena (temp) ; }
		;
		
nombre: 		IDENTIF 									{sprintf (name, "%s", $1) ;
													$$ = genera_cadena (name) ; }                                     
            	;

argsControl:		/*lambda*/									{$$ = "";}
		|	INTEGER IDENTIF multipleArgs							{ sprintf(temp, "%s%s", $2, $3); 
														$$ = genera_cadena (temp) ; }
		|	INTEGER IDENTIF '=' expresion optionalArgs					{ sprintf(temp, "&optional (%s %s)%s", $2, $4, $5); 
														$$ = genera_cadena (temp) ; }			
		;
		
multipleArgs:		/*lambda*/									{$$ = "";}
		|	',' INTEGER IDENTIF multipleArgs						{ sprintf(temp, " %s%s", $3, $4); 
														$$ = genera_cadena (temp) ; }
		|	',' INTEGER IDENTIF '=' expresion optionalArgs					{ sprintf(temp, " &optional (%s %s)%s", $3, $5, $6); 
														$$ = genera_cadena (temp) ; }
		;
		
optionalArgs:		/*lambda*/									{$$ = "";}
		|	',' INTEGER IDENTIF '=' expresion optionalArgs					{ sprintf(temp, " (%s %s)%s", $3, $5, $6); 
														$$ = genera_cadena (temp) ; }
		|	',' INTEGER IDENTIF optionalArgs						{ sprintf(temp, " (%s 0)%s", $3, $4); 
														$$ = genera_cadena (temp) ; }
		;
		
cuerpoControl:	  	/*lambda*/									{$$ = "";}
		| 	cuerpo cuerpoControl								{ sprintf(temp, "%s\n\t%s", $1 ,$2);
													$$ = genera_cadena(temp);}   
		;
		
cuerpo:      		secuenciaVar ';' 								{ sprintf(temp, "%s", $1);
	    													$$ = genera_cadena (temp) ; }
            	|   	INTEGER secuenciaVar ';' 							{ sprintf(temp, "%s",$2);
														$$ = genera_cadena (temp) ; }
            	|  	PRINTF '('STRING ',' argumento')' ';'  						{ sprintf(temp, "%s", $5);
														$$ = genera_cadena(temp); }
	    	|   	PUTS '(' STRING')' ';'  							{ sprintf(temp, "(print \"%s\")", $3);
														$$ = genera_cadena(temp); }
	    	|   	WHILE '(' expresion ')' '{' cuerpoControl '}'    				{ sprintf(temp,"(loop while %s do %s)", $3, $6);
														$$ = genera_cadena(temp); }			
	    	|   	FOR '(' forAsign ';' expresion ';' forAsign ')' '{' cuerpoControl '}'  		{ sprintf(temp,"%s\n(loop while %s do %s %s)",$3 ,$5, $10, $7);
														$$ = genera_cadena(temp); }
	    	|   	FOR '(' INTEGER forAsign ';' expresion ';' forAsign ')' '{' cuerpoControl '}'	{ sprintf(temp,"%s\n(loop while %s do %s %s)",$4 ,$6, $11, $8);
														$$ = genera_cadena(temp); }
	    	|   	IF '(' expresion ')' '{' cuerpoControl '}'    					{ sprintf(temp,"(if %s %s)", $3, $6);
														$$ = genera_cadena(temp); } 
	    	|   	IF '(' expresion ')' '{' cuerpoControl '}' ELSE '{' cuerpoControl '}'    	{ sprintf(temp,"(if %s (progn %s) (progn %s))", $3, $6, $10);
														$$ = genera_cadena(temp); } 
            	|   	IDENTIF '[' expresion ']' '=' expresion ';'					{ sprintf(temp, "(setf (aref %s %s) %s)",$1, $3, $6);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' expresion '?' expresion ':' expresion ';'				{ sprintf(temp,"(if %s (setq %s %s) (setq %s %s))", $3, $1, $5, $1, $7);
														$$ = genera_cadena(temp); }
		|   	INTEGER IDENTIF '=' expresion '?' expresion ':' expresion ';'			{ sprintf(temp,"(if %s (setq %s %s) (setq %s %s))", $4, $2, $6, $2, $8);
														$$ = genera_cadena(temp); }
		|   	RETURN expresion ';' 								{ sprintf(temp, "(return-from %s %s)",name, $2);
	    													$$ = genera_cadena (temp) ; }
	    	|	IDENTIF '(' asignControl ')' ';'						{ sprintf (temp, "(%s %s)", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	;
            	
secuenciaVar:		IDENTIF 									{ sprintf(temp, "(setq %s 0)", $1);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' expresion    							{ sprintf(temp, "(setq %s %s)", $1, $3);
														$$ = genera_cadena (temp) ; }
		|    	IDENTIF ',' secuenciaVar							{ sprintf(temp, "(setq %s 0) %s", $1, $3);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' expresion ',' secuenciaVar   					{ sprintf(temp, "(setq %s %s) %s", $1, $3, $5);
														$$ = genera_cadena (temp) ; }
	        |	IDENTIF '[' expresion ']' 							{ sprintf(temp, "(setq %s (make-array %s))", $1, $3);
														$$ = genera_cadena (temp) ; }
		|	IDENTIF '[' expresion ']'',' secuenciaVar					{ sprintf(temp, "(setq %s (make-array %s))%s", $1, $3, $6);
														$$ = genera_cadena (temp) ; }
		;
            	
forAsign:  		IDENTIF 									{ sprintf(temp, "(setq %s 0)", $1);
														$$ = genera_cadena (temp) ; }
	    	|   	IDENTIF '=' expresion    							{ sprintf(temp, "(setq %s %s)", $1, $3);	
 														$$ = genera_cadena (temp) ; }
            	;
		

argumento: 		expresion									{ sprintf(temp, "(print %s)", $1);
														$$ = genera_cadena(temp); }
            	|  	expresion ',' argumento  							{sprintf(temp, "(print %s) %s", $1 ,$3);
														$$ = genera_cadena(temp);}   
	    	;


expresion:      	termino										{ $$ = $1; }

	    	|   	expresion AND expresion   							{ sprintf (temp, "( And %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion OR expresion   							{ sprintf (temp, "( or %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion NOTEQUAL expresion   							{ sprintf (temp, "(/= %s  %s )", $1, $3) ;
													  	$$ = genera_cadena (temp) ; }
            	|   	expresion '<' expresion   							{ sprintf (temp, "( < %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion '>' expresion   							{ sprintf (temp, "( > %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion LOWTHAN expresion   							{ sprintf (temp, "( <= %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion GREATHAN expresion   							{ sprintf (temp, "( >= %s  %s )", $1, $3) ;
									 	 				$$ = genera_cadena (temp) ; }
            	|   	expresion EQUAL expresion   							{ sprintf (temp, "( = %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion '+' expresion   							{ sprintf (temp, "( + %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion '-' expresion   							{ sprintf (temp, "( - %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion '*' expresion   							{ sprintf (temp, "( * %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	expresion '/' expresion   							{ sprintf (temp, "( / %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
	    	|   	expresion '%' expresion   							{ sprintf (temp, "(mod %s  %s )", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	;

termino:        	operando									{ $$ = $1; }                          
            	|   	'+' operando %prec SIGNO_UNARIO							{ sprintf (temp, "( + %s )", $2) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	'-' operando %prec SIGNO_UNARIO							{ sprintf (temp, "( - %s )", $2) ;
									  					$$ = genera_cadena (temp) ; }
	    	;    


asignControl:		/*lambda*/									{$$ = "";}
		| 	expresion asignArgs								{ sprintf (temp, "%s %s", $1, $2) ;
									  					$$ = genera_cadena (temp) ; }	
		;    
		
		
asignArgs:		/*lambda*/									{$$ = "";}	
		| 	',' expresion asignArgs								{ sprintf (temp, "%s %s", $2, $3) ;
									  				$$ = genera_cadena (temp) ; }	
		;

operando:       	IDENTIF										{ $$ = $1 ; }
	    	|	IDENTIF '(' asignControl ')'							{ sprintf (temp, "(%s %s)", $1, $3) ;
									  					$$ = genera_cadena (temp) ; }
            	|   	NUMERO										{ $$ = int_to_string ($1) ; }

            	|   	'(' expresion ')'								{ $$=$2 ;}
            	|	IDENTIF '[' expresion ']'							{ sprintf(temp, "(aref %s %s)",$1, $3);
														$$ = genera_cadena (temp) ; }
            	;


%%
                            // SECCION 4    Codigo en C
int n_linea = 1 ;

int yyerror (mensaje)
char *mensaje ;
{
    fprintf (stderr, "%s en la linea %d\n", mensaje, n_linea) ;
    printf ( "\n") ;	// bye
}

char *mi_malloc (int nbytes)       // reserva n bytes de memoria dinamica
{
    char *p ;
    static long int nb = 0;        // sirven para contabilizar la memoria
    static int nv = 0 ;            // solicitada en total

    p = malloc (nbytes) ;
    if (p == NULL) {
        fprintf (stderr, "No queda memoria para %d bytes mas\n", nbytes) ;
        fprintf (stderr, "Reservados %ld bytes en %d llamadas\n", nb, nv) ;
        exit (0) ;
    }
    nb += (long) nbytes ;
    nv++ ;

    return p ;
}


/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_pal_reservadas { // para las palabras reservadas de C
    char *nombre ;
    int token ;
} t_reservada ;

t_reservada pal_reservadas [] = { // define las palabras reservadas y los
    "main",        MAIN,           // y los token asociados
    "int",         INTEGER,
    "printf", 	   PRINTF,
    "puts",        PUTS,
    "while", 	   WHILE,
    "&&",          AND,
    "||",          OR,
    "!=",          NOTEQUAL,
    "==",          EQUAL,
    ">=",          GREATHAN,
    "<=",          LOWTHAN,
    "if",          IF,
    "else",        ELSE,
    "for",         FOR,
    "return",      RETURN,
    NULL,          0               // para marcar el fin de la tabla
} ;

t_reservada *busca_pal_reservada (char *nombre_simbolo)
{                                  // Busca n_s en la tabla de pal. res.
                                   // y devuelve puntero a registro (simbolo)
    int i ;
    t_reservada *sim ;

    i = 0 ;
    sim = pal_reservadas ;
    while (sim [i].nombre != NULL) {
	    if (strcmp (sim [i].nombre, nombre_simbolo) == 0) {
		                             // strcmp(a, b) devuelve == 0 si a==b
            return &(sim [i]) ;
        }
        i++ ;
    }

    return NULL ;
}

 
/***************************************************************************/
/******************* Seccion del Analizador Lexicografico ******************/
/***************************************************************************/

char *genera_cadena (char *nombre)     // copia el argumento a un
{                                      // string en memoria dinamica
    char *p ;
    int l ;
	
    l = strlen (nombre)+1 ;
    p = (char *) mi_malloc (l) ;
    strcpy (p, nombre) ;
	
    return p ;
}


int yylex ()
{
    int i ;
    unsigned char c ;
    unsigned char cc ;
    char ops_expandibles [] = "!<=>|&%+-/*" ;
    char cadena [256] ;
    t_reservada *simbolo ;

    do {
        c = getchar () ;

        if (c == '#') {	// Ignora las lineas que empiezan por #  (#define, #include)
            do {		//	OJO que puede funcionar mal si una linea contiene #
                c = getchar () ;
            } while (c != '\n') ;
        }

        if (c == '/') {	// Si la linea contiene un / puede ser inicio de comentario
            cc = getchar () ;
            if (cc != '/') {   // Si el siguiente char es /  es un comentario, pero...
                ungetc (cc, stdin) ;
            } else {
                c = getchar () ;	// ...
                if (c == '@') {	// Si es la secuencia //@  ==> transcribimos la linea
                    do {		// Se trata de codigo inline (Codigo embebido en C)
                        c = getchar () ;
                        putchar (c) ;
                    } while (c != '\n') ;
                } else {		// ==> comentario, ignorar la linea
                    while (c != '\n') {
                        c = getchar () ;
                    }
                }
            }
        } else if (c == '\\') c = getchar () ;
		
        if (c == '\n')
            n_linea++ ;

    } while (c == ' ' || c == '\n' || c == 10 || c == 13 || c == '\t') ;

    if (c == '\"') {
        i = 0 ;
        do {
            c = getchar () ;
            cadena [i++] = c ;
        } while (c != '\"' && i < 255) ;
        if (i == 256) {
            printf ("AVISO: string con mas de 255 caracteres en linea %d\n", n_linea) ;
        }		 	// habria que leer hasta el siguiente " , pero, y si falta?
        cadena [--i] = '\0' ;
        yylval.cadena = genera_cadena (cadena) ;
        return (STRING) ;
    }

    if (c == '.' || (c >= '0' && c <= '9')) {
        ungetc (c, stdin) ;
        scanf ("%d", &yylval.valor) ;
//         printf ("\nDEV: NUMERO %d\n", yylval.valor) ;        // PARA DEPURAR
        return NUMERO ;
    }

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
        i = 0 ;
        while (((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '_') && i < 255) {
            cadena [i++] = tolower (c) ;
            c = getchar () ;
        }
        cadena [i] = '\0' ;
        ungetc (c, stdin) ;

        yylval.cadena = genera_cadena (cadena) ;
        simbolo = busca_pal_reservada (yylval.cadena) ;
        if (simbolo == NULL) {    // no es palabra reservada -> identificador 
//               printf ("\nDEV: IDENTIF %s\n", yylval.cadena) ;    // PARA DEPURAR
            return (IDENTIF) ;
        } else {
//               printf ("\nDEV: OTRO %s\n", yylval.cadena) ;       // PARA DEPURAR
            return (simbolo->token) ;
        }
    }

    if (strchr (ops_expandibles, c) != NULL) { // busca c en ops_expandibles
        cc = getchar () ;
        sprintf (cadena, "%c%c", (char) c, (char) cc) ;
        simbolo = busca_pal_reservada (cadena) ;
        if (simbolo == NULL) {
            ungetc (cc, stdin) ;
            yylval.cadena = NULL ;
            return (c) ;
        } else {
            yylval.cadena = genera_cadena (cadena) ; // aunque no se use
            return (simbolo->token) ;
        }
    }

//    printf ("\nDEV: LITERAL %d #%c#\n", (int) c, c) ;      // PARA DEPURAR
    if (c == EOF || c == 255 || c == 26) {
//         printf ("tEOF ") ;                                // PARA DEPURAR
        return (0) ;
    }

    return c ;
}


int main ()
{
    yyparse () ;
}
