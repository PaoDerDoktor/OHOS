#include "io/printing.hpp"

void print_s(char *s, unsigned int sz) {
    char *addr = (char *)0xB8000;
    for (unsigned int i = 0; i != sz ; ++i) {
        *addr = s[i];
        addr += 2;
    }
    
}

void print_string(const string &s) {
    char *addr = (char *)0xB8000;
    for (unsigned int i = 0; i != s.get_size(); ++i) {
        *addr = s.get_at(i);
        addr += 2;
    }
}
