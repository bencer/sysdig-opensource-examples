#include <stdlib.h>
#include <fcntl.h>

int main()
{
    int j;
    char buf[1];
    int fd; 

    fd = open("write.bin", O_CREAT | O_WRONLY);

    for(j = 0; j < 5000000; j++)
    {   
        write(fd, buf, 1); 
    }   
}
