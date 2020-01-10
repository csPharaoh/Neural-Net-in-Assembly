.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	  a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================

argmax:
    # Prologue

    lw t1 0(a0)  # max so far
    add t2 x0 x0 # max index so far
    add t4 x0 x0 # current index

loop_start:

  addi a1 a1 -1 # decrease counter
  beq a1 x0 loop_end

  addi a0 a0 4  # next element in the array
	addi t4 t4 1  # update index
	lw t3 0(a0)   # current value
	blt t1 t3 updateMax

	j loop_start


updateMax:
   addi t1 t3 0
   addi t2 t4 0
   beq a1 x0 loop_end
   j loop_start

loop_end:
    addi a0 t2 0
    jr ra
    # Epilogue
