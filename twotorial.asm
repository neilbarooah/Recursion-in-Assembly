;;===============================
;;Name: Neil Barooah
;;===============================

.orig x3000

        ; Initialize stack
	LD R6, STACK			; load the stack pointer

        ; Call Twotorial(n)
	LD R0, N				; R0 = N
	ADD R6, R6, -1			; push argument N on stack
	STR R0, R6, 0			

	JSR TWOTORIAL

        ; Pop return value and arg off stack
	LDR R0, R6, 0			; load return value off top of stack
	ADD R6, R6, 2 			; restore stack to previous value

        ; save the answer
	ST R0, ANSWER			; store answer
	HALT

N 		.fill 13
ANSWER 	.blkw 1
STACK 	.fill xF000


TWOTORIAL
	
      ADD R6, R6, -3 ; allocate space for RV, RA, OFP
      STR R7, R6, 1   ; store return address
      STR R5, R6, 0   ; store old frame pointer
      ADD R5, R6, -1  ; new frame pointer

      LDR R0, R5, 4   ; N relative to R5 for offset, load N to check condition code
      BRp else
      AND R0, R0 , 0  ; intialize 0 value
      STR R0, R5, 3   ; store 0 in return value
      ADD R6, R5, 3   ; point R6 at RV
      LDR R7, R5, 2   ; restore RA to R7
      LDR R5, R5, 1   ; restore R5 to OFP
      RET

else LDR R0, R5, 4    ; load N relative to R5 for offset
     ADD R0, R0, -2   ; the next recursive call requires n - 2
     ADD R6, R6, -1   ; points to last parameter of next stack
     STR R0, R6, 0    ; push n - 2 into stack
     JSR TWOTORIAL    ; twotorial(n-2)
     LDR R0, R6, 0    ; R0 = twotorial(n-2)
     ADD R6, R6, 2    ; move R6 back down, popping RV and n - 2 param off stack
     LDR R1, R5, 4    ; loads N relative to R5 for offset
     ADD R0, R1, R0   ; R0 = n + twotorial(n-2)

     STR R0, R5, 3    ; store R0 into return value
     ADD R6, R5, 3    ; points R6 at RV
     LDR R7, R5, 2    ; restore RA to R7
     LDR R5, R5, 1    ; restore R5 to OFP
     RET
      
.end
