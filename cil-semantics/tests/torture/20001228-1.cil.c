/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

union __anonunion_u_21 {
   char a[sizeof(unsigned int )] ;
   unsigned int b ;
};
union __anonunion_u_22 {
   char a[sizeof(unsigned int )] ;
   unsigned int b ;
};
extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void exit(int __status )  __attribute__((__leaf__)) ;
int foo1(void) 
{ union __anonunion_u_21 u ;

  {
  u.b = 1U;
  return ((int )u.a[0]);
}
}
int foo2(void) 
{ union __anonunion_u_22  volatile  u ;

  {
  u.b = (unsigned int volatile   )1;
  return ((int )u.a[0]);
}
}
int main(void) 
{ int tmp ;
  int tmp___0 ;

  {
  tmp = foo1();
  tmp___0 = foo2();
  if (tmp != tmp___0) {
    abort();
  }
  exit(0);
}
}