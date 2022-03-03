
     .text

     .globl main 

main: 
   #init. 0 in s3
  li $s3,0
  
  
  li $v0,4 #print a string
  la $a0,para1 #load the adress of para1
  syscall #call the system

  li $v0,5 #read int 
  syscall
  move $t0,$v0 #move the value of v0 in t0
  
  li $v0,4 #print a string
  la $a0, para2 #load the adress of para2
  syscall
  move $a0,$s3
   loop:
       bgt $a0, $t0, exit #if(a0>=t0) go to exit
       li $v0,4 #print the character " " 
       la $a0, char #load the adress of char
       syscall
       
       
       jal fib #jump and link fib function
       add $s2,$v0,$zero #put the value of v0+0 in s2
       li $v0,1 #print int 
       add $a0,$s2,$zero #put the value of s2+0 in a0
       syscall
       
       addi $a0,$a0,1 #put the value of a0+1 in a0
       j loop #jump at loop
 
  
  


fib:
   move $a0, $s3 #put s3 in a0
   beq $a0, $zero, return #(if a0==0) go to return
   addi $t1, $zero,1 # t1=0+1
   beq $a0, $t1, return #(if a0==t1) go to return
   
   bne $a0,$t1, recursion #(if a0!=t1) go to recursion
   bne $a0,$zero, recursion #if(a0!=0) go to recursion

recursion:
    sub $sp, $sp,12 #sp=sp-12
    sw  $ra, 8($sp) #store register to memory 
    sw  $s0, 4($sp) #store register to memory 
    sw  $a0, 0($sp) #store register to memory
    
    
    #Function fib(x-1)
    addi $a0,$a0,-1 #a0=a0-1
    jal fib #jump and link at fib function
    sw  $v0,8($sp) #store register to memory
    
    #Function fib(x-2)
    addi $a0,$a0,-2 #a0=a0-2
    jal fib  #jump and link at fib function
    lw $t0, 8($sp) #load memory to register
    add $v0, $t0, $v0 #v0=t0+s0

    #Function fib(x-1)+fib(x-2)
    lw $s0, 4($sp) #load memory to register
    lw $ra,8($sp)  #load memory to register
    addi $sp,$sp,12  sp=sp+12
    jr $ra #return control to the caller

return:
  move $v0, $a0
  jr  $ra

exit:
 syscall
 li  $v0,10 #exit	
 syscall

.data
char:  .asciiz " " 
para1: .asciiz "Enter the number of terms of series : "
para2: .asciiz "\nFibonnaci Series : "
lf:    .asciiz	"\n"