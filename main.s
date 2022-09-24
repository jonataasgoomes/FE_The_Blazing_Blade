.text

MAIN:	
jal 	START
jal	LEVEL_1
li 	a7, 10		# finaliza a execucao
ecall

.include	"start.s"
.include	"level1.s"
.include 	"keyboard.s"
.include 	"display.s"
.include 	"sound.s"
#.include	"MACROSv21.s"
#.include	"SYSTEMv21.s"
