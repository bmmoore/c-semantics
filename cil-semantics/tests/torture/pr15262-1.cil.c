/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

#line 6 "../../lib/includes/stddef.h"
typedef unsigned long size_t;
#line 10 "pr15262-1.c"
struct A {
   int t ;
   int i ;
};
#line 13 "../../lib/includes/stdlib.h"
extern void *malloc(size_t size ) ;
#line 21
extern void abort(void) ;
#line 16 "pr15262-1.c"
int foo(void) 
{ 

  {
#line 16
  return (3);
}
}
#line 18 "pr15262-1.c"
int main(void) 
{ struct A *locp ;
  float f ;
  float g ;
  float *p ;
  int T355 ;
  int *T356 ;
  int tmp___0 ;
  void *tmp___1 ;

  {
#line 26
  f = (float )3;
#line 27
  g = (float )2;
#line 28
  tmp___0 = foo();
#line 28
  if (tmp___0) {
#line 28
    p = & g;
  } else {
#line 28
    p = & f;
  }
#line 29
  if ((double )*p > 0.0) {
#line 30
    g = (float )1;
  }
#line 33
  tmp___1 = malloc(sizeof(*locp));
#line 33
  locp = (struct A *)tmp___1;
#line 34
  locp->i = 10;
#line 35
  T355 = locp->i;
#line 38
  T356 = & locp->i;
#line 39
  *T356 = 1;
#line 43
  T355 = locp->i;
#line 44
  if (T355 != 1) {
#line 45
    abort();
  }
#line 47
  return (0);
}
}
