.data
.include	"ally_sword.data"
.include 	"ally_spear.data"
.include 	"ally_axe.data"
.include	"enemy_sword.data"
.include	"enemy_spear.data"
.include	"enemy_axe.data"
.include	"ally_sword_battle.data"
.include	"ally_spear_battle.data"
.include	"ally_axe_battle.data"
.include	"enemy_sword_battle.data"
.include	"enemy_spear_battle.data"
.include	"enemy_axe_battle.data"

.text

# Retorna o vencedor de uma luta
# Parametros:
# a0 - ID do aliado
# a1 - ID do inimigo
# Retorno:
# a0 - 0: vitoria do aliado, 1: vitoria do inimigo, 2: empate
GET_WINNER:
li	t0, 2
li	t1, 3
li	t2, 4

li	t3, 5
li	t4, 6
li	t5, 7

beq	a0, t0, GET_WINNER_SWORD
beq	a0, t1, GET_WINNER_SPEAR
beq	a0, t2, GET_WINNER_AXE

GET_WINNER_SWORD:
beq	a1, t3, GET_WINNER_TIE
beq	a1, t4, GET_WINNER_ENEMY
beq	a1, t5, GET_WINNER_ALLY

GET_WINNER_SPEAR:
beq	a1, t3, GET_WINNER_ALLY
beq	a1, t4, GET_WINNER_TIE
beq	a1, t5, GET_WINNER_ENEMY

GET_WINNER_AXE:
beq	a1, t3, GET_WINNER_ENEMY
beq	a1, t4, GET_WINNER_ALLY
beq	a1, t5, GET_WINNER_TIE

GET_WINNER_ALLY:
li	a0, 0
ret
GET_WINNER_ENEMY:
li	a0, 1
ret
GET_WINNER_TIE:
li	a0, 2
ret


# Retorna o endereco dos sprites de um personagem
# Parametros:
# a0 - o ID do personagem
# Retorno:
# a0 - o endereco dos sprites do personagem
GET_SPRITE:
li	t0, 2
li	t1, 3
li	t2, 4
li	t3, 5
li	t4, 6
li	t5, 7

beq	a0, t0, GET_SPRITE_ALLY_SWORD
beq	a0, t1, GET_SPRITE_ALLY_SPEAR
beq	a0, t2, GET_SPRITE_ALLY_AXE
beq	a0, t3, GET_SPRITE_ENEMY_SWORD
beq	a0, t4, GET_SPRITE_ENEMY_SPEAR
beq	a0, t5, GET_SPRITE_ENEMY_AXE	

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

GET_SPRITE_ENEMY_SWORD:
la	a0, ENEMY_SWORD
ret

GET_SPRITE_ENEMY_SPEAR:
la	a0, ENEMY_SPEAR
ret

GET_SPRITE_ENEMY_AXE:
la	a0, ENEMY_AXE
ret


# Retorna o endereco dos sprites de batalha de um personagem
# Parametros:
# a0 - o ID do personagem
# Retorno:
# a0 - o endereco dos sprites do personagem
GET_SPRITE_BATTLE:
li	t0, 2
li	t1, 3
li	t2, 4
li	t3, 5
li	t4, 6
li	t5, 7

beq	a0, t0, GET_SPRITE_ALLY_SWORD_BATTLE
beq	a0, t1, GET_SPRITE_ALLY_SPEAR_BATTLE
beq	a0, t2, GET_SPRITE_ALLY_AXE_BATTLE
beq	a0, t3, GET_SPRITE_ENEMY_SWORD_BATTLE
beq	a0, t4, GET_SPRITE_ENEMY_SPEAR_BATTLE
beq	a0, t5, GET_SPRITE_ENEMY_AXE_BATTLE

li	a0, 0
ret

GET_SPRITE_ALLY_SWORD_BATTLE:
la	a0, ALLY_SWORD_BATTLE
ret

GET_SPRITE_ALLY_SPEAR_BATTLE:
la	a0, ALLY_SPEAR_BATTLE
ret

GET_SPRITE_ALLY_AXE_BATTLE:
la	a0, ALLY_AXE_BATTLE
ret

GET_SPRITE_ENEMY_SWORD_BATTLE:
la	a0, ENEMY_SWORD_BATTLE
ret

GET_SPRITE_ENEMY_SPEAR_BATTLE:
la	a0, ENEMY_SPEAR_BATTLE
ret

GET_SPRITE_ENEMY_AXE_BATTLE:
la	a0, ENEMY_AXE_BATTLE
ret
