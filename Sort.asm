
; Author: Joseph Di Lullo
; Last Modified: 3/1/2022

INCLUDE Irvine32.inc

.data

welcome				BYTE	"Hello! This program will sort random integers in the range (100...999), it will display the origional list, sort the list, calculate the median value, then display the sorted list." , 0
myname				BYTE	"Programmed by Joseph Di Lullo" , 0
numprompt			BYTE	"How many numbers should be generated? (15 .. 200): " , 0
errormes			BYTE	"Number entered must be between 15 and 200!" , 0
numstring			DWORD	0
lo					DWORD	0
hi					DWORD	0
listindex			DWORD	0
thespace			BYTE	"	" , 0
newlinecounter		DWORD	0
variableone			DWORD	0
unsortp				BYTE	"The unsorted list is: " , 0
ostring				DWORD	200 DUP(?)
itemswap1			DWORD	0
itemswap2			DWORD	0
variable2			DWORD	0
listindexsub1		DWORD	0
thej				DWORD	0
listindex2			DWORD	0
sorted				BYTE	"The sorted list is: " , 0
twooftwo			DWORD	0
fouroffour			DWORD	0
halfofstring		DWORD	0
halfofstringbefore	DWORD	0
halfofstringafter	DWORD	0
thefirstmedian		DWORD	0
thesecondmedian		DWORD	0
themedian			BYTE	"The median is: "


.code

;Description: Main procedure, calls other procedures, sets some values
;Receives: nothing
;Returns: nothing
;Preconditions: none
;Register changed: eax
main PROC

    call randomize

    mov eax, 1                          
    mov variableone, eax

    mov eax, 2                           
    mov twooftwo, eax

    mov eax, 4
    mov fouroffour, eax                 

    mov eax, 2
    mov variable2, eax                  

    mov eax, 100                        
    mov lo, eax

    mov eax, 999                        
    mov hi, eax

    call introduction

    call getuserdata

    call fillarray

    call crlf
    mov edx, OFFSET unsortp			
    call WriteString
    call crlf

    call displayarray

    call sortarray

    mov eax, 1                      
    mov variableone, eax

    call crlf
    call crlf
    mov edx, OFFSET sorted			
    call WriteString
    call crlf

    call displayarray

    call findmedian

exit
main ENDP

;Description: introduction, prints my name and instructions
;Receives: myname,welcome
;Returns: nothing
;Preconditions: none
;Register changed: edx
introduction PROC

    mov edx, OFFSET myname				
    call WriteString 
    call Crlf

    mov edx, OFFSET welcome				
    call WriteString 
    call Crlf

ret
introduction ENDP

;Description: getuserdata, gets the size the user wants the string to be
;Receives: numprompt, numstring
;Returns: nothing
;Preconditions: none
;Register changed: eax, edx
getuserdata PROC

    mov edx, OFFSET numprompt				
    call WriteString 

    call ReadInt

	mov numstring, eax
	cmp numstring, 15								
	jl validate

	cmp numstring, 200							
	jg validate

ret
getuserdata ENDP

;Description: validate, called if a number that is to small or too large is entered to fill array
;Receives: errormes
;Returns: nothing
;Preconditions: none
;Register changed: edx
validate PROC

    mov  edx, OFFSET errormes			
	call WriteString 

	call Crlf

	call getuserdata					


ret
validate ENDP

;Description: fills the array
;Receives: ostring, hi, lo, listindex
;Returns: built array
;Preconditions: numstring must be entered
;Register changed: eax, esi
fillarray proc

    mov esi, OFFSET ostring             

loopyloop: 

    mov eax, hi
    sub eax, lo
    inc eax
    call randomrange                    
    add eax, lo

    mov [esi], eax                                       

    add esi, 4                          
    inc listindex                       

    mov eax, listindex
    cmp eax, numstring                  
    jl loopyloop                        


ret 4
fillarray ENDP

;Description: displays the sorted and unsorted array
;Receives: ostring, newlinecounter, variableone, listindex, numstring, thespace
;Returns: nothing
;Preconditions: list must be filled
;Register changed: eax, esi
displayarray PROC 

    call crlf

    mov eax, 0
    mov newlinecounter, eax             

    mov eax, variableone
    cmp eax, 2                         
    jge loopyloopend1

    mov eax, 0
    mov listindex, eax

    mov esi, OFFSET ostring              

loopyloop1: 

    mov eax, listindex
    cmp eax, numstring                   
    je loopyloopend1

    mov eax, [esi]
    call writedec                       

    mov edx, OFFSET thespace			
	call WriteString

    add esi, 4                          
    inc listindex                       

    inc newlinecounter                

loopyloopend1:                          

    mov eax, newlinecounter
    cmp eax, 10                         
    je newline

    mov eax, listindex
    cmp eax, numstring                  
    jl loopyloop1


ret 4
displayarray ENDP

;Description: prints a new line when list is being printed
;Receives: newlinecounter, variableone
;Returns: nothing
;Preconditions: list is prtinting and one 10th value
;Register changed: eax
newline	PROC

    call crlf

    mov eax, 0
    mov newlinecounter, eax             
    inc variableone
    mov eax, variableone
	cmp eax, 2							
	jge displayarray

ret
newline	ENDP

;Description: sorts the array
;Receives: numstring, 
;Returns: sorted array
;Preconditions: array must be filled
;Register changed: eax, ebx, ecx, edx, esi
sortarray PROC

    mov ecx, numstring            
    dec ecx                  

firstloop:    
    mov edx, ecx               
    lea esi, ostring             

secondloop:            
    mov ebx, [esi+4] 
    mov eax, [esi]         

    cmp eax, ebx
    jg whereweare          
    
    mov [esi+4], eax       
    mov [esi], ebx

whereweare: 
    add esi, 4             
    
    dec edx                 
    
    jnz secondloop          
    loop firstloop         

ret 4
sortarray ENDP

;Description: finds the median in the list
;Receives: sorted list, themedian, numstring, twooftwo, fouroffour, halfofstring, halfofstringbefore, halfofstringafter, thefirstmedian, thesecondmedian
;Returns: nothing
;Preconditions: sorted list
;Register changed: eax, esi, edx
findmedian PROC

    call crlf

    mov  edx, OFFSET themedian			
	call WriteString

    lea esi, ostring                    

    mov edx, 0
    mov eax, numstring
    div twooftwo                       
    mov halfofstring, eax

    mov eax, edx
    cmp eax, 0                           
    je evenum

    mov eax, halfofstring
    mul fouroffour                      
    mov numstring, eax
    add esi, numstring

    mov eax, [esi]                      
    call writedec

    mov eax, twooftwo
    cmp eax, 2                          
    je theend2

evenum:                                 
    mov eax, halfofstring
    mul fouroffour                      
    mov numstring, eax
    add esi, numstring

    mov eax, esi
    sub eax, 4                          
    mov halfofstringbefore, eax         

    mov eax, esi
    mov halfofstringafter, eax          

    mov esi, halfofstringbefore
    mov eax, [esi]                       
    mov thefirstmedian, eax

    mov esi, halfofstringafter
    mov eax, [esi]                         
    mov thesecondmedian, eax

    mov eax, thefirstmedian
    add eax, thesecondmedian               
    div twooftwo
    call writedec
    
theend2:                                    

ret
findmedian ENDP

END main
