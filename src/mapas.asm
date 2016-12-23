%include "video.mac"

section .text

global Obstaculo

;1 - pos desde donde voy a empezar a pintar
;2 - caracter que voy a pintar
;3 - largo del obstaculo
;4 - altura del obstaculo
%macro Obstaculo 4
  ; posicion de origen,ancho,alto
   pushad
   xor ecx,ecx
   xor eax,eax
   xor ebx,ebx
   xor edi,edi
   mov ebx, %1
   mov dx, %4|BG.BLACK|FG.GREEN
   add dword ebx, 0xB8000
   mov ecx,%3
   mov eax, %2 
   add ebx, eax
   add ebx, eax
   inc ecx
 %%sigue:
   sub ebx,eax
   sub ebx,eax
   add ebx,160 
   mov edi,eax
   cmp ecx, 0
   dec ecx
   jne %%PintarRaya
   jmp %%end   
%%PintarRaya:   
   cmp edi,0
   je %%sigue
   mov [ebx] ,dx;|BG.BLACK|FG.GREEN
   add ebx,2
   dec edi
   jmp %%PintarRaya
%%end: 
xor eax,eax
xor ebx,ebx
xor edx,edx
xor ecx,ecx
popad
%endmacro




global nivel1
nivel1:	

   
  
  ret

global nivel2
nivel2:
	pushad
	mov ebx, 0xB8000
	mov dx, 92|FG.BLACK|BG.GRAY
	mov ecx, 1160
	sigue1:
	mov [ebx + ecx], dx
	add ecx, 162
	cmp ecx, 3500
	jb sigue1
	mov dx, 47|FG.BLACK|BG.GRAY
	mov ecx, 1240
	sigue2:
	mov [ebx + ecx], dx
	add ecx, 158
	cmp ecx, 3500
	jb sigue2
	popad

ret

global nivel3
nivel3:
	pushad
	mov ebx, 0xB8000
	mov dx, 7|FG.GREEN|BG.BLACK
	mov ecx, 1200
	sigue3:
	mov [ebx + ecx], dx
	add ecx, 160
	cmp ecx, 3500
	jb sigue3
	mov dx, 7|FG.GREEN|BG.BLACK
	mov ecx, 2360
	sigue4:
	mov [ebx + ecx], dx
	add ecx, -2
	cmp ecx, 2284
	ja sigue4
	popad
ret

global nivel4
nivel4:
pushad
	mov ebx, 0xB8000
	mov dx, 7|BG.BLACK|FG.GREEN
	mov ecx, 1242
	sigue5:
	mov [ebx + ecx], dx
	add ecx, 160
	cmp ecx, 3548
	jb sigue5
	mov ecx, 1164
	sigue6:
	mov [ebx + ecx], dx
	add ecx, 160
	cmp ecx, 3464
	jb sigue6
	mov dx, 7|BG.BLACK|FG.GREEN
	mov ecx, 2360
	sigue7:
	mov [ebx + ecx], dx
	add ecx, -2
	cmp ecx, 2284
	ja sigue7
	popad
ret

global nivel5
nivel5:
	 Obstaculo 1460, 60, 1, 7
	 Obstaculo 2900, 60, 1, 7
ret

global nivel6
nivel6:
	Obstaculo 1456, 1, 15, 7
	Obstaculo 674, 1, 15, 7
	Obstaculo 1492, 1, 15, 7
	Obstaculo 720, 1, 15, 7
	Obstaculo 1528, 1, 15, 7
	Obstaculo 746, 1, 15, 7 
	Obstaculo 1564, 1, 15, 7
	Obstaculo 782, 1, 15, 7
ret

global nivel7
nivel7:
	pushad
	mov edi, 0xB8000
	Obstaculo 1456, 1, 10, 7
	mov [edi + 2416], word 0|BG.GRAY
	Obstaculo 1492, 1, 10, 7
	mov [edi + 2452], word 0|BG.GRAY
	Obstaculo 1456, 18, 1, 7
	mov [edi + 1634], word 0|BG.GRAY
	Obstaculo 3056, 19, 1, 7
	mov [edi + 3234], word 0|BG.GRAY

	Obstaculo 1548, 1, 10, 7
	mov [edi + 2508], word 0|BG.GRAY
	Obstaculo 1584, 1, 10, 7
	mov [edi + 2544], word 0|BG.GRAY
	Obstaculo 1548, 18, 1, 7
	mov [edi + 1726], word 0|BG.GRAY
	Obstaculo 3148, 19, 1, 7
	mov [edi + 3326], word 0|BG.GRAY

	popad
ret

global nivel8
nivel8:
	Obstaculo 1456, 1, 10, 7
	Obstaculo 3056, 19, 1, 7
	Obstaculo 1492, 1, 10, 7
	Obstaculo 1548, 1, 10, 7
	Obstaculo 1584, 1, 10, 7
	Obstaculo 3148, 19, 1, 7
	Obstaculo 1492, 29, 1, 7	
ret

global nivel9
nivel9:
	pusha
	mov edi, 0xB8000 
	Obstaculo 2140, 1, 15, 7
	Obstaculo 2180, 1, 15, 7
	Obstaculo 2120, 40, 1, 7
	Obstaculo 1320, 1, 5, 7
	Obstaculo 1260, 40, 1, 7
	Obstaculo 1400, 1, 6, 7
	mov [edi + 3100], word 0|BG.GRAY
	mov [edi + 3140], word 0|BG.GRAY
	mov [edi + 2310], word 0|BG.GRAY
	mov [edi + 2320], word 0|BG.GRAY
	mov [edi + 2330], word 0|BG.GRAY
	popa
ret

global nivel10
nivel10:
	Obstaculo 1400, 60, 2, 7
	Obstaculo 2900, 60, 2, 7
	Obstaculo 2100, 60, 2, 7
	Obstaculo 2100, 4, 5, 7
	Obstaculo 1412, 4, 5, 7
	
ret


