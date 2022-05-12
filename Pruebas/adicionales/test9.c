#include <stdio.h>
int win=15, lost;
main (){
	if (lost != 0){
		lost = 0;
	}
	int d = 10;
	d = d < win ? d : 5;
	puts("diferencia inicial de: ");
	printf("%d", win - d);
  int i;
	while (lost < win){
		for (i = 10/2+1*3; i < 12; i = i+2){
			d = (d*2)-5;
			if (d>=155){
				puts("menudo bicho");
			}
			printf("%d", d);		
		}
		if (d >300){return -1;}
		lost = lost + 1;
	}
	if (d < 100){
		return 0;
	}else{ 
		return 1;
	}
}
//@ (main)
