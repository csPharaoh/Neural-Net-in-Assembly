.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

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
  addi s1 a1 0
  addi s2 a2 0
  slli s3 a3 2
  slli s4 a4 2
  addi s5 x0 0 #i
  addi s6 x0 0 #product

loop_start:
  beq s5 s2 loop_end
  mul t1 s5 s3
  mul t2 s5 s4
  add s8 s0 t1
  add s9 s1 t2
  lw s10 0(s8)
  lw s11 0(s9)
  mul t0 s10 s11
  add s6 s6 t0
  addi s5 s5 1 #i++
  jal loop_start

loop_end:
  # Epilogue
  addi a0, s6, 0
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
