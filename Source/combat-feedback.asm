.ordinarydamage
 lda armor
 beq MonsterArmorReady
 sec
 sbc #1
MonsterArmorReady
 sta tx
 ldx gameLevel
 lda MonsterDamage-1,x
 sec
 sbc tx
 bcc MinimumDamage
 beq MinimumDamage
MonsterDamageReady
 sta tx
 jmp BS_return
MinimumDamage
 lda #1
 sta tx
 jmp BS_return
MonsterDamage
 .byte 5,10,15,20,25

