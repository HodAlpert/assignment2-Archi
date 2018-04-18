; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	
section .data
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
section .bss
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
section .text
    global calcF
    global divide 
    global power
    global squareAbs
    global sum
    global subtract
    global mult
;     global main
;     extern calloc
;     extern readInput
;     extern getDeriv
    global getNextZ
;     extern checkAcc
;     extern printNumber
; 
; ; main:
; ; 
; ; 		;z :
; ; 			;z.real - [rbp - 0x10] 
; ; 			;z.imagine - [rbp - 0x8] 
; ; 		;init* - [rbp - 0x28]
; ; 		;pol_f* - [rbp - 0x20]
; ; 		;pol_f_deriv* - [rbp - 0x18]
; ; 
; ;     enter 0x50,0 ;allocate space for local variables
; ; 
; ;     calloc for initDate (1,24)
; ;     mov rdi,0x1
; ;     mov rsi, 0x18
; ;     mov rax, 0
; ;     call calloc
; ;     mov qword [rbp-0x28],rax ;init*
; ; 
; ;     ;calloc for pol_f (1,16)
; ;     mov rdi,0x1             
; ;     mov rsi,0x10
; ;     mov rax, 0
; ;     call calloc             
; ;     mov qword [rbp-0x20],rax ;pol_f* 
; ; 
; ; 	;readInput(init*, pol*)
; ;     mov rdi,qword [rbp-0x28]
; ;     mov rsi,qword [rbp-0x20]
; ;     mov rax ,0
; ;     call readInput
; ;     
; ;     ;getDeriv(pol*)
; ;     mov rdi,qword [rbp-0x20]
; ;     mov rax, 0
; ;     call getDeriv
; ;     mov qword [rbp-0x18],rax ; returns pol_f_deriv* 
; ; 
; ;     mov rax, qword [rbp-0x28] ;init*
; ;     mov rbx, qword [rax+0x8] ;init->real
; ;     mov rdx, qword [rax+0x10] ;init->imagine
; ;     mov qword [rbp-0x10],rbx ; z.real
; ;     mov qword [rbp-0x8],rdx ; z.imagine
; ;    
; ; .loop:
; ; 
; ;     ;getNextZ(z, pol_f*, pol_f_deriv)
; ;     movsd xmm1, qword [rbp-0x8] ;xmm1-z.real
; ;     movsd xmm0, qword [rbp-0x10];xmm0-z.imagine
; ;     mov rdi, qword [rbp-0x20]
; ;     mov rsi, qword [rbp-0x18]
; ;     mov rax, 2
; ;     call getNextZ
; ; 
; ;     movq qword [rbp-0x8],xmm1 ;nextZ.real
; ;     movq qword [rbp-0x10], xmm0 ;nextZ.imagine
; ; 
; ; 
; ;     mov rdi, [rbp-0x20]
; ;     ;calcF(pol_f*, z) - z is already in xmm0 and xmm1
; ;     call calcF
; ; 	movq qword [rbp-0x30],xmm1 ;f(z).real
; ;     movq qword [rbp-0x38], xmm0 ;f(z).imagine
; ; ;;צריך לשנות את tword ל oword
; ;     finit
; ;     fld tword [rbp-0x30] ;load real
; ;     fld st0 ;load real again
; ;     fmul ; real^2
; ;     fld tword [rbp-0x38] ;load imagine
; ;     fld st0 ;laod imagine again
; ;     fmul ;imagine^2
; ;     fadd ; (imagine^2 + real^2)
; ;     fsqrt ; ||z||
; ;     mov rax, qword [rbp-0x28]
; ;     fld tword [rax] ; load epsilon
; ;     fcomi
; ;     jle .loop
; ; 
; ; 
; ;     ;checkAcc(init*, pol_f*, z) newZ is already in xmm0 and xmm1
; ;     ; mov rdi, qword [rbp-0x28]              
; ;     ; mov rsi, qword [rbp-0x20]              
; ;     ; mov rax, 2
; ;     ; call checkAcc
; ;     
; ;     ; ;test operation sets ZF to 1 when the result of the AND operation is 0
; ;     ; ;Ergo, when rax=0 ZF is set to 1 and we jump to the loop. If rax is 1 then we finished.
; ;     ; test rax, rax 
; ;     ; je .loop                
; ;    
; ;     movsd xmm1, qword [rbp-0x8] 
; ;     movsd xmm0, qword [rbp-0x10]
; ;     mov rax, 2
; ;     call printNumber          
; ; 
; ;     mov rax, 0
; ;     leave
; ;     ret
; ;assuming xmm0=first.real, xmm1 = first.img, xmm2 = second.real, xmm3 = second.img

mult:
;assuming first.real in [rbp+0x10]
;assuming first.img in [rbp+0x20]
;assuming second.real in [rbp+0x30]
;assuming second.img in [rbp+0x40]
;assuming address to put result is in rdi
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
   fld Tword [rbp-0x20]; xmm0=result.real
   fstp Tword [rdi]      ;returning result.real
   fld Tword [rbp-0x10]; xmm1 = result.img
   fstp Tword [rdi+0x10] ; returning result.img
   leave
   ret

subtract:
;assuming first.real in [rbp+0x10]
;assuming first.img in [rbp+0x20]
;assuming second.real in [rbp+0x30]
;assuming second.img in [rbp+0x40]
;assuming address to put result is in rdi
    enter 0x20,0
    finit
    fld Tword [rbp+0x30]        ; loading second.real
    fld Tword [rbp+0x10]        ; loading first.real
    fsubrp                      ; first.real-second.real
    fstp Tword [rbp-0x20]        ; storing the real value
    fld Tword [rbp+0x40]        ; loading second.img
    fld Tword [rbp+0x20]        ; loading first.img
    fsubrp                      ; first.imagine-second.imagine
    fstp Tword [rbp-0x10]        ; storing the img value
    fld Tword [rbp-0x20]; xmm0=result.real
    fstp Tword [rdi]      ;returning result.real
    fld Tword [rbp-0x10]; xmm1 = result.img
    fstp Tword [rdi+0x10]; returning result.img
    leave
    ret
    
sum:
;assuming first.real in [rbp+0x10]
;assuming first.img in [rbp+0x20]
;assuming second.real in [rbp+0x30]
;assuming second.img in [rbp+0x40]
;assuming address to put result is in rdi
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
    fld Tword [rbp-0x20]; xmm0=result.real
    fstp Tword [rdi]      ;returning result.real
    fld Tword [rbp-0x10]; xmm1 = result.img
    fstp Tword [rdi+0x10] ; returning result.img
    leave
    ret
    
squareAbs:
;assuming z.real in [rbp+0x10]
;assuming z.img in [rbp+0x20]
;value will return in st(0)
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
; assuming power is in esi
; assuming return value pointer is in rdi
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
    fld Tword [rbp-0x30]; xmm0=result.real
    fstp Tword [rbp-0x50] ;moving result.real to call mult
    fld Tword [rbp-0x20]; xmm1 = result.img
    fstp Tword [rbp-0x40]; moving result.img to call mult
    mov ecx, esi
    sub ecx,1                       ;power = power-1 (for the loop)
    cmp ecx,0
    je .return
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
        mov rdi, qword [rbp-0xb]     ; giving rdi the return address
        fld Tword [rbp-0x50]; xmm0=result.real
        fstp Tword [rdi]      ;returning result.real
        fld Tword [rbp-0x40]; xmm1 = result.img
        fstp Tword [rdi+0x10] ; returning result.img
        leave
        ret
    
divide:
;assuming first.real in [rbp+0x10]
;assuming first.img in [rbp+0x20]
;assuming second.real in [rbp+0x30]
;assuming second.img in [rbp+0x40]
;assuming address to put result is in rdi
    push rbp
    mov rbp,rsp
    sub rsp, 0x20
    ;[rbp-0x10] = absolute
    ;[rbp-0x20] = result.img
    ;[rbp-0x30] = result.real
    ;[rbp-0x40] = divisorConjugate.img
    ;[rbp-0x50] = divisorConjugate.real
    ;[rbp-0x60] = dividend.img
    ;[rbp-0x70] = dividend.real
    fld Tword [rbp+0x30]
    fstp Tword [rbp-0x20];saving -divisorConjugate.real
    fld Tword [rbp+0x40]
    fstp Tword [rbp-0x10]; saving dividend.img
    call squareAbs
    sub rsp, 0x50
    fstp Tword [rbp-0x10]       ;[rbp-0x10] <- absolute
    fld Tword [rbp+0x40]
    fld1
    fldz
    fsubrp
    fmulp
    fstp Tword [rbp-0x40] ;saving -divisorConjugate.img
    fld Tword [rbp+0x30]
    fstp Tword [rbp-0x50];saving -divisorConjugate.real
    fld Tword [rbp+0x20]
    fstp Tword [rbp-0x60]; saving dividend.img
    fld Tword [rbp+0x10]
    fstp Tword [rbp-0x70]; saving dividend.real
    mov rsi,rdi                 ; saving rdi
    lea rdi, [rbp-0x30]        ; giving rdi the result address
    call mult
    mov rdi,rsi                 ; restoring rdi
    fld Tword [rbp-0x30] ; load result.real
    fld Tword [rbp-0x10] ;load absolute
    fdivp           ; result.real/absolute
    fstp Tword [rdi] ;saving result.real
    fld Tword [rbp-0x20] ; load result.real
    fld Tword [rbp-0x10] ;load absolute
    fdivp           ; result.real/absolute
    fstp Tword [rdi+0x10] ;saving result.real
    leave
    ret
    

%xdefine address_of_the_return_value qword [rbp-0x8]
%xdefine pol_address qword [rbp-0x10]
%xdefine z_img [rbp-0x20]
%xdefine z_real [rbp-0x30]
%xdefine index dword [rbp-0x34]
%xdefine pol_order dword [rbp-0x38]
%xdefine result_img [rbp-0x48]
%xdefine result_real [rbp-0x58]
%xdefine element_i_img [rbp-0x68]
%xdefine element_i_real [rbp-0x78]
%xdefine x_power_i_img [rbp-0x88]
%xdefine x_power_i_real [rbp-0x98]
%xdefine second_parameter_img [rbp-0xa8]
%xdefine second_parameter_real [rbp-0xb8]
%xdefine fisrt_parameter_img [rbp-0xc8]
%xdefine first_parameter_real [rbp-0xd8]

calcF:
    ;assuming rdi has the address of the return value
    ;assuming rsi =polynom* pol
    ;assuming [rbp+0x10]= z.real
    ;assuming [rbp+0x20]=z.img
    enter 0xd8,0
    mov address_of_the_return_value, rdi
    mov pol_address, rsi
    fld Tword [rbp+0x10]
    fstp Tword z_real
    fld Tword [rbp+0x20]
    fstp Tword z_img
    mov index, 0
    mov esi, Dword [rsi]
    mov pol_order, esi
    fldz
    fldz
    fstp Tword result_real
    fstp Tword result_img
    .myloop:
        fld Tword z_real
        fstp Tword first_parameter_real
        fld Tword z_img
        fstp Tword fisrt_parameter_img
;         movapd Oword z_real, xmm0
;         movapd oword z_img, xmm1

        lea rdi, x_power_i_real         ; giving rdi the address of xpoweri to call power
        mov esi, index
        call power          ;calling xPowerI = power(z,i)
        
        fld Tword x_power_i_real
        fstp Tword first_parameter_real
        fld Tword x_power_i_img
        fstp Tword fisrt_parameter_img      ;moving first parameter for mult
        mov rax, pol_address                        
        mov rax, [rax+0x8]
        mov edx, index
        movsxd rdx, edx
        shl rdx, 5
        add rax, rdx
        fld Tword [rax]        ; xmm0<-coeffs[i].real
        fstp Tword second_parameter_real
        fld Tword [rax+0x10]   ; xmm1<-coeffs[i].img
        fstp Tword second_parameter_img         ; moving second parameter for mult
        lea rdi, element_i_real
        call mult           ; element_i = mult(xPowerI,pol->coeffs[i])
        
        fld Tword result_real
        fstp Tword first_parameter_real
        fld Tword result_img
        fstp Tword fisrt_parameter_img      ;moving first parameter for sum
        fld Tword element_i_real        ; xmm0<-element_i.real
        fstp Tword second_parameter_real
        fld Tword element_i_img               ; xmm1<-element_i.img
        fstp Tword second_parameter_img         ; moving second parameter for mult
        lea rdi, result_real
        call sum
        ;checking loop consitions
        inc index
        mov esi, index
        cmp esi, pol_order
        jle .myloop
        mov rdi, address_of_the_return_value
        fld Tword result_real
        fstp Tword [rdi]
        fld Tword result_img
        fstp Tword [rdi+0x10]
        leave
        ret
        
%xdefine z_real Tword [rbp+0x10]
%xdefine z_img Tword [rbp+0x20]
%xdefine return_address qword [rbp-0x8]
%xdefine pol_f_address qword [rbp-0x10]
%xdefine pol_f_deriv_address qword [rbp-0x18]
%xdefine z_f_img Tword [rbp-0x28]
%xdefine z_f_real Tword [rbp-0x38]
%xdefine z_f_deriv_img Tword [rbp-0x48]
%xdefine z_f_deriv_real Tword [rbp-0x58]
%xdefine quotient_img Tword [rbp-0x68]
%xdefine quotient_real Tword [rbp-0x78]
%xdefine first_img Tword [rbp-0x88]
%xdefine first_real Tword [rbp-0x98]
%xdefine second_img Tword [rbp-0xa8]
%xdefine second_real Tword [rbp-0xb8]

getNextZ:
; assuming rdi has address to return answer
; assuming rsi = pol_address
; assuming rdx = pol_deriv_address
enter 0xb8,0
mov return_address, rdi
mov pol_f_address, rsi
mov pol_f_deriv_address, rdx
;calling calcF(pol_f,z)
fld z_real
fstp second_real
fld z_img
fstp second_img
lea rdi,[rbp-0x38]      ; setting return address for calcF (z_f)
call calcF
; calling calcF(pol_f_deriv,z)
mov rsi, pol_f_deriv_address
lea rdi, [rbp-0x58] ; setting return address for calcF (z_f_deriv)
call calcF
;calling divide(z_f, z_f_deriv)
fld z_f_deriv_real
fstp first_real
fld z_f_deriv_img
fstp first_img
fld z_f_real
fstp second_real
fld z_f_img
fstp second_img
lea rdi,[rbp-0x78]  ; setting return value address for divide (quotient)
call divide
;calling subtract(z, quotient)
fld z_real
fstp second_real
fld z_img
fstp second_img
fld quotient_real
fstp first_real
fld quotient_img
fstp first_img
mov rdi, return_address
call subtract
leave
ret
    
    

    

    
