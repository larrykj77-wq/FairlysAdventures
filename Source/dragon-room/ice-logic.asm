; Level-five phase 5: an eight-pixel-wide wall with one twelve-row gap.
; chestFlags is free until victory; nextDifficulty bit 7 is the frozen flag.
LogicIceCycle
 lda tick
 and #3
 bne LogicIceCycleDone
 dec chestFlags
 lda chestFlags
 cmp #24
 bcs LogicIceCycleDone
 lda #0
 sta chestFlags
 jmp LogicStartFireWarning
LogicIceCycleDone
 rts

LogicIceDamage
 lda phase
 cmp #5
 bne LogicIceNoHit
 lda nextDifficulty
 bmi LogicIceNoHit
 lda grace
 bne LogicIceNoHit
 lda heroX
 sec
 sbc chestFlags
 clc
 adc #7
 cmp #15
 bcs LogicIceNoHit
 ; The gap is fixed for this sweep; the whole wizard must fit inside it.
 lda heroY
 ldy lane
 sec
 sbc IceGapStart,y
 cmp #5
 bcc LogicIceNoHit
LogicIceHit
 lda #$80
 sta nextDifficulty
 lda #0
 sta boltActive
 lda #1
 sta held
 jmp LogicHurt
LogicIceNoHit
 rts

; Three equally likely heights, chosen anew for each ice sweep.
IceGapStart .byte 22,38,54
IceMaskLow .byte <IceUpperRows,<IceRows,<IceLowerRows
IceMaskHigh .byte >IceUpperRows,>IceRows,>IceLowerRows
