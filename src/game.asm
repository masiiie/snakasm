%include "video.mac"
%include "keyboard.mac"

section .data
worm times 2000 dd 0
worm2 times 2000 dd 0
tatica dq 0
direccion dd 2
direccion2 dd 22
Perdiste1 db "  PPPPPPPP  EEEEEEE  RRRRRR    DDDDDDDD   IIIIIIII   SSSSSSSS  TTTTTTTT EEEEEEE",0
Perdiste2 db "  PP      P EE       RR    RR  DD    DDDD    II     SS            TT    EE       ",0
Perdiste3 db "  PP      P EE       RR    RR  DD      DD    II     SS            TT    EE    ",0
Perdiste4 db "  PPPPPPPP  EEEEE    RRRRRR    DD      DD    II       SSSSSS      TT    EEEEE",0
Perdiste5 db "  PP        EE       RR  RR    DD      DD    II             SS    TT    EE ",0
Perdiste6 db "  PP        EE       RR    RR  DD    DDDD    II             SS    TT    EE   ",0
Perdiste7 db "  PP        EEEEEEE  RR      R DDDDDDDD   IIIIIIII   SSSSSSSS     TT    EEEEEE",0
INSTRUCC db  "PRESIONA (R) PARA REINICIAR",0
pausa dd 1
MenuInicialActivo dd 1

global supervivencia
supervivencia db 0
global CantJugadores
CantJugadores dd 1
global vidas1
vidas1 dd 5
global vidas2
vidas2 dd 5
global puntuacion1
puntuacion1 dd 0
global puntuacion2
puntuacion2 dd 0
global nivel
nivel dd 3
global nivelSelec
nivelSelec dd 3
global puntuacionmax
puntuacionmax dd 0
global primerJuego
primerJuego db 1
global FinDJuego
FinDJuego db 1
global Velocidad
Velocidad dd 200
global end
end dd 0

section .text

extern clear
extern scan
extern calibrate
extern delay
extern nivel1
extern nivel2
extern nivel3
extern nivel4
extern nivel5
extern nivel6
extern nivel7
extern nivel8
extern nivel9
extern nivel10
extern Mover
extern Ganar
extern EscribirEstadisticas
extern FrutaValida
extern dibujarSnake
extern printString
extern _puntuacion_
extern Draw_Image
extern AnimacionCambioDePantalla
extern dificultad

; Bind a key to a procedure


%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
%endmacro

; Fill the screen with the given background color

%macro FILL_SCREEN 1
  push word %1
  call clear
  add esp, 2
%endmacro

global game
game:
  ; Initialize game
  FILL_SCREEN BG.GRAY
  ; Calibrate the timing
  call calibrate
  ; Snakasm main loop


cmp dword[MenuInicialActivo],dword 1
jne _STARTGAME
  
  pushad
  _MenuInicial:;va a estar en el ciclo mientras este activo el menu inicial


  call Draw_Image

  mov [MenuInicialActivo],dword 2

  cmp al,1;señal para que salga del menu inicial
  jne _MenuInicial 
  popad

  _STARTGAME:

  
  call inicio 

  game.loop:
    
    push eax;este push es para guardar el resultado de eax ya que delay lo cambia
    .input:

      call get_input

      push dword [Velocidad]
      push tatica

      call delay
      add esp, 8
      cmp eax, 0
      je .input

      pop eax ;este pop es para restaurar el resultado de eax ya que delay lo cambia

      cmp [end], byte 1;comprueba si perdiste variable (end)
      je _Perdiste
      cmp [FinDJuego],byte 0;comprueba si ganaste comprobando si ya te comiste todas las comidas (FinDJuego)
      je _Ganaste
      
      push eax ;guarda eax pq abajo lo utilizo

      cmp [CantJugadores],dword 2 ;compruebo la contidad de jugadores y en dependencia de esto se q quien mover
      jne UnJugador 

      push dword [vidas2]
      push dword [puntuacion2]
      push dword [direccion2];12
      push worm2;8
      call Mover
      add esp,16

      mov [puntuacion2],eax
      mov [vidas2],ebx      

      UnJugador: 
      xor eax,eax
      push dword [vidas1]
      push dword [puntuacion1] 
      push dword [direccion];12
      push worm;8
      call Mover
      add esp,16

      mov [puntuacion1],eax
      mov [vidas1],ebx

      pop eax

    push dword[vidas2]
    push dword[puntuacion2]
    push dword[nivel]
    push dword[puntuacion1]
    push dword[puntuacionmax]
    push dword[vidas1]
    call EscribirEstadisticas
    add esp,24

      jmp game.loop

      _Perdiste:
        

      ;anunciar que perdiste
      push 1120
      push Perdiste1
      call printString
      add esp, 8

      push 1280
      push Perdiste2
      call printString
      add esp, 8

      push 1440
      push Perdiste3
      call printString
      add esp, 8

      push 1600
      push Perdiste4
      call printString
      add esp, 8

      push 1760
      push Perdiste5
      call printString
      add esp, 8

      push 1920
      push Perdiste6
      call printString
      add esp, 8

      push 2080
      push Perdiste7
      call printString
      add esp, 8
      
      push 2620
      push INSTRUCC
      call printString
      add esp, 8
  

      jmp game.loop

      _Ganaste:

       push dword[vidas1]
       push dword[vidas2]
       call Ganar
       add esp,8

       call AnimacionCambioDePantalla

      jmp _STARTGAME



GLOBAL up
up:
  cmp [direccion], dword 160
  je fin
  mov dword [direccion], -160

  ;call Mover
 fin:
  ret;

GLOBAL left
left:
  cmp [direccion], dword 2
  je fin2
  mov dword [direccion], -2
  ;call Mover
  fin2:
  ret;

GLOBAL right
right:
  cmp [direccion], dword -2
  je fin3
  mov dword [direccion], 2
  ;call Mover
  fin3:
  ret;

GLOBAL down
down:
  cmp [direccion], dword -160
  je fin4
  mov dword [direccion], 160
 ; call Mover
 fin4:
  ret;

global _W
_w:
  cmp [direccion2], dword 160
  je fin_1
  mov dword [direccion2], -160

  ;call Mover
 fin_1:
  ret;

global _a
_a:
  cmp [direccion2], dword 2
  je fin_2
  mov dword [direccion2], -2
  ;call Mover
  fin_2:
  ret;

global _d
_d:
  cmp [direccion2], dword -2
  je fin_3
  mov dword [direccion2], 2
  ;call Mover
  fin_3:
  ret;

global _s
_s:
  cmp [direccion2], dword -160
  je fin_4
  mov dword [direccion2], 160
 ; call Mover
 fin_4:
  ret;

GLOBAL get_input
get_input:
pushad
    call scan
    push ax
    ; The value of the input is on 'word [esp]'
    ; Your bindings here
    bind KEY.UP, up
    bind KEY.LEFT, left
    bind KEY.RIGHT, right
    bind KEY.DOWN, down

    bind KEY.R,game

    bind KEY.W, _w
    bind KEY.A, _a
    bind KEY.S, _s
    bind KEY.D, _d

    bind KEY.P, Pausa
    bind KEY.ENTER,salir

   
    add esp, 2 ; free the stack
    popad
    ret



;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
GLOBAL ArmandoParedes
ArmandoParedes:
  pushad

  mov ebx, 0xB8000
  mov dx, 7|FG.GREEN|BG.BLACK
  mov [ebx], dx
  mov ecx, 158
  vertical:
    mov [ebx + ecx], dx
    mov [ebx + ecx + 2], dx
   

    add ecx, 160
    cmp ecx, 3999
    jbe vertical
  mov ecx, 2
  horizontal:
    mov [ebx + ecx], dx
    mov [ebx + ecx + 800], dx
    mov [ebx + ecx + 3840], dx
    add ecx, 2
    cmp ecx, 158
    jbe horizontal

    popad
  ret
;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
GLOBAL LimpiarWorm
LimpiarWorm:
  push ebp
  mov ebp, esp
  pushad

  mov edi, [ebp + 8]
  mov ecx, 2000
  xor eax, eax
  cld
  rep stosd

  popad
  pop ebp
  ret

GLOBAL _Nivel
_Nivel:
  cmp [nivel],dword 1
  je _nivel1
  cmp [nivel],dword 2
  je _nivel2
  cmp [nivel],dword 3
  je _nivel3
  cmp [nivel],dword 4
  je _nivel4
  cmp [nivel],dword 5
  je _nivel5
  cmp [nivel],dword 6
  je _nivel6
  cmp [nivel],dword 7
  je _nivel7
  cmp [nivel],dword 8
  je _nivel8
   cmp [nivel],dword 9
  je _nivel9
  cmp [nivel],dword 10
  je _nivel10

  _nivel1:
    call nivel1
  ret
  _nivel2:
  call nivel2
  ret
  _nivel3:
  call nivel3
  ret
  _nivel4:
  call nivel4
  ret
   _nivel5:
    call nivel5
  ret
  _nivel6:
  call nivel6
  ret
  _nivel7:
  call nivel7
  ret
  _nivel8:
  call nivel8
  ret
   _nivel9:
  call nivel9
  ret
  _nivel10:
  call nivel10
  ret
ret 
;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-

inicio:
     
  cmp [CantJugadores],dword 2
  jne _UnJugador 

  call PreparaWorm2

  _UnJugador:
  
  call PreparaWorm1


  ;a partir de aqui para superviviencia

  FILL_SCREEN BG.GRAY
  call ArmandoParedes


  call _Nivel  

  mov ecx, 0xB8000
  mov bx, 30|FG.BLUE|BG.GRAY
  push edx
  call FrutaValida;el resultado esta en edx
  mov [ecx + edx], bx
  pop edx
  mov [FinDJuego],byte 1
  mov [end],dword 0

  cmp [dificultad],dword 1
  je facil
  cmp [dificultad],dword 2
  je medio
  ;dificil
  mov [Velocidad],dword 70
  ret
  facil:
  mov [Velocidad],dword 200
  ret
  medio:
  mov [Velocidad],dword 100

  ret

Pausa:
    mov [pausa],dword 1    

    pausa1:    
        call get_input         
          cmp [pausa],dword 1
          je pausa1
  
  salir:
  mov [pausa],dword 2 
   ret
;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
 
 PreparaWorm2:
      push worm2
      call LimpiarWorm
      add esp, 4
  
       mov [direccion2], dword 2

       mov [worm2], dword 1660
       mov [worm2 + 4], dword 1662
       mov [worm2 + 8], dword 1664
     mov [worm2 + 12], dword 1666
    ret

 PreparaWorm1:
     push worm
     call LimpiarWorm
     add esp, 4
     mov [direccion], dword 2
     mov [worm], dword 1500
     mov [worm + 4], dword 1502
     mov [worm + 8], dword 1504
     mov [worm + 12], dword 1506
     ret