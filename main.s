
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
section .data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .bss

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
    global power
    global squareAbs
    global sum
    global subtract
    global mult
    global main
    extern calloc
    extern readInput
    extern getDeriv
    extern getNextZ
    extern checkAcc
    extern printNumber
    extern calcF

; main:
; 
; 		;z :
; 			;z.real - [rbp - 0x10] 
; 			;z.imagine - [rbp - 0x8] 
; 		;init* - [rbp - 0x28]
; 		;pol_f* - [rbp - 0x20]
; 		;pol_f_deriv* - [rbp - 0x18]
; 
;     enter 0x50,0 ;allocate space for local variables
; 
;     calloc for initDate (1,24)
;     mov rdi,0x1
;     mov rsi, 0x18
;     mov rax, 0
;     call calloc
;     mov qword [rbp-0x28],rax ;init*
; 
;     ;calloc for pol_f (1,16)
;     mov rdi,0x1             
;     mov rsi,0x10
;     mov rax, 0
;     call calloc             
;     mov qword [rbp-0x20],rax ;pol_f* 
; 
; 	;readInput(init*, pol*)
;     mov rdi,qword [rbp-0x28]
;     mov rsi,qword [rbp-0x20]
;     mov rax ,0
;     call readInput
;     
;     ;getDeriv(pol*)
;     mov rdi,qword [rbp-0x20]
;     mov rax, 0
;     call getDeriv
;     mov qword [rbp-0x18],rax ; returns pol_f_deriv* 
; 
;     mov rax, qword [rbp-0x28] ;init*
;     mov rbx, qword [rax+0x8] ;init->real
;     mov rdx, qword [rax+0x10] ;init->imagine
;     mov qword [rbp-0x10],rbx ; z.real
;     mov qword [rbp-0x8],rdx ; z.imagine
;    
; .loop:
; 
;     ;getNextZ(z, pol_f*, pol_f_deriv)
;     movsd xmm1, qword [rbp-0x8] ;xmm1-z.real
;     movsd xmm0, qword [rbp-0x10];xmm0-z.imagine
;     mov rdi, qword [rbp-0x20]
;     mov rsi, qword [rbp-0x18]
;     mov rax, 2
;     call getNextZ
; 
;     movq qword [rbp-0x8],xmm1 ;nextZ.real
;     movq qword [rbp-0x10], xmm0 ;nextZ.imagine
; 
; 
;     mov rdi, [rbp-0x20]
;     ;calcF(pol_f*, z) - z is already in xmm0 and xmm1
;     call calcF
; 	movq qword [rbp-0x30],xmm1 ;f(z).real
;     movq qword [rbp-0x38], xmm0 ;f(z).imagine
; ;;צריך לשנות את tword ל oword
;     finit
;     fld tword [rbp-0x30] ;load real
;     fld st0 ;load real again
;     fmul ; real^2
;     fld tword [rbp-0x38] ;load imagine
;     fld st0 ;laod imagine again
;     fmul ;imagine^2
;     fadd ; (imagine^2 + real^2)
;     fsqrt ; ||z||
;     mov rax, qword [rbp-0x28]
;     fld tword [rax] ; load epsilon
;     fcomi
;     jle .loop
; 
; 
;     ;checkAcc(init*, pol_f*, z) newZ is already in xmm0 and xmm1
;     ; mov rdi, qword [rbp-0x28]              
;     ; mov rsi, qword [rbp-0x20]              
;     ; mov rax, 2
;     ; call checkAcc
;     
;     ; ;test operation sets ZF to 1 when the result of the AND operation is 0
;     ; ;Ergo, when rax=0 ZF is set to 1 and we jump to the loop. If rax is 1 then we finished.
;     ; test rax, rax 
;     ; je .loop                
;    
;     movsd xmm1, qword [rbp-0x8] 
;     movsd xmm0, qword [rbp-0x10]
;     mov rax, 2
;     call printNumber          
; 
;     mov rax, 0
;     leave
;     ret
;assuming xmm0=first.real, xmm1 = first.img, xmm2 = second.real, xmm3 = second.img
mult:
   enter 0x20,0
                                ; [rbp-0x20]=result.real
                                ; [rbp-0x10]=result.img
   finit
   fld Tword [rbp+0x20]        ; loading first.img
   fld Tword [rbp+0x40]        ; loading second.img
   fmul                        ; first.real*second.real
   fld Tword [rbp+0x10]        ; loading first.real
   fld Tword [rbp+0x30]        ; loading second.real
   fmulp                         ; first.img*second.img
   fsubrp                         ; first.real*second.real-first.img*second.img
   fstp Tword [rbp-0x20]        ; storing the real value
   fld Tword [rbp+0x10]        ; loading first.real
   fld Tword [rbp+0x40]        ; loading second.img
   fmulp                        ; first.real*second.img
   fld Tword [rbp+0x20]          ; loading first.img
   fld Tword [rbp+0x30]          ; loading second.real
   fmulp                         ; first.img*second.real
   faddp                         ; first.real*second.img+first.img*second.real
   fstp Tword [rbp-0x10]        ; storing the img value
   movapd xmm0, Oword [rbp-0x20]; xmm0=result.real
   movapd xmm1, Oword [rbp-0x10]; xmm1 = result.img
   movapd Oword [rdi],xmm0      ;returning result.real
   movapd Oword [rdi+0x10],xmm1 ; returning result.img
   leave
   ret

subtract:
    enter 0x20,0
     ; [rbp-0x20]=result.real
    ; [rbp-0x10]=result.img
    finit
    fld Tword [rbp+0x30]        ; loading second.real
    fld Tword [rbp+0x10]        ; loading first.real
    fsubrp                      ; first.real-second.real
    fstp Tword [rbp-0x20]        ; storing the real value
    fld Tword [rbp+0x40]        ; loading second.img
    fld Tword [rbp+0x20]        ; loading first.img
    fsubrp                      ; first.imagine-second.imagine
    fstp Tword [rbp-0x10]        ; storing the img value
    movapd xmm0, Oword [rbp-0x20]; xmm0=result.real
    movapd xmm1, Oword [rbp-0x10]; xmm1 = result.img
    movapd Oword [rdi],xmm0      ;returning result.real
    movapd Oword [rdi+0x10],xmm1 ; returning result.img
    leave
    ret
    
sum:
    enter 0x20,0
    ; [rbp-0x20]=result.real
    ; [rbp-0x10]=result.img
    finit
    fld Tword [rbp+0x30]        ; loading second.real
    fld Tword [rbp+0x10]        ; loading first.real
    faddp                      ; first.real-second.real
    fstp Tword [rbp-0x20]        ; storing the real value
    fld Tword [rbp+0x40]        ; loading second.img
    fld Tword [rbp+0x20]        ; loading first.img
    faddp                      ; first.imagine-second.imagine
    fstp Tword [rbp-0x10]        ; storing the img value
    movapd xmm0, Oword [rbp-0x20]; xmm0=result.real
    movapd xmm1, Oword [rbp-0x10]; xmm1 = result.img
    movapd Oword [rdi],xmm0      ;returning result.real
    movapd Oword [rdi+0x10],xmm1 ; returning result.img
    leave
    ret
    
squareAbs:
    enter 0x0,0
    finit
    fld Tword [rbp+0x10]
    fld Tword [rbp+0x10]
    fmulp
    fld Tword [rbp+0x20]
    fld Tword [rbp+0x20]
    fmulp
    faddp
    leave
    ret
    
power:
    enter 0x50,0
    ; [rbp-0x4] = power
    ; [rbp-0x30]=result.real
    ; [rbp-0x20]=result.img
    finit
    mov dword [rbp-0x4], esi     ; power<-[rbp-0x4]
    mov qword [rbp-0xb], rdi     ; saving the return pointer
    cmp dword esi,0
    je .returnone
    fld Tword [rbp+0x10]
    fstp Tword [rbp-0x30]
    fld Tword [rbp+0x20]
    fstp Tword [rbp-0x20]           ;loading z
    movapd xmm0, Oword [rbp-0x30]; xmm0=result.real
    movapd xmm1, Oword [rbp-0x20]; xmm1 = result.img
    movapd Oword [rbp-0x50],xmm0 ;moving result.real to call mult
    movapd Oword [rbp-0x40],xmm1 ; moving result.img to call mult
    mov ecx, esi
    sub ecx,1                       ;power = power-1 (for the loop)
    lea rdi, [rbp-0x50]     ; giving rdi return address for mult
    .myloop:
        call mult                     ; result = mult(result,z)
        loop .myloop
        jmp .return
            
    .returnone:
        fld1
        fstp Tword [rbp-0x50]   ; result.real=1
        fldz
        fstp Tword [rbp-0x40]   ; result.img = 0
    .return:
        movapd xmm0, Oword [rbp-0x50]; xmm0=result.real
        movapd xmm1, Oword [rbp-0x40]; xmm1 = result.img
        mov rdi, qword [rbp-0xb]     ; giving rdi the return address
        movapd Oword [rdi],xmm0      ;returning result.real
        movapd Oword [rdi+0x10],xmm1 ; returning result.img
        leave
        ret
    
    
    
    