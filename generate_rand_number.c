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

void bubble_sort(char arr[], int length)
{	
	for (int j = 0; j < length-1; ++j)
	{
		for (int i = 0; i < length-1-j; ++i)
		{
			if (arr[i] > arr[i+1])
			{
				char temp  = arr[i];
				arr[i] = arr[i+1];
				arr[i+1] = temp;
			}
		}		
	}
}

void binary_search(char arr[], int length, char value)
{
	int first,last,middle;
	first = 0;
	last = length - 1;
	middle = (first + last)/2;

	while(first <= last)
	{
		// printf("------error-------\n");
		if (value > arr[middle])
		{
			first = middle + 1;
		}
		else if (value == arr[middle])
		{
			printf("%d found at location %d\n",value,middle);
			// break;
		}
		else
		{
			last = middle - 1;
		}

		middle = (first + last)/2;
	}
	if (last < first)
	{
		printf("------error-------\n");
	}
}
int main(void)
{
	char arr[1000];
	int n = 1000;

	memset(arr,0,n);
	_printf(arr,n);
	generate_array(arr, n);

	bubble_sort(arr,n);

	_printf(arr,n);

	binary_search(arr, n, 66);
	printf("hello\n");
}