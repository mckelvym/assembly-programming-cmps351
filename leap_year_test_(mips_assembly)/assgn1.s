#author 	Mark McKelvy
#clid		jmm0468
#assignment	1

	.data
strwel:	.asciiz "\nWelcome, you will get 3 tries\nto guess a leap year!"
strin:	.asciiz	"\nEnter a year: "
strlp:	.asciiz	"The year is a leap."
strnot: .asciiz "The year is not a leap."
strnl:	.asciiz	"\n"
strbye:	.asciiz "\nBye!"

	.text
main:
	li	$v0, 4		#print strwel output
	la	$a0, strwel	#"Welcome, you will get 3 tries!"
	syscall

	addi	$s1, $zero, 0   #Loop counter
	addi	$s2, $zero, 3	#Loop termination value

Loop:	beq	$s1, $s2, Exit	#check to see if execute
	addi	$s1, $s1, 1	#increment counter

	li	$v0, 4		#print strin prompt
	la	$a0, strin	#"Enter a year: "
	syscall			#

	li	$v0, 5		#read an integer
	syscall			#

	add	$s0, $v0, $zero #move the integer to $s0
	
	addi	$t0, $zero, 4	#the number to divide by	
	div	$s0, $t0	#divide the number by 4
	mfhi	$t0		#the remainder of division
	bne	$t0, $zero, NLeap #The year is not leap

	addi	$t0, $zero, 100 #the number to divide by
	div	$s0, $t0	#divide the number by 100
	mfhi	$t0		#the remainder of division
	bne	$t0, $zero, Leap #the year is leap

	addi	$t0, $zero, 400 #the number to divide by
	div 	$s0, $t0	#divide the number by 400
	mfhi	$t0		#the remainder of division
	bne	$t0, $zero, NLeap #the year is not leap
	j	Leap
	

Leap:	li	$v0, 4		#print strlp output
	la	$a0, strlp	#"The year is a leap."
	syscall
	j	Loop		#Loop Again

NLeap:	li	$v0, 4		#print strnot output
	la	$a0, strnot	#"The year not a leap."
	syscall
	j	Loop		#Loop Again

Exit:	li	$v0, 4		#print strbye output
	la	$a0, strbye	#"Bye!"
	syscall
	li	$v0, 10		#exit
	syscall	