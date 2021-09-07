%include "video.mac"
%include "keyboard.mac"

section .data

_puntuacion1 dd 0
_puntuacion2 dd 0
_puntuacion3 dd 0
_puntuacion4 dd 0
_puntuacion5 dd 0
_puntuacion6 dd 0
_puntuacion7 dd 0

Pcurrent dd 1

section .text

extern clear
extern Obstaculo

%macro FILL_SCREEN 1
  push word %1
  call clear
  add esp, 2
%endmacro

global _AddPuntuacion
_AddPuntuacion:
	push ebp
	mov ebp,esp
	pushad
	cmp [Pcurrent],dword 1
	je _1_
	cmp [Pcurrent],dword 2
	je _2_
	cmp [Pcurrent],dword 3
	je _3_
	cmp [Pcurrent],dword 4
	je _4_
	cmp [Pcurrent],dword 5
	je _5_
	cmp [Pcurrent],dword 6
	je _6_
	cmp [Pcurrent],dword 7
	je _7_

	_1_:

	mov eax,[ebp+8]
	mov [_puntuacion1],eax

	jmp fin

	_2_:

	mov eax,[ebp+8]
	mov [_puntuacion2],eax

	jmp fin

	_3_:


	mov eax,[ebp+8]
	mov [_puntuacion3],eax

	jmp fin

	_4_:

	mov eax,[ebp+8]
	mov [_puntuacion4],eax

	jmp fin

	_5_:

	mov eax,[ebp+8]
	mov [_puntuacion5],eax

	jmp fin

	_6_:

	mov eax,[ebp+8]
	mov [_puntuacion6],eax

	jmp fin

	_7_:

	mov eax,[ebp+8]
	mov [_puntuacion7],eax

	mov [Pcurrent],dword 1

	popad
	pop ebp
	ret
	
	fin:
	push eax
	mov eax,[Pcurrent]
	inc eax
	mov [Pcurrent],eax
	pop eax
	popad
	pop ebp
	ret


global _MostrarPuntuaciones
_MostrarPuntuaciones:
		FILL_SCREEN BG.GRAY
		;Obstaculo 1460, 60, 1, 7

	ret

