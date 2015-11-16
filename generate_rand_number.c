#include "stdio.h"
#include <time.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>

void generate_array(char arr[],int n)
{
	int i;
	srand(time(0));
	for (int i = 0; i < n; ++i)
	{
		arr[i] = rand();
	}

}

void _printf(char arr[], int length)
{
	printf("-----------------------\n");
	for (int i = 0; i < length; i++)
	{
		printf("%d\n",arr[i]);
	}
	printf("-----------------------\n");
}

int main(void)
{
	char arr[10];
	int n = 10;

	memset(arr,0,10);
	_printf(arr,10);
	generate_array(arr, n);

	_printf(arr,10);
	printf("hello\n");
}