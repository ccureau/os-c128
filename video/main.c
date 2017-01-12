void vdc_write_memory(unsigned char c);
void vdc_write_reg(unsigned char reg, unsigned char val);
unsigned char vdc_read_memory();
unsigned char vdc_read_reg(unsigned char reg);
void setup(void);

/* TODO: screen characters are different than petscii characters.
 * Clear bit 6 for regular characters, bit 5 for above 127.
 * other processing for escaped characters
 * Also update attribute mapping!
 */
char * strout(char *s1){
  unsigned char *ptr = s1;
  while (*ptr != '\0') {
    vdc_write_memory(*(ptr++) & 0x3f);
  }
}

unsigned char main() {
    vdc_write_reg(0x12, 0x00);
    vdc_write_reg(0x13, 0x00);

    strout("hi there!");
    return 0;
}
