ORG 0x0100

user_input_buffer DB 11, '0'
char_colors DB 0x14, 0xF3D9, 0xF8, 0xF8, 0xA9, 0xD2, 0xC3, 0xE1, 0x14, 0xF3D9, 0xF6

input_index DW 0
string_index DW 0

MOV SI, 0
MOV DI, 0

MOV AX, 3
INT 10h

MOV AH, 0x00
MOV AL, 0x03
INT 0x10

MOV AX, 1003h
MOV BX, 0
INT 10h

loop_start:
  MOV AH, 0x01
  INT 0x21

  CMP AL, 0x0D
  JE done

  MOV BL, [char_colors + SI]

  MOV AH, 0x09
  MOV CX, 1
  INT 10h

  PUSH AX
  PUSH BX

  MOV [user_input_buffer + DI], AL
  INC SI
  INC DI

  CMP DI, 11
  JE exit_program

  JMP loop_start

done:
  MOV AH, 0x00
  MOV AL, 0x03
  INT 0x10

MOV AX, 1003h
MOV BX, 0
INT 10h

  MOV DX, [user_input_buffer]
  MOV CX, 11

print_loop:
  POP BX
  POP AX

  MOV AH, 0x09
  INT 10h

  ADD DX, 1
  LOOP print_loop

  MOV AH, 0x4c
  INT 0x21

exit_program:
  MOV AL, 0
  SUB DI, CX
  MOV CX, 11
  SUB CX, DI
  REP STOSB

  JMP loop_start
