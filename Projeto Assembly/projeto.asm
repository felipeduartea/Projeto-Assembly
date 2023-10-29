.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib

.data
    inputString db 256 dup(?)
    outputString db 256 dup(?)
    inputHandle dd ?
    outputHandle dd ?
    console_count dd ?
    tamanho_string dd ?
    promptExisting db "Nome do arquivo: ", 0
    promptNew db "Nome do novo arquivo: ", 0

    pos_x db 256 dup(?)
    pos_y db 256 dup(?)
    larguraCensura db 256 dup(?)
    promptX db "Valor de X: ", 0
    promptY db "Valor de Y: ", 0
    promptCensura db "Largura da Censura: ", 0


.code
start:

;Lendo o nome do arquivo inicial

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov outputHandle, eax
invoke WriteConsole, outputHandle, offset promptExisting, sizeof promptExisting, addr console_count, NULL

invoke GetStdHandle, STD_INPUT_HANDLE
mov inputHandle, eax
invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL


mov esi, offset inputString
proximo1:
 mov al, [esi]
 inc esi
 cmp al, 13
 jne proximo1
 dec esi
 xor al, al
 mov [esi], al

;Lendo o nome do novo arquivo

invoke WriteConsole, outputHandle, offset promptNew, sizeof promptNew, addr console_count, NULL
invoke ReadConsole, inputHandle, addr outputString, sizeof outputString, addr console_count, NULL

mov esi, offset outputString
proximo2:
 mov al, [esi]
 inc esi
 cmp al, 13
 jne proximo2
 dec esi
 xor al, al
 mov [esi], al


;Criando novo arquivo

invoke CreateFile, addr inputString, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
mov inputHandle, eax


invoke CreateFile, addr outputString, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
mov outputHandle, eax


invoke ReadFile, inputHandle, addr console_count, sizeof console_count, addr console_count, NULL
invoke WriteFile, outputHandle, addr console_count, sizeof console_count, addr tamanho_string, NULL

invoke CloseHandle, inputHandle
invoke CloseHandle, outputHandle

invoke ExitProcess, 0
end start
