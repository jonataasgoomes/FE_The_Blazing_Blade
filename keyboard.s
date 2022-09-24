.eqv	KEYBOARD_MMIO, 0xff200000

.text

# Tenta ler uma tecla do teclado
# Retorno:
# a0 - 1, se uma tecla foi pressionada, 0 caso contrario
# a1 - a tecla pressionada
KEYBOARD_INPUT:
addi	sp, sp, -4			
sw	s0, 0(sp)			# empilha s0
li	s0, KEYBOARD_MMIO		# carrega o endereco MMIO do teclado
lw	a0, 0(s0)			# carrega o valor lido no endereco MMIO
andi	a0, a0, 1			# mascara o bit de status
beqz	a0, KEYBOARD_INPUT_END1
lw	a1, 4(s0)			# carrega a tecla lida no endereco MMIO

KEYBOARD_INPUT_END1:
lw	s0, 0(sp)			# desempilha s0
addi	sp, sp, 4		
ret