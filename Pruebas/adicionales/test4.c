#include <stdio.h>

int b; int c; 

suma (int a,int b)
{
   int c;
   int d;
   while (a<=b){
	d=a+1;
	c=a+d;
	a=a+1;
	printf("%d",c);
	}
   int d=0;
   return (c);
}

main ()
{
     int a=3;
     int b=10;
     c = suma(a,b);
     puts("La suma total de a a b es: ");
     printf("%d",c);
     return c;
     d = a<b ? a+5 : b-a ;
     return d;

//   system("pause") ;
}

//@ (main)
