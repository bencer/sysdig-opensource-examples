#include <stdio.h>
#include <stdlib.h>

int main()
{
    int j;
    char buf[1];
    FILE* f;

    f = fopen("write.bin", "w+");

    for(j = 0; j < 5000000; j++)
    {   
        fwrite(buf, 1, 1, f); 
    }   
}
