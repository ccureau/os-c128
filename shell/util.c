/*
 * utility functions for shell
 */

int match_any(int c, char *matches)
{
  char *s;

  while (*s) {
    if (*s++ == c) {
      return(1);
    }
  }
  return(0);
}
