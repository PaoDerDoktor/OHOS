#include "kernel.hpp"
#include "datastructures/string.hpp"
#include "io/printing.hpp"

extern "C" void main() {
    print_s("Welcome to paradise city !!", 27);

    string s("Hey coucou :3", 13);

    print_string(s);

    return;
}
