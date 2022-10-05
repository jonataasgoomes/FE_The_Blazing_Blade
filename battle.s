.text

# Parametros:
# a0 - endereco do plano de fundo
# a1 - ID do aliado
# a2 - ID do inimigo
# Retorno:
# a0 - 0: vitoria do aliado, 1: vitoria do inimigo, 2: empate
BATTLE_SCENE:
addi	sp, sp, -16
sw	ra, 0(sp)
sw	s0, 4(sp)
sw	s1, 8(sp)
sw	s2, 12(sp)

mv	s0, a1			# ID do aliado
mv	s1, a2			# ID do inimigo
mv	s2, a3

li	t0, MMIO_DISPLAY_FRAME
li	t1, 1			# frame 1
sw	t1, 0(t0)		# troca para o frame 1

li	a1, 0			# frame 0
jal	DRAW_BACKGROUND		# desenha o plano de fundo

mv	a0, s0			# ID do aliado
li	a1, 0			# frame 0
li	a4, 50			# posicao x
li	a5, 100			# posicao y
jal	DRAW_CHARACTER_BATTLE

mv	a0, s1			# ID do inimigo
li	a1, 0			# frame 0
li	a4, 250			# posicao x
li	a5, 100			# posicao y
jal	DRAW_CHARACTER_BATTLE

li	t0, MMIO_DISPLAY_FRAME
li	t1, 0			# frame 0
sw	t1, 0(t0)		# troca para o frame 0

mv	a0, s0			# ID do aliado
mv	a1, s1			# ID do inimigo
jal	GET_WINNER
mv	t6, a0			# vencedor

li	t0, 0
li	t1, 1

beq	a0, t0, BATTLE_SCENE_VICTORY
beq	a0, t1, BATTLE_SCENE_DEFEAT
j	BATTLE_SCENE_TIE

BATTLE_SCENE_VICTORY:
la	a0, MSG_VICTORY
li	a7, 104			# imprime string na tela
li	a1, 128			# posicao x
li	a2, 200			# posicao y
li	a3, 0xC738		# cor
li	a4, 0			# frame 0
ecall

j	BATTLE_SCENE_CONTINUE1

BATTLE_SCENE_DEFEAT:
la	a0, MSG_DEFEAT
li	a7, 104			# imprime string na tela
li	a1, 130			# posicao x
li	a2, 200			# posicao y
li	a3, 0xC707		# cor
li	a4, 0			# frame 0
ecall

j	BATTLE_SCENE_CONTINUE1

BATTLE_SCENE_TIE:
la	a0, MSG_TIE
li	a7, 104			# imprime string na tela
li	a1, 132			# posicao x
li	a2, 200			# posicao y
li	a3, 0xC7FF		# cor
li	a4, 0			# frame 0
ecall

BATTLE_SCENE_CONTINUE1:
csrr	t0, time
li	t2, 3000		# 3 segundos

BATTLE_SCENE_LOOP1:
csrr	t1, time
sub	t1, t1, t0		# duracao da tela
bgt	t1, t2, BATTLE_SCENE_END1
j	BATTLE_SCENE_LOOP1

BATTLE_SCENE_END1:
mv	a0, t6
mv	a1, s0
mv	a2, s1
mv	a3, s2

lw	ra, 0(sp)
lw	s0, 4(sp)
lw	s1, 8(sp)
lw	s2, 12(sp)
addi	sp, sp, 16
ret
