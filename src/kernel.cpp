#include "kernel.hpp"
#include "datastructures/string.hpp"

extern "C" void main() {
    print_s("Welcome to paradise city !!", 27);
    
    

    // Trying to initialize string
    string s("Hey coucou", 10);

    print_s(s.get_raw_str(), s.get_size());

    return;
}
