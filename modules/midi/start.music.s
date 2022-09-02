.eqv 		TECLADO	0xff200000

.data
#numero de notas do MIDI
NUM: .word 22
NOTAS: 55,976,60,488,64,488,64,976,57,976,57,1220,59,244,60,244,62,244,60,976,59,976,55,976,60,488,64,488,67,976,65,488,64,488,57,1220,59,244,60,244,62,244,62,1952
.text

PLAY.SETUP:	la s0,NUM 		#load de endereço do número de notas
		lw s1,0(s0)		#carrega o numero de notas
		la s0,NOTAS		#define o endereço das notas
	
		li t0,0			#contador para laço de notas
	
		li a2,1			#define o instrumento
		li a3,127		#define o volume
	
PLAY:	beq t0,s1,REPEAT		#beq do contador, t0 contador = s1 numero de notas
	lw a0,0(s0)		#le o valor da nota
	lw a1,4(s0)		#le a duração da nota
	li a7,31		#syscall
	ecall			#toca a nota
	
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	
	j PLAY			#loop para outras notas
	
	
REPEAT:	
	jal PLAY.SETUP
	
	
ANYKEY:	
	
	
			
	
