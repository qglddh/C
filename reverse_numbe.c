
//http://www.programmingsimplified.com/c/source-code/c-program-reverse-number

#include "stdio.h"
#include <time.h>
#include <stdlib.h>


void my_printf(int arr[], int length);

int main(void)
{
	unsigned long i = 123456789;

	unsigned long reverse;

	printf("%lu\n", i);
	while(i !=0 )
	{
		reverse = reverse * 10;
		reverse = reverse + i%10;
		i = i/10;
	}
	printf("%lu\n", reverse);
}