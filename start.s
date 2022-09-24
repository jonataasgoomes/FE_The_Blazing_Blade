.data
.include 	"start1.data"
.include 	"startmusic.data"

.text	
START:
addi	sp, sp, -4		
sw	ra, 0(sp)		# empilha o endereco de retorno
la	a0, start1		# carrega a imagem
li	a1, 0			# seleciona o frame 0
jal	DRAW_BACKGROUND		
li	t0, 0			# inicia o contador de notas

START_LOOP1:
jal	KEYBOARD_INPUT
bnez	a0, START_END1		# se qualquer tecla foi pressionada, termina o loop do start
la	a0, start_music		# carrega a musica
lw	t1, 0(a0)		# carrega o numero de notas
addi	a0, a0, 4		# pula o dado de numero de notas
mv	a1, t0			# carrega o indice da nota
li	a2, 1			# define o instrumento
li	a3, 127			# define o volume
addi	sp, sp, -4
sw	a0, 0(sp)		# empilha a0
jal 	PLAY_MUSIC
lw	a0, 0(sp)		# desempilha a0
addi	sp, sp, 4
addi	t0, t0, 1		# incrementa o contador de notas
blt	t0, t1, START_LOOP1	# quando a musica terminar, toca novamente	
li	t0, 0
j 	START_LOOP1

START_END1:
lw	ra, 0(sp)		# desempilha o endereco de retorno
addi	sp, sp, 4
ret
