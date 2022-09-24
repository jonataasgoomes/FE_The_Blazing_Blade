.eqv	MMIO_DISPLAY_START, 0xff000000	# endereco do primeiro pixel do display (frame 0)
.eqv	MMIO_DISPLAY_END, 0xff012bff	# fim do primeiro pixel do display (frame 0)

.text

# Desenha um plano de fundo 320x240
# Parametros:
# a0 - endereco da imagem de fundo
# a1[0] - frame onde a imagem vai ser escrita
DRAW_BACKGROUND:	
li	t0, MMIO_DISPLAY_START	
li	t1, MMIO_DISPLAY_END
addi	a0, a0, 8			# pula os dados de tamanho da imagem
andi	a1, a1, 1			# mascara o primeiro bit de a1
beqz	a1, DRAW_BACKGROUND_LOOP1	# otimizacao: pula as instrucoes a seguir se o frame for 0
slli	a1, a1, 5			# desloca o bit do frame para a posicao correta
or	t0, t0, a1			# seleciona o frame
or	t1, t1, a1			# seleciona o frame

DRAW_BACKGROUND_LOOP1:
bge	t0, t1, DRAW_BACKGROUND_END1
lw	t2, 0(a0)			# carrega uma word da imagem
sw	t2, 0(t0)			# escreve a word no display
addi	t0, t0, 4			# vai para a proxima word da imagem
addi	a0, a0, 4			# vai para a proxima word do display
j	DRAW_BACKGROUND_LOOP1		

DRAW_BACKGROUND_END1:
ret
