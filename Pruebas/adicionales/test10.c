#include <stdio.h>

int retorno;

optionals(int a, int b=5, int c=100){
	if (b<=c){
		if (b == c){
			b = c/2;
		}
		while (b < c){
			a = a + c;
			puts("Nuevo numero: ");
			printf("%d", a);
			b = b +2;
		}
	} else{
		retorno = b*2 > c ? c : b;
		printf("%d", retorno);
		return retorno;
	}
	return a;
}

main ()
{
   puts("Vamos a probar los opcionales: ");
   return optionals(0, 100);
   
//   system("pause") ;
}

//@ (main)
