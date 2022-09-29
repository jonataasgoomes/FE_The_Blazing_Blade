.data
LAST_PLAYED:	.word 	0
LAST_DURATION:	.word	0

.text

# Toca uma nota
# Parametros:
# a0 - endereco da musica
# a1 - indice da nota
# a2 - instrumento
# a3 - volume
# Retorno:
# a0 -  TRUE se a nota foi tocada, FALSE caso contrario
PLAY_NOTE:

la	t0, LAST_PLAYED
lw	t0, 0(t0)
beqz	t0, PLAY_NOTE_CONTINUE1

csrr	t1, time
la	t2, LAST_DURATION
lw	t2, 0(t2)
sub	t3, t1, t0
bge	t3, t2, PLAY_NOTE_CONTINUE1 

li	a0, FALSE
ret

PLAY_NOTE_CONTINUE1: 
addi	sp, sp, -4
sw	a1, 0(sp)

slli	t0, a1, 3		# calcula o offset do indice
add	t0, t0, a0		# endereco da nota
lw	a0, 0(t0)		# valor da nota
lw	a1, 4(t0)		# duracao da nota
li	a7, 31
ecall

csrr	t1, time
la	t0, LAST_PLAYED
sw	t1, 0(t0)
la	t0, LAST_DURATION
sw	a1, 0(t0)

li	a0, TRUE
lw	a1, 0(sp)
addi	sp, sp, 4
ret
