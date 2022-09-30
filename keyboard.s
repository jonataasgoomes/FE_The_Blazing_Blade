.eqv	KEYBOARD_MMIO, 0xff200000


.eqv	W, 87
.eqv	A, 65
.eqv	S, 83
.eqv	D, 68
.eqv	X, 88
.eqv	w, 119
.eqv	a, 97
.eqv	s, 115
.eqv	d, 100
.eqv	x, 120

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
HANDLE_INPUT:
addi	sp, sp, -4
sw	ra, 0(sp)		# empilha ra

jal	SELECT_TILE		# esses procedimentos so vao fazer algo se a tecla correta for pressionada
jal	MOVE_CURSOR

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
la	t0, cursor_x
la	t1, cursor_y

lw	t0, 0(t0)		# posicao x do cursor
lw	t1, 0(t1)		# posicao y do cursor

li	t2, 15
mul	t2, t2, t1
add	t2, t2, t0		# calcula o indice da tile

la	t3, selected
sw	t2, 0(t3)		# armazena na variavel 'selected'
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


