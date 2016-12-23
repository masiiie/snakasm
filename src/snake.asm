%include "video.mac"

section .data

_puntuacion_ dd 0
vidas dd 0

section .text

extern FrutaValida
extern FinDJuego
extern end
extern Velocidad
extern nivel
extern nivelSelec
extern puntuacionmax
extern primerJuego
extern CantJugadores ;compruebo la contidad de jugadores y en dependencia de esto se q quien mover
extern vidas1
extern vidas2
extern puntuacion2
extern puntuacion1
extern supervivencia
extern descuento



GLOBAL dibujarSnake
dibujarSnake:
  push ebp
  mov ebp,esp
  
  pushad

  xor eax, eax
  mov ecx, 0xB8000


  mov bx, 254|FG.BLUE|BG.GRAY
  mov esi, [ebp+8]
  ciclo:
    cld
    lodsd
    cmp eax, 0
    je salir
    mov [ecx + eax], bx;aqui pintamos cada punto de la  serpiente
    jmp ciclo
  salir:

  popad

  pop ebp
  ret

;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
global Mover
Mover:
  
  push ebp
  mov ebp,esp

  pushad
  mov eax,[ebp+16];[puntuacion]
  mov [_puntuacion_],eax
  mov eax,[ebp+20];[vidas]
  mov [vidas],eax

  push eax
  xor eax, eax
  mov esi,[ebp+8];worm;[ebp+8] ;paso el snake que quiero mover
  cld
  buscador:   ; guardando el valor de la cabeza en ebx
    lodsd
    cmp eax, 0
    je salir2
    mov ebx, eax;queda en ebx la cabeza
    jmp buscador
  salir2:
  pop eax
  add ebx,[ebp+12] ;[direccion]  ;el valor de la direccion a la que tiene que moverse
 
  mov edx, 0xB8000
  cmp [edx + ebx], byte 30 ;comprobando si hay comida aqui, pusimos 30 por poner algo para la comida
  je comio
  cmp [edx + ebx], byte 0
  jne perdio

  mov ecx,[ebp+8];[worm];[ebp+8]
  mov ecx,[ecx]

  mov [edx + ecx], byte 0  ;borra la ultima posicion del snake porque el gusano no comio
 
  push dword[ebp+8];dword[ebp+8] worm
  call RotarArray
  add esp,4
   
  jmp nocomenopierde

  ;desde aqui hasta el final es ponerle la cabeza al final al gusano
  comio:
    push edx

    xor edx,edx
    mov [descuento],edx
    

    mov edx, [Velocidad]
    sub edx, 4
    mov [Velocidad], edx

    mov edx, [ebp+16];[puntuacion]; aqui paso la puntuacion para que la aumente ...
    inc edx    ;nuevo valor de la puntuacion
    mov  [_puntuacion_], edx  ;esta linea pone el nuevo valor de la puntuacion

    cmp edx, dword[puntuacionmax]
    jbe NoRecord
    mov edx, [_puntuacion_]   
    mov [puntuacionmax], edx

    
    NoRecord:
    pop edx

    push ebx
    push eax
    push edx

    cmp [supervivencia],byte 1
    je salto 
    mov ebx,[FinDJuego]
    dec ebx
    mov [FinDJuego],ebx
    salto:
     ; pongo una comida nueva en el mapa
    mov bx, 30|FG.BLUE|BG.GRAY

    mov edi, 0xB8000

    mov [primerJuego],byte 0

    call FrutaValida

    mov [edi+edx],bx
    
    pop edx
    pop eax
    pop ebx


    nocomenopierde:
    push eax
    mov esi, [ebp+8]
    cld
  sigte:
    lodsd
    cmp eax, 0
    jne sigte
    mov [esi - 4], ebx;poner la cabeza en su lugar
    pop eax

    
  push dword[ebp+8]
  call dibujarSnake
  add esp,4

  jmp _FIN_

    perdio:
    ;pop eax
    mov [end], byte 1
       
    ;quitando una vida
    push edx
    xor edx, edx
    mov edx, [vidas]
    dec edx
    mov [vidas], edx
    ;preguntar si me quede sin vidas => score 0 y nivel 1 y velocidad 250
    cmp edx, 0
    jne tengovidas

    mov [_puntuacion_], dword 0
    mov edx,[nivelSelec]
    mov [nivel], edx
    mov [vidas], dword 5
    mov [Velocidad], dword 200

    tengovidas:
    pop edx
    ;quitando una vida

    _FIN_:
    
    popad

    mov eax,[_puntuacion_]
    mov ebx,[vidas]

    pop ebp  

  ret;

;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-
GLOBAL RotarArray
RotarArray:
  push ebp
  mov ebp,esp
  pushad

  mov ecx, 1996 ;es 1996 porque empiezo de la segunda poscion de worm
  mov eax,[ebp+8];worm;[ebp+8]
  mov edi, eax
  add eax, 4
  mov esi, eax 
  rep movsd

  popad
  pop ebp
  ret 

global Ganar
Ganar:
  push ebp
  mov ebp,esp
  pushad
        ;calculo con los restos del nivel para que no se pase del numero esperado de niveles
     mov eax,[nivel]
      mov ebx, 10
      xor edx, edx
      div ebx
      inc edx       ;tomo el resto del nivel en el que estamos con 4 y le incemento 1
      mov [nivel], edx
      ;aumenta el nivel

       cmp [CantJugadores],dword 2 ;compruebo la contidad de jugadores y en dependencia de esto se q quien mover
       je UnJugador 

      mov eax, [vidas2]
      mov ebx, dword 100
      mul ebx
      add eax, dword[puntuacion2]
      mov [puntuacion2], eax;aumenta la  puntuacion

      UnJugador:
      mov eax, [vidas1]
      mov ebx, dword 100
      mul ebx
      add eax, dword[puntuacion1]
      mov [puntuacion1], eax;aumenta la  puntuacion

      cmp eax, dword[puntuacionmax]
      jbe NoRecord2
      mov eax, [_puntuacion_]    
      mov [puntuacionmax], eax ;aumenta la puntuacion maxima
      NoRecord2:


  popad
  pop ebp
ret