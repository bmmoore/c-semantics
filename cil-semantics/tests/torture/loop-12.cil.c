/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

char *p  ;
static int __attribute__((__pure__))  is_end_of_statement(void) 
{ int tmp ;

  {
  if ((int )*p == 10) {
    tmp = 1;
  } else {
    if ((int )*p == 59) {
      tmp = 1;
    } else {
      if ((int )*p == 33) {
        tmp = 1;
      } else {
        tmp = 0;
      }
    }
  }
  return ((int __attribute__((__pure__))  )tmp);
}
}
void foo(void) 
{ int __attribute__((__pure__))  tmp ;

  {
  while (1) {
    tmp = is_end_of_statement();
    if (tmp) {
      break;
    }
    p ++;
  }
  return;
}
}
int main(void) 
{ 

  {
  p = (char *)"abc\n";
  foo();
  return (0);
}
}