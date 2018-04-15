
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
		
		;init* - 0x0-0x8	[rbp-0x8]
			;epsilon - +0x0
			;initial
				;real -   +0x8
				;imagie - +0x10

		;pol_f* - 0x8-0x10 			[rbp-0x10]
		;pol_f_deriv* -0x10-0x18 	[rbp-0x18]

		;z - [rbp-0x28]: ??? use FPU stack instead
		;z.real - 	 	 [rbp-0x28]
		;z.imagine - 	 [rbp-0x20]	
		
		;init* - [rbp - 0x28]
		;pol_f* - [rbp - 0x20]
		;pol_f_deriv* - [rbp - 0x18]

   enter 0,0
   sub rsp, 0x50 ;allocate space for local variables

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
   mov rdx, qword [rax+0x10] 
   mov rax, qword [rax+0x8] 
   mov qword [rbp-0x10],rax ; z.real
   mov qword [rbp-0x8],rdx ; z.imagine
   
   ;up the here is the same, can we shorten the loop?
   
   movsd xmm1, qword [rbp-0x8]
   movsd xmm0, qword [rbp-0x10]
   mov rsi, qword [rbp-0x18]
   mov rdi, qword [rbp-0x20]
   mov rax, 2
   call getNextZ

   movq rax,xmm0
   movapd xmm0,xmm1
   mov qword [rbp-0x10],rax
   movsd qword [rbp-0x8],xmm0
   jmp .startLoop

.loop:

   movsd xmm1,qword [rbp-0x8]
   movsd xmm0,qword [rbp-0x10]
   mov rsi,qword [rbp-0x18]             
   mov rdi, qword[rbp-0x20]                
   mov rax, 2
   call getNextZ

   movq rax,xmm0             
   movapd xmm0,xmm1            
   mov qword [rbp-0x10],rax 
   movsd qword [rbp-0x8],xmm0

.startLoop:

   movsd xmm0,qword [rbp-0x10]
   mov rsi,qword [rbp-0x20]              
   mov rdi,qword [rbp-0x28]              
   mov rax, 2
   call checkAcc             
   test eax,eax              
   je .loop                
   
   movsd xmm1, qword [rbp-0x8] 
   movsd xmm0, qword [rbp-0x10]
   mov rax, 2
   call printNumber          

   mov rax, 0
   leave
   ret

; .loop:

; 		;getNextZ(z, pol_f, pol_f_deriv) - z is two floating args - xmm0/xmm1
; 		movsd xmm0, qword [rbp - 0x10]
; 		movsd xmm1, qword [rbp - 0x8]
		
; 		mov rdi, qword [rbp - 0x20]
; 		mov rsi, qword [rbp - 0x18]
; 		mov rax, 2
; 		call getNextZ
		
; 		movq rax, xmm0
; 		movapd xmm0,xmm1
; 		mov qword [rbp - 0x10], rax
; 		movsd qword [rbp - 0x8], xmm0



; 		;checkAcc(init*, pol_f*, z)
; 		mov rdi, qword [rbp - 0x28]
; 		mov rsi, qword [rbp - 0x20]
; 		call checkAcc
; 		;test sets ZF to 1 when the result of the AND is 0(rax=0 -false). jump if ZF is 1
; 		test rax,rax
; 		je .loop

; .done:
; 		;printNumber(z)


; 		;movsd xmm0, qword [rbp - 0x10]
; 		;movsd xmm1, qword [rbp - 0x8]
; 		;mov rax, 2
; 		mov rax, qword [rbp - 0x10]
; 		movsd xmm1, qword [rbp - 0x8]
; 		mov qword [rbp - 0x48], rax
; 		movsd xmm0, qword [rbp - 0x48]

; 		call printNumber