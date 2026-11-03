; Dedicated title kernel in free space in the existing dragon handoff bank.
TitleTick = $80
TitleSpark = $81
TitleHeld = $82
TitleSparkOn = $83
 ORG $F200
TitleEntry
 sei
 cld
 ldx #$FF
 txs
 lda #0
 ldx #$7F
TitleClearRAM
 sta $80,x
 dex
 bpl TitleClearRAM
 ldx #$2C
TitleClearTIA
 sta 0,x
 dex
 bpl TitleClearTIA
 lda #$54
 sta $F5
 lda #1
 sta TitleHeld
TitleFrame
 lda #2
 sta VBLANK
 sta VSYNC
 sta WSYNC
 sta WSYNC
 sta WSYNC
 lda #0
 sta VSYNC
 lda #43
 sta TIM64T
 inc TitleTick
 lda INPT4
 bpl TitlePressed
 lda #0
 sta TitleHeld
 beq TitleContinue
TitlePressed
 lda TitleHeld
 bne TitleContinue
 jmp $FFE6
TitleContinue
 lda TitleTick
 and #127
 cmp #48
 bcs TitleNoSpark
 clc
 adc #64
 sta TitleSpark
 lda #2
 bne TitleSparkReady
TitleNoSpark
 lda #0
TitleSparkReady
 sta TitleSparkOn
 lda #48
 ldx #0
 jsr TitlePosition
 lda #104
 ldx #1
 jsr TitlePosition
 lda TitleSpark
 ldx #2
 jsr TitlePosition
 sta WSYNC
 sta HMOVE
 lda #$15
 sta NUSIZ0
 lda #5
 sta NUSIZ1
 lda #0
 sta CTRLPF
 sta GRP0
 sta GRP1
 sta ENAM0
 sta COLUBK
 lda #$0E
 sta COLUP1
TitleWaitBlank
 lda INTIM
 bne TitleWaitBlank
 sta WSYNC
 sta VBLANK
 ldy #0
TitleTop
 jsr TitlePFRow
 iny
 cpy #104
 bne TitleTop
 lda #1
 sta CTRLPF
 lda #$08
 sta COLUPF
 lda #$10
 sta PF0
 lda #0
 sta PF1
 sta PF2
 ldx #0
TitleCharacters
 sta WSYNC
 lda TitleTick
 and #16
 beq TitleHeroFirst
 lda TitleHeroB,x
 jmp TitleHeroReady
TitleHeroFirst
 lda TitleHeroA,x
TitleHeroReady
 sta GRP0
 lda TitleHeroInk,x
 sta COLUP0
 lda TitleSkeleton,x
 sta GRP1
 txa
 and #30
 cmp #16
 bne TitleSparkOff
 lda TitleSparkOn
 bne TitleSparkDraw
TitleSparkOff
 lda #0
TitleSparkDraw
 sta ENAM0
 inx
 cpx #32
 bne TitleCharacters
 lda #0
 sta GRP0
 sta GRP1
 sta ENAM0
 sta CTRLPF
 ldy #136
TitleBottom
 jsr TitlePFRow
 iny
 cpy #192
 bne TitleBottom
 lda #2
 sta WSYNC
 sta VBLANK
 lda #0
 sta PF0
 sta PF1
 sta PF2
 ldx #29
TitleOverscan
 sta WSYNC
 dex
 bne TitleOverscan
 jmp TitleFrame

TitlePosition
 sta WSYNC
 sec
TitlePositionLoop
 sbc #15
 bcs TitlePositionLoop
 eor #7
 asl
 asl
 asl
 asl
 sta HMP0,x
 sta RESP0,x
 rts

TitlePFRow
 sta WSYNC
 lda TitleColors,y
 sta COLUPF
 lda TitlePF0L,y
 sta PF0
 lda TitlePF1L,y
 sta PF1
 lda TitlePF2L,y
 sta PF2
 nop
 lda TitlePF0R,y
 sta PF0
 lda TitlePF1R,y
 sta PF1
 lda TitlePF2R,y
 sta PF2
 rts
 include "title-art.inc"
 echo "Title bank free bytes: ",($FFB4-*)
