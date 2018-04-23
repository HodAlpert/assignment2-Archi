

%macro check_malloc 0 
jne %%skip
call malloc_failed
%%skip:
%endmacro
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	
section .data
	printResult: DB "root = %.*Le %.*Le",10,0
	printDividedByZero: DB "Divided by zero",10,0
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
    global main
    global readInput
    global getDeriv
    global getNextZ
    global malloc_failed

    extern calloc
    extern free
    extern scanf
    extern printf

%xdefine arg_z_real Tword [rbp-0x80]
%xdefine arg_z_img Tword [rbp-0x70]
%xdefine init_address qword [rbp-0x68]
%xdefine pol_f_address qword [rbp-0x60]
%xdefine pol_f_deriv_address qword [rbp-0x58]
%xdefine result_z_real Tword [rbp-0x50]
%xdefine result_z_img Tword [rbp-0x40] 
%xdefine f_z_real Tword [rbp-0x30]
%xdefine f_z_img Tword [rbp-0x20]

main:

enter 0x80,0 ;allocate space for local variables

    ;calloc for initDate (1,48)
    mov rdi, 0x1
    mov rsi, 0x30
    mov rax, 0
    call calloc
    cmp rax, 0
	check_malloc

    mov qword init_address, rax ;init*

    ;calloc for pol_f (1,16)
    mov rdi,0x1
    mov rsi,0x10
    mov rax, 0
    call calloc
    cmp rax, 0
	check_malloc

    mov qword pol_f_address, rax ;pol_f* 

	;readInput(init*, pol*)
    mov rdi, qword init_address
    mov rsi, qword pol_f_address
    call readInput
    
    ;getDeriv(pol*)
    mov rdi, qword pol_f_address
    call getDeriv
    mov qword pol_f_deriv_address, rax ; returns pol_f_deriv* 

    mov rax, qword init_address ;init*
    finit
    fld Tword [rax+0x10] ;init->initial.real
    fstp Tword result_z_real
    fld Tword [rax+0x20] ;init->initial.imagine
    fstp Tword result_z_img


.loop:

    ;getNextZ(z, pol_f*, pol_f_deriv)
    lea rdi, [rbp-0x50] ;result in rdi

    push qword [rbp-0x38]
    push qword [rbp-0x40]
    push qword [rbp-0x48]
    push qword [rbp-0x50]
    
   	
    mov rsi, qword pol_f_address
    mov rdx, qword pol_f_deriv_address
    call getNextZ
    
    ;calcF(pol_f*, z)
    lea rdi, [rbp-0x30] ;return address for calcF
    
    add rsp, 0x20
    push qword [rbp-0x38]
    push qword [rbp-0x40]
    push qword [rbp-0x48]
    push qword [rbp-0x50]
    
   
    mov rsi, pol_f_address
    call calcF

    add rsp, 0x20
    push qword [rbp-0x18]
    push qword [rbp-0x20]
    push qword [rbp-0x28]
    push qword [rbp-0x30]
    
    call squareAbs
    add rsp, 0x20
    mov rax, qword init_address
    fld Tword [rax] ;load epsilon
    fld st0
    fmul ;epsilon^2
    fucomi ; epsilon^2 < 
    jb .loop ;if (CF=1)

    fld Tword result_z_real
    fld Tword result_z_img
    
    lea rsp, [rsp-0x10]
    fstp Tword [rsp]
    lea rsp, [rsp-0x10]
    fstp Tword [rsp]
	
    mov rsi, 0x11
    mov rdx, 0x11
    mov rax, 0
    mov rdi, printResult
    call printf

    mov rdi, init_address
    call free

    mov rbx, pol_f_address
    mov rdi, [rbx+0x8]
    call free
    mov rdi, rbx
    call free

    mov rbx, pol_f_deriv_address
    mov rdi, [rbx+0x8]
    call free
    mov rdi, rbx
    call free

    leave
    ret


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

    fldz ;check if dividing by zero
    fcomi
    je .divided_by_zero
    fstp Tword [rbp-0x10]
    
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


.divided_by_zero:

	mov rdi, printDividedByZero
	mov rax, 0
	call printf
	mov rax, 60
	syscall
    

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


%xdefine index dword [rbp-0x20]
%xdefine pol_f_address qword [rbp-0x18]
;%xdefine index qword [rbp-0x10]
%xdefine pol_f_deriv_address qword [rbp-0x8]

getDeriv:

	enter 0x20, 0
	mov pol_f_address, rdi

	;calloc for pol_f_deriv (1,16)
    mov rdi,0x1
    mov rsi,0x10
    mov rax, 0
    call calloc
    cmp rax, 0
	check_malloc
    
    mov qword pol_f_deriv_address, rax ;pol_f*

    ;calloc for pol_f_deriv->coeffs (pol_f->order, 32)
    mov rax, qword pol_f_address
    mov eax, dword [rax]
    cdqe ;convert dword to qword RAX = sign extend of EAX
    mov rdi, rax
    mov rsi, 0x20
    call calloc
    cmp rax, 0
	check_malloc

    mov rdx, pol_f_deriv_address
    mov dword [rdx], 0x0 ;set pol_f_deriv->order = 0
    mov [rdx+0x8], rax ;pol_f_deriv->coeffs

    mov rax, pol_f_address
    mov edx, dword [rax] ;pol_f->order

    cmp edx, 0x0
    je .order_is_zero ; if order = 0, we are done
    
    sub edx, 0x1 ;possible without lea?
    mov rax, pol_f_deriv_address
    mov dword [rax], edx ;pol_f_deriv->order = pol_f->order-1

    mov dword index, 0x0 ; set loop-index to 0

.forLoop:
	
	mov rax, pol_f_deriv_address 
	mov rax, [rax + 0x8] ;pol_f_deriv->coeffs*
	movsxd rdx, dword index 
	shl rdx, 0x5
	add rdx, rax ;pol_f_deriv->coeffs + 0x20*index (32=2^5 = 0x20)
	
	mov rax, pol_f_address 
	mov rax, [rax + 0x8] ;pol_f->coeffs*
	movsxd rcx, dword index
	add rcx, 0x1 
	shl rcx, 0x5
	add rcx, rax ;pol_f->coeffs +1 + 0x20*index

	finit
	fld Tword [rcx] ;load pol_f->coeff[index+1].real
	mov eax, dword index
	fild dword index
	fld1
	fadd ;index+1
	fmul 
	fstp Tword [rdx] ;pol_f->coeff[index+1].real*(index+1)
	
	fld Tword [rcx+0x10] ;load pol_f->coeff[index+1].image
	mov eax, dword index
	fild dword index
	fld1
	fadd ;index+1
	fmul 
	fstp Tword [rdx+0x10] ;pol_f->coeff[index+1].image*(index+1)

	add dword index, 0x1

	mov r8, qword pol_f_address
	mov eax, dword [r8]
	cmp eax, dword index ;if pol_f->order <= loop-index, continue loop
	jg .forLoop

.order_is_zero:

	mov rax, pol_f_deriv_address
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
    
section .data
epsilon_string:
    db "epsilon = %Lf",10,0
order_string:
    db "order = %d",10,0
coeff_string:
    db "coeff %d = %Lf %Lf",10,0
initial_string:
    db "initial = %Lf %Lf",0
fs_malloc_failed:
	db "A call to malloc() failed", 10, 0
section .bss
treal:
    resq 2
timg:    
    resq 2
tcurrent:
    resd 1
epsilon:
    resq 2

section .text
%xdefine initDataAdress qword [rbp-0x10]
%xdefine polAddress qword [rbp-0x20]
%xdefine coeffsAddress qword[rbp-0x30]
%xdefine indexLoop dword[rbp-0x40]

readInput:
    enter 0x40,0
    mov initDataAdress, rdi
    mov polAddress, rsi
    ;calling scanf for epsilon
    mov rsi, epsilon
    mov rdi, qword epsilon_string
    mov rax,0
    call scanf
    mov rsi, initDataAdress
    fld Tword [epsilon]
    fstp Tword [rsi]
    ;calling scanf for order
    mov rdi, qword order_string
    mov rsi, polAddress
    mov rax, 2
    call scanf
    mov rdi, polAddress
    mov edi,dword [rdi]
    add edi, 1
    mov esi, 0x20
    call calloc
    cmp rax, 0
	check_malloc
    
    mov rdx, polAddress
    mov [rdx+8], rax    ;pol->coeff assignment
    mov coeffsAddress, rax
    mov rcx, polAddress
    mov ecx,dword [rcx]
    inc ecx
    mov indexLoop, ecx
    .myloop:
    ;preparing scanf
        mov rdi, qword coeff_string
        mov rsi, qword tcurrent
        mov rcx, qword timg
        mov rdx, qword treal
        xor rax, rax
        call scanf
        mov rax, polAddress
        mov rax, [eax+8]
        mov edx, dword [tcurrent]
        movsxd rdx,edx
        shl rdx,5
        add rax,rdx
        fld Tword [treal]
        fstp Tword [rax]
        fld Tword [timg]
        fstp Tword [rax+0x10]
        dec indexLoop
        cmp indexLoop,0
        jg .myloop
    mov rdi, initial_string
    mov rsi, initDataAdress
    lea rsi, [rsi+0x10]
    lea rdx, [rsi+0x10]
    xor rax,rax
    call scanf
    leave 
    ret

malloc_failed:
    mov rdi, fs_malloc_failed
    mov rax, 0
    call printf
    mov rax, 60
    syscall