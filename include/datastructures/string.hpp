#pragma once

/**
 * @brief A simple raw string wrapper
 */
class string {
    private:
        char         *s_ptr; ///< Pointer to the string
        unsigned int  size;  ///< Size of the string

    public:
        string(char *s_ptr, unsigned int size) : s_ptr(s_ptr), size(size) {}

        char         *get_raw_str() const;
        unsigned int  get_size()    const;
        char get_at(const unsigned int &i) const;
};
