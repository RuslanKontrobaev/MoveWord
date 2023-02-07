{$G+}
Program MoveWord;
const Word: string = 'CYBERPUNK';
var x, y: integer;
BEGIN
    x:= 80 div 2 - 4; y:= 25 div 2;
    asm
       push $b800           {const video mode in stack}
       pop es
	 cld                  
 @Draw:
       mov ax, 03           
       int 10h              {clrscr}
       mov ax, $50          {ax = 80}
       mov bx, y            
       mul bx               {ax = bx * ax}
       add ax, x            
       shl ax, 1            {operations (x+80*y)*2}
       mov di, ax           {position on display in di}
       mov ah, $D           {font color}
       lea si, Word         {load effective address in si}
       mov cl, [si]         {cl = *cl; *cl - value at address si}
       xor ch, ch
       inc si               {stand at first char of "Word"}
    @L:
       lodsb                {read one byte from ds:si in al}
       stosw                {write word from ax in es:di}
       loop @L
@Again:
	 xor ah, ah
       int 16h
       cmp ah, 01h          {compare scan-code 'Esc'}
       je @Exit
       cmp ah, 1Eh          {compare scan-code 'A'}
       je @Left
       cmp ah, 20h          {compare scan-code 'D'}
       je @Right
       cmp ah, 1Fh          {compare scan-code 'S'}
       je @Down
       cmp ah, 11h          {compare scan-code 'W'}
       je @Up
       jmp @Again
  @Left:
       cmp x, $0
       ja @MoveLX
       jmp @Again
@MoveLX:
	 dec x
	 jmp @Draw
 @Right:
       cmp x, $50-9
       jl @MoveRX
       jmp @Again
@MoveRX:
	 inc x
	 jmp @Draw
  @Down:
       cmp y, $18
	 jl @MoveDY
       jmp @Again
@MoveDY:
       inc y
	 jmp @Draw
    @Up:
       cmp y, $0
	 jg @MoveUY
       jmp @Again
@MoveUY:
       dec y
	 jmp @Draw
  @Exit:
    end; {asm}
END.