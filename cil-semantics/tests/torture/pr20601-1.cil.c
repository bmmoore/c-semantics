/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

struct T {
   char *t1 ;
   char t2[4096] ;
   char **t3 ;
};
extern void abort(void) ;
extern void exit(int  ) ;
int a[5]  ;
int b  ;
char **c  ;
int d  ;
char **e  ;
struct T t  ;
char *f[16]  ;
char *g[4]  = {      (char *)"a",      (char *)"-u",      (char *)"b",      (char *)"c"};
 __attribute__((__noreturn__)) void foo(void) ;
void foo(void) 
{ 

  {
  while (1) {

  }
}
}
char *( __attribute__((__noinline__)) bar)(char *x , unsigned int y ) 
{ 

  {
  return ((char *)0);
}
}
__inline static char *baz(char *x , unsigned int y ) 
{ char *tmp ;

  {
  if (sizeof(t.t2) != 4294967295UL) {
    if ((unsigned long )y > sizeof(t.t2)) {
      foo();
    }
  }
  tmp = bar(x, y);
  return (tmp);
}
}
__inline static int setup1(int x ) 
{ char *tmp ;
  char **h ;
  char **i ;
  char *tmp___0 ;

  {
  tmp = baz(t.t2, (unsigned int )sizeof(t.t2));
  if (! tmp) {
    baz(t.t2, (unsigned int )sizeof(t.t2));
  }
  if (x & 512) {
    i = e;
    d ++;
    e = f;
    if (t.t1) {
      if (*(t.t1)) {
        *(e + 0) = t.t1;
      } else {
        abort();
      }
    } else {
      abort();
    }
    h = e + 1;
    while (1) {
      tmp___0 = *i;
      *h = tmp___0;
      if (! tmp___0) {
        break;
      }
      i ++;
      h ++;
    }
  }
  return (1);
}
}
__inline static int setup2(void) 
{ int j ;

  {
  j = 1;
  e = c + 1;
  d = b - 1;
  while (1) {
    if (d > 0) {
      if (! ((int )*(*(e + 0) + 0) == 45)) {
        break;
      }
    } else {
      break;
    }
    if ((int )*(*(e + 0) + 1) != 0) {
      if ((int )*(*(e + 0) + 2) != 0) {
        abort();
      }
    }
    switch ((int )*(*(e + 0) + 1)) {
    case 117: 
    if (! *(e + 1)) {
      abort();
    }
    t.t3 = e + 1;
    d --;
    e ++;
    break;
    case 80: 
    j |= 4096;
    break;
    case 45: 
    d --;
    e ++;
    if (j == 1) {
      j |= 1536;
    }
    return (j);
    }
    d --;
    e ++;
  }
  if (d > 0) {
    if (! (j & 1)) {
      abort();
    }
  }
  return (j);
}
}
int main(void) 
{ int x ;

  {
  c = g;
  b = 4;
  x = setup2();
  t.t1 = (char *)"/bin/sh";
  setup1(x);
  if (x & 1024) {
    if (! a[4]) {
      abort();
    }
  }
  exit(0);
}
}