%include "video.mac"

section .data


a dd 2;esta y la sigte son para generar las frutas random
c dd 3

section .text


global Random
Random:
   
    push eax
    push ebx
    push ecx
    
    otro:
    rdtsc ;pongo en eax el time-spam del micro
    mov ebx, [a];a
    mul ebx
    mov ebx, [c];c    
    add eax, ebx
    mov ebx, 4043;los valores van a estar acotados por 4000
    xor edx, edx
    div ebx

    cmp edx,963
    jb otro
    
    ;el resultado se queda en edx
    pop ecx
    pop ebx
    pop eax
    
    ret
;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
GLOBAL FrutaValida
FrutaValida:
  dameotro:
  call Random
  mov edi, 0xB8000
  add edi, edx 
  mov edi, 0xB8000
  cmp [edi + edx], byte 0
  jne dameotro

  ;el resultado queda en edx
  ret