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


int adjust_array(int arr[], int l, int r)
{
	int i = l, j = r;
	int x = arr[i];

	while(i < j)
	{
		while((i<j) && (arr[j] > x))
			j--;
		if (i < j)
		{
			arr[i] = arr[j];
			i++;
		}

		while((i<j) && (arr[j] > x))
			i++;
		if (i < j)
		{
			arr[j] = arr[i];
			j--;
		}
	}

	arr[i] = x;
	return i;
}

void quick_sort(char arr[],int l, int r)
{

	if(l < r)
	{
		int i=l,j=r,x = arr[i];
		while(i < j)
		{
			while((i<j) && (arr[j]>x))
			{
				j--;
			}
			if (i < j)
			{
				arr[i] = arr[j];
				i++;
			}

			while((i<j) && arr[i] < x)
			{
				i++;
			}
			if (i < j)
			{
				arr[j] = arr[i];
				j--;
			}
			arr[i] = x;
			quick_sort(arr,l,i-1);
			quick_sort(arr,i+1,r);			
		}
	}
	
}

int main(void)
{
	char arr[100];
	int n = 100;

	memset(arr,0,n);
	_printf(arr,n);
	generate_array(arr, n);

	quick_sort(arr,0,99);

	_printf(arr,n);

	printf("hello\n");
}