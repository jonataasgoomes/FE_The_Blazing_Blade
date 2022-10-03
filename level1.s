.data
.include	"map1.data"
.include	"map1_tiles.data"
.include	"level1music.data"

.text

LEVEL1:
addi	sp, sp, -20
sw	ra, 0(sp)		# empilha ra
sw	s0, 4(sp)		# empilha s0
sw	s1, 8(sp)		# empilha s1
sw	s2, 12(sp)		# empilha s2
sw	s3, 16(sp)		# empilha s3

la	a0, map1		# carrega a imagem 'map1'
li	a1, 0			# frame 0
jal	DRAW_BACKGROUND		

la	s0, cursor_x
la	s1, cursor_y
li	s2, 1			# o frame a ser escrito (aquele que nao esta sendo exibido)
li	s3, 0			# inicia o contador de notas

LEVEL1_LOOP1:
jal	KEYBOARD_INPUT
beqz	a0, LEVEL1_CONTINUE1
mv	a0, a1			# carrega a tecla pressionada
la	a1, map1_tiles
jal	HANDLE_INPUT	

LEVEL1_CONTINUE1:
la	a0, map1		# carrega a imagem 'map1'
mv	a1, s2			# frame a ser escrito
jal	DRAW_BACKGROUND		

################ TESTE ###############
li	a0, 2
mv	a1, s2
li	a2, 0
li	a4, 3
li	a5, 3
jal	DRAW_CHARACTER

li	a0, 3
mv	a1, s2
li	a2, 0
li	a4, 4
li	a5, 3
jal	DRAW_CHARACTER

li	a0, 4
mv	a1, s2
li	a2, 0
li	a4, 5
li	a5, 3
jal	DRAW_CHARACTER
######################################

mv	a0, s2
jal	DRAW_CURSOR
jal	SWITCH_FRAMES
mv	s2, a0			# atualiza o frame a ser escrito

la	t0, LEVEL1_MUSIC	# carrega o endereco da musica
addi	a0, t0, 4		# pula a word de numero de notas
mv	a1, s3			# indice da nota
li	a2, 0			# instrumento
li	a3, 127			# volume
jal	PLAY_NOTE

add	s3, s3, a0		# incrementa o contador se a nota foi tocada
la	t0, LEVEL1_MUSIC
lw	t0, 0(t0)
blt	s3, t0, LEVEL1_CONTINUE2
li	s3, 0			# se todas as notas foram tocadas, zera o contador

LEVEL1_CONTINUE2:
j	LEVEL1_LOOP1

lw	ra, 0(sp)		# desempilha ra
lw	s0, 4(sp)		# desempilha s0
lw	s1, 8(sp)		# desempilha s1
lw	s2, 12(sp)		# desempilha s2
lw	s3, 16(sp)		# desempilha s3
addi	sp, sp, 20
ret
