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

void insert_sort(char arr[], int length)
{
	int i,j;
	for (i = 1; i < length; ++i)
	{
		for (j = i-1; j >= 0; j--)
		{
			if (arr[i] > arr[j])
			{
				break;
			}
		}

		if (j != i-1)
		{
			char temp = arr[i];
			for (int m = i; m > j+1; m--)
			{
				arr[m] = arr[m-1];
			}
			arr[j+1] = temp;
		}
	}
}
int main(void)
{
	char arr[10];
	int n = 10;
	generate_array(arr,n);
	_printf(arr, n);
	insert_sort(arr, n);
	_printf(arr, n);

	printf("hello\n");
}