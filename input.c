/*Sum of Natural Numbers using for loop*/
#include <stdio.h>
int main()
{
int n,i,sum=0;
n=6;
//loop starts here
for(i=1;i<=n;i++)
{
sum+=i;
}
printf("Sum=%d",sum);
return 0;
}
