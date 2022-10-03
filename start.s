.data
.include	"start.data"
.include 	"start1.data"
.include 	"startmusic.data"

.text	

# Menu do jogo
START:
addi	sp, sp, -16
sw	ra, 0(sp)		# empilha ra
sw	s0, 4(sp)		# empilha s0
sw	s1, 8(sp)		# empilha s1
sw	s2, 12(sp)		# empilha s2

la	a0, start		# carrega a imagem 'start'
li	a1, 0			# frame 0
jal	DRAW_BACKGROUND

la	a0, start1		# carrega a imagem 'start1'
li	a1, 1			# frame 1
jal	DRAW_BACKGROUND

csrr	s0, time		# tempo da ultima troca de frame
li	s2, 0			# inicia o contador de notas

START_LOOP1:
jal	KEYBOARD_INPUT
bnez	a0, START_END1

csrr	s1, time		# carrega o tempo em milissegundos
li	t0, 800			# tempo para trocar de frame: 800ms
sub	t1, s1, s0		# calcula o tempo decorrido
bltu	t1, t0, START_CONTINUE1

jal	SWITCH_FRAMES
mv	s0, s1			# atualiza o tempo da ultima troca

START_CONTINUE1:
la	t0, START_MUSIC		# carrega o endereco da musica
addi	a0, t0, 4		# pula a word de numero de notas
mv	a1, s2			# indice da nota
li	a2, 0			# instrumento
li	a3, 127			# volume
jal	PLAY_NOTE

add	s2, s2, a0		# incrementa o contador se a nota foi tocada
la	t0, START_MUSIC
lw	t0, 0(t0)
blt	s2, t0, START_CONTINUE2	
li	s2, 0			# se todas as notas foram tocadas, zera o contador

START_CONTINUE2:
j	START_LOOP1

START_END1:
lw	ra, 0(sp)		# desempilha ra
lw	s0, 4(sp)		# desempilha s0
lw	s1, 8(sp)		# desempilha s1
lw	s2, 12(sp)		# desempilha s2
addi	sp, sp, 16
ret
