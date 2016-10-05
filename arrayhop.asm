;;===============================
;;Name: Neil Barooah
;;===============================

.orig x3000

        ; initialize stack
	LD R6, STACK			; load the stack pointer
        
        ; call array_hop(int[] array, idx)
	AND R0, R0, 0
	ADD R6, R6, -1			; push argument idx=0 on stack
	STR R0, R6, 0 

	LD R0, ARRAY1			; R0 = ARRAY1, change later to ARRAY2 and ARRAY3 for testing
	ADD R6, R6, -1 			; allocate spot on stack
	STR R0, R6, 0			; push argument ARRAY on stack

	JSR ARRAYHOP

        ; Pop return value and arg off stack
	LDR R0, R6, 0			; load return value off top of stack
	ADD R6, R6, 3 			; restore stack to previous value

        ; save the answer
	ST R0, ANSWER			; store answer
	HALT

ARRAY1 	.fill x5000
ARRAY2	.fill x5010
ARRAY3  .fill x5020
ANSWER 	.blkw 1
STACK 	.fill xF000


ARRAYHOP
	ADD R6, R6,-3 ; allocate space for RV, RA and OFP
        STR R7, R6, 1 ; store return address
        STR R5, R6, 0 ; store old frame pointer
        ADD R5, R6, -1 ; new frame pointer

        LDR R0, R5, 4  ; load ARRAY relative to R5 for offset
        LDR R1, R5, 5  ; load idx relative to R5 for offset
        ADD R2, R1, R0 ; R2 points to the correct index of ARRAY
        LDR R2, R2, 0  ; load array[idx], condition code is set
        STR R2, R5, 0  ; store local variable n above OFP ;;
        BRnp else
        AND R0, R0, 0  ; initialize 0 value
        STR R0, R5, 3  ; store 0 in return value
        ADD R6, R5, 3  ; point R6 to return value
        LDR R7, R5, 2  ; restore return address to R7
        LDR R5, R5, 1  ; restore R5 to old frame pointer
        RET

else    
        LDR R2, R5, 0  ; loads local variable n = array[idx] ;;
        LDR R1, R5, 5  ; load idx relative to R5 for offset
        ADD R1, R1, R2 ; the next recursive call requires idx + n
        ADD R6, R6, -1 ; points to last parameter of next stack
        STR R1, R6, 0  ; push idx + n into next stack
        ADD R6, R6, -1 ; points to second parameter of next stack
        STR R0, R6, 0  ; push ARRAY into next stack
        JSR ARRAYHOP   ; array_hop(array, idx + n)
        LDR R0, R6, 0  ; R0 = array_hop(array, idx + n)
        ADD R6, R6, 3  ; move R6 back down, popping ARRAY, idx + n, RV
        AND R3, R3, 0  ; intialize R3 to store 1
        ADD R3, R3, 1  ; R3 = 1
        ADD R0, R3, R0 ; R0 = 1 + array_hop(array, idx + n)

        STR R0, R5 , 3 ; store above expression into return value
        ADD R6, R5, 3  ; points R6 at RV
        LDR R7, R5, 2  ; restore RA to R7
        LDR R5, R5, 1  ; restore R5 to OFP
        RET

        


.end

; 4 hops
.orig x5000
.fill 2
.fill 1
.fill 3
.fill 0
.fill -1
.fill -1
.end

; 5 hops
.orig x5010
.fill 1
.fill 1
.fill 1
.fill 3
.fill 0
.fill -12
.fill -2
.end

; 12 hops
.orig x5020
.fill 5
.fill 1
.fill 0
.fill -3
.fill 10
.fill -1
.fill 5
.fill 20
.fill 2
.fill 3
.fill 1
.fill -2
.fill 9
.fill 14
.fill 3
.fill 20
.fill -2
.fill -7
.fill 5
.fill 1
.fill -18
.fill -2
.end
