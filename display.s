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
andi	a1, a1, 1		# mascara o primeiro bit de a1
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


# Desenha o cursor na tela
# Parametros:
# a0 - posicao x do cursor
# a1 - posicao y do cursor
# a2[0] - o frame onde a imagem vai ser escrita
DRAW_CURSOR:
addi	sp, sp, -4
sw	ra, 0(sp)

li	t0, 21
mul	t1, a0, t0
mul	t2, a1, t0
addi	t2, t2, 11
la	a0, cursor
mv	a1, a2
li	a2, 22
li	a3, 22
mv	a4, t1
mv	a5, t2
jal	DRAW_IMAGE

lw	ra, 0(sp)
addi	sp, sp, 4
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
addi	a0, a0, 8
andi	a1, a1, 1
slli	a1, a1, 20
or	t0, t0, a1
add	t0, t0, a4
li	t1, 320
mul	t1, t1, a5
add	t0, t0, t1

li	t2, 0
li	t3, 0

DRAW_IMAGE_LOOP1:
lb	t1, 0(a0)
sb	t1, 0(t0)
addi	a0, a0, 1
addi	t0, t0, 1
addi	t2, t2, 1

blt	t2, a2, DRAW_IMAGE_LOOP1

li	t2, 0
sub	t0, t0, a2
addi	t0, t0, 320
addi	t3, t3, 1

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
