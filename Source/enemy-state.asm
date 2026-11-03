; Swap the full persistent state of independently simulated enemies.
; Missile-1 Y stores 128+secondary HP to keep the unused missile offscreen.
; Secondary navigation packs its lunge direction into bits 3..4.
.swapenemies
 jsr EnemySwapCore
 jmp BS_return
EnemySwapCore
 include "enemy-swap-body.asm"
