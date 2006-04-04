#################################################################
# author         Mark McKelvy                                   #
# clid           jmm0468                                        #
# class          cmps351					#
# assignment     4                                              #
# date           Apr. 6, 2006                                   #
#################################################################
#								#
# Write an assembly language prog to read an integer from the   #
# keyboard and convert it to its corresponding octal value. 	#
# The prog should use a function to pass an integer along with  #
# the beginning address of the place where octal characters are #
# to be stored. The function would determine and store the 	#
# corresponding octal characters. 				#
# The (main) program should then print the corresponding string #
# of octal characters.  					#
# Leading zero characters should be eliminated.  		#
# The function should use some logical instructions.  		#
#								#
#################################################################
 
        .data
hello:	.asciiz "\nEnter a decimal integer to convert to octal:\n"
octal:  .word 0:11
orig:	.asciiz "\nDecimal value: "
new:	.asciiz "\nOctal value:   "

        .text
main:
	li        $v0, 4             #prepare to print a string
        la        $a0, hello         #load hello
        syscall
	li 	  $v0, 5	     #prepare to read an integer
	syscall
	add	  $s0, $v0, $zero    #store the read integer
	add       $a0, $v0, $zero    #argument 1 for the function
	la	  $a1, octal         #the address of the octal string
	jal	  convert	     #transfer control to "convert"
	li	  $v0, 4             #print a string
	la        $a0, orig          #load orig
	syscall
	li	  $v0, 1	     #print an integer
        add       $a0, $s0, $zero    #print original number
	syscall
	li	  $v0, 4	     #print a string
	la	  $a0, new           #load new
        syscall
	addi	  $t0, $zero, 0      #initialize counter
	addi      $t1, $zero, 11     #initialize terminal variable
	la	  $t2, octal         #load base address of octal string
	add	  $t3, $zero, $zero  #bool for zeroes eliminated
loop:	lw	  $a0, 0($t2)        #load next octal character
	
	bne	  $t3, $zero, skip   #skip if zeroes eliminated
	#else, if zeroes not eliminated
	beq	  $a0, $zero, skip2  #skip2 if nonzero encountered	
	#else, if it nonzero, update $t3
	addi	  $t3, $zero, 1      #$t3 reflects that zeroes are elminiated

skip:	li	  $v0, 1	     #print an integer
	syscall
skip2:	addi	  $t2, $t2, 4        #go to next integer
	addi	  $t0, $t0, 1	     #increment counter
	bne	  $t0, $t1, loop     #loop again if needed
	li        $v0, 10            #exit
        syscall


convert:# This function is called from main. The prog should use a 
	# function to pass an integer along with the beginning 
	# address of the place where octal characters are 
	# to be stored. The function would determine and store the
	# corresponding octal characters. 				
	#a0 contains the original integer
	#a1 contains the base address of the octal string
	addi	$t7, $zero, 0	     #initialize counter
	addi	$t8, $zero, 11	     #initialize termination variable
	addi	$a1, $a1, 40	     #start at the rear of the string
loop2:	andi	$t0, $a0, 7	     #apply the mask to get the 3 bits
	sw	$t0, 0($a1)	     #store the value into the octal string
	srl	$a0, $a0, 3	     #shift to the next bits
	addi	$a1, $a1, -4          #go to previous integer
	addi	$t7, $t7, 1	     #increment counter	
	bne	$t7, $t8, loop2	     #loop again if needed	
	jr     	$ra  