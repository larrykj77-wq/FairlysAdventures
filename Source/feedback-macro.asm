; Event cues have priority. Optional quiet enemy calls use the other channel.
 MAC MAIN_FEEDBACK
 lda score+2
 and #15
 beq .Clear
 lda score+2
 lsr
 lsr
 lsr
 lsr
 tax
 lda .Controls,x
 sta AUDC1
 lda score+2
 and #8
 beq .SecondNote
 lda .FirstNotes,x
 bne .Pitch
.SecondNote
 lda .LastNotes,x
.Pitch
 sta AUDF1
 lda #5
 sta AUDV1
 dec score+2
 jmp .Done
.Clear
 lda #0
 sta score+2
 IF {1}
 lda cooldown
 cmp #9
 bcs .Done
 lda tick
 and #63
 cmp #6
 bcs .Done
 lda alive
 beq .Done
 cmp #4
 bcs .Done
 cmp #2
 beq .Bat
 cmp #3
 beq .Slime
 lda #8
 sta AUDC0
 lda #20
 bne .EnemyPitch
.Bat
 lda #4
 sta AUDC0
 lda tick
 and #2
 clc
 adc #2
 bne .EnemyPitch
.Slime
 lda #6
 sta AUDC0
 lda tick
 and #3
 clc
 adc #24
.EnemyPitch
 sta AUDF0
 lda #2
 sta AUDV0
 ENDIF
 jmp .Done
.Controls
 .byte 0,4,8,3,4,4,4,3,4,4
.FirstNotes
 .byte 0,3,20,14,1,3,6,24,10,12
.LastNotes
 .byte 0,3,20,14,1,3,3,24,4,4
.Done
 ENDM
