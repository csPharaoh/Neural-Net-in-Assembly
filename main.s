.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args

    mv s0 a0    # s0 = # of args
    mv s1 a1    # array of filenames

    addi t3 x0 5    # t3 = 5

    bne s0 t3 arg_error #if not 5 args, error
    lw s2 4(s1)         #s2 = m0
    lw s3 8(s1)         #s3 = m1
    lw s4 12(s1)        #s4 = input file

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0

    #malloc 2 integer pointers
    addi a0 x0 4
    jal malloc
    mv s6 a0 #int pointer 1
    addi a0 x0 4
    jal malloc
    mv s7 a0 #int pointer 2

    #read the file m0.bin into a matrix
    mv a0 s2
    mv a1 s6
    mv a2 s7
    jal read_matrix

    #save the pointer to the matrix in s2, s6 = m0's row, s7 = m0's cols
    mv s2 a0
    lw s6 0(a1)
    lw s7 0(a2)

    #code to print m0
    #mv a1 s6
    #mv a2 s7
    #jal ra print_int_array

    # Load pretrained m1

    #malloc 2 integer pointers
    addi a0 x0 4
    jal malloc
    mv s8 a0 #int pointer 1
    addi a0 x0 4
    jal malloc
    mv s9 a0 #int pointer 2

    #read m1 into matrix
    mv a0 s3
    mv a1 s8
    mv a2 s9
    jal read_matrix

    #save the pointer to the matrix in s3, s8 = m1's row, s9 = m1's cols
    mv s3 a0
    lw s8 0(a1)
    lw s9 0(a2)

    #code to print m1
    #mv a1 s8
    #mv a2 s9
    #jal ra print_int_array

    # Load input matrix

    #malloc 2 int pointers to read input
    addi a0 x0 4
    jal malloc
    mv s10 a0 #int pointer 1
    addi a0 x0 4
    jal malloc
    mv s11 a0 #int pointer 2

    mv a0 s4
    mv a1 s10
    mv a2 s11
    jal read_matrix

    #save the pointer to the matrix in s4, s10 = inputs's row, s11 = inputs's cols
    mv s4 a0
    lw s10 0(a1)
    lw s11 0(a2)

    #code to print input
    #mv a1 s10
    #mv a2 s11
    #jal ra print_int_array

    # =====================================
    # RUN LAYERS
    # =====================================
    #s2 m0
    #s6 m0 rows
    #s7 m0 col
    #s3 m1
    #s8 m1 rows
    #s9 m1 col
    #s4 input
    #s10 input rows
    #s11 input col

    #Arguments of matmul
    # 	a0 is the pointer to the start of m0
    #	a1 is the # of rows (height) of m0
    #	a2 is the # of columns (width) of m0
    #	a3 is the pointer to the start of m1
    # 	a4 is the # of rows (height) of m1
    #	a5 is the # of columns (width) of m1
    #	a6 is the pointer to the the start of d
    # Returns:
    #	None, sets d = matmul(m0, m1)





    # 1. ============================================== LINEAR LAYER : m0 * input =======================================================

    mv a1 s6            # a1 = # m0 rows
    mv a2 s7            # a2 = # m0 cols
    mv a3 s4            # a3 = address of the input matrix
    mv a4 s10           # a4 = # rows of the input matrix
    mv a5 s11           # a5 = # cols of the input matrix

    mul t0 a1 a5        # malloc space for output array of matrix Multiplication (and save pointer to heap in a6)
                        # t0 = dimensions of the output matrix i.e hidden layer matrix 
    slli t0 t0 2        # t0 = 4 * t0
    mv a0 t0            # a0 = 4 * t0
    jal malloc          # allocate space for the output matrix i.e hidden layer

    # a0 now has the address of the allocated memory

                        # multiple m0 (stored in s2) and input (stored in s3), and save to a6
    mv a6 a0            # a6 = address of the output matrix i.e hidden layer matrix 
    mv a0 s2            # a0 = address of m0 matrix
    mv a1 s6
    jal ra matmul       # multiple m0 * input 



    mv t4 a6            # t4 = address of the output matrix i.e hidden layer matrix


                        # code to print output matrix i.e hidden layer matrix
    mv a0 a6            # a0 = address of the output matrix i.e hidden layer matrix
    mv a1 s6            # a1 = # m0 rows
    mv a2 s11           # a2 = # cols of the input matrix
    #=================================================== jal ra print_int_array  # print output matrix i.e hidden layer =====================



    #=========================================================================================================================================


    # 2. ========================================================== NONLINEAR LAYER: ReLU(m0 * input) ========================================

    mv a0 t4            # a0 = address of the output matrix i.e hidden layer matrix
    
    #mv a1 s6            # a1 = # m0 rows

    mul a1 s6 s11       # a1 = length of the hidden layer matrix as a vector 

    jal ra relu         # call RelU on the output matrix i.e hidden layer matrix

    # ReLU(hidden layer matrix)

    mv a0 t4            
    mv a1 s6  
    mv a2 s11  
    #=============================================== jal ra print_int_array  # print output matrix i.e hidden layer after RelU ===============





    #==========================================================================================================================================

     # 3. ========================================================== LINEAR LAYER: scores = m1 * ReLU(m0 * input) =============================

    mul t1 s8 s11       # t1 = dimensions of the scores matrix 
    slli t1 t1 2        # t1 = t1 * 4
    mv a0 t1            # a0 = dimensions of the scores matrix in bytes
    jal malloc          # malloc space for the scores matrix
    mv a6 a0            # a6 = address of empty scores matrix 

    mv a0 s3            # a0 = address of m1
    mv a1 s8            # a1 = # m1 rows = rows of scores matrix
    mv a2 s9            # a2 = # m1 cols


    mv a3 t4            # a3 = address of the output matrix i.e hidden layer matrix after RelU
                        # error suspected here


    mv a4 s6            # a4 = # m0 rows
    mv a5 s11           # a5 = # cols of the input matrix = cols of the hidden layer matrix after RelU = cols of scores matrix

    jal ra matmul       # multiply m1 * the output matrix i.e hidden layer matrix after RelU

    # a6 = scores matrix adress

    mv a0 a6            # a0 = address of the scores matrix
    mv a1 s8            # a1 = # rows of scores matrix
    mv a2 s11           # a2 = # cols of scores matrix
    #===================================================== jal ra print_int_array  # print the scores matrix =================================


    #=========================================================================================================================================



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s1) # Load pointer to output filename

    addi a1 a6 0      # a1 = address of the scores matrix
    addi a2 s8 0      # a2 = # rows of scores matrix
    addi a3 s11 0     # a3 = # cols of scores matrix
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0 a6        # a0 = address of the scores matrix
    mul a1 s8 s11   # a1 = scores (rows * cols) 
    jal argmax

    # a0 = index of the largest element in scores


    # Print classification

    mv a1 a0        # a1 = index of largest element in scores matrix 
    jal print_int   # print the index of largest element in scores matrix


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

    arg_error:
        li a1 3
        jal exit2

    print_arrayssss:
        # Print out elements of matrix
        lw a1 0(a1)
        lw a2 0(a2)
        jal ra print_int_array
