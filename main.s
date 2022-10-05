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
jal	LEVEL2
jal	LEVEL3
jal	LEVEL4
jal	LEVEL5
jal	GAME_OVER

.include	"start.s"
.include	"level1.s"
.include	"level2.s"
.include	"level3.s"
.include	"level4.s"
.include	"level5.s"
.include 	"keyboard.s"
.include 	"display.s"
.include	"battle.s"
.include	"game_over.s"
.include 	"sound.s"
.include        "character.s"
.include	"SYSTEMv21.s"
