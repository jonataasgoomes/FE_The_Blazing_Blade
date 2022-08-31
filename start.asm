.data

.include "sprites/start/start.data"
.include "sprites/start/start1.data"

.text
	li s0,0xFF200604	# seleciona frame 0
	sw zero,0(s0)
	
	li s0,0xFF000000	# Frame0
	li s1,0xFF100000	# Frame1
	
	la t0,start
	la t6,start1		# endere�o da imagem
	
	lw t1,0(t0)		# n�mero de linhas
	lw t2,4(t0)		# n�mero de colunas
	li t3,0			# contador
	mul t4,t1,t2		# numero total de pixels
	addi t0,t0,8
	addi t6,t6,8		# primeiro pixel da imagem
	
LOOP: 	beq t3,t4,FORA	 	# Coloca a imagem Start no Frame0 e Start0 no Frame 1

	lw t5,0(t0)
	sw t5,0(s0)
	
	lw a0,0(t6)
	sw a0,0(s1)
	
	addi t0,t0,4
	addi t6,t6,4
	
	addi s0,s0,4
	addi s1,s1,4
	
	addi t3,t3,1
	j LOOP
	
	
FORA:	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 0


LOOP3: 	  sw t2,0(s0)		# seleciona a Frame t2
	  xori t2,t2,0x001	# escolhe a outra frame
	  li a0,500		# pausa de 50m segundos
	  li a7,32
	  ecall	
	  j LOOP3

