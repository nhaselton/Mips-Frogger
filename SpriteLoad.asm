.data
 .globl playerFile
  playerFile: .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/player.sprite"
  
  .globl carLargeFile
  carLargeFile: .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/carLarge.sprite" 
 
  .globl carMedFile
  carMedFile: .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/carMed.sprite" 

  .globl carSmallFile
  carSmallFile: .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/carSmall.sprite" 

   .globl logFile
  logFile: .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/log.sprite" 
	
 .globl winFile
 winFile : .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/win.sprite" 

 .globl loseFile
 loseFile : .asciiz "C:/Users/nhase/Desktop/Mips/_Game/Sprites/lose.sprite" 

 
 .globl playerSpr
 playerSpr: .word 0:256

.globl carLargeSpr
	carLargeSpr: .word 0:256 

.globl carMedSpr
	carMedSpr: .word 0:256 

.globl carSmallSpr
	carSmallSpr: .word 0:256 

.globl logSpr
	logSpr: .word 0:256 

.globl winSpr
	winSpr: .word 0:16384

.globl loseSpr
	loseSpr: .word 0:16384 

.text

LoadSprites: .globl LoadSprites
#keep ptr
	addi $sp, $sp, -4
	sw $ra, ($sp) #store stack ptr for end

#Load Player
	la $a0, playerFile
	la $a1, playerSpr
	jal  LoadFile

#Cars
	la $a0, carLargeFile
	la $a1, carLargeSpr
	jal LoadFile
	
	la $a0, carMedFile
	la $a1, carMedSpr
	jal LoadFile
	
	la $a0, carSmallFile
	la $a1, carSmallSpr
	jal LoadFile

#Log
	la $a0, logFile
	la $a1, logSpr
	jal LoadFile
#Victory/lsoe
	la $a0, winFile
	la $a1, winSpr
	jal LoadFile

	la $a0, loseFile
	la $a1, loseSpr
	jal LoadFile

	#return
	lw $ra, ($sp)
	addi $sp, $sp , 4
	jr $ra
