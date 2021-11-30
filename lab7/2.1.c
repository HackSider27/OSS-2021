#include <stdio.h>
#include <unistd.h>

int main()
{
    	int pid = fork();

    	if (!pid)
        	printf("Children pid: %d, Parent pid:%d\n", getpid(), getppid());

	return 0;
}