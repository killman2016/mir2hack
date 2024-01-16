/*
 * Simple Test program for exe file generation using libtcc
 *
 * libtcc can be useful to use tcc as a "backend" for a code generator.
 *   - Compiling with TCC:
 *       tcc -o libtcc_compile_test.exe examples/libtcc_compile_test.c -I libtcc libtcc/libtcc.def
 *       libtcc_compile_test -> test.exe
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "libtcc.h"

void handle_error(void *opaque, const char *msg)
{
    fprintf(opaque, "%s\n", msg);
}

/* this function is called by the generated code */
int add(int a, int b)
{
    return a + b;
}

/* this strinc is referenced by the generated code */
const char hello[] = "Hello World!";

char my_program[] =
"#include <stdio.h> \n"
"int add(int a, int b) \n"
" { return a+b;} \n"
"int fib(int n) \n"
"{\n"
"    if (n <= 2)\n"
"        return 1;\n"
"    else\n"
"        return fib(n-1) + fib(n-2);\n"
"}\n"
"\n"
"int foo(int n)\n"
"{\n"
"    printf(\"%s\\n\", \"hello\");\n"
"    printf(\"fib(%d) = %d\\n\", n, fib(n));\n"
"    printf(\"add(%d, %d) = %d\\n\", n, 2 * n, add(n, 2 * n));\n"
"    return 0;\n"
"}\n"
"int main(int argc, char** argv) \n"
"{ \n"
"  printf(\"a test!\\n\"); return 0; \n"
"} \n";

int main(int argc, char **argv)
{
    TCCState *s;
    int i;
    int (*func)(int);

    s = tcc_new();
    if (!s) {
        fprintf(stderr, "Could not create tcc state\n");
        exit(1);
    }

    assert(tcc_get_error_func(s) == NULL);
    assert(tcc_get_error_opaque(s) == NULL);

    tcc_set_error_func(s, stderr, handle_error);

    assert(tcc_get_error_func(s) == handle_error);
    assert(tcc_get_error_opaque(s) == stderr);

    /* if tcclib.h and libtcc1.a are not installed, where can we find them */
    for (i = 1; i < argc; ++i) {
        char *a = argv[i];
        if (a[0] == '-') {
            if (a[1] == 'B')
                tcc_set_lib_path(s, a+2);
            else if (a[1] == 'I')
                tcc_add_include_path(s, a+2);
            else if (a[1] == 'L')
                tcc_add_library_path(s, a+2);
        }
    }

    /* MUST BE CALLED before any compilation */
    tcc_set_output_type(s, TCC_OUTPUT_EXE);

    if (tcc_compile_string(s, my_program) == -1) {
		printf("compilation error!\n");
		return 1;
	}

    /* as a test, we add symbols that the compiled program can use.
       You may also open a dll with tcc_add_dll() and use symbols from that */
    
	//tcc_add_symbol(s, "add", add);
    //tcc_add_symbol(s, "hello", hello);

    /* relocate the code */
    //if (tcc_relocate(s, TCC_RELOCATE_AUTO) < 0)
    //    return 1;

    /* get entry symbol */
    // func = tcc_get_symbol(s, "foo");
    // if (!func)
    //    return 1;

    /* run the code */
    // func(32);
	
	tcc_output_file(s,"test.exe");
	
    /* delete the state */
    tcc_delete(s);

    return 0;
}
