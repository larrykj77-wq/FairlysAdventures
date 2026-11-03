; Standard 2600 RAM only. Persistent stats live in $F0..$F5 during the encounter.
 processor 6502
 include "vcs.h"
 include "dragon-link.inc"
 ORG $F000
HelperEnterDragon
 sei
 cld
 ldx #$FF
 txs
 lda #0
 ldx #$EF
HelperClearRAM
 sta 0,x
 dex
 cpx #$7F
 bne HelperClearRAM
 ldx #$2C
HelperClearTIA
 sta 0,x
 dex
 cpx #4 ; Preserve VSYNC/WSYNC/RSYNC during the live frame handoff.
 bcs HelperClearTIA
 lda #2
 sta VBLANK
 ; Move incoming stats below the stack before any nested dragon calls.
 lda $F6
 sta $D5
 lda $F7
 sta $D6
 lda $F1
 sta D_lives
 lda $F3
 clc
 adc #1
 sta D_wandTier
 jsr $FFC6
 lda $F0
 sta D_hp
 lda #90
 sta D_grace
 lda #1
 sta D_held
 ; Complete the outgoing main frame before the dragon emits its VSYNC.
DragonEntryBlank
 lda INTIM
 bmi DragonEntryBlank
 sta WSYNC
 ldx #207
DragonEntryLines
 sta WSYNC
 dex
 bne DragonEntryLines
 lda #2
 sta WSYNC
 sta VSYNC
 ; Mirrored bridge selects the display bank and continues the sync pulse.
 jmp $FFE0
 include "title-screen.asm"
 include "ending-screen.asm"
 ORG $FF68
SceneDispatch
 cmp #$A5
 beq SceneGameOver
 cmp #$A6
 beq SceneGameOverAlign
 jmp $FB40
SceneGameOver
 jmp $FF80
SceneGameOverAlign
 jmp $FF86
 ORG $FF80
GameOverSelectBank
 bit $1FFA
 jmp $F900
GameOverFinishFrame
 lda $E3
 cmp #$DA
 beq GameOverBossWait
GameOverMainWait
 lda INTIM
 bmi GameOverMainWait
 sta WSYNC
 ldx #208
 bne GameOverBlankLines
GameOverBossWait
 lda INTIM
 bne GameOverBossWait
 sta WSYNC
 ldx #230
GameOverBlankLines
 sta WSYNC
 dex
 bne GameOverBlankLines
 jmp $FF80
 ORG $FFFA
 .word $FFB4,$FFB4,$FFB4



