#include "stdio.h"
#include <time.h>
#include <stdlib.h>

#define N 3

void generate_array(int arr[],int n);
void my_printf(int arr[], int length);

//first sort one
void bubble_sort_one(int a[],int count,int order)
{
	for (int i = 0; i < count-1-order; ++i)
	{
		if (a[i] > a[i+1])
		{
			int k = a[i];
			a[i] = a[i+1];
			a[i+1] = k;
		}
	}
}

void bubble_sort_sum(int a[],int sum)
{
	for (int i = 0; i < sum; ++i)
	{
		for (int i = 0; i < count-1-i; ++i)
		{
			if (a[i] > a[i+1])
			{
				int k = a[i];
				a[i] = a[i+1];
				a[i+1] = k;
			}
		}
	}

	// for (int i = 0; i < sum; ++i)
	// {
	// 	bubble_sort_one(a,sum,i);
	// }
}
int main(void)
{
	int arr[N];
	generate_array(arr,N);

	my_printf(arr,N);

	bubble_sort_sum(arr,N);

	my_printf(arr,N);	
}

//产生随机数
void generate_array(int arr[],int n)
{
	int i;
	srand(time(0));

	for (int i = 0; i < n; ++i)
	{
		arr[i] = rand();
	}
}

void my_printf(int arr[], int length)
{
	for (int i = 0; i < length; ++i)
	{
		printf("%d\n", arr[i]);
	}
}