#include <stdlib.h>
#include <fcntl.h>

int main()
{
    int j;
    char* buf = (char*)malloc(5000 * 1000);
    int fd; 

    fd = open("write.bin", O_CREAT | O_WRONLY);

    for(j = 0; j < 3000; j++)
    {   
        write(fd, buf, j * 1000);
    }   
}
