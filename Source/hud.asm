; Steady two-row, three-column abbreviated status panel.
; Every label and number is drawn on every frame. No text multiplexing.
 MAC HUD_NUMBER
 ldx {2}
 lda HudNumberLow,x
 sta scorepointers+{1}
 lda HudNumberHigh,x
 sta scorepointers+{1}+1
 ENDM
 align 256
 ds 32,0
minikernel
 lda $F5
 cmp #$DA
 bne HudMainBegin
 ldx #14
HudSaveDragon
 lda $93,x
 sta $D7,x
 dex
 bpl HudSaveDragon
 lda D_tick
 jmp HudBegin
HudMainBegin
 lda tick
HudBegin
 and #0
 sta score+2
 lda $F5
 cmp #$DA
 beq HudBossTimer
 lda #36
 bne HudSetTimer
HudBossTimer
 lda #44
HudSetTimer
 sta TIM64T
 lda #0
 sta temp7
 sta PF0
 sta PF1
 sta PF2
 sta CTRLPF
 sta ENAM0
 sta ENAM1
 sta ENABL
 sta REFP0
 sta REFP1
 sta VDELP0
 sta VDELP1
 sta GRP0
 sta GRP1
 sta HMCLR
 lda #6
 sta NUSIZ0
 sta NUSIZ1
 lda score+2
 asl
 asl
 asl
 asl
 clc
 adc #32
 sta WSYNC
 sec
HudCoarse0
 sbc #15
 bcs HudCoarse0
 eor #7
 asl
 asl
 asl
 asl
 sta.w HMP0
 sta.w RESP0
 lda score+2
 asl
 asl
 asl
 asl
 clc
 adc #42
 sta WSYNC
 sec
HudCoarse1
 sbc #15
 bcs HudCoarse1
 eor #7
 asl
 asl
 asl
 asl
 sta.w HMP1
 sta.w RESP1
 sta WSYNC
 sta HMOVE
HudPrepareRow
 lda #0
 sta CTRLPF
 sta ENABL
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda temp7
 asl
 ora score+2
 asl
 tax
 lda HudRows,x
 sta score
 lda HudRows+1,x
 sta score+1
 ldy #11
HudCopyPointers
 lda (score),y
 sta scorepointers,y
 dey
 bpl HudCopyPointers
 lda $F5
 cmp #$DA
 beq HudBossValues
 lda temp7
 bne HudMainSecond
 lda hp
 sta score
 lda gold
 sta score+1
 lda lifeCount
 jmp HudValuesReady
HudMainSecond
 lda upgrades
 clc
 adc #1
 sta score
 lda armor
 sta score+1
 lda gameLevel
 jmp HudValuesReady
HudBossValues
 lda temp7
 bne HudBossSecond
 lda D_hp
 sta score
 lda $F2
 sta score+1
 lda D_lives
 jmp HudValuesReady
HudBossSecond
 lda D_wandTier
 sta score
 lda $D6
 sta score+1
 lda $D5
HudValuesReady
 sta stack1
 HUD_NUMBER 2,score
 HUD_NUMBER 6,score+1
 HUD_NUMBER 10,stack1
 ; Number pointers are complete. Reuse stack1 for the rightmost field color.
 lda #$1E
 ldx temp7
 beq HudColorReady
 lda $F5
 cmp #$DA
 beq HudBossColor
 ldx gameLevel
 bne HudColorLookup
HudBossColor
 ldx $D5
HudColorLookup
 lda HudLevelColors-1,x
HudColorReady
 sta stack1
 tsx
 stx score+1
 lda temp7
 beq HudFirstRow
 jmp HudSecondRow
HudFirstRow
 ldy #5
 lda (scorepointers+10),y
 sta score
 sta WSYNC
 sleep 65
 lda HudLabel0,y
 sta GRP0
 sta WSYNC
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel1,y
 lda HudLabel2,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #4
 lda (scorepointers+10),y
 sta score
 lda HudLabel0,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel1,y
 lda HudLabel2,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #3
 lda (scorepointers+10),y
 sta score
 lda HudLabel0,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel1,y
 lda HudLabel2,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #2
 lda (scorepointers+10),y
 sta score
 lda HudLabel0,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel1,y
 lda HudLabel2,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #1
 lda (scorepointers+10),y
 sta score
 lda HudLabel0,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel1,y
 lda HudLabel2,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 jmp HudRowDone
HudSecondRow
 ldy #5
 lda (scorepointers+10),y
 sta score
 sta WSYNC
 sleep 65
 lda HudLabel3,y
 sta GRP0
 sta WSYNC
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel4,y
 lda HudLabel5,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #4
 lda (scorepointers+10),y
 sta score
 lda HudLabel3,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel4,y
 lda HudLabel5,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #3
 lda (scorepointers+10),y
 sta score
 lda HudLabel3,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel4,y
 lda HudLabel5,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #2
 lda (scorepointers+10),y
 sta score
 lda HudLabel3,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel4,y
 lda HudLabel5,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 ldy #1
 lda (scorepointers+10),y
 sta score
 lda HudLabel3,y
 sta GRP0
 ; 76-cycle scanline. Keep the two left fields yellow; recolor the last.
 lda #$1E
 sta COLUP0
 sta COLUP1
 lda (scorepointers+2),y
 sta GRP1
 lax (scorepointers+6),y
 txs
 lax HudLabel4,y
 lda HudLabel5,y
 tay
 lda score
 stx GRP0
 tsx
 stx GRP1
 ldx stack1
 stx COLUP0
 sty GRP0
 stx COLUP1
 sta GRP1
 jmp HudRowDone
HudRowDone
 ldx score+1
 txs
 lda #0
 sta WSYNC
 sta GRP0
 sta GRP1
 inc temp7
 lda temp7
 cmp #2
 beq HudFinished
 jmp HudPrepareRow
HudFinished
 lda #0
 sta NUSIZ0
 sta NUSIZ1
 sta ENABL
 sta GRP1
 lda #1
 sta CTRLPF
 lda $F5
 cmp #$DA
 beq HudRestoreBoss
 lda oldx
 sta score+2
 jmp HudReturn
HudRestoreBoss
 ldx #14
HudRestoreDragon
 lda $D7,x
 sta $93,x
 dex
 bpl HudRestoreDragon
HudReturn
 lda INTIM
 bpl HudReturn
 sta WSYNC
 rts
HudLevelColors .byte $AE,$CA,$66,$3E,$46
HudRows
 .word HudRow0,HudRow0,HudRow1,HudRow1
 include "interface-font.asm"
