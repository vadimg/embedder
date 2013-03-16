#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

int get_symbol(const char* name, void** start, void** end) {
    void* s;
    void* e;
    char buffer[2048] = "_binary_";
    size_t start_len = sizeof("_binary_") - 1;
    size_t len = strlen(name) + start_len;

    /* make sure the start symbol (which is longer than the end symbol)
     * can fit into buffer
     */
    if (sizeof(buffer) < len + sizeof("_start")) {
        *start = NULL;
        *end = NULL;
        return -1;
    }

    /* it is now safe to use the unsafe strcpy function */

    strcpy(buffer + start_len, name);

    /* start symbol */
    strcpy(buffer + len, "_start");
    s = dlsym(NULL, buffer);
    if (!s) {
        *start = NULL;
        *end = NULL;
        return 1;
    }

    /* end symbol */
    strcpy(buffer + len, "_end");
    e = dlsym(NULL, buffer);
    if (!e) {
        *start = NULL;
        *end = NULL;
        return 2;
    }

    *start = s;
    *end = e;

    return 0;
}

int main()
{
    char *start, *end;
    int rc = get_symbol("data_txt", (void**) &start, (void**) &end);
    if (rc) {
        printf("ERROR %d\n\n", rc);
        return 1;
    }

    while(start < end) {
        putchar(*start);
        ++start;
    }
    return 0;
}
