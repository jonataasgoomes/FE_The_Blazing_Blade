.data
.include	"map1.data"
.include	"map1_tiles.data"

.text

LEVEL_1:
addi	sp, sp, -4
sw	ra, 0(sp)	# empilha o endereco de retorno
la	a0, map1	# carrega a imagem
li	a1, 0		# frame 0
jal	DRAW_BACKGROUND
lw	ra, 0(sp)	# desempilha o endereco de retorno
addi	sp, sp, 4
j	LEVEL_1	
ret
