    .export    _vdc_write_memory, _vdc_write_reg, _vdc_read_memory, _vdc_read_reg
    .import    popa, pusha, popax
    .importzp  tmp3

.define  VDC_CONTROL    $D600
.define  VDC_DATA       $D601

.define	 VDC_MEM_RW     $1F

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
    jsr   pusha
    jsr   popax
    jmp   vdc_reader

_vdc_read_memory:
    ldx    #VDC_MEM_RW

vdc_reader:
    stx    VDC_CONTROL
l2:
    bit    VDC_CONTROL
    bpl    l2
    lda    VDC_DATA
    jsr pusha
    rts
