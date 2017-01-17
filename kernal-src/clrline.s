clrscr:
    ldy $E6
    jsr unlink
    jsr setaddr
    bit $D7
    bmi clrscr_80
    dey
clrscr_40:
    iny
    lda #$20
    sta ($E0),Y
    lda $F1
    sta ($E2),Y
    cpy $E7
    bne clrscr_40
    rts
clrscr_80:
    stx $0A31
    sty $0A32
    ldx #$18
    jsr readreg
    and #$7F
    jsr writereg
    ldx #$12
    clc
    tya
    adc $E0
    pha
    sta $0A3C
    lda #$00
    adc $E1
    sta $0A3D
    jsr writereg
    inx
    pla
    jsr writereg
    lda #$20
    jsr write80
    sec
    lda $E7
    sbc $0A32
    pha
    beq LC50B
    tax
    sec
    adc $0A3C
    sta $0A3C
    lda #$00
    adc $0A3D
    sta $0A3D
    txa
    jsr LC53E
LC50B:
    ldx #$12
    clc
    tya
    adc $E2
    pha
    lda #$00
    adc $E3
    jsr writereg
    inx
    pla
    jsr writereg
    lda $0A3D
    and #$07
    ora $0A2F
    sta $0A3D
    lda $F1
    and #$8F
    jsr write80
    pla
    beq LC536
    jsr LC53E
LC536:
    ldx $0A31
    ldy $E7
    rts
