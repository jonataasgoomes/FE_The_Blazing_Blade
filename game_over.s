.data
.include 	"game_over_screen.data"
.include	"gameovermusic.data"

.text

# Tela de fim de jogo
GAME_OVER:
li	t0, MMIO_DISPLAY_FRAME
li	t1, 1
sw	t1, 0(t0)		# troca para o frame 1

la	a0, GAME_OVER_SCREEN
li	a1, 0
jal	DRAW_BACKGROUND

li	t0, MMIO_DISPLAY_FRAME
li	t1, 0
sw	t1, 0(t0)		# troca para o frame 0

li	t6, 0

GAME_OVER_LOOP1:
jal	KEYBOARD_INPUT
bnez	a0, GAME_OVER_END1

la	t0, GAME_OVER_MUSIC	# carrega o endereco da musica
addi	a0, t0, 4		# pula a word de numero de notas
mv	a1, t6			# indice da nota
li	a2, 0			# instrumento
li	a3, 127			# volume
jal	PLAY_NOTE

add	t6, t6, a0		# incrementa o contador se a nota foi tocada
la	t0, GAME_OVER_MUSIC
lw	t0, 0(t0)
blt	t6, t0, GAME_OVER_CONTINUE1
li	t6, 0			# se todas as notas foram tocadas, zera o contador

GAME_OVER_CONTINUE1:
j	GAME_OVER_LOOP1

GAME_OVER_END1:
li	a7, 10
ecall
