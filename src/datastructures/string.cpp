#include "datastructures/string.hpp"

char *string::get_raw_str() const {
    return this->s_ptr;
}

unsigned int string::get_size() const {
    return this->size;
}

char string::get_at(const unsigned int &i) const {
    return this->s_ptr[i];
}
