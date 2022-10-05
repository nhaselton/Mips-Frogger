.data
buffer: .space 40000 #64x64x3
newLine: .asciiz "\n"

.text

LoadFile: .globl LoadFile
	
	
	addi $sp, $sp, -4
	sw $ra, ($sp) #store stack ptr for end

	addi $sp, $sp, -4
	sw $s1, ($sp)

	move $s1, $a1 #move sprite return address here
	move $a1, $t0 #move return address into temp 0
	
#Open File
	li $v0 13
	#la $a0 path #path 
	li $a1 0 #flag = read
	syscall
	move $t0, $v0
#Read File
	li $v0 14
	move $a0, $t0 #file desc
	la $a1, buffer#buffer loc
	la $a2, 40000 #buffer length
	syscall

#=========== READ FILE ===========

	li $t0 0 #startI
	li $t1 8 #endI
	move $t2, $a1 # position in byte arr
	li $t4 0 #final v
	#la $s1 arr
	li $t5 0 #curr Num
	li $t6 40000 #256x256
	 
	loop:
		beq $t0, $t1, endloop
		lbu $t3, ($t2)
		
		beq $t3, 122, done #Check if byte = z, if so then sprite ended
		
		sub $t3, $t3, 0x30
		mul $t4, $t4, 10 # multiply orignal asnwer by 10, 1 * 10 + 2 = 12
		add $t4, $t4, $t3 #add num to total
		
		addi $t2, $t2, 1#byte ptr ++
		addi $t0 ,$t0, 1#i++
	j loop
	
	endloop:
		sw $t4, ($s1) # store wrod
		addi $s1, $s1, 4 # push ptr
		li $t4 0 # reset finalnum
		li $t0 0 # rest count 
		beq $t5, $t6, done #see if done with loop
		addi $t5, $t5, 1# increment if not
		j loop
done:
	lw $s1, ($sp)
	addi $sp ,$sp, 4

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
