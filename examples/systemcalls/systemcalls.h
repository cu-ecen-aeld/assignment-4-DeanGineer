#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h>
//added to fix implicit declaration
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h> // For open and file control options 
#include <sys/wait.h> // For waitpid

bool do_system(const char *command);

bool do_exec(int count, ...);

bool do_exec_redirect(const char *outputfile, int count, ...);
