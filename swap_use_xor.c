
// http://www.programmingsimplified.com/c-program-swap-two-numbers

#include "stdio.h"
#include <time.h>
#include <stdlib.h>


int main(void)
{
	int a = 123;
	int b = 456;

	printf("----------------\n");
	printf("%d, %d\n",a,b);
	a = a ^ b;
	b = a ^ b;
	a = a ^ b;
	printf("%d, %d\n",a,b);

	printf("----------------\n");
	printf("%d, %d\n",a,b);
	a = a + b;
	b = a - b;
	a = a - b;
	printf("%d, %d\n",a,b);
	printf("----------------\n");
}