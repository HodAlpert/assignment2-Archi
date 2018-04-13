
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
section .data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .bss
	initData: resq 1
	pol_f: resq 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
    global main
    extern calloc
    extern readInput
    extern getDeriv
    extern getNextZ
    extern calcF

main:                                 
		enter 0, 0
		sub rsp, 0x40 ;allocate space for local variables - 4*16 bytes 
		;init - 0x0-0x8	[rbp-0x8]
			;epsilon - +0x0
			;initial
				;real -   +0x8
				;imagie - +0x10

		;pol_f - 0x8-0x10 			[rbp-0x10]
		;pol_f_deriv -0x10-0x18 	[rbp-0x18]

		;z - [rbp-0x28]:
		;z.real - 	 	 [rbp-0x28]
		;z.imagine - 	 [rbp-0x20]	

		;calloc for initDate (1,24)
		mov rdi, 0x1
		mov rsi, 0x18
		mov rax, 0
		call calloc
		mov qword [rbp - 0x8], rax
		
		;calloc for pol_f (1,16)
		mov rdi, 0x1
		mov rsi, 0x10
		call calloc
		mov qword [rbp - 0x10], rax

		mov rdi, qword [rbp - 0x8]
		mov rsi, qword [rbp - 0x10]
		mov rax, 0
		call readInput

		mov rdi, qword [rbp - 0x10]
		mov rax,0
		call getDeriv
		mov qword [rbp-0x18], rax

		mov rax, qword [rbp - 0x8] ; init
		mov rdx, qword [rax + 0x8] ; init->initial.real
		mov rax, qword [rax + 0x10]; init->initial.imagine
		mov qword [rbp - 0x28], rdx
		mov qword [rbp - 0x20], rax

		movsd xmm0, qword [rbp - 0x28]
		movsd xmm1, qword [rbp - 0x20]
		mov rdi, qword [rbp - 0x10]
		mov rsi, qword [rbp - 0x18]
		mov rax, 2
		call getNextZ

		movsd qword [rbp - 0x28], xmm0
		movsd qword [rbp - 0x20], xmm1


		mov rdi, [rbp - 0x10]
		mov rax, 2
		call calcF
		leave
		ret