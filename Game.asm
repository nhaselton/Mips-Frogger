# Pixel Size 8x8
# Bitmap Size 512x512
# Base Address: 0x10000000 global data
# Also uses keyboard and display MMIO simulator
#
.data
	.globl px
	px : .word 32
	
	
	.globl py
	py : .word 60
	
	enemies: .word 		
	
	# ============  ROW 1 ========= #
	#x   y   w  h    spr          dir
	0,  56,  3 , 1, carSmallSpr, 1
	16, 56,  3 , 1, carSmallSpr, 1
	32, 56,  3 , 1, carSmallSpr, 1
	# ============  ROW 2 ========= #
	4,  52,  3 , 1, carSmallSpr, 1
	48,  52,  3 , 1, carSmallSpr, 1
	20,  52,  3 , 1, carSmallSpr, 1
	40,  52,  3 , 1, carSmallSpr, 1
	# ============  ROW 3 ========= #
	48,  48,  7 , 1, carMedSpr, 1
	16, 48,  7 , 1, carMedSpr, 1
	32, 48,  7 , 1, carMedSpr, 1
	4, 48, 7 , 1, carMedSpr, 1
	# ==============ROW 4 ============ #
			#EMPTY
	# ==============ROW 5 ============ #
	48,  40,  7 , 1, carMedSpr, 0xFFFFFFFF
	16,  40,  7 , 1, carMedSpr, 0xFFFFFFFF
	32,  40,  7 , 1, carMedSpr, 0xFFFFFFFF
	4,  40,   7 , 1, carMedSpr, 0xFFFFFFFF
	# ==============ROW 6 ============ #
	20,  36,  7 , 1, carMedSpr, 0xFFFFFFFF
	60,  36,  7 , 1, carMedSpr, 0xFFFFFFFF
	# ============== Row 7 ============ #
	36,  32,  15 , 1, carLargeSpr, 0xFFFFFFFF
	12,  32,  15 , 1, carLargeSpr, 0xFFFFFFFF
	# ============== Row 8 ============ #
	0,   28,   3 , 1, carSmallSpr, 0xFFFFFFFF
	48,  28,  3 , 1, carSmallSpr, 0xFFFFFFFF
	# ============== Row 9 ============ #
			#EMPTY
		### WATER SECTION! ###
	# ============== Row 9 ============ #
	
	 
	numCars: .word 21
	
	logs: .word
	#x	y     Dir
	#========= ROW 1   ======= #
	0,	20,    1#0xFFFFFFFF
	48,	20,    1
	#========= ROW 2   ======= #
	16,	16,    0xFFFFFFFF
	60,	16,    0xFFFFFFFF
	#========= ROW 3   ======= #
	0,	12,    1#0xFFFFFFFF
	32,	12,    1
	#========= Row 4 ============= #
	0,	8,    0xFFFFFFFF
	32,	8,    0xFFFFFFFF
	#========= Row 5 ============= #
	40,	4,    0xFFFFFFFF
	16,	4,    0xFFFFFFFF
	0,	4,    0xFFFFFFFF


	numLogs: .word 11
	
.text
	jal InitBitmap
	
	#Fill grey
	lw $a0, grey 
	jal Fill
	#Draw Player
	lw $a0, px
	lw $a1, py
	la $a2 playerSpr
	jal DrawSprite

# ========= Game Logic ====== #
GameLoop:		
	
	#20ms delay
	li $v0 32
	li $a0, 40
	syscall
	
	# ========================== UPDATE PLAYER #========================= #
	
	
	# set up keyboard
	andi $s6, $zero, 0x0000 #nuke info
	lui $s6, 0xFFFF #new key press
	lbu $v0, ($s6) #
	
	beq $v0, 0, noMove #didnt move L + ratio
	lbu $t3, 4($s6) # load ascii button value into temp register
	
	beq $t3, 97, left #check A input
	beq $t3, 100, right #check D input
	beq $t3, 119, up #check W input
	beq $t3, 115, down #check S input
	li $t0, 8 #move amount
	j noMove
	left:
		#Erase PRev
		lw $a0, px
		lw $a1, py
		la $a2 playerSpr
		lw $a3 grey
		jal EraseSprite
		
		#draw at new pos
		lw $a0, px
		add $a0, $a0 , -4
		sw $a0, px
		j didMove
	
	right:
		lw $a0, px
		lw $a1, py
		la $a2 playerSpr
		lw $a3 grey
		jal EraseSprite
		
		#draw at new pos
		lw $a0, px
		add $a0, $a0 , 4
		sw $a0, px
		j didMove
	
	up:
		#Erase PRev
		lw $a0, px
		lw $a1, py
		la $a2 playerSpr
		lw $a3 grey
		jal EraseSprite
		
		#draw at new pos
		lw $a1, py
		add $a1, $a1 , -4
		sw $a1, py
		
		beq $a1, 0, Win
		
		j didMove
	
	down:
		#Erase PRev
		lw $a0, px
		lw $a1, py
		la $a2 playerSpr
		lw $a3 grey
		jal EraseSprite
		
		#draw at new pos
		lw $a1, py
		add $a1, $a1 , 4
		sw $a1, py
		
		j didMove
	
	
	didMove: #can just go to nomove after, no need for j
		lw $a0, px
		lw $a1, py
		la $a2 playerSpr
		jal DrawSprite
	noMove:
		
	
	# ================= UPDATE CAR ==================== #
	li $s0 0 # Current Enemy Index (go up by 6 to make rest more readable) Index
	#li $s3 48
	lw $t0, numCars
	mul $s3, $t0, 24 #array length
carLoop:
	beq $s0, $s3, endCarLoop
	li $t0 0 # temp index for getting components of array ( so $s0 doesnt change until next enemy)
	#Remove car
	add $t0, $t0, $s0
	lw $a0 enemies($t0)
	add $t0, $s0,  4 # get Y
	lw $a1 enemies($t0)
	addi $t0, $s0, 16 #get image index
	lw $a2, enemies($t0) #set image
	
	lw $a3, gray
	jal EraseSprite
	
	add $t0, $s0, 0 # set temp back to X
	lw $a0 enemies($t0) #get x pos 
	
	addi $t1, $s0, 20
	lw $t2 enemies($t1)
	
	
	#li $t2, 1
	
	add $a0, $a0, $t2 #sub 1
	ble $a0, 64, notLeft
	#li $a0 -10 #place far right
	addi $a0, $a0, -72
	notLeft:
	bgt, $a0, 0, carOnScreen #chekc if offscreen 
	#li $a0 70 #place far right
	addi $a0, $a0, 72
carOnScreen:

	sw $a0, enemies($t0) #store new X
	
	addi $t0, $s0, 4 #get Y index in array
	lw $a1 enemies($t0) #get y
	
	addi $t0, $s0, 16 #get image index
	lw $a2, enemies($t0) #set image
	jal DrawSprite	#draw
	
	
	#Collsion detection between player and car
	
	addi $t0, $s0, 0 #width
	lw $t4, enemies($s0) #Bx1
	
	addi $t0, $s0, 4 #height
	lw $t5, enemies($t0) #Bx1
	
	#Width
	addi $t0, $s0, 8 #width pos
	lw $t1, enemies($t0) #widht num
	add $t6, $t4, $t1 #x + width
	
	addi $t0, $s0, 12 #Y
	lw $t1, enemies($t0)
	add $t7, $t5, $t1
	
	#Player Hitbox (slightly smaller than you)
	lw $t0, px #Ax1
	lw $t1, py #Ay1
	addi $t2, $t0, 2 #Ax2
	addi $t3, $t1, 2 #Ay2
	

	bgt $t0, $t6, noCollison #x1 < x2+xw
	blt $t2, $t4, noCollison #x1+xw > x2
	bgt $t1, $t7 noCollison #y1 < y2+h2
	blt $t3, $t5, noCollison #y1+h1 > y2
	
	
	#kill if collide
	jal Lose
	noCollison:
	
	addi $s0, $s0, 24
	j carLoop
	
endCarLoop:
	jal DrawOcean
	
	# ================= UPDATE LOGS ==================== #
	addi $sp ,$sp -4#if you dont store s1 shit breaks
	sw $s1, ($sp)
	lw $s0, px
	lw $s1, py #dont use $s1 because that shit breaks for some reason
	li $s2, 0 # logs[i]
	lw $s3, numLogs
	li $t4 0 #$s2 pointer
	mul $s3, $s3, 12 #8 bytes per log
	
	li $s4, 0 #bool istouching
	li $s5, 0 #dir moving
LogLoop:
	bge $s2, $s3 logsDone
	
	addi $t4 $s2, 0#xloc
	lw $t0, logs($t4) #logX
	addi $t4 $s2, 4 #yloc
	lw $t1, logs($t4) #logY
	
	#Clear Sprite
	addi $sp , $sp, -8 #store $t0, $t1, used by erasesprite
	sw $t0 ($sp)
	sw $t1 4($sp)	 
	
	move $a0 $t0 
	move $a1 $t1
	la $a2, logSpr
	lw $a3, blue
	#jal EraseSprite
	lw $t0 ($sp)
	lw $t1 4($sp)	
	addi $sp $sp, 8
	
	
	bge $s1, 23, noLogCollide
	addi $t0, $t0, -3 # give a little error room because log moves kinda fast, makes it easier to see whats going on
	#Collsion detection (check if point in rect, rect/rect collision is overkill for "1x1 grid based thing"
	addi $t2, $t0, 15 #log x + LogW
	addi $t3, $t1, 1 #log y+ logH

	blt $s0, $t0 noLogCollide #x > x1 
	bgt $s0, $t2 noLogCollide  #x < x2
	blt $s1, $t1 noLogCollide  #y > y1
	bgt $s1, $t3 noLogCollide  #y < y2
	
	li $s4, 1 #bool hastouched = true
	
	addi $t4 $s2, 8#log Dir
	lw $s5, logs($t4) #stroe in temp for when player hsa to move
	
	#jal Exit

noLogCollide:	
#Move Log 	
	
	addi $t4 $s2, 0 #x loc
	lw $a0 logs($t4) #get x
	#addi $a0, $a0, 1 #move X by 1 
	addi $t4 $s2, 8#log Dir
	lw $t0, logs($t4) #stroe in temp for when player hsa to move
	add $a0, $a0, $t0
	#Move log back on screen if it goes off
	bgt $a0 , -15, logNotLeft
	li $a0 65
	logNotLeft:
	blt $a0, 69, logNotOffScreen
	li $a0, -14
	#continue draw
	logNotOffScreen:
	sw $a0 logs($s2) 
	addi $t4 $s2, 4 #y loc
	lw $a1 logs($t4) #get y
	la $a2, logSpr #get spr
	jal DrawSprite #draw
	
	addi $s2 $s2, 12
	j LogLoop
	
logsDone:
	
	lw $t0 py #i do this check twice, its bad but im in too deep to reformat all 
	bge $s1, 23, skipLogs
	#if on a log, mvoe over 1 like log does then redraw player
	lw $a0 px
	add $a0, $a0, $s5 #px += logDir
	sw $a0 px #move right
	move $a1, $t0
	la $a2 playerSpr
	
	beq $s4, $zero, Lose
	jal DrawSprite
	
skipLogs:
	#restore s1
	lw $s1, ($sp)
	addi $sp, $sp, 4
	j GameLoop
	#=============END LOOP============#
