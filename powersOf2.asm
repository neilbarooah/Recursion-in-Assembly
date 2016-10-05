;;===============================
;;Name: Neil Barooah
;;===============================

.orig x3000
	
        ; initialize stack
        LD R6, STACK             ; load the stack pointer

        ; call powersOf2(int n)
        LD R0, N
        ADD R6, R6, -1           ; push argument n = N into stack
        STR R0, R6, 0

        JSR POWERSOF2

        ; pop return value and arg off stack
        LDR R0, R6, 0            ; load return value of the stack
        ADD R6, R6, 2            ; restore stack to previous value

        ; save the answer
        ST R0, ANSWER            ; store answer
        HALT

N 		.fill 9
ANSWER 	.blkw 1
STACK 	.fill xF000


POWERSOF2
	ADD R6, R6, -3  ; Allocate space for RV, RA, OFP
        STR R7, R6, 1   ; store return address
        STR R5, R6, 0   ; store old frame pointer
        ADD R5, R6, -1  ; new frame pointer
        ADD R6, R6,  -2 ; stack pointer at temp2
        
        AND R1, R1, 0   ; initialize temp1
        STR R1, R5, 0   ; store local variable temp1 above OFP
        AND R2, R2, 0   ; initialize temp2
        STR R2, R5, -1  ; store local variable temp2 above OFP
        LDR R0, R5, 4   ; load n relative to R5 offset
        BRnp secondcondition
        AND R0, R0, 0   ; initialize R0 to 0
        ADD R0, R0, 1   ; if n == 0, return 1
        STR R0, R5, 3   ; store 1 in return value
        ADD R6, R5, 3   ; point R6 at RV
        LDR R7, R5, 2   ; restore RA to R7
        LDR R5, R5, 1   ; restore R5 to OFP
        RET

secondcondition
        ADD R0, R0, -1  ; add (-1) to n
        BRnp else
        AND R0, R0, 0   ; initialize R0 to 0
        ADD R0, R0, 2   ; if n == 0, return 2
        STR R0, R5, 3   ; store 2 in return value
        ADD R6, R5, 3   ; point R6 to RV
        LDR R7, R5, 2   ; restore RA to R7
        LDR R5, R5, 1   ; restore R5 to OFP
        RET

else    LDR R0, R5, 4   ; loads n relative to R5 offset
        AND R1, R1, 0   ; initialize R1 to store param of recursive call
        ADD R1, R0, -1  ; recursive call of temp1 is (n-1)
        ADD R6, R6, -1  ; points to last param of next stack ;;
        STR R1, R6, 0   ; push n - 1 into next stack
        JSR POWERSOF2   ; powersOf2(n-1)
        LDR R0, R6, 0   ; R0 = powersOf2(n-1)
        STR R0, R5, 0   ; store powersOf2(n-1) into temp1
        ADD R6, R6, 2   ; move R6 back down, popping n - 1 and RV
  
        LDR R0, R5, 4   ; loads n relative to R5 offset
        AND R1, R1, 0   ; initialize R1 to store param of second recursive call
        ADD R1, R0, -2  ; recursive call of temp2 is (n-2)
        ADD R6, R6, -1  ; points to last param of next stack
        STR R1, R6, 0   ; push n - 2 into next stack
        JSR POWERSOF2   ; powersOf2(n-2)
        LDR R0, R6, 0   ; R0 = powersOf2(n-2)
        STR R0, R5, -1  ; store powersOf2(n-2) into temp2
        ADD R6, R6, 2   ; move R6 back down, popping n - 2 and RV
        
        LDR R2, R5, 0   ; loads temp1
        AND R3, R3, 0   ; initialize R3 that will hold temp1 * 3
        ADD R3, R2, R2  ; temp1 * 2
        ADD R3, R3, R2  ; (temp1 * 2) + temp1 = 3 * temp1
        LDR R2, R5, -1  ; loads temp2
        AND R1, R1, 0   ; initialize R1 that will hold -(2 * temp2)
        ADD R1, R2, R2  ; temp2 * 2
        NOT R1, R1      ;  NOT(2 * temp2)
        ADD R1, R1, 1   ; -(2 * temp2)
        ADD R0, R1, R3  ; R0 = (3 * temp1 - 2 * temp2)
        STR R0, R5, 3   ; store above expression in return value
        ADD R6, R5, 3   ; points R6 to RV
        LDR R7, R5, 2   ; restore RA to R7
        LDR R5, R5, 1   ; restore R5 to OFP
        RET
  
.end
