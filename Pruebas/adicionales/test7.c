#include <stdio.h>
int winner;
int vector[16];

calc2 (int n, int d) {
	int fin;
	puts("Esto es una función de comprobacion con el numero: ");
    	printf ("%d ", n) ;
  puts("\n");

  if (n > d) {
		fin = n ;
		printf("%d", fin);
    		winner = n;
		return n*d;
    } else { 
    		fin = d ;
		printf("%d", fin);
      		winner = d;
		return n/d;
	} 
}

calc3(){
	puts("And the winner is: ");
	printf("%d", winner);
}

main (){
	int primer, segun;
	vector[0] = 12;
	primer = 5*vector[0];
	segun = 7*(15-8);
	calc2(primer, segun);
	calc3();
	return 0;
}
//@ (main)

