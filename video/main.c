#define LOWBYTE(v)   ((unsigned char) (v))
#define HIGHBYTE(v)  ((unsigned char) (((unsigned int) (v)) >> 8))

void vdc_write_memory(unsigned char c);
void vdc_write_reg(unsigned char reg, unsigned char val);
void vdc_clear_screen();
unsigned char vdc_read_memory();
unsigned char vdc_read_reg(unsigned char reg);
void vdc_set_cursor();
void setup(void);

extern unsigned int vdc_cursor_pos;
extern unsigned int vdc_attrib_pos;

/* TODO: screen characters are different than petscii characters.
 * Clear bit 6 for regular characters, bit 5 for above 127.
 * other processing for escaped characters
 * Also update attribute mapping!
 */
void strout(char *s1){
  unsigned char *ptr = s1;
  while (*ptr != '\0') {
    vdc_write_memory(*(ptr++) & 0x3f);
    ++vdc_cursor_pos;
    ++vdc_attrib_pos;
    vdc_set_cursor();
  }
}

unsigned int calc_mem_pos(unsigned char row, unsigned char col) {
  return (row*80)+col;
}

void vdc_gotoxy(unsigned char row, unsigned char col) {
  unsigned int pos = calc_mem_pos(row, col);
  vdc_cursor_pos = pos;
  vdc_attrib_pos = pos + 0x800;
  vdc_write_reg(0x12, HIGHBYTE(vdc_cursor_pos));
  vdc_write_reg(0x13, LOWBYTE(vdc_cursor_pos));
}

unsigned char main() {
    vdc_clear_screen();
    //vdc_write_reg(0x12, 0x00);
    //vdc_write_reg(0x13, 0x00);

    vdc_gotoxy(15,10);
    strout("hi there!");
    while(1) {}
}
