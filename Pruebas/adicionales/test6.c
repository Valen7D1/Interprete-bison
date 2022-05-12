#include <stdio.h>

int a; int b; int c;


main ()
{
   int d= 5*7+36/4-65%5;
   a=0;
   b=1;
   c=0;
   while(c<=d || b<d) {
	a=a+b;
	c=c+a;
	b=a+b;
	}
   puts("Resultados: ");
   printf("%d", c);
   return c;
   
//   system("pause") ;
}

//@ (main)
