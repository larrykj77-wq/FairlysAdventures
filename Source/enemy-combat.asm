; Direct independent hitboxes, without swapping actor state for collision tests.
.enemyhit
 lda #0
 sta blocked
 lda player1y
 clc
 adc #1
 sec
 sbc boltY
 cmp #9
 bcs EnemyCheckSecondHit
 lda player1x
 sec
 sbc boltX
 clc
 adc #7
 cmp #9
 bcs EnemyCheckSecondHit
 lda #$1A
 sta score+2
 lda upgrades
 clc
 adc #1
 sta tx
 lda enemyHP
 sec
 sbc tx
 beq EnemyFirstKilled
 bcc EnemyFirstKilled
 sta enemyHP
 jmp EnemyHitAbsorbed
EnemyFirstKilled
 lda #$4C
 sta score+2
 lda #0
 sta enemyHP
 lda wallDirection
 cmp #129
 bcs EnemyPromoteSurvivor
 lda #2
 sta blocked
 jmp BS_return
EnemyPromoteSurvivor
 jsr EnemySwapCore
 jmp EnemyHitAbsorbed
EnemyCheckSecondHit
 lda wallDirection
 cmp #129
 bcc EnemyCombatReturn
 lda enemy2Y
 clc
 adc #1
 sec
 sbc boltY
 cmp #9
 bcs EnemyCombatReturn
 lda enemy2X
 sec
 sbc boltX
 clc
 adc #7
 cmp #9
 bcs EnemyCombatReturn
 lda #$5A
 sta score+2
 lda upgrades
 clc
 adc #1
 sta tx
 lda wallDirection
 sec
 sbc tx
 cmp #129
 bcc EnemySecondKilled
 sta wallDirection
 jmp EnemyHitAbsorbed
EnemySecondKilled
 lda #$4C
 sta score+2
 lda #128
 sta wallDirection
EnemyHitAbsorbed
 lda #1
 sta blocked
EnemyCombatReturn
 jmp BS_return

.enemycontact
 lda #0
 sta blocked
 lda player1y
 sec
 sbc player0y
 clc
 adc #7
 cmp #15
 bcs EnemySecondContact
 lda player1x
 sec
 sbc player0x
 clc
 adc #7
 cmp #15
 bcc EnemyContactHit
EnemySecondContact
 lda wallDirection
 cmp #129
 bcc EnemyCombatReturn
 lda enemy2Y
 sec
 sbc player0y
 clc
 adc #7
 cmp #15
 bcs EnemyCombatReturn
 lda enemy2X
 sec
 sbc player0x
 clc
 adc #7
 cmp #15
 bcs EnemyCombatReturn
EnemyContactHit
 lda #1
 sta blocked
 jmp BS_return

