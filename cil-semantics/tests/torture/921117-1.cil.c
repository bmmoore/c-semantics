/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

#line 3 "921117-1.c"
struct s {
   char text[11] ;
   int flag ;
};
#line 8 "../../lib/includes/string.h"
extern int strcmp(char const   *str1 , char const   *str2 ) ;
#line 9
extern char *strcpy(char *s1 , char const   *s2 ) ;
#line 17 "../../lib/includes/stdlib.h"
extern void exit(int status ) ;
#line 21
extern void abort(void) ;
#line 3 "921117-1.c"
struct s cell  ;
#line 8 "921117-1.c"
int check(struct s p ) 
{ int tmp ;

  {
#line 11
  if (p.flag != 99) {
#line 12
    return (1);
  }
#line 13
  tmp = strcmp((char const   *)(p.text), "0123456789");
#line 13
  return (tmp);
}
}
#line 16 "921117-1.c"
int main(void) 
{ int tmp ;

  {
#line 18
  cell.flag = 99;
#line 19
  strcpy(cell.text, "0123456789");
#line 21
  tmp = check(cell);
#line 21
  if (tmp) {
#line 22
    abort();
  }
#line 23
  exit(0);
}
}
