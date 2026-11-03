; Original large-dragon encounter experiment, NTSC Atari 2600, 16 KB F6.
; Assemble two base banks; pack-rewards.ps1 adds the reward display overlay.
; F6 banks: 0 reset fallback, 1 rewards, 2 logic, 3 combat display.
 processor 6502
 include "vcs.h"

 SEG.U RAM
 ORG $80
heroX ds 1
heroY ds 1
hp ds 1
lives ds 1
dragonHP ds 1
tick ds 1
facing ds 1
held ds 1
cooldown ds 1
grace ds 1
boltX ds 1
boltY ds 1
boltDir ds 1
boltActive ds 1
phase ds 1
phaseTimer ds 1
lane ds 1
hitFlash ds 1
drawHero ds 1
drawDragon ds 1
drawBolt ds 1
nextHeroColor ds 1
heroPointer ds 2
heroColorPointer ds 2
dragonPointer ds 2
dragonPFPointer ds 2
wallColor ds 1
dragonColor ds 1
hpA ds 1
hpB ds 1
bossA ds 1
bossB ds 1
lifePips ds 1
scratch ds 1
firstCol ds 1
lastCol ds 1
heroBottom ds 1
oldX ds 1
oldY ds 1
rooms ds 1
chestFlags ds 1
keyOwned ds 1
wandTier ds 1
nextDifficulty ds 1
transitionReady ds 1
hudA ds 12
hudB ds 12
hudColor ds 12

; Integrated HUD bar arrays are transient; reuse two bytes for the ice raster.
icePointer = hudA+10
; A spare legacy HUD byte holds one extra 255-HP block. dragonHP stays
; nonzero while alive, preserving every existing renderer/death check.
dragonHPExtra = hudB+11
combatCue = hudB+10

 SEG CODE
 ORG $1000
 RORG $F000
LogicNewGame
 IFCONST INTEGRATED
 jmp $FFB4
 ENDIF
 lda #1
 sta wandTier
 lda #0
 sta nextDifficulty
LogicNewLives
 lda #3
 sta lives
 lda #0
 sta rooms
LogicStartRoom
 lda #0
 sta dragonHPExtra
 sta combatCue
 lda #5
 sta hp
 IFCONST INTEGRATED
 ldx $D5
 lda DragonHealthExtra-1,x
 sta dragonHPExtra
 lda DragonHealth-1,x
 ELSE
 lda #20
 ENDIF
 sta dragonHP
 lda #36
 sta heroX
 lda #44
 sta heroY
 lda #3
 sta facing
 lda #0
 sta held
 sta cooldown
 sta grace
 sta hitFlash
 sta boltActive
 sta phase
 sta lane
 sta chestFlags
 sta keyOwned
 sta transitionReady
 sta nextDifficulty
 lda #90
 sta phaseTimer
 rts

LogicUpdate
 lda combatCue
 and #15
 bne LogicCueTick
 sta combatCue
 beq LogicCueReady
LogicCueTick
 dec combatCue
LogicCueReady
 lda SWCHB
 and #1
 bne LogicNoReset
 jsr LogicNewGame
LogicNoReset
 inc tick
 lda cooldown
 beq LogicCoolDone
 dec cooldown
LogicCoolDone
 lda grace
 beq LogicGraceDone
 dec grace
LogicGraceDone
 lda hitFlash
 beq LogicHitDone
 dec hitFlash
LogicHitDone
 lda lives
 bne LogicPlaying
 lda INPT4
 bpl LogicGameOverPressed
 lda #0
 sta held
 jmp LogicStatus
LogicGameOverPressed
 lda held
 bne LogicGameOverWait
 jsr LogicNewGame
LogicGameOverWait
 jmp LogicStatus
LogicPlaying
 lda transitionReady
 beq LogicContinuePlaying
 jmp LogicStatus
LogicContinuePlaying
 jsr LogicMove
 jsr LogicLava
 bcs LogicStatus
 jsr LogicCast
 jsr LogicBolt
 lda dragonHP
 beq LogicNoEncounter
 jsr LogicEncounter
 jsr LogicIceDamage
 jsr LogicFireDamage
LogicNoEncounter
LogicStatus
 jsr LogicSound
 IFNCONST INTEGRATED
 ldx hp
 lda BarA,x
 sta hpA
 lda BarB,x
 sta hpB
 ldx dragonHP
 cpx #7
 bcc LogicBossBarReady
 ldx #6
LogicBossBarReady
 lda BarA,x
 sta bossA
 lda BarB,x
 sta bossB
 ldx lives
 cpx #7
 bcc LogicLivesBarReady
 ldx #6
LogicLivesBarReady
 lda BarA,x
 sta lifePips
 lda lives
 bne LogicAudioOkay
 lda #0
 sta AUDV0
 sta AUDV1
LogicAudioOkay
 ldx #3
LogicHudFill
 lda hpA
 sta hudA,x
 lda hpB
 sta hudB,x
 lda #$CA
 sta hudColor,x
 lda bossA
 sta hudA+4,x
 lda bossB
 sta hudB+4,x
 lda #$46
 sta hudColor+4,x
 lda lifePips
 sta hudA+8,x
 ; hudB+8..11 remain unused; +11 now preserves the dragon HP overflow.
 lda #$1E
 sta hudColor+8,x
 dex
 bpl LogicHudFill
 lda dragonHP
 bne LogicHudDone
 jsr LogicRewardHud
LogicHudDone
 ENDIF
 rts

LogicMove
 lda nextDifficulty
 bmi LogicFrozenMove
 lda heroX
 sta oldX
 lda heroY
 sta oldY
 lda SWCHA
 and #$10
 bne LogicNotUp
 dec heroY
 lda #0
 sta facing
 jmp LogicMoved
LogicFrozenMove
 rts
LogicNotUp
 lda SWCHA
 and #$20
 bne LogicNotDown
 inc heroY
 lda #1
 sta facing
 jmp LogicMoved
LogicNotDown
 lda SWCHA
 and #$40
 bne LogicNotLeft
 dec heroX
 lda #2
 sta facing
 jmp LogicMoved
LogicNotLeft
 lda SWCHA
 and #$80
 bne LogicMoved
 inc heroX
 lda #3
 sta facing
LogicMoved
 lda heroY
 cmp #8
 bcc LogicUndo
 cmp #73
 bcs LogicUndo
 IFCONST INTEGRATED
 lda heroX
 cmp #24
 bcc LogicLeftExitCheck
 ENDIF
 lda dragonHP
 beq LogicVictoryBounds
 lda heroX
 cmp #24
 bcc LogicUndo
 cmp #89
 bcs LogicUndo
 rts
LogicVictoryBounds
 lda heroX
 cmp #24
 bcc LogicLeftExitCheck
 cmp #129
 bcc LogicVictoryInside
 lda keyOwned
 beq LogicUndo
 lda heroY
 cmp #38
 bcc LogicUndo
 cmp #43
 bcs LogicUndo
 lda heroX
 cmp #132
 bcc LogicVictoryInside
 IFCONST INTEGRATED
 lda $D5
 cmp #5
 bcs LogicFinalGate
 inc $D5
 lda #2
 sta transitionReady
 jmp LogicLeave
LogicFinalGate
 jmp $FFEC
 ELSE
 lda #2
 ENDIF
 sta nextDifficulty
 lda #1
 sta transitionReady
 lda #128
 sta heroX
 lda #0
 sta boltActive
 sta cooldown
 sta AUDV0
 sta AUDV1
 rts
LogicLeftExitCheck
 lda heroY
 cmp #20
 bcc LogicUndo
 cmp #29
 bcs LogicUndo
 lda heroX
 cmp #20
 bcc LogicLeave
LogicVictoryInside
 rts

LogicUndo
 lda oldX
 sta heroX
 lda oldY
 sta heroY
 rts
LogicLeave
 IFCONST INTEGRATED
 lda #0
 ldx transitionReady
 cpx #2
 bne LogicLeaveCueReady
 lda #$9F
LogicLeaveCueReady
 sta $F8
 lda $D5
 sta $F6
 lda $D6
 sta $F7
 lda hp
 sta $F0
 lda lives
 sta $F1
 lda wandTier
 sec
 sbc #1
 sta $F3
 jmp $FFC0
 ELSE
 inc rooms
 jmp LogicStartRoom
 ENDIF


 ; Test the full wizard box against bands generated from visible lava cells.
LogicLava
 ; The central channel (rows 38..49) is clear across every pool column.
 lda heroY
 cmp #38
 bcc LogicLavaGeometry
 cmp #43
 bcs LogicLavaGeometry
 clc
 rts
LogicLavaGeometry
 lda heroX
 clc
 adc #7
 cmp #32
 bcc LogicLavaSafe
 lda heroX
 cmp #112
 bcs LogicLavaSafe
 sec
 sbc #16
 lsr
 lsr
 tax
 lda heroX
 clc
 adc #7
 sec
 sbc #16
 lsr
 lsr
 sta lastCol
 lda heroY
 clc
 adc #7
 sta heroBottom
LogicLavaColumn
 lda LavaUpperMin,x
 cmp heroBottom
 bcc LogicLavaUpperOverlap
 beq LogicLavaUpperOverlap
 bcs LogicLavaLowerCheck
LogicLavaUpperOverlap
 lda LavaUpperMax,x
 cmp heroY
 bcs LogicLavaKill
LogicLavaLowerCheck
 lda LavaLowerMin,x
 cmp heroBottom
 bcc LogicLavaLowerOverlap
 beq LogicLavaLowerOverlap
 bcs LogicLavaNext
LogicLavaLowerOverlap
 lda LavaLowerMax,x
 cmp heroY
 bcs LogicLavaKill
LogicLavaNext
 inx
 cpx lastCol
 bcc LogicLavaColumn
 beq LogicLavaColumn
 jmp LogicLavaSafe

LogicLavaKill
 lda #0
 sta hp
 sta boltActive
 dec lives
 beq LogicLavaGameOver
 jsr LogicStartRoom
 lda #$3C
 sta combatCue
 lda #90
 sta grace
 sec
 rts
LogicLavaGameOver
 jsr LogicDead
 sec
 rts
LogicLavaSafe
 clc
 rts

LogicCast
 lda nextDifficulty
 bmi LogicCastDone
 lda INPT4
 bmi LogicRelease
 lda held
 bne LogicCastDone
 lda #1
 sta held
 lda dragonHP
 bne LogicCastWand
 jsr LogicLootPress
 bcs LogicCastDone
LogicCastWand
 lda cooldown
 ora boltActive
 bne LogicCastDone
 lda #2
 sta boltActive
 lda #12
 IFNCONST INTEGRATED
 ldx wandTier
 lda WandCooldown,x
 ENDIF
 sta cooldown
 lda heroX
 clc
 adc #3
 sta boltX
 lda heroY
 clc
 adc #4
 sta boltY
 lda facing
 sta boltDir
LogicCastDone
 rts
LogicRelease
 lda #0
 sta held
 rts

LogicBolt
 lda boltActive
 bne LogicBoltMoving
 jmp LogicBoltDone
LogicBoltMoving
 lda boltDir
 beq LogicBoltUp
 cmp #1
 beq LogicBoltDown
 cmp #2
 beq LogicBoltLeft
 inc boltX
 inc boltX
 jmp LogicBoltBounds
LogicBoltLeft
 dec boltX
 dec boltX
 jmp LogicBoltBounds
LogicBoltUp
 dec boltY
 dec boltY
 jmp LogicBoltBounds
LogicBoltDown
 inc boltY
 inc boltY
LogicBoltBounds
 lda boltY
 cmp #8
 bcc LogicBoltEnd
 cmp #80
 bcs LogicBoltEnd
 lda boltX
 cmp #24
 bcc LogicBoltEnd
 cmp #140
 bcs LogicBoltEnd
 cmp #96
 bcc LogicBoltDone
 cmp #112
 bcs LogicBoltDone
 lda dragonHP
 beq LogicBoltDone
 ; Only the head is vulnerable, and only during recovery (gold dragon).
 lda boltY
 cmp #40
 bcc LogicBoltDone
 cmp #48
 bcs LogicBoltDone
 lda phase
 cmp #3
 beq LogicHeadVulnerable
 lda #$28
 sta combatCue
 jmp LogicBoltEnd
LogicHeadVulnerable
 lda dragonHP
 sec
 sbc wandTier
 bcs LogicWandDamageReady
 ldx dragonHPExtra
 beq LogicWandLethal
 dec dragonHPExtra
 sec
 sbc #1
 jmp LogicWandStoreDamage
LogicWandLethal
 lda #0
LogicWandDamageReady
 bne LogicWandStoreDamage
 ldx dragonHPExtra
 beq LogicWandStoreDamage
 dec dragonHPExtra
 lda #255
LogicWandStoreDamage
 sta dragonHP
 lda #$1A
 sta combatCue
 lda #9
 sta hitFlash
 lda dragonHP
 bne LogicBoltEnd
 lda #4
 sta phase
 lda #0
 sta phaseTimer
 sta chestFlags
 sta nextDifficulty
 lda #$6F
 sta combatCue
LogicBoltEnd
 lda #0
 sta boltActive
LogicBoltDone
 rts

 ; Key and upgrade chest, each collected once. The upgrade chest always
 ; adds one life (up to ten), independently of the wand upgrade/cap.
DragonHealth
 .byte 40,80,150,5,120
DragonHealthExtra
 .byte 0,0,0,1,1
LogicLootPress
 lda heroX
 cmp #56
 bcs LogicLootMiss
 clc
 adc #7
 cmp #48
 bcc LogicLootMiss
 lda heroY
 cmp #38
 bcs LogicLootWandCheck
 clc
 adc #7
 cmp #30
 bcc LogicLootMiss
 lda chestFlags
 and #1
 bne LogicLootMiss
 lda #1
 sta keyOwned
 ora chestFlags
 sta chestFlags
 jmp LogicLootCollected
LogicLootWandCheck
 cmp #62
 bcs LogicLootMiss
 clc
 adc #7
 cmp #54
 bcc LogicLootMiss
 lda chestFlags
 and #2
 bne LogicLootMiss
 lda chestFlags
 ora #2
 sta chestFlags
 lda wandTier
 IFCONST INTEGRATED
 ldx $D5
 cmp LevelWandCaps-1,x
 ELSE
 cmp #3
 ENDIF
 bcs LogicLootExtraLife
 inc wandTier
LogicLootExtraLife
 lda lives
 cmp #10
 bcs LogicLootCollected
 inc lives
LogicLootCollected
 lda #$5F
 sta combatCue
 lda #9
 sta hitFlash
 lda #12
 sta cooldown
 sec
 rts
LogicLootMiss
 clc
 rts
LevelWandCaps .byte 5,10,15,20,25
WandCooldown .byte 12,12,8,6,4

 IFNCONST INTEGRATED
LogicRewardHud
 ldx keyOwned
 lda transitionReady
 beq LogicRewardKeyHud
 ldx #2
LogicRewardKeyHud
 lda BarA,x
 sta hudA+4
 sta hudA+5
 lda #0
 sta hudB+4
 sta hudB+5
 sta hudB+6
 sta hudB+7
 lda #$1E
 sta hudColor+4
 sta hudColor+5
 ldx wandTier
 cpx #6
 bcc LogicWandHudIndexReady
 ldx #5
LogicWandHudIndexReady
 lda BarA,x
 sta hudA+6
 sta hudA+7
 lda #$86
 sta hudColor+6
 sta hudColor+7
 rts
 ENDIF

LogicEncounter
 lda phase
 cmp #5
 bne LogicEncounterNormal
 jmp LogicIceCycle
LogicEncounterNormal
 dec phaseTimer
 bne LogicEncounterDone
 lda phase
 beq LogicWindup
 cmp #1
 beq LogicBreath
 cmp #2
 beq LogicRecovery
 lda #0
 sta phase
 lda #90
 sta phaseTimer
 rts
LogicWindup
 IFCONST INTEGRATED
 ldx $D5
 cpx #5
 bne LogicStartFireWarning
 jsr LogicRandomLane
 lda #5
 sta phase
 lda #88
 sta chestFlags
 rts
 ENDIF
LogicStartFireWarning
 jsr LogicRandomLane
 lda #1
 sta phase
 lda #60
 sta phaseTimer
 rts
LogicBreath
 lda #2
 sta phase
 lda #72
 sta phaseTimer
 rts
LogicRecovery
 lda #0
 sta nextDifficulty
 lda #3
 sta phase
 lda #90
 sta phaseTimer
LogicEncounterDone
 rts

 ; rooms is otherwise unused in the integrated encounter; reuse it as RNG.
LogicRandomLane
 lda rooms
 bne LogicLaneAdvance
 IFCONST INTEGRATED
 lda $F4
 ELSE
 lda #$B4
 ENDIF
 bne LogicLaneAdvance
 lda #$B4
LogicLaneAdvance
 lsr
 bcc LogicLaneRandomReady
 eor #$B4
LogicLaneRandomReady
 sta rooms
 cmp #86
 bcc LogicLaneUpper
 cmp #171
 bcc LogicLaneMiddle
 lda #2
 bne LogicLaneStore
LogicLaneUpper
 lda #0
 beq LogicLaneStore
LogicLaneMiddle
 lda #1
LogicLaneStore
 sta lane
 rts

 include "ice-logic.asm"

LogicFireDamage
 ; Breath ends at the muzzle: decorative wings behind it cannot hurt.
 lda heroX
 cmp #96
 bcs LogicFireDone
 lda phase
 cmp #2
 bne LogicFireDone
 ; Draw six complete fire frames before contact can hurt Wiz.
 lda phaseTimer
 cmp #67
 bcs LogicFireDone
 lda grace
 bne LogicFireDone
 lda heroY
 clc
 adc #7
 sta heroBottom
 lda heroX
 sec
 sbc #16
 lsr
 lsr
 sta firstCol
 lda heroX
 clc
 adc #7
 sec
 sbc #16
 lsr
 lsr
 sta lastCol
 ; The bounds below are generated from the exact displayed playfield cells.
 ldy lane
 lda ConeOffset,y
 clc
 adc firstCol
 tax
LogicFireCell
 lda ConeMin,x
 cmp #$FF
 beq LogicFireNext
 cmp heroBottom
 bcc LogicFireLowOkay
 beq LogicFireLowOkay
 bcs LogicFireNext
LogicFireLowOkay
 lda ConeMax,x
 cmp heroY
 bcs LogicHurt
LogicFireNext
 inc firstCol
 inx
 lda firstCol
 cmp lastCol
 bcc LogicFireCell
 beq LogicFireCell
LogicFireDone
 rts
LogicHurt
 lda #$3C
 ldx phase
 cpx #5
 bne LogicHurtCueReady
 lda #$4C
LogicHurtCueReady
 sta combatCue
 IFCONST INTEGRATED
 lda $D6
 beq LogicDragonArmorReady
 sec
 sbc #1
LogicDragonArmorReady
 sta scratch
 ldx $D5
 lda DragonDamage-1,x
 sec
 sbc scratch
 bcc LogicDragonMinimum
 beq LogicDragonMinimum
 bne LogicDragonDamageReady
LogicDragonMinimum
 lda #1
LogicDragonDamageReady
 ELSE
 lda #5
 ENDIF
 sta scratch
 lda hp
 sec
 sbc scratch
 bcs LogicDragonHealthReady
 lda #0
LogicDragonHealthReady
 sta hp
 lda #90
 sta grace
 lda hp
 bne LogicFireDone
 dec lives
 beq LogicDead
 jsr LogicStartRoom
 lda #$3C
 sta combatCue
 lda #90
 sta grace
 rts
DragonDamage
 .byte 5,10,15,20,25
LogicDead
 IFCONST INTEGRATED
 ldx $D5
 lda #$A5
 jmp $FFEC
 ENDIF
 lda #0
 sta boltActive
 lda #1
 sta held
 rts

LogicSound
 lda #0
 sta AUDV0
 sta AUDV1
 lda phase
 cmp #1
 beq LogicWarningSound
 cmp #5
 beq LogicIceStartSound
 cmp #2
 bne LogicCastSound
 lda #8
 sta AUDC0
 lda tick
 and #7
 clc
 adc #8
 sta AUDF0
 lda #3
 sta AUDV0
 jmp LogicCastSound
LogicWarningSound
 lda tick
 and #8
 beq LogicCastSound
 lda #3
 sta AUDC0
 lda lane
 asl
 clc
 adc #16
 sta AUDF0
 lda #3
 sta AUDV0
 jmp LogicCastSound
LogicIceStartSound
 lda chestFlags
 cmp #84
 bcc LogicCastSound
 lda #12
 sta AUDC0
 lda #5
 sta AUDF0
 lda #2
 sta AUDV0
LogicCastSound
 lda cooldown
 cmp #9
 bcc LogicSoundDone
 lda #4
 sta AUDC1
 lda #5
 sta AUDF1
 lda #4
 sta AUDV1
LogicSoundDone
 lda combatCue
 and #15
 beq LogicRecoverySound
 lda combatCue
 lsr
 lsr
 lsr
 lsr
 tax
 lda DragonCueControl,x
 sta AUDC1
 lda combatCue
 and #8
 beq LogicCueLastNote
 lda DragonCuePitch,x
 bne LogicCuePitchReady
LogicCueLastNote
 lda DragonCueLastPitch,x
LogicCuePitchReady
 sta AUDF1
 lda #5
 sta AUDV1
 rts
LogicRecoverySound
 lda phase
 cmp #3
 bne LogicFeedbackDone
 lda phaseTimer
 cmp #85
 bcc LogicFeedbackDone
 lda #4
 sta AUDC1
 lda #2
 sta AUDF1
 lda #4
 sta AUDV1
LogicFeedbackDone
 rts
DragonCueControl .byte 0,4,8,3,8,4,4
DragonCuePitch .byte 0,3,20,14,5,6,3
DragonCueLastPitch .byte 0,3,20,14,5,3,1

LogicPrepareFrame
 jsr LogicUpdate
 lda #<HeroA
 ldx #>HeroA
 ldy phase
 cpy #5
 bne LogicIcePointerReady
 ldy lane
 lda IceMaskLow,y
 ldx IceMaskHigh,y
LogicIcePointerReady
 sta icePointer
 stx icePointer+1
 lda heroX
 ldx #0
 jsr DisplayPosition
 lda dragonHP
 beq DisplayLootPosition
 lda #76
 bne DisplayObjectPosition
DisplayLootPosition
 lda transitionReady
 bne DisplayGatePosition
 lda #44
 bne DisplayObjectPosition
DisplayGatePosition
 lda #76
DisplayObjectPosition
 ldx #1
 jsr DisplayPosition
 lda boltX
 ldx #2
 jsr DisplayPosition
 lda #0
 ldx phase
 cpx #5
 bne LogicIcePositionReady
 lda chestFlags
LogicIcePositionReady
 ldx #3
 jsr DisplayPosition
 sta WSYNC
 sta HMOVE
 lda #0
 sta VDELP0
 sta VDELP1
 sta PF0
 sta GRP0
 sta GRP1
 sta ENAM0
 sta ENAM1
 sta ENABL
 sta COLUBK
 sta drawHero
 sta drawDragon
 sta drawBolt
 sta REFP0
 lda facing
 cmp #2
 bne DisplayFacingReady
 lda #8
 sta REFP0
DisplayFacingReady
 lda #$10
 sta NUSIZ0
 lda dragonHP
 bne DisplayLargeObject
 lda transitionReady
 beq DisplaySmallObject
DisplayLargeObject
 lda #7
 bne DisplayObjectSizeReady
DisplaySmallObject
 lda #0
DisplayObjectSizeReady
 ldx phase
 cpx #5
 bne LogicIceSizeReady
 ora #$30
LogicIceSizeReady
 sta NUSIZ1
 lda #1
 sta CTRLPF
 lda #$06
 ldx phase
 cpx #2
 bne DisplayWallColor
 lda tick
 and #4
 beq DisplayBrightFire
 lda #$3C
 bne DisplayWallColor
DisplayBrightFire
 lda #$3E
DisplayWallColor
 sta COLUPF
 sta wallColor
 lda #$36
 IFCONST INTEGRATED
 ldx $D5
 cpx #5
 bne LogicDragonNormalColor
 lda #$8A
LogicDragonNormalColor
 ENDIF
 ldx dragonHP
 bne DisplayNormalDragonColor
 lda #$1E
DisplayNormalDragonColor
 ldx phase
 cpx #3
 bne DisplayDragonColor
 lda #$1E
DisplayDragonColor
 ldx hitFlash
 beq DisplayNoFlash
 lda #$0E
DisplayNoFlash
 sta COLUP1
 sta dragonColor
 lda #$AE
 sta nextHeroColor
 ; Row-indexed sparse pages preserve the approved wizard's exact pixel rows.
 lda #89
 sec
 sbc heroY
 sta heroPointer
 sta heroColorPointer
 lda #>HeroA
 sta heroPointer+1
 lda tick
 and #8
 beq DisplayHeroReady
 lda #>HeroB
 sta heroPointer+1
DisplayHeroReady
 lda #>HeroColors
 sta heroColorPointer+1
 lda nextDifficulty
 bpl LogicHeroNotFrozen
 lda #0
 sta heroColorPointer
 jmp DisplayHeroVisible
LogicHeroNotFrozen
 lda grace
 beq DisplayHeroVisible
 lda tick
 and #4
 beq DisplayHeroVisible
 lda #0
 sta heroPointer
DisplayHeroVisible
 lda lives
 bne DisplayHeroAlive
 lda #0
 sta heroPointer
DisplayHeroAlive
 lda #<(DragonIdle+1)
 ldy #>(DragonIdle+1)
 ldx dragonHP
 beq DisplayDragonGone
 ldx phase
 cpx #1
 beq DisplayDragonCue
 cpx #2
 bne DisplayDragonReady
DisplayDragonCue
 ldx lane
 beq DisplayUpperFoot
 cpx #1
 beq DisplayBothFeet
 lda #<(DragonLower+1)
 ldy #>(DragonLower+1)
 jmp DisplayDragonReady
DisplayUpperFoot
 lda #<(DragonUpper+1)
 ldy #>(DragonUpper+1)
 jmp DisplayDragonReady
DisplayBothFeet
 lda #<(DragonBoth+1)
 ldy #>(DragonBoth+1)
 jmp DisplayDragonReady
DisplayDragonGone
 lda transitionReady
 beq DisplayChestPose
 lda #<(RewardGate+1)
 ldy #>(RewardGate+1)
 jmp DisplayDragonReady
DisplayChestPose
 ldx chestFlags
 lda RewardSpriteLow,x
 ldy RewardSpriteHigh,x

DisplayDragonReady
 sta dragonPointer
 sty dragonPointer+1
 lda dragonHP
 bne DragonBodyAlive
 lda wallColor
 sta dragonColor
 lda #<DragonIdleR
 ldy #>DragonIdleR
 ldx keyOwned
 beq DisplayRewardDoorSelected
 lda #<RewardDoorOpen
 ldy #>RewardDoorOpen
DisplayRewardDoorSelected
 sta dragonPFPointer
 sty dragonPFPointer+1
 rts
DragonBodyAlive
 ldx #0
 lda phase
 cmp #1
 beq DragonRightCue
 cmp #2
 bne DragonRightSelect
DragonRightCue
 ldx lane
 inx
DragonRightSelect
 lda DragonRightLow,x
 sta dragonPFPointer
 lda DragonRightHigh,x
 sta dragonPFPointer+1
DragonHalfReady
 rts
DragonRightLow
 .byte <DragonIdleR,<DragonUpperR,<DragonBothR,<DragonLowerR
DragonRightHigh
 .byte >DragonIdleR,>DragonUpperR,>DragonBothR,>DragonLowerR

RewardSpriteLow .byte <(DragonIdle+1),<(DragonUpper+1),<(DragonLower+1),<(DragonBoth+1)
RewardSpriteHigh .byte >(DragonIdle+1),>(DragonUpper+1),>(DragonLower+1),>(DragonBoth+1)
RewardDoorOpen = QuietLeft1
RewardGate = HeroColors+168

DisplayPosition
 sta WSYNC
 sec
DisplayPositionLoop
 sbc #15
 bcs DisplayPositionLoop
 eor #7
 asl
 asl
 asl
 asl
 sta HMP0,x
 sta RESP0,x
 rts


BarA .byte $00,$80,$A0,$A8,$AA,$AA,$AA
BarB .byte $00,$00,$00,$00,$00,$02,$0A
 include "damage.inc"
 include "lava-damage.inc"
 IFCONST INTEGRATED
 include "game-over.asm"
 ENDIF

 ORG $1F00
 RORG $FF00
ResetBridge1
 bit $1FF9
 jmp DisplayReset
 ORG $1F10
 RORG $FF10
UpdateBridge1
 bit $1FF8
 jsr LogicPrepareFrame
 bit $1FF9
 rts
 ORG $1F20
 RORG $FF20
NewGameBridge1
 bit $1FF8
 jsr LogicNewGame
 bit $1FF9
 rts
 ORG $1F30
 RORG $FF30
RewardBridge1
 bit $1FF7
 jmp DisplayWait
 ORG $1F80
 RORG $FF80
GameOverSelectBank1
 bit $1FFA
 jmp $F900
 ORG $1FFA
 RORG $FFFA
 .word ResetBridge1,ResetBridge1,ResetBridge1

 ORG $2000
 RORG $F000
DisplayReset
 IFCONST INTEGRATED
 jmp $FFB4
 ENDIF
 sei
 cld
 ldx #$FF
 txs
 lda #0
DisplayClear
 sta 0,x
 dex
 bne DisplayClear
 jsr NewGameBridge2
DisplayFrame
 lda #2
 sta VBLANK
 sta VSYNC
DisplaySyncLines
 sta WSYNC
 sta WSYNC
 sta WSYNC
 lda #0
 sta VSYNC
 IFCONST INTEGRATED
 lda #34
 ELSE
 lda #43
 ENDIF
 sta TIM64T
 jsr UpdateBridge2
 lda dragonHP
 bne DisplayWait
 jmp RewardBridge2
DisplayWait
 lda INTIM
 bne DisplayWait
 sta WSYNC
 sta VBLANK
 ldx #0
 jsr BorderRows
 ; Prime row eight after the sixteen top-border scanlines.
 ldy #7
 lda (heroColorPointer),y
 sta nextHeroColor
 lda (heroPointer),y
 tax
 ldy #8
 lda dragonHP
 bne DisplayAlive
 jmp VictoryKernel
DisplayAlive
 lda phase
 cmp #2
 beq DisplayAttack
 jmp QuietKernel
DisplayAttack
 lda lane
 bne DisplayNotUpper
 jmp UpperKernel
DisplayNotUpper
 cmp #1
 bne DisplayNotMiddle
 jmp MiddleKernel
DisplayNotMiddle
 jmp LowerKernel

 ; Each pair is bounded by WSYNC. Left PF is retained until its bits are
 ; scanned; right PF1/PF2 writes complete at cycles 42/49. The left sprite
 ; is prefetched on line two and stays at x=76. The right body is present
 ; on both lines, with brown/gray scanline shading instead of frame flicker.
 ; The wall color is restored at cycle 68; top/bottom borders draw separately.
 ; Persistent PF tables fit a page; sprite reads have a reserved extra cycle.
 MAC DRAGON_DISPLAY
.Loop
 sta WSYNC
 lda nextHeroColor
 sta COLUP0
 stx GRP0
 lda drawBolt
 sta ENAM0
 lda {1},y
 sta PF1
 lda {2},y
 sta PF2
 lda #$3C
 sta COLUPF
 lda (dragonPFPointer),y
 IF {5}=0
 and #$FC
 ENDIF
 sta PF1
 lda {3},y
 sta PF2
 IF {5}
 lda dragonColor
 sta COLUPF
 ENDIF
 lda (heroPointer),y
 tax
 ; Restore the wall color at cycle 68, before the right-hand brick border.
 lda wallColor
 sta COLUPF
 lda (heroColorPointer),y
.Second
 sta WSYNC
 sta nextHeroColor
 lda {1},y
 sta PF1
 lda {2},y
 sta PF2
 lda (dragonPointer),y
 sta GRP1
 lda (icePointer),y
 sta.w ENAM1
 lda (dragonPFPointer),y
 IF {5}=0
 and #$FC
 ENDIF
 sta PF1
 lda {3},y
 sta PF2
 iny
 cpy #80
 beq .Finished
 lda boltActive
 cpy boltY
 beq .BoltReady
 lda #0
.BoltReady
 sta drawBolt
 jmp .Loop
.Finished
 ldx #80
 jsr BorderRows
 jmp DisplayHud
 ENDM

 align 128
QuietKernel
 IFCONST INTEGRATED
 DRAGON_DISPLAY VictoryLeft1,QuietLeft2,QuietRight2,RightWall,1
 ELSE
 DRAGON_DISPLAY QuietLeft1,QuietLeft2,QuietRight2,RightWall,1
 ENDIF
 align 128
UpperKernel
 DRAGON_DISPLAY UpperLeft1,UpperLeft2,UpperRight2,RightWall,1
 align 128
MiddleKernel
 DRAGON_DISPLAY MiddleLeft1,MiddleLeft2,MiddleRight2,RightWall,1
 align 128
LowerKernel
 DRAGON_DISPLAY LowerLeft1,LowerLeft2,LowerRight2,RightWall,1
 ; Victory reuses the quiet renderer with open door values selected through
 ; a separate row set. It remains a small isolated arena, not a main-game port.
 align 128
VictoryKernel
 DRAGON_DISPLAY VictoryLeft1,QuietLeft2,QuietRight2,VictoryRight1,0

DisplayHud
 IFCONST INTEGRATED
 jsr $FFD6
 lda #2
 sta VBLANK
 ldx #13
IntegratedInterfaceOverscan
 sta WSYNC
 dex
 bne IntegratedInterfaceOverscan
 jmp DisplayFrame
 ENDIF
 sta WSYNC
 lda #0
 sta GRP0
 sta GRP1
 sta ENAM0
 sta PF1
 sta PF2
 sta CTRLPF
 sta WSYNC
 ldx #0
DisplayHudRow
 sta WSYNC
 lda hudColor,x
 sta COLUPF
 lda hudA,x
 sta PF1
 lda hudB,x
 sta PF2
 ldy #5
DisplayHudDelay
 dey
 bne DisplayHudDelay
 lda #0
 sta PF1
 sta PF2
 inx
 cpx #12
 bne DisplayHudRow
 sta WSYNC
 lda #0
 sta PF1
 sta PF2
 sta WSYNC
 lda #2
 sta VBLANK
 ldx #31
DisplayOverscan
 sta WSYNC
 dex
 bne DisplayOverscan
 jmp DisplayFrame

 include "art.inc"
 echo "Dragon display bytes free:", ($FF00-*)
 ORG $2F00
 RORG $FF00
ResetBridge2
 bit $1FF9
 jmp DisplayReset
 ORG $2F10
 RORG $FF10
UpdateBridge2
 bit $1FF8
 jsr LogicPrepareFrame
 bit $1FF9
 rts
 ORG $2F20
 RORG $FF20
NewGameBridge2
 bit $1FF8
 jsr LogicNewGame
 bit $1FF9
 rts
 ORG $2F30
 RORG $FF30
RewardBridge2
 bit $1FF7
 jmp DisplayWait
 ORG $2FFA
 RORG $FFFA
 .word ResetBridge2,ResetBridge2,ResetBridge2



