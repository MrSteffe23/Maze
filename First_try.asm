.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 890
area_height EQU 580
area DD 0

counter DD 0 ; numara evenimentele de tip timer
secunda dd 0 ; numara secundele pentru timer-ul jocului
count_x dd 60 ; variabila folosita pentru locul unde si de unde se sterge/muta jucatorul
count_y dd 60 ; variabila folosita pentru locul unde si de unde se sterge/muta jucatorul
temporar dd 0 ; variabila folosita pentru locul unde si de unde se sterge/muta jucatorul

conditie_score dd 1 ;se foloseste ca un ok pentru a contoriza sau nu timpul. Cand ajungem la final, timpul se opreste
conditie dd 0 ; se foloseste ca un ok pentru a nu afisa de mai multe ori mesajul de "felicitari"
bravo db "BRAVO", 0
len dd $-bravo
msg_x dd 730 ;coordonata x a mesajului
msg_y dd 300 ;coordonata y a mesajului

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

score dd 0

start_x dd 40
start_x_backup dd 40
start_y dd 100
start_y_backup dd 100
vec dd  0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dd	0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dd	0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,0,0,0,0
	dd	0,0,2,0,0,0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,2,0,0,0,0,0,2,0,0,0,0
	dd	0,0,2,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,2,0,0,0,0,0,2,0,0,0,0
	dd	0,0,2,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,2,0,0,0,0,0,2,0,0,0,0
	dd	0,0,2,0,0,0,2,2,2,2,2,2,2,2,0,0,2,0,0,0,0,2,0,0,0,2,2,2,0,0,0,0
	dd	0,0,2,2,0,0,2,0,0,0,0,0,0,0,0,0,2,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0
	dd	0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,0,0,0,0,0,0
	dd	0,0,0,2,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0
	dd	0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0
	dd	0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0
	dd	0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0
	dd	0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,2,2
	dd	0,0,0,2,2,2,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,0,0
	dd	0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,0,0
	dd	0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,2,2,2,2,0,0
	dd	0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,2,0,0,0,0,0
	dd	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,2,0,0,0,0,0
	dd	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0
	dd	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

button_left_x equ 745
button_left_y equ 230
button_right_x equ 805
button_right_y equ 230
button_up_x equ 775
button_up_y equ 200
button_down_x equ 775
button_down_y equ 230
button_size equ 30

symbol_width_small EQU 10
symbol_height_small EQU 20

symbol_width_big EQU 20
symbol_height_big EQU 20

include digits.inc
include letters.inc
include labirint.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
		make_text_big proc ;coloram un patrat de pixeli de 20 pe 20
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp+arg1] ; citim simbolul de afisat
			lea esi, labirint
			sub eax, '0'
			;daca eax = 0 => patrat negru
			;daca eax = 1 => patrat rosu (lava)
			;daca eax = 2 => patrat alb
			;daca eax = 3 => patrat galben
			;daca eax = 4 => sageata stanga
			;daca eax = 4 => sageata dreapta
			;daca eax = 4 => sageata sus
			;daca eax = 4 => sageata jos
			mov ebx, symbol_width_big
			mul ebx
			mov ebx, symbol_height_big
			mul ebx ;eax = pozitia de unde incepe sa afiseze din labirint
			add esi, eax ;esi = adresa din labirint de unde incepe sa se scrie caracterul
			mov ecx, symbol_height_big ;ecx reprezinta cati pixeli sunt in inaltime
			
		bucla_simbol_linii_b:
			mov edi, [ebp+arg2] ; pointer la matricea de pixeli
			mov eax, [ebp+arg4] ; pointer la coord y
			add eax, symbol_height_big
			sub eax, ecx
			mov ebx, area_width
			mul ebx ; eax = nr ded linii inainte de pozitia unde e cursorul a cate area_width pixeli
			add eax, [ebp+arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie caracterul/patratul alb/patratul negru
			push ecx
			mov ecx, symbol_width_big
		bucla_simbol_coloane_b:
			cmp byte ptr [esi], 0
			je simbol_pixel_alb_b
			cmp byte ptr [esi], 3
			je simbol_pixel_rosu_b
			cmp byte ptr [esi], 2
			je simbol_pixel_auriu
			mov dword ptr [edi], 0 ;face pixel-ul negru
			jmp simbol_pixel_next_b
		simbol_pixel_alb_b:
			mov dword ptr [edi], 0FFFFFFh ;face pixel-ul alb
			jmp simbol_pixel_next_b
		simbol_pixel_auriu:
			mov dword ptr [edi], 0FFD700h ;face pixel-ul auriu
			jmp simbol_pixel_next_b
	    simbol_pixel_rosu_b:
			mov dword ptr [edi], 0FF0000h ;face pixel-ul rosu
		simbol_pixel_next_b:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane_b
			pop ecx
			loop bucla_simbol_linii_b

			popa
			mov esp, ebp
			pop ebp
			ret
		make_text_big endp

; un macro ca sa apelam mai usor desenarea simbolului de dimensiune 20 pe 20
make_text_macro_big macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text_big
	add esp, 16
endm

; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text_small proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_sign
	cmp eax, '9'
	jg make_sign
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_sign:
	cmp eax, '-'
	je linie
	cmp eax, '+'
	je character
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	jmp draw_text
character:
	mov eax, 28 ; de la 0 pana la 25 sunt litere, 26 e space, 27 e linie, 28 e caracterul
	lea esi, letters
	jmp draw_text
linie:
	mov eax, 27 ; de la 0 pana la 25 sunt litere, 26 e space, 27 e linie
	lea esi, letters
	jmp draw_text
	
draw_text:
	mov ebx, symbol_width_small
	mul ebx
	mov ebx, symbol_height_small
	mul ebx ;eax = pozitia de unde incepe sa afiseze din letters
	add esi, eax ;esi = adresa din letters/digits de unde incepe sa se scrie litera
	mov ecx, symbol_height_small ;ecx este marimea unei linii pe care urmeaza sa o scriu
	
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_small
	sub eax, ecx
	mov ebx, area_width
	mul ebx ; eax linii inainte de pozitia unde e cursorul a cate area_width pixeli
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie litera/cifra
	push ecx
	mov ecx, symbol_width_small
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	cmp byte ptr [esi], 2
	je simbol_pixel_verde
	cmp byte ptr [esi], 3
	je simbol_pixel_albastru
	mov dword ptr [edi], 0FF0000h ;face pixel-ul rosu
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh ;face pixel-ul alb
	jmp simbol_pixel_next
simbol_pixel_verde:
	mov dword ptr [edi], 04B0082h ;face pixel-ul verde
	jmp simbol_pixel_next
simbol_pixel_albastru:
	mov dword ptr [edi], 00000FFh ;face pixel-ul albastru
	jmp simbol_pixel_next
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii

	final:
	popa
	mov esp, ebp
	pop ebp
	ret
make_text_small endp

; un macro ca sa apelam mai usor desenarea simbolului de dimensiune 10 pe 20
make_text_macro_small macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text_small
	add esp, 16
endm

line_horizontal macro x, y, len, gr, color
	local loopp, loopgr
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len ;ecx = lungimea liniei orizontale
	loopp:
		push ecx ;salvam pe stiva lungimea liniei orizontale
		push eax ;salvam pe stiva inceputul scrierii in grosime a unui strat
		mov ecx, gr
		loopgr:
			mov dword ptr [eax], color
			add eax, area_width*4 ;desenam o linie de un pixel pe verticala (care reprezinta grosimea liniei orizontale)
		loop loopgr
		pop eax
		add eax, 4
		pop ecx
	loop loopp
endm

line_vertical macro x, y, len, gr, color
	local loopp, fine, grosime
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
	loopp:
		push ecx ;salvam pe stiva lungimea liniei
		push eax ;salvam pe stiva locul de unde incepem sa coloram o linie pe grosime
		mov ecx, gr
		grosime:
			mov dword ptr [eax], color
			add eax, 4 ;desenam o linie de un pixel pe orizontala, care reprezinta de fapt grosimea liniei verticale
		loop grosime
		pop eax
		pop ecx
		add eax, area_width*4 ;actualizam locul de unde scriem alt strat al liniei pe grosime
	loop loopp
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	;contorizez la TIMER si timpul in care utilizatorul apasa pe butoane
	mov eax, conditie_score
	cmp eax, 1
	jne nu_secundaa
	inc counter
	mov eax, counter
	cmp eax, 5
	jne nu_secundaa
	mov eax, 0
	mov counter, eax
	inc secunda
	nu_secundaa:
	;buton pentru deplasare_in_stanga
	mov eax, [ebp + arg2]
	cmp eax, button_left_x
	jl exterior
	cmp eax, button_left_x + button_size
	jg posibil_restul
	mov eax, [ebp + arg3]
	cmp eax, button_left_y
	jl exterior
	cmp eax, button_left_y + button_size
	jg exterior
	
	mov eax, count_x
	mov temporar, eax
	cmp eax, 0
	jne merge
	mov temporar, 880
	jmp peste
	merge:
	sub temporar, 10
	peste:
	;aici verific daca pozitia pe care vreau sa ajung nu e un zid
	mov edi, area ; pointer la matricea de pixeli
	mov eax, count_y ; pointer la coord y
	mov ebx, area_width
	mul ebx ; eax linii inainte de pozitia unde e cursorul a cate area_width pixeli
	add eax, temporar ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie litera/cifra
	cmp dword ptr [edi], 0
	je afisare_litere ;am dat de un zid negru
	cmp dword ptr [edi], 0FF0000h
	je lava_restart ;am dat de lava
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_x, eax
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	lava_restart:
	mov eax, score
	inc eax
	mov score, eax ;crestem scorul pentru ca ne-a murit caracterul
	mov eax, 0
	mov conditie, eax
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_x, eax
	make_text_macro_small '+', area, count_x, count_y
	mov count_x, 60
	mov count_y, 60
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	
	posibil_restul: ;se analizeaza mai intai posibilitatea de a se deplasa in dreapta
	mov eax, [ebp + arg2]
	cmp eax, button_right_x
	jl posibil_sus_sau_jos
	cmp eax, button_right_x + button_size
	jg exterior
	mov eax, [ebp + arg3]
	cmp eax, button_right_y 
	jl exterior
	cmp eax, button_right_y + button_size
	jg exterior
	
	mov eax, count_x
	mov temporar, eax
	cmp eax, 880
	jne merge2
	mov temporar, 0
	jmp peste2
	merge2:
	add temporar, 10
	peste2:
	
	;aici verific daca pozitia pe care vreau sa ajung nu e un zid
	mov edi, area ; pointer la matricea de pixeli
	mov eax, count_y ; pointer la coord y
	mov ebx, area_width
	mul ebx ; eax linii inainte de pozitia unde e cursorul a cate area_width pixeli
	add eax, temporar ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie litera/cifra
	cmp dword ptr [edi], 0
	je afisare_litere ;am dat de un zid negru
	cmp dword ptr [edi], 0FF0000h
	je lava_restart1 ;am dat de lava
	cmp dword ptr [edi], 0FFD700h
	je ai_castigat ;am dat de final
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_x, eax
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	lava_restart1:
	mov eax, score
	inc eax
	mov score, eax ;crestem scorul pentru ca ne-a murit caracterul
	mov eax, 0
	mov conditie, eax
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_x, eax
	make_text_macro_small '+', area, count_x, count_y
	mov count_x, 60
	mov count_y, 60
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	;am ajuns la final si afisam mesajul de BRAVO + oprim timer-ul
	ai_castigat:
	mov conditie_score, eax ;setam conditia pentru score pe 0 ca sa nu mai contorizeze timpul
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_x, eax
	make_text_macro_small '+', area, count_x, count_y
	mov eax, conditie ;conditie functioneaza ca un ok, a.i. sa nu scriem mesajul BRAVO de mai multe ori
	cmp eax, 1
	je afisare_litere ;conditie e initial 0, iar apoi se modifica in 1 pentru a nu mai lasa codul sa intre in afisarea lui BRAVO
	mov eax, 1
	mov conditie, eax
	mov ecx, 0
	scriem_mesaj:
		xor ebx, ebx
		mov bl, bravo[ecx]
		make_text_macro_small ebx, area, msg_x, msg_y
		mov eax, msg_x
		add eax, 10
		mov msg_x, eax
		inc ecx
		cmp ecx, len
		jne scriem_mesaj
	mov msg_x, 730
	jmp afisare_litere

	posibil_sus_sau_jos:
	;verificam mai intai pentru posibil_sus
	mov eax, [ebp + arg3]
	cmp eax, button_up_y
	jl exterior
	cmp eax, button_up_y + button_size
	jg posibil_jos
	
	mov eax, count_y
	mov temporar, eax
	cmp eax, 20
	jge merge3
	mov  temporar, 560 ;580-20(h caracter)
	jmp sterg
	merge3:
	sub  temporar, 20
	sterg:
	
	;aici verific daca pozitia pe care vreau sa ajung nu e un zid
	mov edi, area ; pointer la matricea de pixeli
	mov eax, temporar ; pointer la coord y
	mov ebx, area_width
	mul ebx ; eax linii inainte de pozitia unde e cursorul a cate area_width pixeli
	add eax, count_x ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie litera/cifra
	cmp dword ptr [edi], 0
	je afisare_litere ;am dat de un zid negru
	cmp dword ptr [edi], 0FF0000h
	je lava_restartt ;am dat de lava
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_y, eax
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	lava_restartt:
	mov eax, score
	inc eax
	mov score, eax ;crestem scorul pentru ca ne-a murit caracterul
	mov eax, 0
	mov conditie, eax
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_y, eax
	make_text_macro_small '+', area, count_x, count_y
	mov count_x, 60
	mov count_y, 60
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere

	
	posibil_jos:
	mov eax, [ebp + arg3]
	cmp eax, button_down_y + button_size
	jg exterior

	mov eax, count_y
	mov temporar, eax
	cmp eax, 540
	jle merge4
	mov temporar, 0
	jmp sterg2
	merge4:
	add temporar, 20
	sterg2:
	
	;aici verific daca pozitia pe care vreau sa ajung nu e un zid
	mov edi, area ; pointer la matricea de pixeli
	mov eax, temporar ; pointer la coord y
	mov ebx, area_width
	mul ebx ; eax linii inainte de pozitia unde e cursorul a cate area_width pixeli
	add eax, count_x ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax ; edi = adresa in matrice unde vrea sa inceapa sa scrie litera/cifra
	cmp dword ptr [edi], 0
	je afisare_litere ;am dat de un zid negru
	cmp dword ptr [edi], 0FF0000h
	je lava_restartt1 ;am dat de lava
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_y, eax
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	lava_restartt1:
	mov eax, score
	inc eax
	mov score, eax ;crestem scorul pentru ca ne-a murit caracterul
	mov eax, 0
	mov conditie, eax
	make_text_macro_small ' ', area, count_x, count_y
	mov eax, temporar
	mov count_y, eax
	make_text_macro_small '+', area, count_x, count_y
	mov count_x, 60
	mov count_y, 60
	make_text_macro_small '+', area, count_x, count_y
	jmp afisare_litere
	
	exterior: ;mai jos verificam daca am dat click pe butonul START	
	mov eax, [ebp + arg2]
	cmp eax, button_left_x ;butonul START e aliniat cu butoanele pentru deplasare, doar ca mai sus (y mai mic)
	jl afisare_litere
	cmp eax, button_left_x + 90
	jg afisare_litere
	mov eax, [ebp + arg3]
	cmp eax, 120
	jl afisare_litere
	cmp eax, 150
	jg posibil_generate
	;am dat click pe butonul START	
	mov eax, 0
	mov counter, eax ;resetam counter-ul si apoi secundele si scorul
	mov secunda, eax
	mov score, eax
	mov eax, 1
	mov conditie_score, eax
	make_text_macro_small ' ', area, count_x, count_y
	mov count_x, 60
	mov count_y, 60
	make_text_macro_small '+', area, count_x, count_y ;desenam caracterul in pozitia initiala
	mov conditie, 0
	mov ecx, 0
	golim_mesaj: ;stergem mesajul BRAVO daca a fost scris
		make_text_macro_small ' ', area, msg_x, msg_y 
		mov eax, msg_x
		add eax, 10
		mov msg_x, eax
		inc ecx
		cmp ecx, len
	jne golim_mesaj
	mov msg_x, 730
	jmp afisare_litere
	
	posibil_generate: ;verificam daca am dat click pe butonul GENERATE
	mov eax, [ebp + arg3]
	cmp eax, 460
	jl afisare_litere
	cmp eax, 490
	jg afisare_litere
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	;curatam matricea cu labirintul in cazul in care a fost deja generata anterior, pentru a putea genera mai jos alta
	mov ecx, 0
	curat:
		cmp dword ptr vec[ecx*4], 2
		je sari_peste_clean
		mov dword ptr vec[ecx*4], 0 
		sari_peste_clean:
		inc ecx
		cmp ecx, 672
	jne curat
	;generam alt labirint
	mov ecx, 0
	looplinii:
		cmp dword ptr vec[ecx*4], 2
		je sari_peste
		
		rdtsc
		mov bl, al
		xor eax, eax
		mov al, bl
		xor edx, edx
		mov esi, 8
		div esi
		cmp edx, 6
		jge rosu
		cmp edx, 4
		jl negru
		jmp sari_peste

		negru:
		mov dword ptr vec[ecx*4], 1 ;1 este zid
		jmp sari_peste
		rosu:
		mov dword ptr vec[ecx*4], 3 ;3 este lava
		;si 0 in labirint este cale libera
		
		sari_peste:
		inc ecx
		cmp ecx, 672
	jne looplinii
	jmp afisare_litere
	
evt_timer:
	mov eax, conditie_score ;verificam daca nu am ajuns deja la final, iar in caz contrar contorizam timpul in secunde
	cmp eax, 1
	jne nu_secundaa1
	inc counter
	mov eax, counter
	cmp eax, 5
	jne nu_secundaa1
	mov eax, 0
	mov counter, eax
	inc secunda
	nu_secundaa1:
	
afisare_litere:
	make_text_macro_small 'T', area, 10, 10
	make_text_macro_small 'I', area, 20, 10
	make_text_macro_small 'M', area, 30, 10
	make_text_macro_small 'E', area, 40, 10
	make_text_macro_small 'R', area, 50, 10
	
	;make_text_macro_big '3', area, 100, 40 
	;instructiunea de sus e pentru demonstrarea aparitiei si disparitiei mesajului BRAVO la apasarea pe START
	
	make_text_macro_small 'S', area, 780, 10
	make_text_macro_small 'C', area, 790, 10
	make_text_macro_small 'O', area, 800, 10
	make_text_macro_small 'R', area, 810, 10
	make_text_macro_small 'E', area, 820, 10
	;afisam numarul de secunde (sute, zeci si unitati)
	mov ebx, 10
	mov eax, secunda
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 90, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 80, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 70, 10
	
	;afisam valoarea scorului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, score
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 860, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 850, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro_small edx, area, 840, 10
	
	;scriem un mesaj
	make_text_macro_small 'A', area, 380, 35
	make_text_macro_small '-', area, 390, 35
	make_text_macro_small 'M', area, 400, 35
	make_text_macro_small 'A', area, 410, 35
	make_text_macro_small 'Z', area, 420, 35
	make_text_macro_small 'E', area, 430, 35
	make_text_macro_small '-', area, 440, 35
	make_text_macro_small 'I', area, 450, 35
	make_text_macro_small 'N', area, 460, 35
	make_text_macro_small 'G', area, 470, 35
	
	;button_left
	line_vertical button_left_x, button_left_y, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, button_left_y, button_size, 1h, 0FF0000h
	line_vertical button_left_x + button_size, button_left_y, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, button_left_y + button_size, button_size, 1h, 0FF0000h
		;sageata_stanga
	make_text_macro_big '4', area, button_left_x + 5, button_left_y + 5
	;button_right
	line_vertical button_right_x, button_right_y, button_size, 1h, 0FF0000h
	line_horizontal button_right_x, button_right_y, button_size, 1h, 0FF0000h
	line_vertical button_right_x + button_size, button_right_y, button_size, 1h, 0FF0000h
	line_horizontal button_right_x, button_right_y + button_size, button_size, 1h, 0FF0000h
		;sageata_dreapta
	make_text_macro_big '5', area, button_right_x + 5, button_right_y + 5
	;button_up 
	line_vertical button_up_x, button_up_y, button_size, 1h, 0FF0000h
	line_horizontal button_up_x, button_up_y, button_size, 1h, 0FF0000h
	line_vertical button_up_x + button_size, button_up_y, button_size, 1h, 0FF0000h
	line_horizontal button_up_x, button_up_y + button_size, button_size, 1h, 0FF0000h
		;sageata_sus
	make_text_macro_big '6', area, button_up_x + 5, button_up_y + 5
	;button_down
	line_horizontal button_down_x, button_down_y + button_size, button_size, 1h, 0FF0000h
		;sageata_jos
	make_text_macro_big '7', area, button_down_x + 5, button_down_y + 5
	
	;coloram chenarul pentru START
	line_vertical button_left_x, 120, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, 120, 90, 1h, 0FF0000h
	line_vertical button_left_x + 90, 120, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, 150, 90, 1h, 0FF0000h
	;desenam cuvantul START
	make_text_macro_small 'S', area, button_left_x + 20, 125
	make_text_macro_small 'T', area, button_left_x + 30, 125
	make_text_macro_small 'A', area, button_left_x + 40, 125
	make_text_macro_small 'R', area, button_left_x + 50, 125
	make_text_macro_small 'T', area, button_left_x + 60, 125
	
	;coloram chenarul pentru GENERATE
	line_vertical button_left_x, 460, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, 460, 90, 1h, 0FF0000h
	line_vertical button_left_x + 90, 460, button_size, 1h, 0FF0000h
	line_horizontal button_left_x, 490, 90, 1h, 0FF0000h
	;desenam cuvantul GENERATE
	make_text_macro_small 'G', area, button_left_x + 5, 465
	make_text_macro_small 'E', area, button_left_x + 15, 465
	make_text_macro_small 'N', area, button_left_x + 25, 465
	make_text_macro_small 'E', area, button_left_x + 35, 465
	make_text_macro_small 'R', area, button_left_x + 45, 465
	make_text_macro_small 'A', area, button_left_x + 55, 465
	make_text_macro_small 'T', area, button_left_x + 65, 465
	make_text_macro_small 'E', area, button_left_x + 75, 465
	
	line_vertical 20, 100, 420, 20, 0
	line_vertical 680, 100, 260, 20, 0
	line_vertical 680, 380, 140, 20, 0
	line_horizontal 20, 520, 680, 20, 0
	line_horizontal 20, 80, 40, 20, 0
	line_horizontal 80, 80, 620, 20, 0
	
	line_horizontal 700, 340, 40, 20, 0
	line_horizontal 700, 380, 40, 20, 0
	line_horizontal 720, 360, 20, 20, 0
	make_text_macro_big '3', area , 700, 360
	
	;mai jos se deseneaza labirintul conform matricei generate random
	mov ebx, 0
	loopliniii:
		push ebx
		mov eax, vec[ebx*4]
		cmp eax, 3
		je lava
		cmp eax, 1
		je zid
		jmp sari
		lava:
		make_text_macro_big '1', area, start_x, start_y
		jmp sari
		zid:
		make_text_macro_big '0', area, start_x, start_y
		sari:
		mov eax, start_x
			cmp eax, 660
			jne mergebine ;modific si x si y
				mov eax, 40
				mov start_x, eax
				mov eax, start_y
				add eax, 20
				mov start_y, eax
				jmp saripeste
			mergebine: ;modific doar x
			add eax, 20
			mov start_x, eax
		saripeste:
		pop ebx
		inc ebx
		cmp ebx, 672
	jne loopliniii
	
	mov eax, start_x_backup
	mov start_x, eax
	mov eax, start_y_backup
	mov start_y, eax
	
	
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
