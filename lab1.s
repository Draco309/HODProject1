#Kevin DeNicola
#Last Modified 07/24/19
#Sort Name Alphabetically
#kdenicola@massasoit.edu

.globl main
.data
name: .ascii "kdenicola" #9 characters, array length 9
                         #Expected output: acdeiklno
.text
    lui $sp 0x8000               #Initialize stack pointer.
#main:
     addiu $sp, $sp, -16         #Stack grows by 16 bytes
     sw $ra, 12($sp)             #Save return address into the stack
     sw $s0, 8($sp)              #Store $s0 so it can be used for i
     sw $s1, 4($sp)              #Store $s1 so it can be used for j
     addu $s0, $zero, $zero      #Initialize the i counter to 0
     addu $s1, $zero, $zero      #Initialize the j counter to 0
iloop:                           #Perform the first loop
      beq $s0, 9, iexit          #Exit loop after character position has been sorted
jloop:                           #Perform the second loop
      beq $s1, 8, jexit          #Exit loop after character has been sorted
      la $t0, name               #Load address of name array in preparation for comparison
      addu $t0, $t0, $s1         #Add the index to the base address
      lb $t1 0($t0)              #Load character at index into temp register for comparison
      lb $t2 1($t0)              #Load character at index + 1 into temp register for comparison
      blt $t1, $t2, skip         #Compare to see if the letters need to be swapped.
      addu $a0, $s1, $zero       #Pass the index j to the swap function
      jal swap                   #Call sub function swap
skip:                            #Skip swap if the letters are already alphabetically in order
      addiu $s1, $s1, 1          #Increment j counter
      j jloop                    #Return to jloop start
jexit:                           #Exit point for jloop
      addu $s1, $zero, $zero     #Reset for next loop.
      addu $s0, $s0, 1           #Increment i counter
      j iloop                    #Return to iloop start 
iexit:                           #Exit point for iloop
      lw $s0, 8($sp)             #Restore $s0 from the stack
      lw $s1, 4($sp)             #Restore $s1 from the stack
      lw $ra, 12($sp)            #Restore return address
      addiu $sp, $sp, 16         #Shrink the stack by 16 bytes                
      jr $ra                     #Return
       
swap: 
     addiu $sp, $sp, -4          #Stack grows by 4 bytes
     sw $ra, 0($sp)              #Save return address into the stack
     la $t0, name                #Load base address of name array into $t0
     addu $t0, $t0, $a0          #Add index to base address
     lbu $t1, 0($t0)             #Load character at index for swap
     lbu $t2, 1($t0)             #Load character at index + 1 for swap
     sb $t2, 0($t0)              #Replace value in name[j]
     sb $t1, 1($t0)              #Replace value in name[j+1]
     lw $ra, 0($sp)              #Restore return address
     addiu $sp, $sp, 4           #Shrink stack
     jr $ra                      #Return to function call
