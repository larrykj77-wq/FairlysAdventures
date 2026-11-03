; Original art and exact left/right fire cone masks.
 align 256
HeroA
 ds 88,0
 .byte $10,$3C,$18,$3B,$39,$7E,$3C,$66
 ds 72,0
DragonIdleR
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$D0,$D0,$D0,$D0,$D8,$DC,$DC,$DC,$DE,$DE,$DE,$DE,$DE,$DE,$DE
 .byte $DE,$DF,$DC,$DC,$DC,$D8,$D8,$D8,$D8,$D8,$DF,$DF,$DF,$DF,$D8,$D8
 .byte $D8,$D8,$D8,$D8,$DC,$DF,$DC,$DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
 .byte $DC,$DC,$DC,$D8,$D0,$D0,$D0,$D0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $EE,$EE,$EE,$FF,$BB,$BB,$BB,$FF

 align 256
HeroB
 ds 88,0
 .byte $10,$3C,$18,$3B,$39,$3E,$7C,$24
 ds 72,0
QuietRight2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF

 align 256
HeroColors
 ds 88,$AE
HeroInk
 .byte $84,$86,$3E,$3E,$8A,$88,$86,$F4
 ds 72,$AE
IceUpperRows
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 ds 8,0

DragonIdle
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $0C,$07,$0C,$0C,$00,$00,$00,$01,$07,$05,$0F,$0F,$0F,$0F,$05,$07
 .byte $01,$00,$00,$00,$0C,$07,$0C,$0C,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00
DragonUpper
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $03,$01,$03,$03,$00,$00,$00,$01,$07,$05,$0F,$0F,$0F,$0F,$05,$07
 .byte $01,$00,$00,$00,$0C,$07,$0C,$0C,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00
IceLowerRows
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 align 256
DragonLower
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $0C,$07,$0C,$0C,$00,$00,$00,$01,$07,$05,$0F,$0F,$0F,$0F,$05,$07
 .byte $01,$00,$00,$00,$03,$01,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00
DragonBoth
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $03,$01,$03,$03,$00,$00,$00,$01,$07,$05,$0F,$0F,$0F,$0F,$05,$07
 .byte $01,$00,$00,$00,$03,$01,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00
IceRows
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
 .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
BlankDragon = HeroA-1
 align 128
QuietLeft1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$CF,$CF,$CF,$CF,$CF,$C3,$C3,$C3
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C3,$C3,$C3,$CF,$CF,$CF,$CF,$CF
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF
 align 128
QuietLeft2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$0F,$0F,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FE,$FE,$FE,$FE,$FE,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$0F
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF
; QuietRight2 has its own asymmetric lava data.
QuietRight1 = QuietLeft1
 align 128
UpperLeft1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$CF,$EF,$EF,$FF,$FF,$FB,$FB,$FF
 .byte $FC,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$DF,$C7,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C3,$C3,$C3,$CF,$CF,$CF,$CF,$CF
 .byte $EE,$EE,$EE,$FF,$BB,$BB,$BB,$FF
 align 128
UpperLeft2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$0F,$0F,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FE,$FE,$FE,$FE,$FE,$F1,$F1,$F3,$F3,$F7,$F7,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FE,$F8,$E0,$80,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$0F
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
 align 128
UpperRight2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$80,$C0,$C0,$E0,$60,$10,$00,$00,$00,$00
 .byte $00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
UpperRight1 = QuietLeft1
 align 128
MiddleLeft1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$CF,$CF,$CF,$CF,$CF,$C3,$C3,$C3
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$E0,$F0,$F8,$FC,$FE,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FC,$F8,$F0,$E0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C3,$C3,$C3,$CF,$CF,$CF,$CF,$CF
 .byte $EE,$EE,$EE,$FF,$BB,$BB,$BB,$FF
 align 128
MiddleLeft2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$0F,$0F,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FE,$FE,$FE,$FE,$FE,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F1,$F3,$F7,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$7F,$FF,$FF,$FF,$F7,$F3,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$0F
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
 align 128
MiddleRight2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$80,$C0,$E0,$F0,$F0,$E0,$C0,$80
 .byte $00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
MiddleRight1 = QuietLeft1
 align 128
LowerLeft1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$CF,$CF,$CF,$CF,$CF,$C3,$C3,$C3
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C1,$C7,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FE,$FE,$FC,$FC,$FB,$FB,$F3,$FF,$EF,$EF,$CF,$CF
 .byte $EE,$EE,$EE,$FF,$BB,$BB,$BB,$FF
 align 128
LowerLeft2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$0F,$0F,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FE,$FE,$FE,$FE,$FE,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$80,$E0
 .byte $F8,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7,$F3,$F3
 .byte $F1,$F1,$F0,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$0F
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
 align 128
LowerRight2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$F0,$F0,$F0
 .byte $F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$00,$00,$00,$10,$60,$E0,$C0
 .byte $C0,$80,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00
 .byte $77,$77,$77,$FF,$DD,$DD,$DD,$FF
LowerRight1 = QuietLeft1
 align 128
VictoryLeft1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF,$CF,$CF,$CF,$CF,$CF,$C3,$C3,$C3
 .byte $C0,$C0,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C3,$C3,$C3,$CF,$CF,$CF,$CF,$CF
 .byte $EE,$EE,$EE,$FF,$BB,$BB,$BB,$FF
VictoryLeft2 = QuietLeft2
VictoryRight2 = QuietLeft2
VictoryRight1 = VictoryLeft1
RightWall = QuietRight1

DragonUpperR = DragonIdleR
DragonLowerR = DragonIdleR
DragonBothR = DragonIdleR

; Keep executable border bytes outside the wizard/projectile color page.
BorderRows
.BorderLoop
 sta WSYNC
 lda #0
 sta GRP0
 sta GRP1
 sta ENAM0
 sta ENAM1
 lda wallColor
 sta COLUPF
 lda QuietLeft1,x
 sta PF1
 lda QuietLeft2,x
 sta PF2
 sta WSYNC
 inx
 txa
 and #7
 bne .BorderLoop
 rts
