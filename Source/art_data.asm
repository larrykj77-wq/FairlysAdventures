; Full-game original artwork. Wizard/skeleton data match the approved room.
PrepareArt
 lda #<ArtHeroA
 sta player0pointer
 lda #>ArtHeroA
 sta player0pointer+1
 lda tick
 and #8
 beq ArtHeroReady
 lda #>ArtHeroB
 sta player0pointer+1
ArtHeroReady
 lda #<ArtGold
 sta aux1
 lda #>ArtGold
 sta aux2
 lda tint
 cmp #$CA
 bne ArtNotGreen
 lda #>ArtGreen
 sta aux2
ArtNotGreen
 cmp #$6C
 bne ArtNotPurple
 lda #>ArtPurple
 sta aux2
ArtNotPurple
 cmp #$2E
 bne ArtNotMerchant
 lda #>ArtOrange
 sta aux2
ArtNotMerchant
 cmp #$46
 bne ArtNotRed
 lda #>ArtRed
 sta aux2
ArtNotRed
 cmp #$3E
 bne ArtTintReady
 lda #>ArtYellow
 sta aux2
ArtTintReady
 lda #<ArtSkeletonA
 ldy #>ArtSkeletonA
 ldx alive
 cpx #1
 beq ArtSkeleton
 cpx #2
 beq ArtBat
 cpx #3
 beq ArtSlimeSelect
 cpx #128
 bcs ArtDragon
 lda navDir
 cmp #4
 bcs ArtVendor
 lda #<ArtChest
 ldy #>ArtChest
 ldx navDir
 beq ArtSelected
 lda #<ArtChestOpen
 jmp ArtSelected
ArtVendor
 lda #<ArtMerchant
 ldy #>ArtMerchant
 jmp ArtSelected
ArtSkeleton
 lda #>ArtSkeletonPalette
 sta aux2
 lda tick
 and #8
 beq ArtSkeletonFirst
 lda #<ArtSkeletonB
 jmp ArtSelected
ArtSkeletonFirst
 lda #<ArtSkeletonA
 jmp ArtSelected
ArtBat
 lda #<ArtBatA
 ldy #>ArtBatA
 ldx tick
 txa
 and #8
 beq ArtBatFirst
 lda #<ArtBatB
 jmp ArtSelected
ArtBatFirst
 lda #<ArtBatA
 jmp ArtSelected
ArtSlimeSelect
 lda #<ArtSlime
 ldy #>ArtSlime
 ldx phase
 cpx #56
 bcc ArtSelected
 cpx #20
 bcs ArtSelected
 lda #<ArtSlimeTall
 jmp ArtSelected
ArtDragon
 lda #<ArtDragonA
 ldy #>ArtDragonA
 ldx tick
 txa
 and #8
 beq ArtDragonFirst
 lda #<ArtDragonB
 jmp ArtSelected
ArtDragonFirst
 lda #<ArtDragonA
ArtSelected
 sta player1pointer
 sty player1pointer+1
 lda #<ArtStoneCourses
 sta aux3
 lda #>ArtStoneCourses
 sta aux4
 lda roomType
 cmp #4
 bne ArtPrepareDone
 lda #<ArtFlameCourses
 sta aux3
ArtPrepareDone
 MAIN_FEEDBACK 1
 ; Flash only the enemy that was struck, respecting alternating enemy draws.
 lda score+2
 and #$F0
 cmp #$10
 beq ArtFeedbackFirst
 cmp #$50
 bne ArtFeedbackDone
 lda tick
 and #1
 beq ArtFeedbackDone
 bne ArtFeedbackGold
ArtFeedbackFirst
 lda wallDirection
 cmp #129
 bcc ArtFeedbackGold
 lda tick
 and #1
 bne ArtFeedbackDone
ArtFeedbackGold
 lda #<ArtGold
 sta aux1
 lda #>ArtGold
 sta aux2
ArtFeedbackDone
 rts

 ; Called at the top/bottom only, where movement keeps actors out of the wall.
ArtWallBand
 ldx #0
ArtWallPair
 sta WSYNC
 lda ArtWall1,x
 sta PF1
 lda ArtWall2,x
 sta PF2
 lda ArtWallColors,x
 sta COLUPF
 sta WSYNC
 inx
 inx ; One two-line course per decorative wall; interior coordinates unchanged.
 cpx #2
 bne ArtWallPair
 rts

 align 256
ArtStoneCourses
 .byte $06,$06,$06,$08,$06,$06,$06,$08,$06,$06
ArtFlameCourses
 .byte $46,$46,$3E,$3E,$46,$46,$3E,$3E,$46,$46
ArtWall1
 .byte $FF,$EE,$EE,$FF,$BB,$BB,$BB,$FF
ArtWall2
 .byte $FF,$77,$77,$FF,$DD,$DD,$DD,$FF
ArtWallColors
 .byte $06,$06,$08,$06,$06,$06,$08,$06
 align 256
ArtHeroA
 .byte $66,$3C,$7E,$39,$3B,$18,$3C,$10
 ds 248,0
 align 256
ArtHeroB
 .byte $24,$7C,$3E,$39,$3B,$18,$3C,$10
 ds 248,0
 align 256
ArtHeroColors
 ; Standard-kernel VDELP0 latches the previous row: palette is rotated one row.
 .byte $86,$88,$8A,$3E,$3E,$86,$84
 ds 248,$AE
 .byte $F4
 align 256
ArtSkeletonPalette
 .byte $0E,$0A,$0C,$06,$0E,$0A,$08,$0C,$0E
 ds 247,$0E
 align 256
ArtGold
 ds 256,$1E
 align 256
ArtGreen
 ds 256,$CA
 align 256
ArtPurple
 ds 256,$6C
 align 256
ArtOrange
 ds 256,$2E
 align 256
ArtRed
 ds 256,$46
 align 256
ArtYellow
 ds 256,$3E
 align 256
ArtSkeletonA
 .byte $42,$24,$18,$5A,$3C,$18,$5A,$3C
ArtSkeletonB
 .byte $24,$42,$18,$5A,$3C,$18,$5A,$3C
ArtChest
 .byte $FF,$81,$A5,$FF,$99,$FF,$7E,$3C
ArtChestOpen
 .byte $FF,$81,$81,$00,$00,$81,$81,$7E
ArtMerchant
 .byte $66,$3C,$7E,$39,$3B,$18,$3C,$10
ArtDragonA
 .byte $40,$64,$34,$1E,$3F,$3E,$7C,$FE,$DC,$9C,$1C,$1F,$6F,$3E,$1C,$0A
ArtDragonB
 .byte $08,$48,$34,$1E,$3F,$BE,$FC,$FE,$1C,$1C,$1C,$1F,$6F,$3E,$1C,$0A
ArtBatA
 .byte $18,$3C,$7E,$FF,$DB,$81,$00,$00
ArtBatB
 .byte $81,$DB,$FF,$7E,$3C,$18,$00,$00
ArtSlime
 .byte $FF,$7E,$3C,$24,$18,$00,$00,$00
ArtSlimeTall
 .byte $7E,$3C,$3C,$3C,$24,$18,$00,$00


