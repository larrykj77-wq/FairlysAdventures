 lda player1x
 ldx enemy2X
 sta enemy2X
 stx player1x
 lda player1y
 ldx enemy2Y
 sta enemy2Y
 stx player1y
 lda phase
 ldx enemy2Phase
 sta enemy2Phase
 stx phase
 lda wallGap
 ldx enemy2Brain
 sta enemy2Brain
 stx wallGap
 lda enemyHP
 clc
 adc #128
 tax
 lda wallDirection
 sec
 sbc #128
 sta enemyHP
 stx wallDirection
 lda fireAge
 and #3
 asl
 asl
 asl
 ora navDir
 tax
 lda enemy2Nav
 and #7
 sta navDir
 lda enemy2Nav
 lsr
 lsr
 lsr
 and #3
 sta fireAge
 stx enemy2Nav
 rts
