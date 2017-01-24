    .export    _vdc_write_memory, _vdc_write_reg, _vdc_read_memory, _vdc_read_reg
    .export    _vdc_clear_screen, _vdc_set_cursor
    .export    _vdc_cursor_pos, _vdc_attrib_pos
    .import    popa, pusha, popax
    .importzp  tmp2, tmp3

; definitions
.define   VDC_CONTROL       $D600
.define   VDC_DATA          $D601

.define   VDC_REG_CURSHIGH    $0E
.define   VDC_REG_CURSLOW     $0F
.define   VDC_REG_MEMHIGH     $12
.define   VDC_REG_MEMLOW      $13

.define	  VDC_MEM_RW        $1F

; zero page variables
.segment	"BSS"
vdc_tmp:
  .res 2
_vdc_cursor_pos:
  .res 2
_vdc_attrib_pos:
  .res 2


; code
.segment	"CODE"

_vdc_set_cursor:
    lda   #VDC_REG_CURSHIGH
    jsr   pusha
    lda   _vdc_cursor_pos+1
    jsr   _vdc_write_reg
    lda   #VDC_REG_CURSLOW
    jsr   pusha
    lda   _vdc_cursor_pos
    jsr   _vdc_write_reg
    rts

_vdc_clear_screen:
    lda   #$00
    sta   vdc_tmp
    sta   vdc_tmp+1
    lda   #$20
    sta   tmp2
    lda   #$08
    sta   tmp3
    jsr   vdc_clear_loop

    lda   #$00
    sta   vdc_tmp
    lda   #$08
    sta   vdc_tmp+1
    lda   #$87              ; attribute
    sta   tmp2
    lda   #$08
    sta   tmp3
    jsr   vdc_clear_loop

    rts

vdc_clear_loop:
    lda   #$12
    jsr   pusha
    lda   vdc_tmp+1
    jsr   _vdc_write_reg

    lda   #$13
    jsr   pusha
    lda   vdc_tmp
    jsr   _vdc_write_reg

    lda   tmp2
    jsr   _vdc_write_memory

    lda   #$18
    jsr   pusha
    jsr   _vdc_read_reg
    and   #$7F
    jsr   _vdc_write_reg

    lda   #$1E
    jsr   pusha
    lda   #$FE
    jsr   _vdc_write_reg

    lda   #$12
    jsr   _vdc_read_reg
    sta   vdc_tmp+1

    lda   #$13
    jsr   _vdc_read_reg
    sta   vdc_tmp

    dec   tmp3
    bne   vdc_clear_loop

    rts

_vdc_write_reg:
    jsr   pusha
    jsr   popax
    jmp   vdc_writer

_vdc_write_memory:
    ldx   #VDC_MEM_RW

vdc_writer:
    stx   VDC_CONTROL
l1:
    bit   VDC_CONTROL
    bpl   l1
    sta   VDC_DATA
    rts

_vdc_read_reg:
    tax
    jmp   vdc_reader

_vdc_read_memory:
    ldx    #VDC_MEM_RW

vdc_reader:
    stx    VDC_CONTROL
l2:
    bit    VDC_CONTROL
    bpl    l2
    lda    VDC_DATA
    rts
