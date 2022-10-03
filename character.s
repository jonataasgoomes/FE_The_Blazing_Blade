.data
.include	"ally_sword.data"
.include 	"ally_spear.data"
.include 	"ally_axe.data"

.text

# Retorna o endereco dos sprites de um personagem
# Parametros:
# a0 - o ID do personagem
# Retorno:
# a0 - o endereco dos sprites do personagem
GET_SPRITE:
li	t0, 2
li	t1, 3
li	t2, 4

beq	a0, t0, GET_SPRITE_ALLY_SWORD
beq	a0, t1, GET_SPRITE_ALLY_SPEAR
beq	a0, t2, GET_SPRITE_ALLY_AXE
li	a0, 0
ret

GET_SPRITE_ALLY_SWORD:
la	a0, ALLY_SWORD
ret

GET_SPRITE_ALLY_SPEAR:
la	a0, ALLY_SPEAR
ret

GET_SPRITE_ALLY_AXE:
la	a0, ALLY_AXE
ret