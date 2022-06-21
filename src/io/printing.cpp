#include "io/printing.hpp"

void print_s(char *s, unsigned int sz) {
    char *addr = (char *)0xB8000;
    for (unsigned int i = 0; i != sz ; ++i) {
        *addr = s[i];
        addr += 2;
    }
    
}
