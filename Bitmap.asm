#TODO make all functions store regs then restore them after done
#last pixel doesnt draw and just breakss
.data
#min size 4x4 & 256 or run out of memory?

	lastKey: .word 0
	
	displayAddress:	.word	0x10000000
	inp: .word 0xffff0004
	
	width: .word 512
	height: .word 512
	bitmapWidth: .word 0
	bitmapHeight: .word 0
	pixelSize: .word 8
	
	.globl red
	red:   .word 0xff0000
	.globl green
	green: .word 0x00ff00
	.globl blue
	blue:  .word 0x0000ff
	.globl black
	black: .word 0
	.globl white
	white: .word 0xffffff
	.globl grey
	grey: .word 0xd3d3d3 
	.globl gray
	gray: .word 0xd3d3d3 
	
	
	space: .asciiz " "
	newLine: .asciiz "\n"
	
.text
main:
InitBitmap: .globl InitBitmap
	addi $sp, $sp ,-4
	sw $ra, ($sp)
	
	lw $t9, displayAddress	# $t0 stores the base address for display
	
	# ====  Dimensions ==== 
	#Width
	lw $t0 width
	lw $t1 pixelSize #pixel size
	lw $t2 height
	div $t0, $t0, $t1 # bitmap widht = width/pixelsize
	div $t2, $t2, $t1
	sw $t0, bitmapWidth #store bitmap width
	sw $t2, bitmapHeight # set height
	
	
	lw $a0, blue
	#jal Fill
	
	jal LoadSprites
	
	lw $a0 px
	lw $a1 py
	la $a2 playerSpr
	jal DrawSprite
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
DrawSprite: .globl DrawSprite#x,y,spr
	addi $sp, $sp, -4 #reset return ptr
	sw $ra, 0($sp)#store RA & Stack 
	subi $a0, $a0, 1
	addi $sp,$sp -24 #store s1-s3 sincei edit them
	sw $s1 , 0($sp)
	sw $s2 , 4($sp)
	sw $s3 , 8($sp)
	sw $s0,  12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	lw $s3, 0($a2) #W
	lw $t1, 4($a2) #H
	addi $a2, $a2, 8 #go to pixel data
	
	mul $s0, $s3, $t1 #Num pixels
	#addi $s0, $s0, -1 #sub 1 to not overboard
	li $s1, 0 #current pixel
	move $s2, $a2 #move sprite
	lw $a2, 0($s2) #color++
	
	add $s4, $s3, $a0 # create bound, start pos + widht
	addi $s4, $s4 , 0
	addi $s0, $s0, -1
	dloop:
		beq $s1, $s0, enddloop
	
		add $a0, $a0, 1 #x++
		lw $a2, 0($s2) #set next color
		addi $s2, $s2, 4#color ++
		addi $s1, $s1, 1#i++
	
		beq $a2, 13882323, skipDraw
		jal Draw
		skipDraw:
		#check if y go down
		blt $a0, $s4, noYMove
			addi $a1, $a1, 1 #y++
			sub  $a0, $a0, $s3 #x-width
	noYMove:
		j dloop
	
	enddloop:
	#problem drawing last pxiel this is a stupid hack to get it working
	#jal Draw
	#addi $a0, $a0, 1
	#jal Draw

	lw $s1 , 0($sp)
	lw $s2 , 4($sp)
	lw $s3 , 8($sp)
	lw $s0,  12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp,$sp 24 #store s1-s3 sincei edit them
		

	lw $ra, 0($sp)
	addi $sp, $sp, 4


Draw:.globl Draw # x,y,color
	lw $t0, bitmapWidth # get size of bitmap
		
	bgt $a0, $t0, CancelDraw #check x in bounds
	bltz $a0, CancelDraw
	bgt $a1, $t0, CancelDraw #check y in bounds
	bltz $a0, CancelDraw	
	
	
	li $t1 0#array pos
	mul $t1, $a1 , $t0 # arraypos = y * width
	
	add $t1, $t1, $a0 #arraypos += x
	mul $t1, $t1, 4 #mult position by 4 for bytes (rgba)
	add $t3, $t9, $t1 #add position to bitmap pointer
	sw $a2, 0($t3) # sets pos to color

	
CancelDraw:
	jr $ra
	
Fill:.globl Fill
	lw $t0 bitmapWidth
	lw $t1 bitmapHeight
	mul $t4, $t0, $t1 #num itterations
	#lw $a0, blue
	li $a1, 0 #inital

	lw $t0, displayAddress

 	fillLoop:
		beq $a1, $t4, endFill  
		sw $a0, ($t0) #set color
		addi $t0, $t0, 4 #add to ptr
		addi $a1, $a1, 1 #i++
	 	j fillLoop
	endFill: 
		jr $ra


EraseSprite:.globl EraseSprite #x y spr color
	addi $sp, $sp, -4 #reset return ptr
	sw $ra, 0($sp)#store RA & Stack 
	
	
	addi $sp,$sp -24 #store s1-s3 sincei edit them
	sw $s1 , 0($sp)
	sw $s2 , 4($sp)
	sw $s3 , 8($sp)
	sw $s0,  12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	
	move $s5, $a3 #move color 
	lw $s3, 0($a2) #W
	lw $t1, 4($a2) #H
	mul $s0, $s3, $t1 #Num pixels
	move $s2, $a2 #move sprite
	
	add $s4, $s3, $a0 # create bound, start pos + widht
	move $s2, $a3
	jal Draw

		eloop:
		beq $s1, $s0, endeloop
		#lw $a2, red
		move $a2, $a3
		#lw $a2, grey
		move $a2, $s5
		jal Draw
		add $a0, $a0, 1 #x++
		addi $s1, $s1, 1#i++

		move $a2, $s2
		#check if y go down
		blt $a0, $s4, noYMove2
			addi $a1, $a1, 1 #y++
			sub  $a0, $a0, $s3 #x-width
	noYMove2:
		j eloop
	
	endeloop:

	lw $s1 , 0($sp)
	lw $s2 , 4($sp)
	lw $s3 , 8($sp)
	lw $s0,  12($sp)
	lw $s4, 16($sp)
	sw $s5, 20($sp)
	addi $sp,$sp 24 

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

DrawOcean: .globl DrawOcean
	li $t0 64
	li $t1 20
	mul $t4, $t0, $t1 #num itterations
	#lw $a0, blue
	li $a1, 0 #inital

	lw $t0, displayAddress
	lw $a0 blue
	addi $t0 , $t0 1024 #skip last row
 	fillLoopOcean:
		beq $a1, $t4, endFillOcean  
		#sw $a0, ($t0) #set color
		sw $a0, ($t0)
		addi $t0, $t0, 4 #add to ptr
		addi $a1, $a1, 1 #i++
	 	j fillLoopOcean
	endFillOcean: 
		jr $ra
jr $ra
	
Win : .globl Win
	li $a0 0
	li $a1 0
	la $a2 winSpr
	jal DrawSprite
	j Exit

Lose : .globl Lose
	li $a0 0
	li $a1 0
	la $a2 loseSpr
	jal DrawSprite
	j Exit


Exit:.globl Exit
	li $v0, 10 
	syscall
	
