#include <stdio.h>


doble (int a)
{ 
   int b;
   b=a*2;
   return b;
}

cuatriple (int a)
{
    int b;
    b=a*4;
    return b;
}

triple (int a)
{
    int b;
    b=a*3;
    return b;
}


main ()
{
     int a ;
     a = 3 ;
     puts ("El triple de ") ;
     printf ("%d", a) ;
     c = triple (a) ;
     puts (" es ") ;
     printf ("%d\n", c) ;

     a = 12 ;
     puts ("El doble de ") ;
     printf ("%d", a) ;
     puts (" es ") ;
     printf ("%d\n", doble (a)) ;


//   system("pause") ;
}

//@ (main)
