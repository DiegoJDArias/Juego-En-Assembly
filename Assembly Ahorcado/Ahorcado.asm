macro print message
    lea    dx, message
    mov    ah, 9
    int    21h
endm

;  /////////////////////////////////////////////////
;  Author Diego J D Arias - diegojdarias@gmail.com.
; ////////////////////////////////////////////////

data segment
    enter         db 10, 13, "$"
    guion         db "_$"
    space         db " $"
    cleanLinea    db 13, "                                    ", 13, "$"
    titulo        db "Ahorcado by Diego JD Arias Assembly 8086", 10, 13, "$"
    string        db "Ingrese la palabra a buscar: $"
    string2       db "Ingrese una pista: $"                                 
    string3       db "**************** PISTA: ****************", 10, 13, "$"
    string4       db "****************************************", 10, 13, "$"
    stringIngreso db "Ingrese una letra: $"
    stringLetra   db "  Letra: $"
    stringWinner  db "***** HAS GANADO! *****$"      
    
    stringFin     db "***** GAME OVER! *****$"      
    
    cleaner       db 10, 13, "                                   "
                  db "                                   "
                  db "                                   "
                  db "                                   "
                  db "                                   $"
    contador      dw 0
    intentos      dw 0
    stringPista   db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    strbuscarda   db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    strEncontrada db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    
    
ends

stack segment
    dw   128  dup(0)
ends

code segment

; set segment registers:

start:
    mov    ax, data
    mov    ds, ax
    mov    es, ax
    print  titulo                    ; ===== INICIO ===== ;
    print  string
    mov    si, offset strbuscarda
    mov    cx, 0
	
read:
    mov    ah, 1
    int    21h
    cmp    al, 13
    jz     finRead
    mov    [si], al
    inc    si
    inc    cx
    jmp    read
	
finRead:
    mov    contador, cx             ; Guardamos la cantidad de strbuscardas
    print  enter                     
    print  string2                   ; Pista
    mov    si, offset stringPista
	
read2:
    mov    ah, 1
    int    21h
    cmp    al, 13
    jz     finRead2
    mov    [si], al
    inc    si
    jmp    read2
	
finRead2:
    mov    ax, 12h                  ; modo de video (720x400)
    int    10h  
    print  enter
    print  titulo                   ; Pistas
    print  enter
    print  string3                                              
    print  enter
    print  stringPista
    print  enter
    print  enter
    print  enter
    print  string4
    print  enter
    print  stringIngreso
    print  enter
    print  enter
    print  enter
   
; * ===== Empieza el juego =====

verifica:    
    print  cleanLinea                 ; Limpia linea
    mov    si, offset strEncontrada   ; strEncontrada = strbuscarda que forma el usuario
    mov    cx, contador
	
cuenta:
    print  space
    mov    bx, 0
    mov    bl, [si]
    cmp    bl, 0
    jz     printGuion                 ; Imprime el valor del vector
    mov    dx, bx 
    mov    ah, 2
    int    21h
    jmp    sigCuenta
	
printGuion:
    print  guion
    
sigCuenta:
    inc    si
    loop   cuenta                     ; Verifica si ya encontro la strbuscarda
    mov    si, offset strbuscarda     ; strbuscarda a encontrar
    mov    di, offset strEncontrada   ; strbuscarda del usuario
    mov    cx, contador
	
comprobarPalabra:
    mov    ax, 0
    mov    bx, 0
    mov    al, [si]
    mov    bl, [di]
    cmp    al, bl
    jz     sigVerificar
    jmp    digiteLetra               ; si no es igual que siga buscarndo
    
sigVerificar:
    inc    si                        ; Verifica cada caracter
    inc    di
    loop   comprobarPalabra
    print  enter                     ; A ganado :D
    print  enter
    print  cleaner
    print  stringWinner
    jmp    sigstringFinal

digiteLetra:
    print  stringLetra               ; Digite una letra
    mov    ah, 1
    int    21h
    mov    si, offset strbuscarda     ; Verificamos si esta caracter se encuentra en la cadena
    mov    di, offset strEncontrada
    mov    cx, contador
    mov    dx, 0                     ; Bandera para verificar si acerto
	
buscar:
    mov    bx, 0
    mov    bl, [si]
    cmp    al, bl
    jz     colocaLetra
    jmp    sigB
    
colocaLetra:
    mov    [di], al                  ; coloca el caracter a la strbuscarda usuario
    mov    dx, 1
    
sigB:
    inc    si
    inc    di
    loop   buscar
    cmp    dx, 1                    ; Verificando si la letra estaba en la strbuscarda
    jz     correcto
    mov    cx, intentos             ; incorrecto:
    inc    cx
    mov    intentos, cx
    cmp    cx, 1
    jz     primerIntento
    cmp    cx, 2
    jz     segundoIntento
    cmp    cx, 3
    jz     tercerIntento
    cmp    cx, 4
    jz     cuartoIntento
    cmp    cx, 5
    jz     quintoIntento
    cmp    cx, 6
    jz     sextoIntento 
    cmp    cx, 7               ; VER ESTO QUE TAL...
    jmp    septimoIntento
	
primerIntento:
    mov    bx, 0
    mov    cx, 50
    mov    dx, 200
    call   pendientePosi
    mov    bx, 0
    mov    cx, 60
    mov    dx, 190
    call   pendienteNega
    mov    bx, 0
    mov    cx, 60
    mov    dx, 190
    call   rectaV
    jmp    sigIncorrecto
   
segundoIntento:
    mov    bx, 0
    mov    cx, 60
    mov    dx, 140
    call   rectaH
    jmp    sigIncorrecto
   
tercerIntento:
    mov    bx, 40
    mov    cx, 90
    mov    dx, 150 
    call   rectaV
    jmp    sigIncorrecto
   
cuartoIntento:
    mov    bx, 22
    mov    cx, 87
    mov    dx, 150
    call   rectaH
    mov    bx, 22
    mov    cx, 87
    mov    dx, 158
    call   rectaH
    mov    bx, 42
    mov    cx, 87
    mov    dx, 158
    call   rectaV
    mov    bx, 42
    mov    cx, 95
    mov    dx, 158
    call   rectaV
    jmp    sigIncorrecto
   
quintoIntento:
    mov    bx, 35
    mov    cx, 90
    mov    dx, 173 
    call   rectaV
    jmp    sigIncorrecto
    
sextoIntento:
    mov    bx, 6
    mov    cx, 86
    mov    dx, 167 
    call   pendientePosi
    mov    bx, 6
    mov    cx, 91
    mov    dx, 163
    call   pendienteNega
    jmp    sigIncorrecto
    
septimoIntento:
    mov    bx, 6
    mov    cx, 86
    mov    dx, 177 
    call   pendientePosi
    mov    bx, 6
    mov    cx, 91
    mov    dx, 173
    call   pendienteNega
    jmp    sigIncorrecto
	
sigIncorrecto:
   
correcto:
    mov    cx, intentos             ; Verifica si tiene mas intentos
    cmp    cx, 7
    jz     gameOver
    jmp    verifica
   
gameOver:
    print  enter                    ; A perdido :c
    print  cleaner
    print  stringFin
   
sigstringFinal:
    mov    ax, 4C00h                ; ===== stringFin ===== ;
    int    21h
ends

proc pendientePosi
    mov    ax, 0A000h
    mov    es, ax
	
lineaPP:
    mov    ah, 0ch
    mov    al, 09h                 
    int    10h
    inc    cx
    dec    dx
    inc    bx
    cmp    bx, 10
    jz     stringFinPP
    jmp    lineaPP
	
stringFinPP:
    ret
	
endp

proc pendienteNega
    mov    ax, 0A000h
    mov    es, ax
	
lineaPN:
    mov    ah, 0ch
    mov    al, 09h
    int    10h   
    inc    cx
    inc    dx
    inc    bx
    cmp    bx, 10
    jz     stringFinPN
    jmp    lineaPN
	
stringFinPN:
    ret
	
endp

proc rectaV
    mov    ax, 0A000h
    mov    es, ax
	
lineaRV:
    mov    ah, 0ch
    mov    al, 09h
    int    10h
    dec    dx
    inc    bx
    cmp    bx, 50
    jz     stringFinRV
    jmp    lineaRV
	
stringFinRV:
    ret
	
endp

proc rectaH
    mov    ax, 0A000h
    mov    es, ax
	
lineaRH:
    mov    ah, 0ch
    mov    al, 09h
    int    10h
    inc    cx
    inc    bx
    cmp    bx, 30
    jz     stringFinRH
    jmp    lineaRH
	
stringFinRH:
    ret
	
endp
