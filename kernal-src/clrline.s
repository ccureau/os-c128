clrscr:
    ldy CURR_LEFT_MARGIN      ; leftmost column of current line
    jsr unlink
    jsr setaddr
    bit ACTIVE_SCREEN         ; bit 7 high ? 80 col : 40 col
    bmi clrscr_80
    dey
clrscr_40:
    iny
    lda #$20
    sta (LINE_PTR_LOW),Y      ; memory ptr to first column in current line
    lda $F1
    sta (ATTR_PTR_LOW),Y      ; memory ptr to first attribute col in current line
    cpy CURR_RIGHT_MARGIN
    bne clrscr_40
    rts
clrscr_80:
    stx CURR_ROW_NUMBER
    sty CURR_COL_NUMBER
    ldx #$18                  ; Smooth scroll/block copy register
    jsr readreg
    and #$7F                  ; Turn off block copy
    jsr writereg
    ldx #$12
    clc
    tya
    adc LINE_PTR_LOW
    pha
    sta VDC_WORK_PTR_LOW
    lda #$00
    adc $E1
    sta VDC_WORK_PTR_HIGH
    jsr writereg
    inx
    pla
    jsr writereg
    lda #$20
    jsr write80
    sec
    lda CURR_RIGHT_MARGIN
    sbc CURR_COL_NUMBER
    pha
    beq LC50B
    tax
    sec
    adc VDC_WORK_PTR_LOW
    sta VDC_WORK_PTR_LOW
    lda #$00
    adc VDC_WORK_PTR_HIGH
    sta VDC_WORK_PTR_HIGH
    txa
    jsr LC53E
LC50B:
    ldx #$12
    clc
    tya
    adc ATTR_PTR_LOW
    pha
    lda #$00
    adc $E3
    jsr writereg
    inx
    pla
    jsr writereg
    lda VDC_WORK_PTR_HIGH
    and #$07
    ora VDC_ATTRIBUTE_START_PAGE
    sta VDC_WORK_PTR_HIGH
    lda $F1
    and #$8F
    jsr write80
    pla
    beq LC536
    jsr LC53E
LC536:
    ldx CURR_ROW_NUMBER
    ldy CURR_RIGHT_MARGIN
    rts
