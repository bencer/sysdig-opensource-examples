#include <stdio.h>
#include <stdlib.h>

int main()
{
    int j;
    char* buf = (char*)malloc(5000 * 1000);

    FILE* f;
    f = fopen("write.bin", "w+");

    for(j = 0; j < 3000; j++)
    {   
        fwrite(buf, j * 1000, 1, f); 
    }   
}
