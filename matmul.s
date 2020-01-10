.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	  a1 is the # of rows (height) of m0
#	  a2 is the # of columns (width) of m0
#	  a3 is the pointer to the start of m1
#   a4 is the # of rows (height) of m1
#	  a5 is the # of columns (width) of m1
#	  a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

  # Error if mismatched dimensions
  bne a2 a4 mismatched_dimensions

  # Prologue
  addi sp, sp, -52
  sw ra 0(sp) #return value
  sw s0 4(sp) #max
  sw s1 8(sp) #i
  sw s2 12(sp)
  sw s3 16(sp)
  sw s4 20(sp) #stride 0
  sw s5 24(sp) #stride 1
  sw s6 28(sp)
  sw s7 32(sp)
  sw s8 36(sp)
  sw s9 40(sp)
  sw s10 44(sp)
  sw s11 48(sp)

  addi s0 a0 0
  addi s1 a3 0
  addi s2 a1 0 #s2 = m
  addi s3 a5 0 #s3 = k
  addi s4 x0 0 #i = 0 (i < m)
  addi s6 a6 0
  addi s7 a2 0 #n

outer_loop_start:
  beq s4 s2 outer_loop_end #(if i = m)
  addi s5 x0 0 #j = 0  (j < k)
  mul t1 s4 s7 #(t1 = i*n)
  slli t1 t1 2 #(t1 = 4*i*n (int size))
  add a0 s0 t1 #(a0 = m0 + i*4*n)
  addi a3 x0 1 #(stride = 1)


  addi s8 x0 0

inner_loop_start:
  beq s8 s3 inner_loop_end #(if j = k)
  slli t2 s8 2 #(t2 = 4*j)
  add a1 s1 t2
  addi a4 a5 0 #stride = n
  addi s10 a0 0 #lw s10 0(a0)
  jal ra dot
  sw a0 0(s6)
  addi a0 s10 0 #lw a0 0(s10)
  addi s6 s6 4
  addi s8 s8 1 #(j++)
  j inner_loop_start

inner_loop_end:
  addi s4 s4 1 #(i++)

  j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp) #j
    lw s5 24(sp) #j
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    lw s10 44(sp)
    lw s11 48(sp)
    addi sp, sp, 52
    ret
    jr ra


mismatched_dimensions:
    li a1 2
    jal exit2
