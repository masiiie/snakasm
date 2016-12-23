%include "video.mac"
%include "keyboard.mac"


section .data 
opcion db 0

presentacion1 db " ____  _   _     _     _  __ _____        _     ____  __  __ ",0
presentacion2 db "/ ___|| \ | |   / \   | |/ /| ____|      / \   / ___||  \/  |",0
presentacion3 db "\___ \|  \| |  / _ \  | ' / |  _|       / _ \  \___ \| |\/| |",0
presentacion4 db " ___) | |\  | / ___ \ | . \ | |___  _  / ___ \  ___) | |  | | ",0
presentacion5 db "\____/|_| \_|/_/   \_\|_|\_\|_____|(_)/_/   \_\\____/|_|  |_|",0

cantP11 db " _",0
cantP12 db "/ |",0
cantP13 db "| |",0
cantP14 db "| |",0
cantP15 db "|_|",0

cantP21 db " ____",0
cantP22 db "|___ \",0
cantP23 db "  __) |",0
cantP24 db " / __/",0
cantP25 db "|_____|",0
limpio db  "       ",0

nivel1 db "Nivel-1",0
nivel2 db "Nivel-2",0
nivel3 db "Nivel-3",0
nivel4 db "Nivel-4",0
nivel5 db "Nivel-5",0
nivel6 db "Nivel-6",0
nivel7 db "Nivel-7",0
nivel8 db "Nivel-8",0
nivel9 db "Nivel-9",0
nivel10 db "Nivel-10",0

string1 db "INICIAR JUEGO NUEVO",0
string2 db "UN JUGADOR",0
string3 db "DOS JUGADORES CO-OP",0
string4 db "SUPERVIVENCIA (1 JUGADOR)",0

string5 db "PUEDE SELECCIONAR EL MAPA DESEADO CON LAS TECLAS F1...F10",0
string6 db "<= DIFICULTAD =>",0

ElementoSelec db '*',0
ElementoDselec db ' ',0
tatica dq 0

opcionSelec dd 1
global dificultad
dificultad dd 1 

section .text

extern printString
extern scan
extern delay
extern vidas1
extern vidas2
extern puntuacion1
extern puntuacion2
extern nivel
extern nivelSelec
extern CantJugadores
extern supervivencia

; Bind a key to a procedure
%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
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

global Draw_Image 
Draw_Image:
		        
	    call Title 

      push dword 1330;la posicion en la que queremmos pintar
      push string1;el string que queremos escribir
      call printString
      add esp, 8

      push dword 1660;la posicion en la que queremmos pintar
      push string2;el string que queremos escribir
      call printString
      add esp, 8

      push dword 1970;la posicion en la que queremmos pintar
      push string3;el string que queremos escribir
      call printString
      add esp, 8

      push dword 2286;la posicion en la que queremmos pintar
      push string4;el string que queremos escribir
      call printString
      add esp, 8

      push dword 2900;la posicion en la que queremmos pintar
      push string5;el string que queremos escribir
      call printString
      add esp, 8

      push dword 3258;la posicion en la que queremmos pintar
      push string6;el string que queremos escribir
      call printString
      add esp, 8

      call PintaDific

      call get_input1
      
ret

  up:
      pushad

      mov eax,[opcionSelec]
      dec eax
      cmp eax,0
      jne aqui
      mov eax,4
      aqui:
      mov [opcionSelec],eax
      call SeleccionarElem
     
      popad
  ret;

down:
      
      pushad

      mov eax,[opcionSelec]
      mov ebx, 4
      xor edx, edx
      div ebx
      inc edx       ;tomo el resto del nivel en el que estamos con 4 y le incemento 1
      mov [opcionSelec], edx

      call SeleccionarElem
     
      popad
  ret;

  SeleccionarElem:
    pushad
     call QuitaElemenSelec
     mov edx,[opcionSelec]
      cmp edx,2
      jg mayor

      cmp edx,2
      jne uno
      push dword 1696;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      uno:
      push dword 1376;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      mayor:

      cmp edx,3
      jne cuatro
      push dword 2016;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      cuatro:

      push dword 2336;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      fin:

      popad

  ret

  QuitaElemenSelec:
     push dword 1696;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8

      push dword 1376;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
     
     
      push dword 2016;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
     
      push dword 2336;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
  ret

selec:

    cmp [opcionSelec],byte 2
    jg _mayor

      cmp [opcionSelec],byte 1
      jne _dos

      
      call AnimacionCambioDePantalla
     
      mov al,1;aqui dejo la señal de que seleccione y tiene q salir del menu

      ret

      _dos:

      call QuitaCantJugadores
      mov [CantJugadores],dword 1

      call UnJugador
      
      ret

    _mayor:

      call QuitaCantJugadores
      cmp [opcionSelec],byte 3
      je tres

      ;aqui hacer el de supervivencia----------------------------------------------------
        

      ;mov [puntuacion1],dword 0
      call AnimacionCambioDePantalla     
      mov al,1;aqui dejo la señal de que seleccione y tiene q salir del menu      
      mov [CantJugadores],dword 1
      mov [supervivencia],byte 1
      ;tengo q dejar una señal para saber que es el modo supervivencia
      ;hasta aqui el de supervivencia----------------------------------------------------

        ret
      tres:
         mov [CantJugadores],dword 2
        
        call DosJugadores
          
  ret



UnJugador:
      push dword 1390;la posicion en la que queremmos pintar
      push cantP11;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1550;la posicion en la que queremmos pintar
      push cantP12;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1710;la posicion en la que queremmos pintar
      push cantP13;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1870;la posicion en la que queremmos pintar
      push cantP14;el string que queremos escribir
      call printString
      add esp, 8

       push dword 2030;la posicion en la que queremmos pintar
      push cantP15;el string que queremos escribir
      call printString
      add esp, 8

ret

DosJugadores:
      push dword 1390;la posicion en la que queremmos pintar
      push cantP21;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1550;la posicion en la que queremmos pintar
      push cantP22;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1710;la posicion en la que queremmos pintar
      push cantP23;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1870;la posicion en la que queremmos pintar
      push cantP24;el string que queremos escribir
      call printString
      add esp, 8

       push dword 2030;la posicion en la que queremmos pintar
      push cantP25;el string que queremos escribir
      call printString
      add esp, 8

ret

QuitaCantJugadores:
  
    push dword 1390;la posicion en la que queremmos pintar
      push limpio;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1550;la posicion en la que queremmos pintar
      push limpio;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1710;la posicion en la que queremmos pintar
      push limpio;el string que queremos escribir
      call printString
      add esp, 8

       push dword 1870;la posicion en la que queremmos pintar
      push limpio;el string que queremos escribir
      call printString
      add esp, 8

       push dword 2030;la posicion en la que queremmos pintar
      push limpio;el string que queremos escribir
      call printString
      add esp, 8
  
ret


get_input1:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'
    ; Your bindings here
    bind KEY.UP, up
    bind KEY.DOWN, down

    bind KEY.LEFT,bajarDific
    bind KEY.RIGHT,subirDific

    bind KEY.ENTER,selec

    bind KEY.F1,F1
    bind KEY.F2,F2
    bind KEY.F3,F3
    bind KEY.F4,F4
    bind KEY.F5,F5
    bind KEY.F6,F6
    bind KEY.F7,F7
    bind KEY.F8,F8
    bind KEY.F9,F9
    bind KEY.F10,F10


    add esp, 2 ; free the stack
    ret


global AnimacionCambioDePantalla
AnimacionCambioDePantalla:
  pushad
  mov ecx,80
  mov edx,0
  mov edi,318
 oo:

   pushad
   espera:
    
      push dword 20
      push tatica

      call delay
      add esp, 8
      cmp eax, 0
      je espera
   popad

      push edx
      push edi
      mov ax,176|FG.BLACK|BG.GRAY

      mov esi,0xB8000
      push ecx
      mov ecx,25      
      mov ebx,320

      ____aqui:  ;pinta los puntos verticales

        mov [esi+edx],ax
        mov [esi+edi],ax
        add edi,ebx
        add edx,ebx

      loop ____aqui
      pop ecx
      pop edi
      pop edx

      add edx,dword 2
      sub edi,dword 2

      loop oo
      popad
ret

bajarDific:
    push eax
      mov eax,[dificultad]
      cmp eax,1
      jbe _fin_
        dec eax
        mov [dificultad],eax
      _fin_:
      call PintaDific
    pop eax
  ret
subirDific:    
    push eax
      mov eax,[dificultad]
      cmp eax,3
      jge _fin_1
        inc eax
        mov [dificultad],eax
      _fin_1:
      call PintaDific
    pop eax
  ret

PintaDific:
  push eax
  mov eax,0xB8000
  cmp [dificultad],byte 1
  je facil
  cmp [dificultad],byte 2
  je medio  
  ;dificil
    mov [eax+3584],word 158|FG.GREEN|BG.GREEN
    mov [eax+3586],word 158|FG.GREEN|BG.GREEN
    mov [eax+3588],word 158|FG.GREEN|BG.GREEN

    mov [eax+3590],word 158|FG.YELLOW|BG.YELLOW
    mov [eax+3592],word 158|FG.YELLOW|BG.YELLOW
    mov [eax+3594],word 158|FG.YELLOW|BG.YELLOW

    mov [eax+3596],word 158|FG.RED|BG.RED
    mov [eax+3598],word 158|FG.RED|BG.RED
    mov [eax+3600],word 158|FG.RED|BG.RED
    pop eax
  ret
  facil:
    mov [eax+3584],word 158|FG.GREEN|BG.GREEN
    mov [eax+3586],word 158|FG.GREEN|BG.GREEN
    mov [eax+3588],word 158|FG.GREEN|BG.GREEN

    mov [eax+3590],word 0|FG.GRAY|BG.GRAY
    mov [eax+3592],word 0|FG.GRAY|BG.GRAY
    mov [eax+3594],word 0|FG.GRAY|BG.GRAY
    
    mov [eax+3596],word 0|FG.GRAY|BG.GRAY
    mov [eax+3598],word 0|FG.GRAY|BG.GRAY
    mov [eax+3600],word 0|FG.GRAY|BG.GRAY
  pop eax
  ret
  medio:
    mov [eax+3584],word 158|FG.GREEN|BG.GREEN
    mov [eax+3586],word 158|FG.GREEN|BG.GREEN
    mov [eax+3588],word 158|FG.GREEN|BG.GREEN

    mov [eax+3590],word 158|FG.YELLOW|BG.YELLOW
    mov [eax+3592],word 158|FG.YELLOW|BG.YELLOW
    mov [eax+3594],word 158|FG.YELLOW|BG.YELLOW

    mov [eax+3596],word 0|FG.GRAY|BG.GRAY
    mov [eax+3598],word 0|FG.GRAY|BG.GRAY
    mov [eax+3600],word 0|FG.GRAY|BG.GRAY

  pop eax
  ret

F1:
  mov [nivel],dword 1
  mov [nivelSelec],dword 1
ret

F2:
  mov [nivel],dword 2
  mov [nivelSelec],dword 2
ret
F3:
  mov [nivel],dword 3
  mov [nivelSelec],dword 3
ret
F4:
  mov [nivel],dword 4
  mov [nivelSelec],dword 4
ret
F5:
  mov [nivel],dword 5
  mov [nivelSelec],dword 5
ret
F6:
  mov [nivel],dword 6
  mov [nivelSelec],dword 6
ret
F7:
  mov [nivel],dword 7
  mov [nivelSelec],dword 7
ret
F8:
  mov [nivel],dword 8
  mov [nivelSelec],dword 8
ret

F9:
  mov [nivel],dword 9
  mov [nivelSelec],dword 9
ret

F10:
  mov [nivel],dword 10
  mov [nivelSelec],dword 10
ret

Title:
  
      push dword 18;la posicion en la que queremmos pintar
      push presentacion1;el string que queremos escribir
      call printString
      add esp, 8

        push dword 178;la posicion en la que queremmos pintar
      push presentacion2;el string que queremos escribir
      call printString
      add esp, 8

        push dword 338;la posicion en la que queremmos pintar
      push presentacion3;el string que queremos escribir
      call printString
      add esp, 8

          push dword 498;la posicion en la que queremmos pintar
      push presentacion4;el string que queremos escribir
      call printString
      add esp, 8

        push dword 658;la posicion en la que queremmos pintar
      push presentacion5;el string que queremos escribir
      call printString
      add esp, 8

      ret

