 rem Wizard Dungeon Arena - NTSC, custom assembly graphics, 32K F4
 set romsize 32k
 set tv ntsc
 set smartbranching on
 const font=hex
 const noscore=1
 const pfrowheight=9
 const SHOP_CHANCE=2
 const DRAGON_THRESHOLD=4
 const TRAP_THRESHOLD=19
 asm
 include "dragon-link.inc"
 include "feedback-macro.asm"
end
 dim gameLevel=missile0height
 dim armor=ballheight
 dim enemyHP=aux6
 dim tint=aux5
 dim hp=a
 dim lifeCount=b
 dim facing=c
 dim held=d
 dim cooldown=e
 dim boltLife=f
 dim grace=g
 dim tick=h
 dim alive=i
 dim oldx=j
 dim oldy=k
 dim tx=l
 dim ty=m
 dim blocked=n
 dim phase=o
 dim gold=p
 dim upgrades=q
 dim layout=r
 dim dead=s
 dim enemy2Brain=t
 dim enemy2X=scorecolor
 dim enemy2Y=player0height
 dim enemy2Phase=x
 dim enemy2Nav=y
 dim boltX=u
 dim boltY=v
 dim boltDir=w
 dim rightCol=temp3
 dim bottomRow=temp4
 dim navDir=z
 dim fireAge=ballx
 dim roomCleared=missile1x
 dim roomType=missile1height
 dim wallGap=bally
 dim wallDirection=missile1y

newgame
 hp=5:lifeCount=3:gold=0:upgrades=0:armor=0:gameLevel=1:layout=0:dead=0
 asm
 sta score+2
end
 score=0
 gosub arena
 goto main
arena
 rem Only this layout and the live playfield are retained.
 roomCleared=0:phase=0:navDir=0:fireAge=0:bally=200:missile1y=200:missile1height=2:NUSIZ1=$10
 rem Offset mortar joints are decorative; room bounds remain solid.
 gosub roomwalls bank2
 player0x=36:player0y=31
 player1x=112:player1y=81
 asm
 ldx gameLevel
 lda MonsterHealth-1,x
 sta enemyHP
end
 wallGap=232:wallDirection=128
 enemy2X=112:enemy2Y=31:enemy2Phase=37:enemy2Nav=0:enemy2Brain=227
 if gameLevel>1 then wallDirection=128+enemyHP
 alive=1:facing=1:held=1:cooldown=0:boltLife=0:grace=90:missile0y=200
 return
main
 if switchreset then newgame
 tick=tick+1
 if dead then gameover
 if cooldown>0 then cooldown=cooldown-1
 if grace>0 then grace=grace-1
 AUDV0=0:AUDV1=0
 oldx=player0x:oldy=player0y
 rem One axis each frame, including diagonal joystick positions.
 if joy0up then player0y=player0y-1:facing=0:goto moved
 if joy0down then player0y=player0y+1:facing=1:goto moved
 if joy0left then player0x=player0x-1:facing=2:goto moved
 if joy0right then player0x=player0x+1:facing=3
moved
 if roomCleared=1 then alive=0
 tx=player0x:ty=player0y:gosub solid
 if blocked then player0x=oldx:player0y=oldy
 if !joy0fire then held=0
 if joy0fire && held=0 then gosub fire
 if roomType=4 then gosub trapstep bank2
 if roomType=4 && blocked then hurt
 if alive=0 then chased
 if wallDirection>128 && tick{0} then gosub swaplocal:roomType=3
enemyupdate
 gosub enemybrain
 if alive=2 then gosub batstep bank2:goto chased
 if alive=3 then phase=phase+1:goto slimepairclock
 phase=phase+gameLevel+4
 rem Skeleton fractional cadence increases at each game level.
 if phase<15 then chased
 phase=phase-15
 goto pursue
slimepairclock
 if wallDirection>128 then phase=phase+1
slimeclock
 if phase>=80 then phase=0
 if phase>=56 && phase<80 then goto slimelunge
 tx=phase&7
 if tx>=gameLevel then chased
pursue
 if !wallGap{3} then gosub wanderstep bank2:goto chased
 oldx=player1x:oldy=player1y
 temp6=1
 if wallDirection>128 then temp6=2
 if navDir>2 then chasey
 if player1x=player0x then chasey
 if player1x<player0x then player1x=player1x+temp6
 if player1x>player0x then player1x=player1x-temp6
 gosub enemysolid
 if blocked=0 then navDir=0:goto chased
 player1x=oldx
 rem Remember a detour direction until the direct path opens.
 if navDir=0 then navDir=1
 if navDir=1 then player1y=player1y-temp6 else player1y=player1y+temp6
 goto checkenemy
chasey
 if player1y=player0y then navDir=0:goto chased
 if player1y<player0y then player1y=player1y+temp6
 if player1y>player0y then player1y=player1y-temp6
 gosub enemysolid
 if blocked=0 then navDir=0:goto chased
 player1y=oldy
 if navDir<3 then navDir=3
 if navDir=3 then player1x=player1x-temp6 else player1x=player1x+temp6
checkenemy
 gosub enemysolid
 if blocked=0 then chased
 player1x=oldx:player1y=oldy
 if navDir>2 then navDir=7-navDir:goto chased
 navDir=3-navDir
returnchase

chased
 if alive=0 then enemyupdated
 if roomType=3 then gosub swaplocal:roomType=2:goto enemyupdated

enemyupdated
 missile0y=200:NUSIZ0=$10
 if boltLife=0 then contact
 boltLife=boltLife-1
 rem Direction is captured on cast, independent of later wizard movement.
 if boltDir=0 then boltY=boltY-2
 if boltDir=1 then boltY=boltY+2
 if boltDir=2 then boltX=boltX-2
 if boltDir=3 then boltX=boltX+2
 if boltX<20 then gosub dissipate:goto contact
 if boltX>139 then gosub dissipate:goto contact
 if boltY<11 then gosub dissipate:goto contact
 if boltY>95 then gosub dissipate:goto contact
 tx=boltX:ty=boltY:gosub spellsolid
 if blocked then gosub dissipate:goto contact
 missile0x=boltX:missile0y=boltY
 if alive=0 then contact
 gosub enemyhit bank4
 if blocked=0 then contact
 if blocked=1 then gosub dissipate:goto contact
 gosub dissipate

enemydefeated
 roomCleared=1
 alive=0:navDir=0:phase=0:fireAge=0:missile1y=128
 gosub unlock:gosub dissipate
 AUDC0=8:AUDF0=4:AUDV0=5

contact
 if alive=0 then exits
 if grace>0 then exits
 gosub enemycontact bank4
 if blocked=0 then exits

hurt
 if roomCleared=1 && roomType<>4 then exits
 if alive=0 && roomType<>4 then exits
 if grace>0 then exits
 tx=1
 if alive>=1 && alive<=3 then gosub ordinarydamage bank4
 if hp<=tx then hp=0 else hp=hp-tx
 grace=90
 asm
 lda #$3C
 sta score+2
end
 if hp>0 then exits
 lifeCount=lifeCount-1
 if lifeCount=0 then dead=1:goto render
 hp=5
 rem Finish this combat frame before copying a respawn room in fresh blanking.
 drawscreen
 if roomType=4 then gosub traproom:goto exits
 if alive>=128 then gosub dragonroom:goto exits
 oldx=alive:gosub arena:alive=oldx
 if alive=2 then wallDirection=128
exits
 if alive then render
 if player0y<45 then render
 if player0y>63 then render
 if player0x<21 then changeroom
 if player0x>131 then changeroom
 goto render
changeroom
 rem Finish this movement frame; build the next room in a fresh blank interval.
 drawscreen
 gosub nextroom
render
 COLUBK=$00:COLUPF=$06:COLUP0=$AE:COLUP1=$0E:tint=$0E
 if roomType=4 then gosub traplook bank2
 REFP0=0:REFP1=0:NUSIZ1=$10
 if facing=2 then REFP0=8
 if grace>0 && tick{2} then COLUP0=$00
 player1height=7

spritesdone
 if alive=2 || alive=3 then gosub critterpicture bank2:goto drawactors
 if alive>=128 then dragonpicture
 if navDir>=4 && alive=0 then merchant
 if alive then drawactors
 player1x=112:player1y=81:COLUP1=$1E:tint=$1E
 if phase>0 then phase=phase-1
 if navDir=2 && phase>0 then COLUP1=$CA:tint=$CA
 if navDir=3 && phase>0 then COLUP1=$6C:tint=$6C
 if navDir>0 then openedchest
 player1:
 %11111111
 %10000001
 %10100101
 %11111111
 %10011001
 %11111111
 %01111110
 %00111100
end
 goto drawactors
openedchest
 player1:
 %11111111
 %10000001
 %10000001
 %00000000
 %00000000
 %10000001
 %10000001
 %01111110
end
drawactors
 drawscreen
 goto main
fire
 held=1
 if navDir>=4 && alive=0 then buy
 if alive=0 && navDir=0 && player0x>=100 && player0x<=124 && player0y>=68 then openchest
 if cooldown>0 then return
 if boltLife>0 then return
 boltLife=64
 cooldown=12:boltDir=facing
 boltX=player0x+3:boltY=player0y-3
 AUDC0=4:AUDF0=12:AUDV0=5
 return
enemysolid
 tx=player1x:ty=player1y:gosub solid
 return

solid
 blocked=0
 if ty<17 then blocked=1:return
 if ty>89 then blocked=1:return
 if tx<20 then blocked=1:return
 if tx>132 then blocked=1:return
 if alive=0 && ty>=45 && ty<=63 then goto tiles
 if tx<24 then blocked=1:return
 if tx>128 then blocked=1:return
tiles
 if roomType=4 then return
 if navDir>=4 && alive=0 then return
 rem Sprite box: x..x+7, bottom y with height 8. Check every covered cell.
 rightCol=tx+7:rightCol=rightCol-16:rightCol=rightCol/4
 asm
 ldx ty
 lda RoomRowIndex,x
 sta bottomRow
end
 tx=tx-16:tx=tx/4
 ty=ty-7
 asm
 ldx ty
 lda RoomRowIndex,x
 sta ty
end
 goto tilebox
spellsolid
 blocked=0
 if ty<9 || ty>=90 then blocked=1:return
 rightCol=tx+1:rightCol=rightCol-16:rightCol=rightCol/4
 asm
 ldx ty
 lda RoomRowIndex,x
 sta bottomRow
end
 tx=tx-16:tx=tx/4
 ty=ty-1
 asm
 ldx ty
 lda RoomRowIndex,x
 sta ty
end
tilebox
 rem Direct local tile reads avoid repeated cross-bank pfread calls.
 asm
 ldx tx
TileBoxColumn
 txa
 lsr
 lsr
 lsr
 sta temp1
 lda ty
 asl
 asl
 clc
 adc temp1
 tay
 lda TileBoxMask,x
 and playfield,y
 bne TileBoxBlocked
 lda ty
 cmp bottomRow
 beq TileBoxNext
 lda TileBoxMask,x
 and playfield+4,y
 bne TileBoxBlocked
TileBoxNext
 inx
 cpx rightCol
 bcc TileBoxColumn
 beq TileBoxColumn
 rts
TileBoxBlocked
 lda #1
 sta blocked
 rts
TileBoxMask
 .byte $80,$40,$20,$10,$08,$04,$02,$01
 .byte $01,$02,$04,$08,$10,$20,$40,$80
 .byte $80,$40,$20,$10,$08,$04,$02,$01
 .byte $01,$02,$04,$08,$10,$20,$40,$80
RoomRowIndex
 .byte 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1
 .byte 1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3
 .byte 3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5
 .byte 5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,7
 .byte 7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8
 .byte 8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10
 .byte 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
 .byte 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10

end


unlock
 asm
 ldx #12
UnlockRow
 lda playfield+16,x
 and #$3F
 sta playfield+16,x
 lda playfield+19,x
 and #$3F
 sta playfield+19,x
 dex
 dex
 dex
 dex
 bpl UnlockRow
end
 return


dissipate
 asm
 lda score+2
 bne FeedbackDissipateDone
 lda #$26
 sta score+2
FeedbackDissipateDone
end
 boltLife=0:missile0y=200
 return

gameover
 asm
 ldx gameLevel
 lda #$A5
 jmp $FFEC
end


openchest
 rem navDir and phase become chest state and reward timer after combat.
 tx=rand:phase=90
 asm
 lda #$8F
 sta score+2
end
 if tx<160 then chestgold
 if tx<224 then chestheal
 if tx>=240 then chestarmor
 tx=gameLevel*5:tx=tx-1
 if upgrades>=tx then bonusgold
 upgrades=upgrades+1:navDir=3
 return
chestarmor
 tx=gameLevel*5
 if armor>=tx then bonusgold
 armor=armor+1:navDir=2
 return
chestheal
 if hp=5 then bonusgold
 hp=hp+2
 if hp>5 then hp=5
 navDir=2
 return
chestgold
bonusgold
 gosub chestcoins bank2
addgold
 gold=gold+tx
 if gold>25 then gold=25
 navDir=1
 return

nextroom
 asm
 lda rand
 bne RoomSeedReady
 lda #$B4
 sta rand
RoomSeedReady
end
 rem Unbiased 0-99 roll from the 255-state generator (reject excess).
 tx=rand:tx=tx-1
 if tx>=200 then nextroom
 if tx>=100 then tx=tx-100
 if tx<SHOP_CHANCE then shoproom
 if tx<DRAGON_THRESHOLD then dragonroom
 if tx<TRAP_THRESHOLD then traproom
 layout=rand&7:gosub arena
 gosub chooseenemy bank2
 return
shoproom
 layout=7:gosub arena
 roomCleared=1
 alive=0:navDir=4:phase=0:player0x=36:player0y=70
 rem ShopTiles already contains both open exits.
 gosub shopsigns bank2
 return
merchant
 player1x=77:player1y=53:COLUP1=$2E:tint=$2E
 if phase>0 then phase=phase-1
 if navDir=5 && phase>0 then COLUP1=$CA:tint=$CA
 if navDir>=6 && phase>0 then COLUP1=$46:tint=$46
 if phase=0 then navDir=4
 player1:
 %01111110
 %00111100
 %01111110
 %10111101
 %00111100
 %01011010
 %00111100
 %01111110
end
 goto drawactors
buy
 navDir=6:phase=60
 asm
 lda #$7A
 sta score+2
end
 if player0x<64 then buywand
 if player0x>=96 then buyarmor
 if hp=5 then return
 if gold<5 then navDir=7:return
 gold=gold-5:hp=5
 goto bought
buywand
 tx=gameLevel*5:tx=tx-1
 if upgrades>=tx then return
 if gold<15 then navDir=7:return
 gold=gold-15:upgrades=upgrades+1
 goto bought
buyarmor
 navDir=6:phase=60
 tx=gameLevel*5
 if armor>=tx then return
 if gold<15 then navDir=7:return
 gold=gold-15:armor=armor+1
bought
 navDir=5
 asm
 lda #$6F
 sta score+2
end
 return

dragonroom
 rem Save only persistent character data; the old room can be discarded.
 asm
 lda hp
 sta $F0
 lda lifeCount
 sta $F1
 lda gold
 sta $F2
 lda upgrades
 sta $F3
 lda rand
 sta $F4
 lda gameLevel
 sta $F6
 lda armor
 sta $F7
 lda #$DA
 sta $F5
 jmp $FFBA
end

dragonresume
 rem Reinitialize the BASIC renderer while preserving the six-byte mailbox.
 asm
 sei
 cld
 ldx #$FF
 txs
 lda #0
 ldx #$EF
MainResumeClear
 sta 0,x
 dex
 cpx #$7F
 bne MainResumeClear
 ldx #$2C
MainResumeTIA
 sta 0,x
 dex
 cpx #4
 bcs MainResumeTIA
 lda #2
 sta VBLANK
 lda $F0
 sta hp
 lda $F1
 sta lifeCount
 lda $F2
 sta gold
 lda $F3
 sta upgrades
 lda $F6
 sta gameLevel
 lda $F7
 sta armor
 lda $F4
 bne MainResumeSeed
 lda #$B4
MainResumeSeed
 sta rand
 lda #0
 sta $F5
 lda #9
 sta playfieldpos
 lda #<scoretable
 ldx #5
MainResumeScore
 sta scorepointers,x
 dex
 bpl MainResumeScore
 lda #1
 sta CTRLPF
 lda $F8
 sta score+2
end
 gosub nextroom
 goto main

slimelunge
 oldx=player1x:oldy=player1y
 gosub slimemove
 tx=tick&7:ty=gameLevel-1
 if tx<ty then gosub slimeadvance
 gosub enemysolid
 if blocked then player1x=oldx:player1y=oldy
 goto chased

traproom
 layout=7:gosub arena
 alive=0:roomCleared=1:roomType=4:fireAge=16:wallDirection=200:grace=0
 wallGap=rand&3:wallGap=wallGap+203
 gosub unlock
 return

dragonpicture
 goto dragonroom

slimemove
 rem Lock lunge direction once; the wizard can sidestep the charge.
 if phase=56 then slimeaim
 if phase=57 && wallDirection>128 then slimeaim
 goto slimeadvance
slimeaim
 if !wallGap{3} then fireAge=wallGap&3:goto slimeadvance
 fireAge=2
 if player1x<player0x then fireAge=3
 if player1x=player0x then fireAge=0
 if player1x=player0x && player1y<player0y then fireAge=1
slimeadvance
 tx=1
 if wallDirection>128 then tx=2
 if fireAge=0 then player1y=player1y-tx
 if fireAge=1 then player1y=player1y+tx
 if fireAge=2 then player1x=player1x-tx
 if fireAge=3 then player1x=player1x+tx
 return
enemybrain
 asm
 lda alive
 cmp #2
 beq EnemyBrainDone
 lda tick
 and #63
 ldx roomType
 cpx #3
 bne EnemyBrainSchedule
 eor #33
EnemyBrainSchedule
 bne EnemyBrainDone
 lda rand
 lsr
 bcc EnemyBrainRandom
 eor #$B4
EnemyBrainRandom
 sta rand
 and #7
 sta tx
 lda wallGap
 eor #8
 and #248
 ora tx
 sta wallGap
 lda alive
 cmp #3
 beq EnemyBrainKeepLunge
 lda #0
 sta phase
EnemyBrainKeepLunge
 lda #0
 sta navDir
EnemyBrainDone
 rts
end
 asm
MonsterHealth
 .byte 5,19,30,37,71
end
 asm
.swaplocal
 include "enemy-swap-body.asm"
end
 bank 2
shopsigns
 asm
 ldy #43
ShopCopy
 lda ShopTiles,y
 sta playfield,y
 dey
 bpl ShopCopy
end
 return otherbank
 asm
ShopTiles
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF

end

wanderstep
 oldx=player1x:oldy=player1y
 temp6=1
 if wallDirection>128 then temp6=2
 tx=wallGap&3
 if tx=0 then player1y=player1y-temp6
 if tx=1 then player1y=player1y+temp6
 if tx=2 then player1x=player1x-temp6
 if tx=3 then player1x=player1x+temp6
 gosub enemysolid bank1
 if blocked then player1x=oldx:player1y=oldy:wallGap=wallGap^1
 return otherbank

batstep
 rem Random eight-way flight. Never reads Wiz's position or pursues him.
 tx=tick
 if wallDirection>128 then tx=tx/2
 tx=tx&7:ty=gameLevel+3
 if tx>=ty then return otherbank
 if phase=0 then tx=rand:navDir=tx&7:phase=24
 phase=phase-1
 asm
 ldx navDir
 lda BatDirectionX,x
 clc
 adc player1x
 ldy wallDirection
 cpy #129
 bcc BatSingleStepX
 clc
 adc BatDirectionX,x
BatSingleStepX
 cmp #24
 bcc BatLeftEdge
 cmp #129
 bcc BatXReady
 lda #128
 bne BatNewDirectionX
BatLeftEdge
 lda #24
BatNewDirectionX
 pha
 lda wallGap
 eor #3
 sta wallGap
 pla
 ldy #0
 sty phase
BatXReady
 sta player1x
 lda BatDirectionY,x
 clc
 adc player1y
 ldy wallDirection
 cpy #129
 bcc BatSingleStepY
 clc
 adc BatDirectionY,x
BatSingleStepY
 cmp #17
 bcc BatTopEdge
 cmp #90
 bcc BatYReady
 lda #89
 bne BatNewDirectionY
BatTopEdge
 lda #17
BatNewDirectionY
 pha
 lda wallGap
 eor #3
 sta wallGap
 pla
 ldy #0
 sty phase
BatYReady
 sta player1y
 jmp BatFlightDone
BatDirectionX .byte 1,255,1,255,0,0,1,255
BatDirectionY .byte 1,1,255,255,1,255,0,0
BatFlightDone
end
 return
chooseenemy
 asm
 lda rand
 bne EnemySeedReady
 lda #$B4
 sta rand
EnemySeedReady
end
 tx=rand:tx=tx-1
 if tx>=252 then chooseenemy
choosekind
 if tx<89 then alive=1:return otherbank
 if tx<163 then alive=2:wallDirection=128:return otherbank
 alive=3
 return otherbank

chestcoins
 rem Exact 50/40/10 split: unbiased 0..199, two copies of 0..99.
 tx=rand:tx=tx-1
 if tx>=200 then chestcoins
 if tx>=100 then tx=tx-100
 if tx<50 then tx=0:return otherbank
 if tx<90 then tx=1:return otherbank
 tx=2:return otherbank

critterpicture
 player1height=7
 COLUP1=$6C:tint=$6C
 if alive=2 then return otherbank
 COLUP1=$CA:tint=$CA
 if phase>=44 && phase<80 then COLUP1=$1E:tint=$1E
 return otherbank

trapstep
 blocked=0
 rem A continuous vertical fire wall sweeps sideways, leaving one 27-pixel gap.
 tx=tick&7
 if tx>0 then firecollision
 pfvline fireAge 1 9 off
 if wallDirection=200 then fireAge=fireAge-1 else fireAge=fireAge+1
 if fireAge<=4 then wallDirection=201
 if fireAge>=27 then wallDirection=200
firecollision
 if grace>0 then return otherbank
 tx=fireAge*4:tx=tx+16
 if player0x+7<tx then return otherbank
 tx=tx+3
 if player0x>tx then return otherbank
 asm
 lda wallGap
 sec
 sbc #200
 sta ty
 asl
 asl
 asl
 clc
 adc ty
 sta ty
end
 bottomRow=ty+27
 ty=ty+7
 if player0y>=ty && player0y<bottomRow then return otherbank
 blocked=1
 return otherbank
traplook
 COLUPF=$46
 if tick{2} then COLUPF=$3E
 rem Draw the same nine cells locally, avoiding cross-bank pixel calls.
 asm
 ldx fireAge
 lda FirewallBits,x
 sta temp1
 eor #255
 sta temp2
 txa
 lsr
 lsr
 lsr
 clc
 adc #4
 tay
 lda wallGap
 sec
 sbc #200
 sta tx
 clc
 adc #3
 sta ty
 ldx #1
FirewallDrawRow
 cpx tx
 bcc FirewallDrawOn
 cpx ty
 bcs FirewallDrawOn
 lda playfield,y
 and temp2
 jmp FirewallDrawStore
FirewallDrawOn
 lda playfield,y
 ora temp1
FirewallDrawStore
 sta playfield,y
 iny
 iny
 iny
 iny
 inx
 cpx #10
 bne FirewallDrawRow
 jmp FirewallDrawDone
FirewallBits
 .byte $80,$40,$20,$10,$08,$04,$02,$01
 .byte $01,$02,$04,$08,$10,$20,$40,$80
 .byte $80,$40,$20,$10,$08,$04,$02,$01
 .byte $01,$02,$04,$08,$10,$20,$40,$80
FirewallDrawDone
end
 return otherbank

roomwalls
 asm
 ldx layout
 lda RoomTileLow,x
 sta aux1
 lda RoomTileHigh,x
 sta aux2
 ldy #0
RoomTileCopy
 lda (aux1),y
 sta playfield,y
 iny
 lda (aux1),y
 sta playfield,y
 iny
 lda (aux1),y
 sta playfield,y
 iny
 lda (aux1),y
 sta playfield,y
 iny
 cpy #44
 bne RoomTileCopy
end
 return otherbank
 asm
RoomTileLow
 .byte <RoomTiles0,<RoomTiles1,<RoomTiles2,<RoomTiles3,<RoomTiles4,<RoomTiles5,<RoomTiles6,<RoomTiles7
RoomTileHigh
 .byte >RoomTiles0,>RoomTiles1,>RoomTiles2,>RoomTiles3,>RoomTiles4,>RoomTiles5,>RoomTiles6,>RoomTiles7
RoomTiles0
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0
 .byte $C0,$F0,$00,$C0,$C0,$F0,$00,$C0,$C0,$F0,$00,$C0,$C0,$00,$00,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles1
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$1C,$00,$C0
 .byte $C0,$1C,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$07,$C0,$C0,$00,$07,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles2
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$0E,$07,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$0E,$07,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles3
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$F0,$80,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$7C,$C0,$C0,$00,$00,$C0,$C0,$7C,$00,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles4
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0
 .byte $C0,$F0,$F0,$C0,$C0,$F0,$F0,$C0,$C0,$F0,$F0,$C0,$C0,$00,$00,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles5
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$FC,$FE,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$FC,$FE,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles6
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$C0,$C0,$C0,$00,$C0,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$C0,$C0
 .byte $C0,$00,$C0,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
RoomTiles7
 .byte $FF,$FF,$FF,$FF,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0,$C0,$00,$00,$C0
 .byte $C0,$00,$00,$C0,$C0,$00,$00,$C0,$FF,$FF,$FF,$FF
end

 asm
 include "shop-arena.asm"
end
 bank 3
 asm
 include "custom_arena.asm"
end
 bank 4

 asm
 include "combat-feedback.asm"
 include "enemy-combat.asm"
 include "enemy-state.asm"
 include "hud.asm"
end

