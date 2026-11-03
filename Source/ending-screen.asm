; Victory vault: autonomous walk and original looping two-voice celebration.
EndingX = $80
EndingTick = $81
EndingNote = $82
EndingPose = $84
 ORG $FB40
EndingEntry
 sei
 cld
 ldx #$FF
 txs
 lda #0
 ldx #$7F
EndingClearRAM
 sta $80,x
 dex
 bpl EndingClearRAM
 ldx #$2C
EndingClearTIA
 sta 0,x
 dex
 bpl EndingClearTIA
 lda #$56
 sta $F5
 lda #20
 sta EndingX
 lda #7
 sta EndingTick
EndingFrame
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
 lda SWCHB
 and #1
 bne EndingContinue
 jmp $FFB4
EndingContinue
 inc EndingTick
 lda EndingTick
 and #1
 bne EndingNoStep
 lda EndingX
 cmp #72
 bcs EndingNoStep
 inc EndingX
EndingNoStep
 lda EndingTick
 and #7
 bne EndingMusicReady
 inc EndingNote
 lda EndingNote
 and #15
 sta EndingNote
EndingMusicReady
 ldx EndingNote
 lda EndingMelody,x
 sta AUDF0
 txa
 lsr
 lsr
 tax
 lda EndingBass,x
 sta AUDF1
 lda #4
 sta AUDC0
 sta AUDV0
 lda #6
 sta AUDC1
 lda #2
 sta AUDV1
 lda #<EndingHeroA
 ldx #>EndingHeroA
 ldy EndingX
 cpy #72
 bcs EndingPoseReady
 ldy EndingTick
 tya
 and #16
 beq EndingFirstPose
 lda #<EndingHeroB
 ldx #>EndingHeroB
 bne EndingPoseReady
EndingFirstPose
 lda #<EndingHeroA
EndingPoseReady
 sta EndingPose
 stx EndingPose+1
 lda EndingX
 ldx #0
 jsr TitlePosition
 sta WSYNC
 sta HMOVE
 lda #1
 sta CTRLPF
 lda #0
 sta NUSIZ0
 sta GRP0
 sta GRP1
 sta PF0
 sta PF1
 sta PF2
 sta COLUBK
 lda #8
 sta COLUPF
EndingWaitBlank
 lda INTIM
 bne EndingWaitBlank
 sta WSYNC
 sta VBLANK
 ldx #16
EndingTopBlank
 sta WSYNC
 dex
 bne EndingTopBlank
 ldy #0
EndingRows
 sta WSYNC
 lda EndingPF0,y
 sta PF0
 lda EndingPF1,y
 sta PF1
 lda EndingPF2,y
 sta PF2
 lda EndingColors,y
 nop
 sta COLUPF
 lda #$C0
 sta PF0
 lda #8
 bit EndingTick
 REPEAT 12
 nop
 REPEND
 sta COLUPF
 sta WSYNC
 lda EndingPF0,y
 sta PF0
 lda EndingPF1,y
 sta PF1
 lda EndingPF2,y
 sta PF2
 lda EndingColors,y
 nop
 sta COLUPF
 lda #$C0
 sta PF0
 iny
 bit EndingTick
 nop
 nop
 lda (EndingPose),y
 sta GRP0
 lda EndingInk,y
 sta COLUP0
 lda #8
 bit EndingTick
 sta COLUPF
 cpy #80
 bne EndingRows
 lda #0
 sta GRP0
 sta PF0
 sta PF1
 sta PF2
 ldx #16
EndingBottomBlank
 sta WSYNC
 dex
 bne EndingBottomBlank
 lda #2
 sta VBLANK
 ldx #30
EndingOverscan
 sta WSYNC
 dex
 bne EndingOverscan
 jmp EndingFrame
 include "ending-art.inc"
EndingMelody
 .byte 31,24,20,15,20,24,31,20,27,23,18,13,18,23,15,31
EndingBass
 .byte 31,24,27,23
 echo "Ending bank free bytes: ",($FFB4-*)
