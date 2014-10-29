# EE 466 Computer Architecture Fall 2014
# Instructor: Dr. Chen Liue
# Project 2 Factorial
# Written by James Lamphere (0274872)
# Software Engineering Major
# lamphejw@clarkson.edu

.data
inputprompt:	.asciiz "Which number would you like to calculate for: "
youentered:		.asciiz "You entered: "
invalidnumber:	.asciiz "You must enter a valid number (n where n >= 0)\nWould you like to try again? (y/n): "
output:			.asciiz "The calculated factorial is: "
newline:		.asciiz "\n"
exitmessage:	.asciiz "\nHave a nice day!\n"
.text
.globl main

main:
	li $v0, 4				#load function print_string
	la $a0, inputprompt		#load inputprompt into argument $a0
	syscall					#call print_string
	
	li $v0, 5				#load function read_int
	syscall					#call read_int
	
	add $t0, $v0, $zero		#user input is placed in $v0, so add it to $t0 for later
	
	li $v0, 4				#load function print_string
	la $a0, youentered		#load youentered into argument $a0
	syscall					#call print_string
	
	li $v0, 1				#load function print_int
	add $a0, $t0, $zero		#add value from $t0 (user input) to argument $a0
	syscall					#call print_int and show the number the user entered
	
	li $v0, 4				#load function print_string
	la $a0, newline			#load newline into argument $a0
	syscall					#print a newline after the users input
	
	slt $t1, $t0, 0			#set $t1 equal to 1 if $t0 < 1
	beq $t1, 1, badnumber	#if $t1 equal to 1 branch to badnumber label
	
	add $a0, $t0, $zero     #place user input in $t0
	addi $sp, $sp, -12      #move our stackpoint ($sp) up 3 words
	sw $t0, 0($sp)          #push user input onto top of stack
	sw $ra, 8($sp)          #keep a counter at the bottom of the stack
	jal factorial           #jump to the factorial loop

	lw  $s0, 4($sp)         #take calculated result from stack, store in $s0

	li $v0, 4        		#load function print_string
	la $a0, output 			#get ready to print output
	syscall 				#print the stuff before factorial is shown

	li $v0, 1               #load function print_int
	add $a0, $s0, $zero     #load factorial result into argument $a0
	syscall 				#call print_int, shows calculated result

	li $v0, 4        		#load function print_string
	la $a0, newline 		#print a newline at the end
	syscall 				#syscall print_line

	addi $sp, $sp, 12       #return the stack pointer to its original place
 
	li $v0, 10              #load function exit
	syscall                 #call system exit
	
factorial:
	lw $t0, 0($sp)          #grab user input from the top of the stack, place in $t0		
	beq $t0, 0, zerocase    #if they entered zero, make sure we return 1 and dont explode
	addi $t0, $t0, -1       #if they didn't, subtract 1 	
	addi $sp, $sp, -12      #move $sp 3 words up the stack
	sw $t0, 0($sp)          #place current number at the top of the stack
	sw $ra, 8($sp)          #counter is still at the bottom
	
	jal factorial           #lets recurse

	lw $ra, 8($sp)          #after the jump (recursion), must load the correct $ra
	lw $t1, 4($sp)          #load return value into $t1	 
	lw $t2, 12($sp)         #load previous start value into $t2		
	mul $t3, $t1, $t2       #multiply the previous 2 values, store result in $t3
	sw $t3, 16($sp)         #take $t3, place it in parent call's return value
	addi $sp, $sp, 12       #return $sp back to its original correct spot	 
	jr $ra                  #jump to the parent call
	
badnumber:
	li $v0, 4				#load function print_string
	la $a0, invalidnumber	#load invalidnumber into argument $a0
	syscall					#call print_string
	
	li $v0, 12				#load function read_char
	syscall					#read a character from the user
	
	add $t2, $v0, $zero		#store the users input in $t2 so we can print a newline
	
	li $v0, 4				#load function print_string
	la $a0, newline			#load newline into argument $a0
	syscall					#print a newline after the users input
	
	beq $t2, 121, main		#ascii code for user input character is in $v0, 121='y'

	j exit					#if anything else, goto the exit

zerocase:
	li $t0, 1               #the user entered 0, 0! = 1, load that in $t0
	sw $t0, 4($sp)			#move the "result" (just 1) to the correct place in stack
	jr $ra 					#return to the parent call
	
exit:
	li $v0, 4				#load function print_string
	la $a0, exitmessage		#load exitmessage into argument $a0
	syscall					#call print_string
	
	li $v0, 1				#return 1
	
	jr $ra					#return gracefully