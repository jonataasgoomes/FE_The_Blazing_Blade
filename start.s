.data
.include "modules\sprites\start\start1.data"

.text
	li s0, 0xFF200604 	#endereço de seleção do frame.
	sw zero, 0(s0)		#seleciona o frame 0.
	
	li s0, 0xFF000000	#frame 0
	
	la t0,start1		#carrega a imagem
	
	lw t1,0(t0)		#numero de linhas
	lw t2,4(t0)		#numero de colunas
	
	li t3,0			#contador
	
	mul t4,t1,t2		#Linhas x Colunas = Numero total de pixels
	
	addi t0,t0,8		#pula o cabeçalho dos dados.
	
IMAGEM:	beq t3,t4,PLAY.SETUP
	
	lw t5,0(t0)		#Load do valor da imagem em t5
	sw t5,0(s0)		#Store do valor t5 da imagem no frame0
	
	addi t0,t0,4		#próximo valor da imagem
	
	addi s0,s0,4		#proximo valor do frame0
		
	addi t3,t3,1		#incremento do contador

	j IMAGEM
	
	
.include "modules\midi\start.music.s" 

	
		
	
	
	
	
	
	
