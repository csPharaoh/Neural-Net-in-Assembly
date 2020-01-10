.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -52
    sw ra 0(sp) #return value
    sw s0 4(sp) #max
    sw s1 8(sp) #i
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp) #stride 1
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)
    sw s10 44(sp)
    sw s11 48(sp)

    addi s9 x0 -1 #s9 = -1

    mv s0 a0
    mv s1 a1 #s1 = pointer to int 1
    mv s2 a2 #s2 = "" to int 2

    mv a1 s0
    addi a2 x0 5
    jal ra fopen
    mv s10 a0 #s10 = file descriptor
    beq a0 s9 eof_or_error

    mv a1 s10
    mv a2 s1
    addi a3 x0 4
    jal ra fread
    bne a0 a3 eof_or_error

    mv s4 a2 #rows

    mv a1 s10
    mv a2 s2
    addi a3 x0 4
    jal ra fread
    bne a0 a3 eof_or_error

    mv s5 a2 #columns

    lw t0 0(s4)
    lw t1 0(s5)

    mul s6 t0 t1
    slli a0 s6 2
    add s11 a0 x0
    jal ra malloc #(rows*colums + 8)
    mv s8 a0 #s8 is file buffer

    mv a1 s10
    mv a2 s8
    mv a3 s11
    jal ra fread
    bne a0 a3 eof_or_error

    mv a1 s10
    jal ra fclose
    beq a0 s9 eof_or_error

    mv a0 a2

    # Epilogue
    mv a1 s4
    mv a2 s5

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

eof_or_error:
    li a1 1
    jal exit2
