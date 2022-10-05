.eqv	KEYBOARD_MMIO, 0xff200000

.eqv	W, 87
.eqv	A, 65
.eqv	S, 83
.eqv	D, 68
.eqv	X, 88
.eqv	M, 77
.eqv	K, 75
.eqv	w, 119
.eqv	a, 97
.eqv	s, 115
.eqv	d, 100
.eqv	x, 120
.eqv	m, 109
.eqv	k, 107

.text

# Tenta ler uma tecla do teclado
# Retorno:
# a0 - sucesso (bool)
# a1 - a tecla pressionada
KEYBOARD_INPUT:
li	t0, KEYBOARD_MMIO		# carrega o endereco MMIO do teclado
lw	a0, 0(t0)			# carrega o valor lido no endereco MMIO
andi	a0, a0, 1			# mascara o bit de status
beqz	a0, KEYBOARD_INPUT_END1
lw	a1, 4(t0)			# carrega a tecla lida no endereco MMIO

KEYBOARD_INPUT_END1:
ret

# Executa uma acao de acordo com a tecla pressionada
# Parametros:
# a0 - tecla pressionada
# a1 - endereco das tiles no mapa
# a2 - endereco do mapa de batalha
# a3 - dados dos personagens
HANDLE_INPUT:
addi	sp, sp, -4
sw	ra, 0(sp)		# empilha ra

jal	SELECT_TILE		# esses procedimentos so vao fazer algo se a tecla correta for pressionada
jal	MOVE_CURSOR
jal	MOVE_CHARACTER
jal	ATTACK

lw	ra, 0(sp)		# desempilha ra
addi	sp, sp, 4
ret


# Seleciona a tile sob o cursor
# Parametros:
# a0 - tecla pressionada
# a1 - endereco das tiles do mapa
SELECT_TILE:
li	t0, X
li	t1, x
beq	a0, t0, SELECT_TILE_END1
beq	a0, t1, SELECT_TILE_END1
ret

SELECT_TILE_END1:
la	t0, selected
lw	t1, 0(t0)		# tile selecionada

addi	a1, a1, 8
add	a1, a1, t1

la	t0, cursor_x
la	t1, cursor_y

lw	t0, 0(t0)		# posicao x do cursor
lw	t1, 0(t1)		# posicao y do cursor

li	t2, 15
mul	t2, t2, t1
add	t2, t2, t0		# calcula o indice da tile

la	t3, selected
lw	t3, 0(t3)		# tile selecionada

add	t3, t2, a1		# endereco da tile
lb	t3, 0(t3)		# dado da tile

la	t3, selected
sw	t2, 0(t3)		# armazena na variavel 'selected'

SELECT_TILE_END2:
ret 


# Move o cursor uma unidade na direcao selecionada
# Parametros:
# a0 - tecla pressionada
MOVE_CURSOR:
li	t0, W
li	t1, w
beq	a0, t0, MOVE_NORTH
beq	a0, t1, MOVE_NORTH

li	t0, A
li	t1, a
beq	a0, t0, MOVE_WEST
beq	a0, t1, MOVE_WEST

li	t0, S
li	t1, s
beq	a0, t0, MOVE_SOUTH
beq	a0, t1, MOVE_SOUTH

li	t0, D
li	t1, d
beq	a0, t0, MOVE_EAST
beq	a0, t1, MOVE_EAST
ret

MOVE_NORTH:
la	t0, cursor_y		
lw	t1, 0(t0)		
addi	t1, t1, -1		
li	t2, 10			
bgeu	t1, t2, MOVE_CURSOR_END1
sw	t1, 0(t0)		
ret

MOVE_WEST:
la	t0, cursor_x
lw	t1, 0(t0)
addi	t1, t1, -1
li	t2, 15
bgeu	t1, t2, MOVE_CURSOR_END1
sw	t1, 0(t0)
ret

MOVE_SOUTH:
la	t0, cursor_y
lw	t1, 0(t0)
addi	t1, t1, 1
li	t2, 10
bgeu	t1, t2, MOVE_CURSOR_END1
sw	t1, 0(t0)
ret

MOVE_EAST:
la	t0, cursor_x
lw	t1, 0(t0)
addi	t1, t1, 1
li	t2, 15
bgeu	t1, t2, MOVE_CURSOR_END1
sw	t1, 0(t0)
ret

MOVE_CURSOR_END1:
ret

# Ataca um inimigo proximo
# Parametros:
# a0 - tecla pressionada
# a1 - endereco das tiles do mapa
# a2 - endereco do mapa de batalha
# a3 - dados de personagens
ATTACK:
addi	sp, sp, -20
sw	ra, 0(sp)		# empilha ra
sw	s0, 4(sp)		# empilha s0
sw	s1, 8(sp)		# empilha s1
sw	s2, 12(sp)		# empilha s2
sw	s3, 16(sp)		# empilha s3

li	t0, K
li	t1, k
beq	a0, t0, ATTACK_END1
beq	a0, t1, ATTACK_END1
j	ATTACK_END3

ATTACK_END1:
la	t0, cursor_x
lw	t0, 0(t0)		# posicao x do cursor

la	t1, cursor_y
lw	t1, 0(t1)		# posicao y do cursor

li	t2, 15
mul	t2, t2, t1
add	t2, t2, t0		# tile sob o cursor
addi	a1, a1, 8

add	t3, a1, t2		# endereco da tile sob o cursor
mv	s2, t3
lb	s0, 0(t3)		# dado da tile sob o cursor

li	t2, 5
li	t3, 6
li	t4, 7

beq	s0, t2, ATTACK_END2
beq	s0, t3, ATTACK_END2
beq	s0, t4, ATTACK_END2
j	ATTACK_END3

ATTACK_END2:
la	t2, selected
lw	t2, 0(t2)

add	t3, a1, t2		# endereco da tile selecionada
mv 	s3, t3
lb	s1, 0(t3)		# dado da tile selecionada

li	t5, 15
remu	t3, t2, t5		# posicao x selecionada
divu	t4, t2, t5		# posicao y selecionada

sub	t0, t3, t0		# distancia x
sub	t1, t4, t1		# distancia y

mul	t0, t0, t0		# distancia x ao quadrado
mul	t1, t1, t1		# distancia y ao quadrado

add	t0, t0, t1		# distancia quadrada

li	t1, 1			
bgt	t0, t1, ATTACK_END3

mv	a0, a2			# plano de fundo
mv	a1, s1			# ID do aliado
mv	a2, s0			# ID do inimigo
jal	BATTLE_SCENE

li	t0, 0
li	t1, 1

beq	a0, t0, ATTACK_ALLY_WIN
beq	a0, t1, ATTACK_ENEMY_WIN
j	ATTACK_END3

ATTACK_ALLY_WIN:
sb	zero, 0(s2)		# remove o inimigo

lb	t0, 1(a3)		
addi	t0, t0, -1		# decrementa o numero de inimigos
sb	t0, 1(a3)

j	ATTACK_END3

ATTACK_ENEMY_WIN:
sb	zero, 0(s3)		# remove o aliado

lb	t0, 0(a3)
addi	t0, t0, -1		# decrementa o numero de aliados
sb	t0, 0(a3)

ATTACK_END3:
lw	ra, 0(sp)		# desempilha ra
lw	s0, 4(sp)		# desempilha s0
lw	s1, 8(sp)		# desempilha s1
lw	s2, 12(sp)		# desempilha s2
lw	s3, 16(sp)		# desempilha s3
addi	sp, sp, 20
ret


# Move o personagem selecionado para a tile sob o cursor
# Parametros:
# a0 - tecla pressionada
# a1 - endereco das tiles do mapa
MOVE_CHARACTER:
li	t0, M
li	t1, m
beq	a0, t0, MOVE_CHARACTER_END1
beq	a0, t1, MOVE_CHARACTER_END1
ret

MOVE_CHARACTER_END1:
la	t0, cursor_x
lw	t0, 0(t0)		# posicao x do cursor

la	t1, cursor_y
lw	t1, 0(t1)		# posicao y do cursor

li	t2, 15
mul	t2, t2, t1
add	t2, t2, t0		# tile sob o cursor
addi	a1, a1, 8

add	t3, a1, t2		# endereco da tile sob o cursor
lb	t4, 0(t3)		# dado da tile sob o cursor
bnez	t4, MOVE_CHARACTER_END2

la	t2, selected	
lw	t2, 0(t2)		# tile selecionada

li	t5, 15
remu	t4, t2, t5		# posicao x selecionada
divu	t5, t2, t5		# posicao y selecionada

sub	t0, t4, t0		# distancia x
sub	t1, t5, t1		# distancia y

mul	t0, t0, t0		# distancia x ao quadrado
mul	t1, t1, t1		# distancia y ao quadrado

add	t0, t0, t1		# distancia quadrada

li	t1, 25
bgt	t0, t1,  MOVE_CHARACTER_END2

add	t4, a1, t2		# endereco da tile selecionada
lb	t0, 0(t4)		# dado da tile selecionada
sb	zero, 0(t4)		
sb	t0, 0(t3)		# move o dado da tile selecionada para a tile sob o cursor

MOVE_CHARACTER_END2:
ret
