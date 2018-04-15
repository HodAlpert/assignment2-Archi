
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
section .data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .bss

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
    global main
    extern calloc
    extern readInput
    extern getDeriv
    extern getNextZ
    extern checkAcc
    extern printNumber

main:

		;z :
			;z.real - [rbp - 0x10] 
			;z.imagine - [rbp - 0x8] 
		;init* - [rbp - 0x28]
		;pol_f* - [rbp - 0x20]
		;pol_f_deriv* - [rbp - 0x18]

    enter 0x50,0 ;allocate space for local variables

    ;calloc for initDate (1,24)
    mov rdi,0x1
    mov rsi, 0x18
    mov rax, 0
    call calloc
    mov qword [rbp-0x28],rax ;init*

    ;calloc for pol_f (1,16)
    mov rdi,0x1             
    mov rsi,0x10
    mov rax, 0
    call calloc             
    mov qword [rbp-0x20],rax ;pol_f* 

	;readInput(init*, pol*)
    mov rdi,qword [rbp-0x28]
    mov rsi,qword [rbp-0x20]
    mov rax ,0
    call readInput
    
    ;getDeriv(pol*)
    mov rdi,qword [rbp-0x20]
    mov rax, 0
    call getDeriv
    mov qword [rbp-0x18],rax ; returns pol_f_deriv* 

    mov rax, qword [rbp-0x28] ;init*
    mov rbx, qword [rax+0x8] ;init->real
    mov rdx, qword [rax+0x10] ;init->imagine
    mov qword [rbp-0x10],rbx ; z.real
    mov qword [rbp-0x8],rdx ; z.imagine
   
.loop:

    ;getNextZ(z, pol_f*, pol_f_deriv)
    movsd xmm1, qword [rbp-0x8] ;xmm1-z.real
    movsd xmm0, qword [rbp-0x10];xmm0-z.imagine
    mov rdi, qword [rbp-0x20]
    mov rsi, qword [rbp-0x18]
    mov rax, 2
    call getNextZ

    movq qword [rbp-0x8],xmm1 ;nextZ.real
    movq qword [rbp-0x10], xmm0 ;nextZ.imagine

    ;checkAcc(init*, pol_f*, z) newZ is already in xmm0 and xmm1
    mov rdi, qword [rbp-0x28]              
    mov rsi, qword [rbp-0x20]              
    mov rax, 2
    call checkAcc
    
    ;test operation sets ZF to 1 when the result of the AND operation is 0
    ;Ergo, when rax=0 ZF is set to 1 and we jump to the loop. If rax is 1 then we finished.
    test rax, rax 
    je .loop                
   
    movsd xmm1, qword [rbp-0x8] 
    movsd xmm0, qword [rbp-0x10]
    mov rax, 2
    call printNumber          

    mov rax, 0
    leave
    ret