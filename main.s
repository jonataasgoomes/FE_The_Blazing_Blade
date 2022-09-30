.eqv	TRUE, 1
.eqv	FALSE, 0

.data
.include	"cursor.data"

cursor_x:	.word	0
cursor_y:	.word	0
selected:	.word	-1

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
.include 	"sound.s"
.include	"MACROSv21.s"
.include	"SYSTEMv21.s"
