; Original custom vendor-room raster. 167 physical scanlines, 60 Hz.
; The playfield supplies two stationary chests and their WP/AR labels.
; Both player objects remain available for Wiz and the centered merchant.
ShopArena
 MAIN_FEEDBACK 0
 lda player0y
 sta oldy
 lda player1y
 sta temp3
 lda missile0y
 sta temp5
 lda missile1y
 sta temp6
 lda bally
 sta stack2
 lda tick
 and #8
 beq ShopHeroFrameA
 lda #<(ShopHeroB-89)
 sta scorepointers
 lda #>(ShopHeroB-89)
 bne ShopHeroFrameReady
ShopHeroFrameA
 lda #<(ShopHeroA-89)
 sta scorepointers
 lda #>(ShopHeroA-89)
ShopHeroFrameReady
 sta scorepointers+1
 lda #10
 sec
 sbc playfieldpos
 sta playfieldpos
 ldx player0y
 lda ShopTopByY,x
 sta oldx
 lda scorepointers
 sec
 sbc oldx
 sta scorepointers
 lda scorepointers+1
 sbc #0
 sta scorepointers+1
 lda #<(ShopHeroColors-89)
 sec
 sbc oldx
 sta scorepointers+2
 lda #>(ShopHeroColors-89)
 sbc #0
 sta scorepointers+3
 ; Merchant is the same recognizable wizard silhouette, in a warm palette.
 lda #<(ShopHeroA-89-75)
 sta scorepointers+4
 lda #>(ShopHeroA-89-75)
 sta scorepointers+5
 lda #<(ShopVendorColors-89-75)
 ldx #>(ShopVendorColors-89-75)
 ldy phase
 beq ShopVendorPaletteReady
 ldy navDir
 cpy #5
 beq ShopVendorSuccess
 cpy #6
 bcc ShopVendorPaletteReady
 lda #<(ShopFailureColors-89-75)
 ldx #>(ShopFailureColors-89-75)
 bne ShopVendorPaletteReady
ShopVendorSuccess
 lda #<(ShopSuccessColors-89-75)
 ldx #>(ShopSuccessColors-89-75)
ShopVendorPaletteReady
 sta scorepointers+6
 stx scorepointers+7
 lda #0
 sta VDELP0
 sta VDELP1
 sta VDELBL
 sta NUSIZ0
 sta NUSIZ1
 sta GRP0
 sta GRP1
 sta ENAM0
 sta ENAM1
 sta ENABL
 sta PF0
 lda #1
 sta CTRLPF
 lda #$06
 sta COLUPF
ShopWaitBlank
 lda INTIM
 bmi ShopWaitBlank
 sta WSYNC
 lda #0
 sta VBLANK
 ldy #89
 lda ShopPF1L,y
 ldx ShopPF2L,y
 jmp ShopRaster
 align 128
ShopRaster
 sta WSYNC
 sta PF1
 stx PF2
 lda (scorepointers),y
 sta GRP0
 lda (scorepointers+2),y
 sta COLUP0
 lda (scorepointers+4),y
 sta GRP1
 lda (scorepointers+6),y
 sta COLUP1
 sleep 4
 lda ShopPF2R,y
 sta PF2
 lda ShopPF1R,y
 sta PF1
 lda ShopPF1L+1,y
 ldx ShopPF2L+1,y
 iny
 bne ShopRaster
 lda #0
 sta WSYNC
 sta GRP0
 sta GRP1
 sta PF1
 sta PF2
 lda oldy
 sta temp2
 jmp BS_return
 align 256
ShopPF1L
 ds 89,0
 .byte $FF,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$3F,$3F,$21,$3F,$20,$20
 .byte $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2E,$2E,$2E,$2A,$2A,$2A,$20
 .byte $20,$3F,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$00,$C0,$FF,$FF
 align 256
ShopPF2L
 ds 89,0
 .byte $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$1F,$1F,$10,$1F,$10,$10
 .byte $13,$13,$13,$15,$15,$15,$13,$13,$13,$11,$11,$11,$11,$11,$11,$10
 .byte $10,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$FF,$FF
 align 256
ShopPF2R
 ds 89,0
 .byte $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$1F,$1F,$10,$1F,$10,$10
 .byte $12,$12,$12,$15,$15,$15,$17,$17,$17,$15,$15,$15,$15,$15,$15,$10
 .byte $10,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$FF,$FF
 align 256
ShopPF1R
 ds 89,0
 .byte $FF,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$3F,$3F,$21,$3F,$20,$20
 .byte $26,$26,$26,$2A,$2A,$2A,$26,$26,$26,$2A,$2A,$2A,$2A,$2A,$2A,$20
 .byte $20,$3F,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$00,$C0,$FF,$FF
 ds 174,0
ShopHeroA
 .byte $10,$10,$3C,$3C,$18,$18,$3B,$3B,$39,$39,$7E,$7E,$3C,$3C,$66,$66
 ds 174,0
 ds 174,0
ShopHeroB
 .byte $10,$10,$3C,$3C,$18,$18,$3B,$3B,$39,$39,$3E,$3E,$7C,$7C,$24,$24
 ds 174,0
ShopHeroColors
 .byte $84,$84,$86,$86,$3E,$3E,$3E,$3E,$8A,$8A,$88,$88,$86,$86,$F4,$F4
ShopVendorColors
 .byte $1C,$1C,$1E,$1E,$3E,$3E,$3E,$3E,$4A,$4A,$48,$48,$46,$46,$26,$26
ShopSuccessColors
 .byte $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
ShopFailureColors
 .byte $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
ShopTopByY
 .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byte 0,1,3,5,7,9,11,13,15,17,19,21,23,25,27
 .byte 29,31,33,35,37,39,41,43,45,47,49,51,53,55,57
 .byte 59,61,63,65,67,69,71,73,75,77,79,81,83,85,87
 .byte 89,91,93,95,97,99,101,103,105,107,109,111,113,115,117
 .byte 119,121,123,125,127,129,131,133,135,137,139,141,143,145,147
