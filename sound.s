.text

# Toca uma nota musical
# Parametros:
# a0 - endereco da musica
# a1 - indice da nota
# a2 - instrumento
# a3 - volume
PLAY_MUSIC:
addi	sp, sp, -4
sw	a0, 0(sp)
slli	a1, a1, 3		# multiplica pelo tamanho de uma nota e sua duracao
add	a0, a0, a1		# calcula o endereco da nota
lw	a1, 4(a0)		# carrega a duracao da nota
lw	a0, 0(a0)		# carrega o valor da nota
li	a7, 31			# toca a nota
ecall
mv 	a0, a1			# carrega a duracao da nota
li 	a7, 32			# sleep
ecall		
lw	a0, 0(sp)
addi	sp, sp, 4		
ret