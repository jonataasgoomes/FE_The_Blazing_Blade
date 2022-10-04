.data
.include	"cursor.data"
.include	"cursor_blue.data"
.include	"cursor_red.data"

.eqv	MMIO_DISPLAY_START, 0xff000000	# endereco do primeiro pixel do display (frame 0)
.eqv	MMIO_DISPLAY_END, 0xff012bff	# fim do primeiro pixel do display (frame 0)
.eqv	MMIO_DISPLAY_FRAME, 0xff200604	# endereco que define o frame do display

.text

# Desenha um plano de fundo 320x240
# Parametros:
# a0 - endereco da imagem de fundo
# a1[0] - frame onde a imagem vai ser escrita
DRAW_BACKGROUND:	
li	t0, MMIO_DISPLAY_START	
li	t1, MMIO_DISPLAY_END

addi	a0, a0, 8		# pula os dados de tamanho da imagem
andi	a1, a1, 1		# mascara o bit do frame
slli	a1, a1, 20		# desloca o bit do frame para a posicao correta

or	t0, t0, a1		# seleciona o frame
or	t1, t1, a1		# seleciona o frame

DRAW_BACKGROUND_LOOP1:
bge	t0, t1, DRAW_BACKGROUND_END1

lw	t2, 0(a0)		# carrega uma word da imagem
sw	t2, 0(t0)		# escreve a word no display

addi	t0, t0, 4		# vai para a proxima word da imagem
addi	a0, a0, 4		# vai para a proxima word do display

j	DRAW_BACKGROUND_LOOP1		

DRAW_BACKGROUND_END1:
ret

# Desenha todos os personagens de um nivel na tela
# Parametros:
# a0 - endereco das tiles do mapa
# a1[0] - o frame onde o personagem vai ser desenhado
DRAW_CHARACTERS:
addi	sp, sp, -16
sw	ra, 0(sp)
sw	s0, 4(sp)
sw	s1, 8(sp)
sw	s2, 12(sp)

li	s0, 0			# contador de tiles
li	s1, 150
addi	s2, a0, 8

DRAW_CHARACTERS_LOOP1:
bge	s0, s1, DRAW_CHARACTERS_END1
lb	a0, 0(s2)

li	t0, 15
remu	a4, s0, t0
divu	a5, s0, t0

addi	sp, sp, -4
sw	a1, 0(sp)

jal	DRAW_CHARACTER

lw	a1, 0(sp)
addi	sp, sp, 4

addi	s0, s0, 1
addi	s2, s2, 1
j	DRAW_CHARACTERS_LOOP1

DRAW_CHARACTERS_END1:
lw	ra, 0(sp)
lw	s0, 4(sp)
lw	s1, 8(sp)
lw	s2, 12(sp)
addi	sp, sp, 16
ret

# Desenha um personagem na tela
# Parametros:
# a0 - ID do personagem
# a1[0] - o frame onde o personagem vai ser desenhado
# a4 - posicao x do personagem
# a5 - posicao y do personagem
DRAW_CHARACTER:
addi	sp, sp, -4
sw	ra, 0(sp)

jal	GET_SPRITE
beqz	a0, DRAW_CHARACTER_END1

lw	a2, 0(a0)
lw	a3, 4(a0)

li	t0, 21
mul	a4, a4, t0
mul	a5, a5, t0	

addi	a4, a4, 5		# pula a borda
addi	a5, a5, 16		# pula a borda
	
jal	DRAW_IMAGE

DRAW_CHARACTER_END1:
lw	ra, 0(sp)
addi	sp, sp, 4
ret


# Desenha um personagem na tela (cena de batalha)
# Parametros:
# a0 - ID do personagem
# a1[0] - o frame onde o personagem vai ser desenhado
# a4 - posicao x da tela
# a5 - posicao y da tela
DRAW_CHARACTER_BATTLE:
addi	sp, sp, -4
sw	ra, 0(sp)

jal	GET_SPRITE_BATTLE
beqz	a0, DRAW_CHARACTER_BATTLE_END1

lw	a2, 0(a0)
lw	a3, 4(a0)

jal	DRAW_IMAGE

DRAW_CHARACTER_BATTLE_END1:
lw	ra, 0(sp)
addi	sp, sp, 4
ret


# Desenha o cursor na tela
# Parametros:
# a0 - endereco das tiles do mapa
# a1[0] - o frame onde o cursor vai ser desenhado
DRAW_CURSOR:
addi	sp, sp, -12
sw	ra, 0(sp)		# empilha ra
sw	s0, 4(sp)		# empilha s0
sw	s1, 8(sp)		# empilha s1

la	s0, cursor_x
la	s1, cursor_y

jal	GET_CURSOR		
li	t0, 21			# tamanho do cursor

li	a2, 21			# largura do cursor
li	a3, 21			# altura do cursor

lw	a4, 0(s0)		# posicao x do cursor
lw	a5, 0(s1)		# posicao y do cursor

mul	a4, a4, t0		# pixel x do cursor
mul	a5, a5, t0		# pixel y do cursor

addi	a4, a4, 2		# pula a borda
addi	a5, a5, 15		# pula a borda

jal	DRAW_IMAGE

lw	ra, 0(sp)		# desempilha ra
lw	s0, 4(sp)		# desempilha s0
lw	s1, 8(sp)		# desempilha s1
addi	sp, sp, 12
ret


# Desenha uma imagem na tela
# Parametros:
# a0 - endereco da imagem
# a1[0] - o frame onde a imagem vai ser escrita
# a2 - largura da imagem (em pixels)
# a3 - altura da imagem (em pixels)
# a4 - posicao x da tela
# a5 - posicao y da tela
DRAW_IMAGE:
li	t0, MMIO_DISPLAY_START

addi	a0, a0, 8		# pula os dados de tamanho da imagem
andi	a1, a1, 1		# mascara o bit do frame
slli	a1, a1, 20		# desloca o bit do frame para a posicao correta

or	t0, t0, a1		# seleciona o frame

add	t0, t0, a4		# coluna onde a imagem vai ser desenhada
li	t1, 320
mul	t1, t1, a5
add	t0, t0, t1		# linha onde a imagem vai ser desenhada

li	t2, 0			# contador de colunas
li	t3, 0			# contador de linhas

DRAW_IMAGE_LOOP1:
lb	t1, 0(a0)		# carrega um pixel da imagem
sb	t1, 0(t0)		# desenha o pixel no display

addi	a0, a0, 1		# vai para o proximo pixel da imagem
addi	t0, t0, 1		# vai para o proximo pixel do display
addi	t2, t2, 1		# incrementa o contador de colunas

blt	t2, a2, DRAW_IMAGE_LOOP1

li	t2, 0			# zera o contador de colunas
sub	t0, t0, a2		
addi	t0, t0, 320		# vai para a proxima linha
addi	t3, t3, 1		# incrementa o contador de linhas

blt	t3, a3, DRAW_IMAGE_LOOP1
ret


# Troca o frame apresentado na tela
# Retorno:
# a0 - o frame antigo
SWITCH_FRAMES:
addi	sp, sp, -8
sw	s0, 0(sp)		# empilha s0
sw	s1, 4(sp)		# empilha s1

li	s0, MMIO_DISPLAY_FRAME
lw	s1, 0(s0)		# carrega o frame exibido na tela
mv	a0, s1			# retorna o frame antigo
xori	s1, s1, 1		# inverte o primeiro bit
sw	s1, 0(s0)		# define o frame a ser exibido

lw	s0, 0(sp)		# desempilha s0
lw	s1, 4(sp)		# desempilha s1
addi	sp, sp, 8
ret 


# Retorna o endereco do cursor, que pode ser amarelo, azul ou vermelho
# Parametros:
# a0 - endereco das tiles do mapa
GET_CURSOR:
la	t0, selected
lw	t0, 0(t0)		# tile selecionada

addi	a0, a0, 8
add	t1, a0, t0		
lb	t0, 0(t1)		# dado da tile selecionada

li	t1, 2			# aliado (espada)
li	t2, 3			# aliado (lanca)
li	t3, 4			# aliado (machado)

beq	t0, t1, GET_CURSOR_MOVEMENT
beq	t0, t2, GET_CURSOR_MOVEMENT
beq	t0, t3, GET_CURSOR_MOVEMENT

la	a0, CURSOR
ret

GET_CURSOR_MOVEMENT:
la	t0, selected
lw	t0, 0(t0)		# tile selecionada

la	t1, cursor_x
lw	t1, 0(t1)		# posicao x do cursor

la	t2, cursor_y
lw	t2, 0(t2)		# posicao y do cursor

li	t3, 15

remu	t4, t0, t3		# posicao x selecionada
divu	t5, t0, t3		# posicao y selecionada

sub	t3, t4, t1		# distancia horizontal
sub	t4, t5, t2		# distancia vertical

mul	t3, t3, t3
mul	t4, t4, t4

add	t5, t4, t3		# distancia quadrada entre o cursor e a tile selecionada

li	t4, 25
bgt	t5, t4, GET_CURSOR_RED

la	t0, selected
lw	t0, 0(t0)		# tile selecionada

li	t3, 15
mul	t3, t3, t2
add	t3, t3, t1		# tile onde o cursor esta

add	t1, a0, t3
lb	t0, 0(t1)		# dado da tile do cursor

bnez	t0, GET_CURSOR_RED

la	a0, CURSOR_BLUE
ret

GET_CURSOR_RED:
la	a0, CURSOR_RED
ret
