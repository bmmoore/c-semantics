#include <stdio.h>
#include <stdarg.h>

int sum(int s0, ...)
{
  va_list args;
  int s = s0, n;

  va_start(args, s0);
  while (n = va_arg(args, int))
    s += n;
  va_end(args);

  return s;
}

int main(int argc, char **argv)
{
  int x = sum(4, 3, 32, 22, 0);
  printf("hello world %d\n", x);
  return 0;
}
