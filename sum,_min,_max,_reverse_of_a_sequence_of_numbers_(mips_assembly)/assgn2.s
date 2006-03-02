#################################################################
# author 	Mark McKelvy					#
# clid		jmm0468						#
# assignment	2						#	
# date		Feb. 27, 2006					#
#								#
# Read a sequence of maximum 10 integers from keyboard into an  #
#  array defined in the data segment.				#
# Print their sum						#
# Print the maximum number					#
# Print the minimum number					#
# Print the numbers in reverse order (as read).  In doing this  #
#  print an appropriate heading and then print each number on   #
#  a new line.							#
#################################################################

	.data
strwel:	.asciiz "Welcome, you will be prompted to enter 10 integers.\n\n"
prompt:	.asciiz " Enter an integer (or 0): "
strsum:	.asciiz	"\nThe sum of the integers is: "
strmax:	.asciiz	"\nThe maximum of the integers is: "
strmin: .asciiz "\nThe minimum of the integers is: "
strrev:	.asciiz	"\nThe reverse of the integers (last to first):\n"
strr1:	.asciiz "\n integer ("
strr2:	.asciiz "): "
strbye:	.asciiz "\n\nBye!"
array:	.word	0:10

	.text
main:
	li	$v0, 4		#print strwel output
	la	$a0, strwel	#"Welcome, you will be prompted to enter 10 integers:\n"
	syscall
	
	addu	$t0, $0, $0	#initialize our counter to 0
	la	$s0, array	#load the base address of the array into memory
	
prmptlp:li	$v0, 4		#print prompt
	la	$a0, prompt	#"\n Enter an integer (or 0): "
	syscall

	li	$v0, 5		#read an integer
	syscall

	sw	$v0, 0($s0)	#store the read integer into the array
	addi	$s0, $s0, 4	#increment our pointer in the array
	addi	$t0, $t0, 1	#increment our counter
	slt	$t1, $t0, 10	#see if we've looped 10 times
	bne	$t1, $0, prmptlp#loop again if we need to

	la	$s0, array	#load the base address of the array back into $s0
	addu	$t0, $0, $0	#initialize our counter variable to 0
	addu	$s1, $0, $0	#initialize our sum variable to 0
	addu	$s2, $0, $0	#initialize max variable to 0
	lw	$s3, 0($s0)	#read the first integer in the array
		
sumlp:	lw	$t7, 0($s0)	#read an integer from the array
	slt	$t1, $s2, $t7	#is max less than the current int
	beq	$t1, $0, skip1  
	add	$s2, $0, $t7	#set max to the current int

skip1:	slt	$t1, $t7, $s3	#is current int less than min
	beq	$t1, $0, skip2
	add	$s3, $0, $t7	#set min to the current int
 
skip2:	addi	$s0, $s0, 4	#increment the pointer in the array
	addi	$t0, $t0, 1	#increment the counter
	add	$s1, $s1, $t7	#add to our sum
	slt	$t1, $t0, 10	#see if we've gone through all 10 integers
	bne	$t1, $0, sumlp	#loop again if needed
	
	li	$v0, 4		#print strsum
	la	$a0, strsum	#"\nThe sum of the integers is: "
	syscall

	li	$v0, 1		#print sum
	add	$a0, $0, $s1	#value of the sum
	syscall

	li	$v0, 4		#print strmax
	la 	$a0, strmax	#"\nThe maximum of the integers is: "
	syscall

	li	$v0, 1		#print max
	add	$a0, $0, $s2	#value of the max
	syscall

	li	$v0, 4		#print strmin
	la	$a0, strmin	#"\nThe minimum of the integers is: "
	syscall
	
	li	$v0, 1		#print min
	add	$a0, $0, $s3	#value of the min
	syscall

	addu	$t0, $0, $0	#initialize our counter to 0
	la	$s0, array	#load the base address of the array into memory
	
	addi	$s0, $s0, 36	#put the pointer at the end of the array
	li	$v0, 4		#print strrev
	la	$a0, strrev	#"\nThe reverse of all the integers is (from last to first):\n"
	syscall

revlp:	lw	$t1, 0($s0)	#load an integer from the array
	addi	$s0, $s0, -4	#decrement our pointer in the array
	addi	$t0, $t0, 1	#increment our counter
	
	li	$v0, 4		#print strr1
	la	$a0, strr1	#"\n integer("
	syscall

	li	$v0, 1		#print the counter
	add	$a0, $0, $t0	
	syscall
	
	li	$v0, 4		#print strr2
	la	$a0, strr2	#"): "
	syscall	

	li	$v0, 1		#print the integer in the current position
	add	$a0, $0, $t1	
	syscall
	
	slt	$t1, $t0, 10	#see if we've looped 10 times
	bne	$t1, $0, revlp  #loop again if we need to

Exit:	li	$v0, 4		#print strbye output
	la	$a0, strbye	#"Bye!"
	syscall

	li	$v0, 10		#exit
	syscall	