%include "video.mac"

; Frame buffer location
%define FBUFFER 0xB8000

section .data

score db "Score",0
highscore db "HighScore",0
level db "Level",0
lives db "Lives",0
P1 db "P1",0
P2 db "P2",0

section .text

extern CantJugadores


%macro Estadisticas 2
      push %2;la posicion en la que queremmos pintar
      push %1;el string que queremos escribir
      call printString
      add esp, 8
%endmacro

%macro PrintScores 2
  pushad
  ;escribir el highscore
  mov edi, 0xB8000
  add edi, %1;544;lugar de memoria de la puntuacion
  mov ecx, 5;ctdad de numeros de la puntuacion
  mov ebx, 10;para obtener cada digito de la puntuacion
  mov eax, %2;[puntuacionmax]
  %%division:
  xor edx,edx
  div ebx
  add edx, 48;para pintar el caracter de la cifra
  mov [edi], dl;usamos dl porque el resto es de una cifra
  sub edi, dword 2;para pintar para atras
  loop %%division
  popad
%endmacro

; clear(byte char, byte attrs)
; Clear the screen by filling it with char and attributes.
global clear
clear:
  
  mov ax, [esp + 4] ; char, attrs
  mov edi, FBUFFER
  mov ecx, COLS * ROWS
  cld
  rep stosw
  ret

global printString
printString:
  push ebp
  mov ebp,esp
  pushad

  mov edx,FBUFFER
  mov esi,[ebp+8]; string
  mov ecx,[ebp+12];posicion en la pantlla del string
  cld
    lodsb
  ciclo:

    mov [edx+ecx],al ;debe ir ax falta por ver lo de los colores
    add ecx,2
    lodsb
    cmp al,byte 0
    jne ciclo

  popad
  pop ebp
  ret

global EscribirEstadisticas
EscribirEstadisticas:
  push ebp
  mov ebp,esp

  pushad
 

  ;escribir el highscore
  cmp [CantJugadores],dword 2
  je _dos_Jugadores

   Estadisticas lives,334
  Estadisticas highscore,372
  Estadisticas level,448
  ;pintando corazones
  mov ecx,[ebp+8] ;[vidas]
  mov edi, 0xB8000
  mov ax, 3|FG.RED|BG.GRAY
  cld
  add edi, 494 ;a partir de aqui van los corazones
  rep stosw ;pintando corazones


    mov edx,[ebp+12]
    PrintScores dword 544,edx;puntuacionmax
     mov edx,[ebp+20]
    PrintScores dword 616,edx;[ebp+20];nivel

  Estadisticas score,410 
  mov edx,[ebp+16]
  PrintScores dword 578,edx;[ebp+16];puntuacion
  jmp _FIN

    _dos_Jugadores:;--------------------------------------------------------------------------------------

    Estadisticas level,448
  Estadisticas lives,172

    Estadisticas P1,332
    Estadisticas P2,492

    mov ecx,[ebp+8] ;[vidas]
  mov edi, 0xB8000
  mov ax, 3|FG.RED|BG.GRAY
  cld
  add edi, 338 ;a partir de aqui van los corazones
  rep stosw ;pintando corazones

  mov ecx,[ebp+28] ;[vidas]
  mov edi, 0xB8000
  mov ax, 3|FG.RED|BG.GRAY
  cld
  add edi, 498 ;a partir de aqui van los corazones
  rep stosw ;pintando corazones

  ;High score

  Estadisticas highscore,372
  mov edx,[ebp+12]
    PrintScores dword 544,edx;puntuacionmax

     mov edx,[ebp+20]
    PrintScores dword 616,edx;[ebp+20];nivel



    
  Estadisticas score,250 
  

  Estadisticas P1,410
  Estadisticas P2,570
     mov edx,[ebp+16]
    PrintScores dword 426,edx;[ebp+16];puntuacion1
    mov edx,[ebp+24]
    PrintScores dword 586,edx;[ebp+16];puntuacion2   

    _FIN:

  popad
  pop ebp
  ret





 




