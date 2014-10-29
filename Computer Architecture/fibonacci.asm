# EE 466 Computer Architecture Fall 2014
# Instructor: Dr. Chen Liu
# Project 1 Fibonacci Numbers
# Written by James Lamphere (0274872)
# Software Engineering Major
# lamphejw@clarkson.edu

.data
inputprompt:	.asciiz "How many numbers would you like: "
spacee:			.asciiz " "
youentered:		.asciiz "You entered: "
invalidnumber:	.asciiz "You must enter a valid number (n where n >= 1)\nWould you like to try again? (y/n): "
output:			.asciiz "The fibonacci numbers are: "
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
	
	slt $t1, $t0, 1			#set $t1 equal to 1 if $t0 < 1
	beq $t1, 1, badnumber	#if $t1 equal to 1 branch to badnumber label
	
	add $t3, $zero, $zero	#first number holder
	add $t4, $zero, $zero	#second number holder
	add $t5, $zero, 1		#current fibonacci number
	add $t6, $zero, $zero	#how many we've done
	
	j fibloop				#everything is all set, lets start the loop
	
fibloop:
	bge $t6, $t0, exit		#if we've printed the amount the user wants, quit
	
	li $v0, 1				#load function print_int
	add $a0, $t5, $zero		#load the current fib number into argument $a0
	syscall					#print it
	
	li $v0, 4				#load function print_string
	la $a0, spacee			#print a space in between each number
	syscall					#call print_string
	
	add $t3, $t4, $t5		#t3=t4+t5
	add $t4, $t5, $zero		#t4=t5
	add $t5, $t3, $zero		#t5=t3
	add $t6, $t6, 1			#t6=t6+1, increasing our counter
	
	j fibloop				#jump back to the beginning of loop
	
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
							#so if the user entered y, go back to the main
	j exit					#if anything else, goto the exit
	
exit:
	li $v0, 4				#load function print_string
	la $a0, exitmessage		#load exitmessage into argument $a0
	syscall					#call print_string
	
	li $v0, 1				#return 1
	
	jr $ra					#return gracefully