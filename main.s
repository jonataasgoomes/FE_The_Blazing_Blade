.eqv	TRUE, 1
.eqv	FALSE, 0

.include	"cursor.data"

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
