; Provided under the CC0 license. See the included LICENSE.txt for details.

; every bank has this stuff at the same place
; this code can switch to/from any bank at any entry point
; and can preserve register values
; note: lines not starting with a space are not placed in all banks
;
; line below tells the compiler how long this is - do not remove
;size=96

begin_bscode
 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha

BS_return
 pha
 txa
 pha
 tsx

 if bankswitch != 64
   lda 4,x ; get high byte of return address

   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif

BS_jsr
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif

; Common integrated-program bridges, mirrored in every physical F4 bank.
; The standard bankswitch prefix above is exactly 32 bytes.
 nop
 nop
MainResetBridge
 bit $1FF8
 jmp $F200
MainDragonBridge
 bit $1FF8
 jmp $F000
MainResumeBridge
 bit $1FF4
 jmp .dragonresume
DragonInitBridge
 bit $1FFA
 jsr DragonLogicStartRoom
 bit $1FF8
 rts
DragonFrameBridge
 bit $1FFB
 jmp DragonDisplayFrame
InterfaceBridge
 bit $1FF7
 jsr minikernel
 bit $1FFB
 rts
DragonAlignedFrameBridge
 bit $1FFB
 jmp DragonDisplaySyncLines
TitleGameBridge
 bit $1FF7
 jmp start
EndingBridge
 bit $1FF8
 jmp $FF68
 ds ($1FF4-(* & $1FFF)),0
