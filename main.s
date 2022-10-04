.eqv	TRUE, 1
.eqv	FALSE, 0

.include	"MACROSv21.s"

.data
cursor_x:	.word	0
cursor_y:	.word	0
selected:	.word	0

MSG_VICTORY:	.string	"Vitoria"
MSG_DEFEAT:	.string	"Derrota"
MSG_TIE:	.string	"Empate"

.text

MAIN:	
jal 	START
jal	LEVEL1
li 	a7, 10		# finaliza a execucao
ecall

.include	"start.s"
.include	"level1.s"
.include 	"keyboard.s"
.include 	"display.s"
.include	"battle.s"
.include	"game_over.s"
.include 	"sound.s"
.include        "character.s"
.include	"SYSTEMv21.s"
