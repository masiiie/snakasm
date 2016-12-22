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



string1 db "INICIAR JUEGO NUEVO",0
string2 db "CONTINUAR",0
string3 db "UN JUGADOR",0
string4 db "DOS JUGADORES",0
ElementoSelec db '*',0
ElementoDselec db ' ',0
tatica dq 0

opcionSelec dd 1

section .text

extern printString
extern scan
extern delay
extern vidas1
extern vidas2
extern puntuacion1
extern puntuacion2
extern nivel
extern CantJugadores

; Bind a key to a procedure
%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
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

      push dword 1980;la posicion en la que queremmos pintar
      push string3;el string que queremos escribir
      call printString
      add esp, 8

      push dword 2300;la posicion en la que queremmos pintar
      push string4;el string que queremos escribir
      call printString
      add esp, 8

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
      push dword 1692;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      uno:
      push dword 1372;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      mayor:

      cmp edx,3
      jne cuatro

      push dword 2012;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      jmp fin
      cuatro:

      push dword 2332;la posicion en la que queremmos pintar
      push ElementoSelec;el string que queremos escribir
      call printString
      add esp, 8
      fin:

      popad

  ret

  QuitaElemenSelec:
     push dword 1692;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8

      push dword 1372;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
     
     
      push dword 2012;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
     
      push dword 2332;la posicion en la que queremmos pintar
      push ElementoDselec;el string que queremos escribir
      call printString
      add esp, 8
  ret

selec:

    cmp [opcionSelec],byte 2
    jg _mayor

      cmp [opcionSelec],byte 1
      jne _uno

      call AnimacionCambioDePantalla
     
      mov al,1;aqui dejo la señal de que seleccione y tiene q salir del menu

      ret

      _uno:

      mov [vidas1],dword 5
      mov [vidas2],dword 5
      mov [puntuacion2],dword 0
      mov [puntuacion1],dword 0
      mov [nivel], dword 1 

      call AnimacionCambioDePantalla
     
      mov al,1;aqui dejo la señal de que seleccione y tiene q salir del menu

      ret



    _mayor:

      call QuitaCantJugadores
      cmp [opcionSelec],byte 3
      je tres
        mov [CantJugadores],dword 2
        
        call DosJugadores


        ret
      tres:
        mov [CantJugadores],dword 1

        call UnJugador
          
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

    bind KEY.ENTER,selec


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

