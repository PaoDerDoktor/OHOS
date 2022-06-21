#include "kernel.hpp"
#include "datastructures/string.hpp"

extern "C" void main() {
    print_s("Welcome to paradise city !!", 27);
    
    

    // Trying to initialize string
    string s("Hey coucou", 10);

    print_s(s.get_raw_str(), s.get_size());

    return;
}

void print_s(char *s, unsigned int sz) {
    char *addr = (char *)0xB8000;
    for (unsigned int i = 0; i != sz ; ++i) {
        *addr = s[i];
        addr += 2;
    }
    
}
