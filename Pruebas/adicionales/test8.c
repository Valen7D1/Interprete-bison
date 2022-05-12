#include <stdio.h>
int winner=10;
int vector[16];
main (){
	int cont = 0;
	while (cont < winner){
		vector[cont] = cont;
		cont = cont +1;
	}
	for (int i = 0; i < 10; i = i +1){
		printf("%d", vector[i]);
	}
	if (vector[0] - vector[1] +15 < 17){
		return -1;
	}
	
	return 0;
}
//@ (main)

