; Shared final-life screen. X carries the reached game level from either engine.
GOSprite = $80
GOLevel = $E0
GOHeld = $E1
GOTune = $E2
GOSource = $E3
GORetryWanted = $E4
 ORG $1900
 RORG $F900
GOEntry
 lda $F5
 cmp #$58
 beq GOInitialize
 sta GOSource
 stx GOLevel
 lda #$58
 sta $F5
 lda #$A6
 jmp $FFEC
GOInitialize
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
 sei
 cld
 ldx #$FF
 txs
 lda #0
 ldx #95
GOClearRAM
 sta GOSprite,x
 dex
 bpl GOClearRAM
 ldx #$2C
GOClearTIA
 sta 0,x
 dex
 cpx #4
 bcs GOClearTIA
 lda #2
 sta VBLANK
 lda GOLevel
 cmp #1
 bcs GOLevelLowerOK
 lda #1
GOLevelLowerOK
 cmp #6
 bcc GOLevelOK
 lda #5
GOLevelOK
 sta GOLevel
 sec
 sbc #1
 asl
 asl
 asl
 tax
 ldy #0
GOCopyDigit
 lda GODigits,x
 sta GOSprite+59,y
 inx
 iny
 cpy #5
 bne GOCopyDigit
 ldx #7
GOCopyHat
 lda GOHat,x
 sta GOSprite+29,x
 dex
 bpl GOCopyHat
 lda #$57
 sta $F5
 lda #1
 sta GOHeld
 lda #64
 sta GOTune
 lda #0
 sta GORetryWanted
 jmp GOFrameInput
GOFrame
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
GOFrameInput
 lda SWCHB
 and #1
 beq GORetry
 lda INPT4
 bpl GOFire
 lda #0
 sta GOHeld
 beq GOInputReady
GOFire
 lda GOHeld
 bne GOInputReady
GORetry
 lda #1
 sta GORetryWanted
GOInputReady
 lda GOTune
 beq GOSilent
 dec GOTune
 lda GOTune
 lsr
 lsr
 lsr
 lsr
 tax
 lda GONotes,x
 sta AUDF0
 lda #4
 sta AUDC0
 sta AUDV0
 bne GOSoundReady
GOSilent
 sta AUDV0
GOSoundReady
 lda #72
 ldx #0
 jsr GOPosition
 lda #88
 ldx #1
 jsr GOPosition
 sta WSYNC
 sta HMOVE
 lda #0
 sta NUSIZ0
 sta NUSIZ1
 sta CTRLPF
 sta GRP0
 sta GRP1
 sta COLUBK
 lda #$84
 sta COLUP0
 lda #$0E
 sta COLUP1
GOWaitBlank
 lda INTIM
 bne GOWaitBlank
 sta WSYNC
 sta VBLANK
 ldy #0
GORows
 sta WSYNC
 lda GOColors,y
 sta COLUPF
 lda GOPF0L,y
 sta PF0
 lda GOPF1L,y
 sta PF1
 lda GOPF2L,y
 sta PF2
 nop
 lda GOPF0R,y
 sta PF0
 lda GOPF1R,y
 sta PF1
 lda GOPF2R,y
 sta PF2
 cpy #40
 bne GOPaletteReady
 lda #$1E
 sta COLUP0
GOPaletteReady
 sta WSYNC
 lda GOColors,y
 sta COLUPF
 lda GOPF0L,y
 sta PF0
 lda GOPF1L,y
 sta PF1
 lda GOPF2L,y
 sta PF2
 nop
 lda GOPF0R,y
 sta PF0
 lda GOPF1R,y
 sta PF1
 lda GOPF2R,y
 sta PF2
 iny
 lda GOSprite,y
 sta GRP0
 lda GOWand,y
 sta GRP1
 cpy #96
 bne GORows
 lda #2
 sta WSYNC
 sta VBLANK
 lda #0
 sta PF0
 sta PF1
 sta PF2
 sta GRP0
 sta GRP1
 ldx #30
GOOverscan
 sta WSYNC
 dex
 bne GOOverscan
 lda GORetryWanted
 bne GOStartAgain
 jmp GOFrame
GOStartAgain
 jmp $FFE6
GOPosition
 sta WSYNC
 sec
GOPositionLoop
 sbc #15
 bcs GOPositionLoop
 eor #7
 asl
 asl
 asl
 asl
 sta HMP0,x
 sta RESP0,x
 rts
GOHat
 .byte $10,$18,$18,$38,$3C,$7E,$FF,$00
GODigits
 .byte $10,$30,$10,$10,$38,0,0,0
 .byte $38,$08,$38,$20,$38,0,0,0
 .byte $38,$08,$38,$08,$38,0,0,0
 .byte $28,$28,$38,$08,$08,0,0,0
 .byte $38,$20,$38,$08,$38,0,0,0
GONotes
 .byte 27,20,15,10
 include "game-over-art.inc"
 echo "Game-over logic bank free bytes: ",($FF00-*)
