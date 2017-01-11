; kernal PRINT routine, assembled at $C72D

      sta   $EF     ; store current keypress in temp space

      pha           ; preserve a, x, y
      txa
      pha
      tya
      pha

l1:   lda   $0A21   ; Check pause flag. 0 = continue, else loop
      bne   l1

      sta   $D6     ; Set input source flag to 0 (keyboard)

      lda   #$C3    ; Store $C30B on stack for later RTS call
      pha           ; (This is the common exit routine)
      lda   #$0B
      pha

      ldy   $EC     ; ?
      lda   $EF     ; grab current keypress

      cmp   #$0D    ; if CR or Shift-CR, go to return handler
      beq   DoCR
      cmp   #$8D
      beq   DoCR

      tax           ; Character codes >127 go to handling routine
      bpl   l2
      jmp   $C802

l2:   cmp   #$20    ; Character codes 0<x<32 go to handling routine
      bcc   $C7B6

      cmp   #$60    ; Characters 32<x<96 get bit 6 cleared
      bcc   l3

      and   #$DF    ; Character codes 96<x<127 get bit 5 cleared

      ; BEWARE - HERE BE DRAGONS!
      ; These lines change depending on the entry point.
      ; opcodes are:
      ; C766  2C
      ; C767  29
      ; C768  3F
      ; Dropping through to $C766

      bit   $3F29   ; effectivey a NOP

      ; or...jmp from l3 above ($C767)

l3:   and   #$3F    ; Continue clearing bit 6 from above

      ; end BIT skip

      jsr   $C2FF   ; " processing routine
      jmp   $C322   ; Display character to screen

DoCR:
