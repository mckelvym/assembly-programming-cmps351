#################################################################
# author         Mark McKelvy                                   #
# clid           jmm0468                                        #
# class          cmps351					#
# assignment     3                                              #
# date           Mar. 14, 2006                                  #
#################################################################

#Read a number of null-terminated character strings and store 
#them in an area defined in the data segment (buffer area).  
#Each string is typed on a new line.  A line with only a new 
#line character (ASCII 10) signals the end of input.  Assume the 
#maximum number of characters in a string to be nine (one is 
#left for null).  Place each string nine bytes from the previous 
#string even though the previous one might have shorter than 
#nine characters.  Also, assume the maximum number of the 
#strings to be 10 (.space 90).
 
        .data
hello:	.asciiz "\nHello, please enter a series of strings.\n(max strings 10, max chars 9)\n"
strings:.space 90
most:	.asciiz "\nMost occuring string: "
times:	.asciiz "Times it appeared: "

        .text
main:
	li        $v0, 4             #prepare to print a string
        la        $a0, hello         #load hello
        syscall

	addi	  $t0, $zero, 0	     #initialize counter variable
	addi      $t1, $zero, 10     #initialize termination variable
	la        $a0, strings	     #load the base address for the strings
lpmn:	
	beq	  $t0, $t1, cont
	li 	  $v0, 8	     #prepare to read a string
	li 	  $a1, 10	     #allowed to enter up to 9 characters
	syscall
	lb	  $t2, 0($a0)	     #load the first character into temp
	addi	  $t3, $zero, 10     #prepare to check for line feed
	beq	  $t2, $t3, cont     #line feed detected, exit loop
	
	#increment string pointer to next spot for strings
	addi	  $a0, $a0, 9

	addi	  $t0, $t0, 1	     #increment counter variable
	j	  lpmn	             #continue the loop	                 
cont:	
	la	  $a0, strings       #the address of the string buffer
	add	  $a1, $zero, $t0    #the number of strings

	jal	  func1		     #transfer control to func1

	add       $s0, $zero, $v0    #save the contents
	add	  $s1, $zero, $v1    #of return registers

	li	  $v0, 4             #print a string
	la        $a0, most          #load most
	syscall
	li        $v0, 4             #prepare to print a string
        add       $a0, $zero, $s0    #load hello
        syscall
	li	  $v0, 4	     #print a string
	la	  $a0, times         #load times
        syscall
        li        $v0, 1             #print an integer
        add       $a0, $zero, $s1    #print frequency
        syscall

	li        $v0, 10            #exit
        syscall


func1:  #This function is called from main.  Pass the beginning address of the buffer 
	#area where the strings are defined (in $a0) and the number of the strings 
	#(in $a1) to this function.  Return the address of the most frequent string 
	#(in $v0) along with its number of occurrences (in $v1) to main to be printed.

	addi   $sp, $sp, -44      #allocate mem
       	sw     $ra, 0($sp)        #for save
       	sw     $s0, 4($sp)        #registers and
       	sw     $s1, 8($sp)        #$ra
 	sw     $s2, 12($sp)
	sw     $s3, 16($sp)
	sw     $s4, 20($sp)
	sw     $s5, 24($sp)
	sw     $s6, 28($sp)
	sw     $s7, 32($sp)
	sw     $a0, 36($sp)	  #the address of the strings
	sw     $a1, 40($sp)	  #the number of strings

	lw     $t0, 36($sp)	  #load base address of strings into temp
	add    $s0, $zero, $t0    #use $s0 as a pointer through the strings
	add    $s1, $zero, $t0    #use $s1 as a second pointer
	add    $s2, $zero, $zero  #counter variable - outer loop
	add    $s3, $zero, $zero  #counter variable - inner loop
	add    $s6, $zero, $zero  #use $s6 as address of frequent string
        add    $s7, $zero, $zero  #use $s7 as num of freqency	
lpf1:   
	lw     $t0, 40($sp)	  #load num of strings into temp
	beq    $s2, $t0, done     #all strings have been checked
	add    $s4, $zero, $zero  #use $s4 as temp num of freq        
inner:	
	add    $a0, $zero, $s0    #first arg string
	add    $a1, $zero, $s1    #second arg string
        jal    func2
	
        beq    $v0, $zero, skipit #don't add to the temp num of freq
	add    $s4, $s4, 1        #increment temp num of freq
skipit:	
	lw     $t0, 40($sp)       #load number of strings
	addi   $s3, $s3, 1        #increment counter
	addi   $s1, $s1, 9
	bne    $s3, $t0, inner    #loop again if not at end of strings
	j      outer
outer:	
	addi   $s2, $s2, 1        #increment counter
        add    $t1, $zero, $s0	  #save the address of the string if we need it
	addi   $s0, $s0, 9        #increment base pointer
	lw     $t0, 36($sp)       #load base address of strings to temp
        add    $s1, $zero, $t0    #reset iterating pointer to base address
	add    $s3, $zero, $zero  #reset inner counter
	slt    $t0, $s7, $s4      #if we have a more frequent string
	beq    $t0, $zero, lpf1   #no more frequent string
	add    $s7, $zero, $s4    #set the new frequency of the new string
        add    $s6, $zero, $t1    #set the new address of the new string
	j      lpf1         
done:	
	add    $v0, $zero, $s6    #frequent string address
	add    $v1, $zero, $s7    #num of occurences

	lw     $ra, 0($sp)	  #restore save
       	lw     $s0, 4($sp)	  #registers and
       	lw     $s1, 8($sp)	  #$ra
 	lw     $s2, 12($sp)
	lw     $s3, 16($sp)
	lw     $s4, 20($sp)
	lw     $s5, 24($sp)
	lw     $s6, 28($sp)
	lw     $s7, 32($sp)
       	addi   $sp, $sp, 44
       	jr     $ra

func2:  #This function is called from func1, which receives the addresses of two 
	#strings (in $a0, and $a1) to be compared for equality and returns a one or 
	#zero depending whether they are equal or not.  Remember that two characters 
	#are equal if their ASCII codes are the same (i.e. uppercase letters are 
	#not equal to lowercase letters).

	addu	$v0, $zero, $zero #load a zero into the return register
	addi	$t0, $zero, 0	  #initialize counter variable
	addi	$t1, $zero, 9     #initialize termination variable
	add	$t2, $a0, $zero	  #copy the string1 to $t2
	add	$t3, $a1, $zero	  #copy the string2 to $t3
lpf2:	
	beq	$t0, $t1, equal   #the end of the strings reached, must be equal
	lb	$a0, 0($t2)	  #load a character from str1 to $a0
	lb	$a1, 0($t3)	  #load a character from str2 to $a1
	bne	$a0, $a1, noteq   #if the characters are not equal, exit
	addi	$t2, $t2, 1	  #move the pointer to the next variable
	addi	$t3, $t3, 1	  #move the other pointer to the next variable
	addi	$t0, $t0, 1	  #increment counter
	j	lpf2		  #continue the loop
noteq:	
	jr 	$ra
equal:	
	addi	$v0, $zero, 1	  #for a return value of 1
	jr	$ra        