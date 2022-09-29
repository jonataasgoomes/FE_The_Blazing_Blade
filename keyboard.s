.eqv	KEYBOARD_MMIO, 0xff200000

.eqv	W, 87
.eqv	A, 65
.eqv	S, 83
.eqv	D, 68
.eqv	w, 119
.eqv	a, 97
.eqv	s, 115
.eqv	d, 100

.text

# Tenta ler uma tecla do teclado
# Retorno:
# a0 - TRUE, se uma tecla foi pressionada, FALSE caso contrario
# a1 - a tecla pressionada
KEYBOARD_INPUT:
li	t0, KEYBOARD_MMIO		# carrega o endereco MMIO do teclado
lw	a0, 0(t0)			# carrega o valor lido no endereco MMIO
andi	a0, a0, 1			# mascara o bit de status
beqz	a0, KEYBOARD_INPUT_END1
lw	a1, 4(t0)			# carrega a tecla lida no endereco MMIO

KEYBOARD_INPUT_END1:
ret


# Move o cursor uma unidade em uma direcao
# Parametros:
# a0 - posicao x do cursor
# a1 - posicao y do cursor
# a2 - tecla pressionada
# Retorno:
# a0 - nova posicao x
# a1 - nova posicao y
MOVE_CURSOR:
li	t0, W
li	t1, w
beq	a2, t0, MOVE_NORTH
beq	a2, t1, MOVE_NORTH

li	t0, A
li	t1, a
beq	a2, t0, MOVE_WEST
beq	a2, t1, MOVE_WEST

li	t0, S
li	t1, s
beq	a2, t0, MOVE_SOUTH
beq	a2, t1, MOVE_SOUTH

li	t0, D
li	t1, d
beq	a2, t0, MOVE_EAST
beq	a2, t1, MOVE_EAST
ret

MOVE_NORTH:
addi	t0, a1, -1
li	t1, 10
bgeu	t0, t1, MOVE_CURSOR_CONTINUE1
mv	a1, t0
ret

MOVE_WEST:
addi	t0, a0, -1
li	t1, 15
bgeu	t0, t1, MOVE_CURSOR_CONTINUE1
mv	a0, t0
ret

MOVE_SOUTH:
addi	t0, a1, 1
li	t1, 10
bgeu	t0, t1, MOVE_CURSOR_CONTINUE1
mv	a1, t0
ret

MOVE_EAST:
addi	t0, a0, 1
li	t1, 15
bgeu	t0, t1, MOVE_CURSOR_CONTINUE1
mv	a0, t0

MOVE_CURSOR_CONTINUE1:
ret


