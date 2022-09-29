.data
.include	"map1.data"
.include	"map1_tiles.data"

.text

LEVEL1:
addi	sp, sp, -16
sw	ra, 0(sp)		# empilha ra
sw	s0, 4(sp)		# empilha s0
sw	s1, 8(sp)		# empilha s1
sw	s2, 12(sp)		# empilha s2

li	s0, 7			# cursor x
li	s1, 5			# cursor y

la	a0, map1		# carrega a imagem 'map1'
li	a1, 0			# frame 0
jal	DRAW_BACKGROUND		

li	s2, 1			# o frame a ser escrito (aquele que nao esta sendo exibido)

LEVEL1_LOOP1:
jal	KEYBOARD_INPUT
beqz	a0, LEVEL1_CONTINUE1

mv	a2, a1			# carrega a tecla pressionada
mv	a0, s0			# carrega a posicao x do cursor
mv	a1, s1			# carrega a posicao y do cursor
jal	MOVE_CURSOR		
mv	s0, a0			# atualiza a posicao x do cursor
mv	s1, a1			# atualiza a posicao y do cursor

LEVEL1_CONTINUE1:
la	a0, map1		# carrega a imagem 'map1'
mv	a1, s2			# frame a ser escrito
jal	DRAW_BACKGROUND		

mv	a0, s0
mv	a1, s1
mv	a2, s2
mv	a2, s2
jal	DRAW_CURSOR

jal	SWITCH_FRAMES
mv	s2, a0			# atualiza o frame a ser escrito

j	LEVEL1_LOOP1

lw	ra, 0(sp)		# desempilha ra
lw	s0, 4(sp)		# desempilha s0
lw	s1, 8(sp)		# desempilha s1
lw	s2, 12(sp)		# desempilha s2
addi	sp, sp, 16
ret
