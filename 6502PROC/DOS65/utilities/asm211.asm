;ASM -- DOS/65 ASSEMBLER
;VERSION 2.11-A
;RELEASED:	7 MARCH 2008
;THIS VERSION INCORPORATES THE FOLLOWING CHANGES FROM 2.04
;	FORMAT FOR *= CHANGED FOR TASM COMPATIBILITY
;		THIS MEANS FIRST * NOT IN COLUMN 1
;		ALL SUCH STATEMENTS ARE ON A SEPARATE LINE FROM LABLE
;	.BYT & .WOR CHANGED TO .BYTE & .WORD FOR TASM
;	ALL COMMENTS HAVE ; FOR TASM
;	MADE ' & " INTERCHANGEABLE SO STRINGS CAN US
;		"" FOR TASM COMPATIBILITY.
;		NOTE THAT ASM210 USES ' ONLY
;		AND SHOULD BE ASSEMBLED EITHER BY
;		ITSELF, ASM204, OR IF ALL STRINGS
;		IN .BYTE STATEMENT ARE CHANGED TO "
;		IT CAN BE ASSEMBLED BY TASM.
;	MADE ALL #' ' HAVE CLOSING ' (OR ") FOR TASM
;	STRINGS BROKEN UP TO 31 MAX FOR TASM
;	MANY COMMENTS ADDED OR CLARIFIED
;	MORE ASCII CHARACTERS DEFINED TO SIMPLIFY COMPATIBILITY
;LAST REVISION:
;	31 MARCH 2008
;		CHANGED STRING DELIMITERS TO ""
;		ADDED FIVE MISSING SEMICOLONS
;ASCII CHARACTER DEFINITIONS
TAB             = $9            ;TAB CHAR
LF              = $A            ;LINEFEED
CR              = $D            ;RETURN
EOF             = $1A           ;END OF FILE
BLANK           = $20           ;BLANK
QUOTE           = $22           ;VALUE OF "
APOST           = $27           ;VALUE OF '
SEMICO          = $3B           ;VALUE OF SEMICOLON ;
DELETE          = $7F           ;DEL CHAR
;FIXED PARAMETERS
NUMASM          = 15            ;NUMBER DIRECTIVES OR PARAMETERS
NUMSAV          = 10            ;NUMBER OPT PARAMETERS
LINESZ          = 80            ;CHARACTERS PER LINE (NOT INCL CR/LF)
BYTSRC          = 24            ;BYTES PER KIM RECORD
SRCLNG          = 1024          ;SOURCE BUFFER LENGTH
KIMLNG          = 1024          ;KIM BUFFER LENGTH
LSTLNG          = 1024          ;LIST BUFFER LENGTH
;EXTERNAL REFERENCES
TEA             = $800
PEM             = $103
DFLFCB          = $107
DFLBUF          = $128
;PAGE ZERO VARIABLES


N               = $02           ;COUNT IN SORT
PASNUM          = $04           ;PASS NUMBER
SRCIND          = $05           ;SOURCE BUFFER INDEX
KIMIND          = $07           ;KIM BUFFER INDEX
LSTIND          = $09           ;LIST BUFFER INDEX
STSAVE          = $0B           ;SYMBOL TABLE START
TBLSZ           = $0D           ;SYMBOL TABLE END
SYMTBL          = $0F           ;ADDRESS OF SYMBOL FOUND
OPRTBL          = $11           ;ADDRESS OF OPCODE IN TABLE
TBLPTR          = $13           ;USED IN ASSEMBLER DIRECTIVE SEARCHES
COLCNT          = $15           ;COLUMN COUNT
LINENO          = $16           ;LINE NUMBER (HL)
NOSYM           = $18           ;NUMBER SYMBOLS (HL)
ERCT            = $1A           ;TOTAL ERROR COUNT (HL)
PC              = $1C           ;PROGRAM COUNTER
FLAGS           = $1E           ;SET OF FLAGS
;FLAG BIT FUNCTIONS
; FLAG	(7)	IF 1 THEN DO NOT GENERATE STRINGS
;	(6)	IF 1 THEN LIST SYMBOL TABLE
;	(5)	IF 1 THEN GENERATE KIM FILE
;	(4)	IF 1 AND IF FLAG(2)=0 THEN LIST ERRORS
;	(3)
;	(2)	IF 1 THEN PRODUCE LISTING
;	(1)
;	(0)
; FLAG+1(7)
;	(6)
;	(5)
;	(4)	EXPR RETURN FLAG
;	(3)	EXPR OVERFLOW FLAG
;	(2)
;	(1)	SIGN BIT
;	(0)	EXP SIGN BIT
COLP            = $20           ;CURRENT COLUMN
CSB             = $21           ;CURRENT STRING BEGINNING
CSE             = $22           ;CURRENT STRING END
CSL             = $23           ;CURRENT STRING LENGTH
LSST            = $24           ;START OF LABEL
EXP             = $25           ;VALUE OF EXPRESSION (HL)
PARST           = $27           ;PARSE STARTING COLUMN
MAXCL           = $28           ;MAX COLUMN IN LINE
LABL            = $29           ;FLAG SET IF LABEL IN LINE
ORG             = $2A           ;FLAG SET IF ORG IN LINE
BYWOR           = $2B           ;BYTE/WORD FLAG
LCDPT           = $2C           ;MULTIPLE LINES FLAG
SYMPTR          = $2D           ;CURRENT # SYMBOLS SEARCHED IN FIND
LEN             = $2F           ;LENGTH OF STRING TO BE PACKED
BASE            = $30           ;BASE OF NUMBER
OP              = $31           ;NEXT OPERATOR IN EVAL
LOW             = $32           ;< FLAG
HIGH            = $33           ;> FLAG
VAL             = $34           ;INTERMEDIATE VALUE IN EVAL (HL)
RETURN          = $36           ;RETURN CODE
OPBAS           = $37           ;BASE OPCODE
OPTEM           = $38           ;OPCODE TEMPLATE
OPLEN           = $39           ;OPERAND LENGTH
OPTYP           = $3A           ;OPERAND TYPE
NOPV            = $3B           ;FLAG FOR NO OPERAND VALUE
J               = $3C           ;UTILITY VARIABLE
ERCOL           = $3D           ;COLUMN WITH ERROR
EROR            = $3E           ;ERROR NUMBER
TEMP            = $3F           ;UTILITY VARIABLE
TEMB            = $41           ;UTILITY VARIABLE
LTBL            = $43           ;LENGTH TABLE - INFO BUFFER
SRTFLG          = $48           ;SORT FLAG
CURADR          = $49           ;CURRENT SYMBOL FOR SORT
NXTADR          = $4B           ;NEXT SYMBOL FOR SORT
BYTCNT          = $4D           ;KIM RECORD BYTE COUNT
FRSTPC          = $4E           ;FIRST PC IN KIM RECORD
KIMREC          = $50           ;KIM RECORD BUFFER
CHKSUM          = $68           ;KIM RECORD CHECKSUM
CURNPC          = $6A           ;CURRENT KIM PC
CDEPTR          = $6C           ;CODE POINTER
SAVE            = $6E           ;SAVE FOR X AND Y
ACC             = $70           ;MUL AND DIV ACCUM
KINDEX          = $72           ;KIM RECORD INDEX
KIMCNT          = $73           ;KIM CODE COUNT
RDSCCN          = $74           ;READ SOURCE SECTOR COUNT
LNGKIM          = $75           ;LENGTH OF BUFFER AT WRITE
LNGLST          = $77           ;LENGTH OF LIST BUFFER
MPNT            = $79           ;POINTER FOR STRING WRITE
MAXECH          = $7B           ;LAST ECHO POSITION
STRING          = $7C           ;LOWERCASE FLAG
LSTFLG          = $7D           ;LIST FILE TO CONSOLE IF > 127
NLSFLG          = $7E           ;NO LIST FILE OUTPUT IF > 127
NKMFLG          = $7F           ;NO KIM FILE OUTPUT IF > 127
STRDEL          = $80           ;STRING DELIMITER IN .BYT
LASTZP          = $81
;ENTRY POINT
        .SEGMENT "TEA"
        .ORG    $0800

        JMP     MAIN            ;SKIP TO MAIN SECTION
SYMLEN:
        .BYTE   16              ;MAX SYMBOL LENGTH
        .BYTE   "COPYRIGHT (C) 2008 -"
        .BYTE   " RICHARD A. LEARY"
;SUBROUTINES
;CHECK FOR CORRECT DRIVE RANGE
CHKDRV:
        CMP     #'A'            ;IF LESS THAN A
        BCC     BADRV           ;IS BAD
        CMP     #'H'+1          ;IF OVER H
        BCS     BADRV           ;IS BAD
        AND     #15             ;LOOK AT LSBS ONLY
        RTS
BADRV:
        LDA     #<ILDMSG        ;POINT TO MESSAGE
        LDY     #>ILDMSG
        JSR     WRCNMS          ;WRITE IT
;WARM BOOT
WRMBTE:
        LDX     #0
        BEQ     PEMENT
;CONSOLE OUTPUT
CNSOUT:
        CMP     #EOF            ;SEE IF EOF CHAR
        BNE     *+3             ;CONTINUE IF NOT
        RTS                     ;ELSE DONE
        LDX     #2
        BNE     PEMENT
;SELECT DRIVE
DRVSEL:
        LDX     #14
        BNE     PEMENT
;SET BUFFER ADDRESS
SETBUF:
        LDX     #26
        BNE     PEMENT
;WRITE CONSOLE MESSAGE
WRCNMS:
        LDX     #9
        BNE     PEMENT
;OPEN FILE
OPNFIL:
        LDX     #15
        BNE     PEM255
;CLOSE FILE
CLSFIL:
        LDX     #16
        BNE     PEM255
;DELETE FILE
DLTFIL:
        LDX     #19
        BNE     PEM255
;CREATE FILE
CRTFIL:
        LDX     #22
        BNE     PEM255
;READ RECORD
RDERCR:
        LDX     #20
        BNE     PEMENT
;WRITE RECORD
WRTRCR:
        LDX     #21
;PEM ENTRY
PEMENT:
        JMP     PEM             ;EXECUTE
;PEM ENTRY WITH TEST A=255
PEM255:
        JSR     PEM             ;EXECUTE
        CMP     #255            ;TEST FOR INVALID
        RTS
;WRITE MESSAGE TO LIST FILE
;INPUT: A,Y POINT TO MESSAGE
;OUTPUT: NONE
;ALTERS: ALL
WRLSMS:
        STA     MPNT            ;SAVE
        STY     MPNT+1          ;POINTER
        LDY     #0              ;CLEAR INDEX
WR:
        LDA     (MPNT),Y        ;GET CHAR
        CMP     #'$'            ;SEE IF $
        BNE     *+3             ;CONTINUE IF NOT
        RTS                     ;ELSE DONE
        JSR     OUTPUT          ;SEND IT
        INY                     ;BUMP INDEX
        BNE     WR              ;JUMP ALWAYS
;DOS ERROR HANDLER
DOSERR:
        LDA     #<PERMSG        ;PRINT ERROR
        LDY     #>PERMSG        ;MESSAGE ON
        JSR     WRCNMS          ;CONSOLE
        JMP     WRMBTE          ;AND DO BOOT
;SET SOURCE FCB
SSRFCB:
        LDA     #<SRCFCB
        LDY     #>SRCFCB
        RTS
;SET KIM FCB
SKMFCB:
        LDA     #<KIMFCB
        LDY     #>KIMFCB
        RTS
;SET LIST FCB
SLSFCB:
        LDA     #<LSTFCB
        LDY     #>LSTFCB
        RTS
;DELETE KIM FILE
DLTKIM:
        JSR     SKMFCB          ;SET FCB
        JMP     DLTFIL          ;DELETE AND RETURN
;READ SOURCE RECORD
RDESRC:
        LDA     #<SRCBUF        ;SET
        LDY     #>SRCBUF        ;BUFFER
        JSR     SETBUF          ;ADDRESS
        JSR     SSRFCB          ;POINT TO FCB
        JMP     RDERCR          ;READ
;WRITE KIM RECORD
WRTKIM:
        SEC                     ;SUBTRACT
        LDA     KIMIND          ;START
        SBC     #<KIMBUF        ;FROM
        STA     LNGKIM          ;INDEX
        LDA     KIMIND+1        ;TO GET
        SBC     #>KIMBUF        ;LENGTH
        STA     LNGKIM+1        ;OF BUFFER
        LDX     #7              ;DIVIDE
WRTDV:
        LSR     LNGKIM+1        ;BY 128
        ROR     LNGKIM          ;TO GET
        DEX                     ;NUMBER
        BNE     WRTDV           ;OF RECORDS
        CPX     LNGKIM          ;IF NOT ZERO
        BNE     *+3             ;GO WRITE
        RTS                     ;ELSE DONE
        JSR     CLKIND          ;CLEAR INDEX
WRTKLP:
        LDA     KIMIND          ;GET RECORD
        LDY     KIMIND+1        ;START
        JSR     SETBUF          ;AND SET BUFFER
        JSR     SKMFCB          ;POINT TO FCB
        JSR     WRTRCR          ;WRITE SECTOR
        BEQ     *+5             ;CONTINUE IF OK
        JMP     DOSERR          ;ELSE DOS/65 ERROR
        CLC                     ;ADD
        LDA     KIMIND          ;128
        ADC     #128            ;TO
        STA     KIMIND          ;KIM
        BCC     *+4             ;INDEX
        INC     KIMIND+1        ;FOR NEXT
        DEC     LNGKIM          ;DROP COUNT
        BNE     WRTKLP          ;LOOP IF MORE
;CLEAR KIM INDEX
CLKIND:
        LDA     #<KIMBUF        ;SET
        LDY     #>KIMBUF        ;INDEX
        STA     KIMIND          ;TO BUFFER
        STY     KIMIND+1        ;START
        RTS
;LIST FILE CHARACTER OUTPUT
;INPUT: ASCII CHAR IN A
;OUTPUT: NONE
;ALTERS: ALL
;WRITE LIST BUFFER TO DISK IF FULL AND
;THEN INSERT CHAR INTO BUFFER
LSTOUT:
        BIT     NLSFLG          ;TEST FOR NO LIST OUTPUT
        BMI     LSTEXT          ;DONE IF SET
        BIT     LSTFLG          ;TEST FLAG
        BPL     *+5             ;IF CLEAR TO DISK
        JMP     CNSOUT          ;ELSE TO CONSOLE
        LDX     LSTIND          ;GET LOW INDEX
        CPX     #<(LSTBUF+LSTLNG);COMPARE TO LIMIT
        BNE     NOLSWR          ;JUMP IF OK
        LDX     LSTIND+1        ;ELSE TRY
        CPX     #>(LSTBUF+LSTLNG);SAME FOR HIGH
        BNE     NOLSWR          ;OK IF DIFFERENT
        PHA                     ;SAVE CHAR
        JSR     WRTLST          ;WRITE BUFFER
        PLA                     ;GET CHAR
NOLSWR:
        LDY     #0              ;CLEAR INDEX
        STA     (LSTIND),Y      ;INSERT CHAR
        INC     LSTIND          ;BUMP
        BNE     *+4             ;INDEX
        INC     LSTIND+1        ;BY ONE
LSTEXT:
        RTS
;WRITE LIST BUFFER TO DISK
;INPUT: NONE
;OUTPUT: NONE
;ALTERS: ALL
;ALSO SETS INDEX TO START
WRTLST:
        SEC                     ;SUBTRACT
        LDA     LSTIND          ;BUFFER START
        SBC     #<LSTBUF        ;FROM
        STA     LNGLST          ;CURRENT
        LDA     LSTIND+1        ;INDEX TO
        SBC     #>LSTBUF        ;GET
        STA     LNGLST+1        ;LENGTH
        LDX     #7              ;DIVIDE
WRLDV:
        LSR     LNGLST+1        ;THAT
        ROR     LNGLST          ;BY 128
        DEX                     ;TO CALCULATE
        BNE     WRLDV           ;NUMBER RECORDS
        CPX     LNGLST          ;IF NOT ZERO
        BNE     *+3             ;THEN GO WRITE
        RTS                     ;ELSE DONE
        JSR     CLLIND          ;SET INDEX TO START
WRTLLP:
        LDA     LSTIND          ;GET INDEX
        LDY     LSTIND+1        ;AND SET
        JSR     SETBUF          ;AS BUFFER START
        JSR     SLSFCB          ;POINT TO FCB
        JSR     WRTRCR          ;WRITE RECORD
        BEQ     *+5             ;CONTINUE IF OK
        JMP     DOSERR          ;ELSE A FATAL ERROR
        CLC                     ;NOW
        LDA     LSTIND          ;ADD
        ADC     #128            ;128
        STA     LSTIND          ;TO
        BCC     *+4             ;INDEX
        INC     LSTIND+1        ;FOR NEXT
        DEC     LNGLST          ;DROP COUNT
        BNE     WRTLLP          ;LOOP IF MORE
;CLEAR LIST INDEX
;INPUT: NONE
;OUTPUT: NONE
;ALTERS: A,Y,P
CLLIND:
        LDA     #<LSTBUF        ;SET LIST
        LDY     #>LSTBUF        ;INDEX
        STA     LSTIND          ;TO
        STY     LSTIND+1        ;BUFFER
        RTS                     ;START
;CONVERT NIBBLE TO HEX
NIBHEX:
        AND     #$F             ;MASK OUT MSN
        ORA     #'0'            ;CONVERT TO ASCII
        CMP     #'9'+1          ;IF DECIMAL
        BCC     *+4             ;OK
        ADC     #6              ;ELSE MAKE ALPHA
        RTS
;KIM FILE BYTE OUTPUT
KIMBYT:
        PHA                     ;SAVE BYTE
        LSR     A               ;MOVE
        LSR     A               ;MSN
        LSR     A               ;TO
        LSR     A               ;LSN
        JSR     KIMHEX          ;CONVERT AND SEND
        PLA                     ;GET BYTE
;KIM FILE NIBBLE OUTPUT
KIMHEX:
        JSR     NIBHEX          ;CONVERT
;KIM FILE CHAR OUTPUT
KIMOUT:
        LDX     KIMIND          ;COMPARE INDEX
        CPX     #<(KIMBUF+KIMLNG);TO LIMIT
        BNE     NOKMWR          ;CONTINUE IF LESS
        LDX     KIMIND+1        ;DO SAME
        CPX     #>(KIMBUF+KIMLNG);FOR
        BNE     NOKMWR          ;HIGH BYTES
        PHA                     ;SAVE BYTE
        JSR     WRTKIM          ;WRITE BUFFER
        PLA                     ;RESTORE CHAR
NOKMWR:
        LDY     #0              ;CLEAR INDEX
        STA     (KIMIND),Y      ;SAVE CHAR
        INC     KIMIND          ;BUMP
        BNE     *+4             ;INDEX
        INC     KIMIND+1        ;BY ONE
        RTS
;OUTPUT SINGLE CHAR TO LIST FILE
OUTPUT:
        PHP                     ;SAVE FLAGS
        PHA                     ;SAVE CHAR
        STX     SAVE            ;SAVE X
        STY     SAVE+1          ;AND Y
        BIT     PASNUM
        BPL     *+5
        JSR     LSTOUT          ;DO OUTPUT
        LDY     SAVE+1          ;RESTORE Y
        LDX     SAVE            ;AND X
        PLA                     ;RESTORE CHAR
        PLP                     ;RESTORE FLAGS
        RTS
;OUTPUT BYTE AS HEX TO LIST FILE
NUMA:
        PHA                     ;SAVE BYTE
        LSR     A               ;MOVE
        LSR     A               ;MSN
        LSR     A               ;TO
        LSR     A               ;LSN
        JSR     NIBHEX          ;CONVERT
        JSR     OUTPUT          ;AND SEND
        PLA                     ;GET CHAR
        JSR     NIBHEX          ;CONVERT LSN
        JMP     OUTPUT          ;AND SEND
;OUTPUT BYTE AS HEX TO CONSOLE
;INPUT: A
;OUTPUT: NONE
;ALTERS: A,P
CNUMA:
        PHA                     ;SAVE BYTE
        LSR     A               ;MOVE
        LSR     A               ;MSN
        LSR     A               ;TO
        LSR     A               ;LSN
        JSR     NIBHEX          ;CONVERT
        JSR     CNSOUT          ;SEND TO CONSOLE
        PLA                     ;GET BYTE
        JSR     NIBHEX          ;CONVERT LOW
        JMP     CNSOUT          ;SEND IT
;DO A CR AND LF TO LIST FILE
CRLF:
        LDA     #CR             ;GET CR
        JSR     OUTPUT          ;SEND
        LDA     #LF             ;THEN GET LF
        JMP     OUTPUT          ;SEND IT
;DO A CR AND LF TO CONSOLE
CCRLF:
        LDA     #CR             ;GET CR
        JSR     CNSOUT          ;SEND
        LDA     #LF             ;THEN GET LF
        JMP     CNSOUT          ;AND SEND IT
;SET NEXT SORT ADDRESS
ADRNS:
        CLC                     ;ADD
        LDA     CURADR          ;LENGTH+2
        ADC     SYMLEN          ;TO CURRENT
        STA     NXTADR          ;TO
        LDA     CURADR+1        ;MAKE
        ADC     #0              ;POINTER TO
        STA     NXTADR+1        ;NEXT ENTRY
        CLC                     ;DO +2 PART NOW
        LDA     NXTADR
        ADC     #2
        STA     NXTADR
        BCC     ADRNSX          ;DONE IF NO CARRY
        INC     NXTADR+1        ;ELSE BUMP HIGH
ADRNSX:
        RTS
;SORT SYMBOL TABLE
;USES BUBBLE SORT BUT KEEPS TRACK
;OF HIGHEST SYMBOL TO SORT
;CHECK FOR ZERO OR ONE SYMBOL
SORT:
        LDY     NOSYM+1         ;SET LOW
        STY     N+1             ;COUNT
        LDA     NOSYM           ;AND HIGH
        STA     N               ;COUNT
        BNE     SORT1           ;IF > 255 GO DO SORT
        TYA                     ;GET LOW
        BEQ     SORTX           ;DONE IF ZERO
        CMP     #1              ;IF MORE THAN
        BNE     SORT1           ;ONE DO SORT
SORTX:
        RTS                     ;ELSE DONE
;DROP AND CHECK COUNT
SORT0:
        LDA     N+1             ;CHECK LOW
        BNE     *+4             ;SKIP IF NOT ZERO
        DEC     N               ;ELSE DROP HIGH
        DEC     N+1             ;THEN LOW
        LDA     N               ;GET NEW HIGH
        BNE     SORT1           ;DO IT IF <> 0
        LDA     N+1             ;NOW GET LOW
        BEQ     SORTX           ;DONE IF ZERO
        CMP     #1              ;SEE IF ONE
        BEQ     SORTX           ;DONE IF IS
;INTIALIZE FOR PASS
SORT1:
        LDA     #$FF            ;SET
        STA     SRTFLG          ;FLAG
        LDA     STSAVE          ;SET
        STA     CURADR          ;POINTER
        LDA     STSAVE+1        ;TO FIRST
        STA     CURADR+1        ;ENTRY
        LDA     #1              ;THEN
        STA     SYMPTR+1        ;SET
        LDA     #0              ;COUNTER
        STA     SYMPTR          ;TO ONE
        JSR     ADRNS           ;SET NEXT ADDRESS
;COMPARE SYMBOLS
SORT11:
        LDY     #0              ;CLEAR INDEX
SORT2:
        LDA     (CURADR),Y      ;COMPARE FIRST
        CMP     (NXTADR),Y      ;TO NEXT
        BNE     SORT21          ;JUMP IF NOT SAME
        INY                     ;ELSE BUMP INDEX
        CPY     SYMLEN          ;IF STILL SMALL
        BNE     SORT2           ;FOR NEXT
        BEQ     SORT3           ;ELSE DO NEXT PAIR
SORT21:
        BCC     SORT3           ;IF ORDER OK DO NEXT
;SWITCH SYMBOLS
        LDY     SYMLEN          ;DO SYMBOL AND VALUE
        INY
RX1:
        LDA     (CURADR),Y      ;GET LOW
        PHA                     ;SAVE
        LDA     (NXTADR),Y      ;THEN MOVE HIGH
        STA     (CURADR),Y      ;TO LOW
        PLA                     ;RESTORE LOW
        STA     (NXTADR),Y      ;MOVE TO HIGH
        DEY                     ;COUNT DOWN
        BPL     RX1             ;LOOP IF MORE
        INY                     ;CLEAR FLAG
        STY     SRTFLG          ;TO SHOW SWITCH
;NEXT PAIR
SORT3:
        LDA     NXTADR          ;CHANGE
        STA     CURADR          ;POINTER
        LDA     NXTADR+1        ;TO NEXT
        STA     CURADR+1        ;SYMBOL
        JSR     ADRNS           ;AND SET NEXT
        INC     SYMPTR+1        ;BUMP
        BNE     *+4             ;COUNTER
        INC     SYMPTR          ;BY 1
        LDA     SYMPTR          ;IF MORE
        CMP     N               ;THEN GO
        BCC     SORT11          ;SORT MORE
        LDA     SYMPTR+1        ;DO SAME
        CMP     N+1             ;WITH LOW
        BCC     SORT11          ;PART OF COUNT
        BIT     SRTFLG          ;TEST SWITCH
        BPL     SORT0           ;GO IF WAS A SWITCH
        RTS                     ;ELSE DONE
;INCREMENT LINE BUFFER POINTER
; IF X <= MAXCL THEN C=0 ELSE C=1
INCRP:
        INX
        CPX     MAXCL
        BNE     *+3
        CLC
        RTS
;CHECK IF EXP IS A VALID INDIRECT ADDRESS
; IF EXP < 255 THEN C=1 ELSE C=0
INDADR:
        LDA     EXP             ;IF EXP>255 IS TOO BIG
        BEQ     *+4
        CLC
        RTS
        LDA     EXP+1           ;IF EXP=255 IS TOO BIG
        CMP     #255
        BEQ     *-6
        SEC
        RTS
;CHECK IF A RELATIVE BRANCH IS OUT OF RANGE
; TEMP MUST = PC AND EXP MUST =	DEST ADDR
; IF VALID THEN C=1 ELSE C=0
RELADR:
        CLC                     ;COMPUTE RELATIVE OFFSET
        LDA     TEMP
        ADC     #2
        STA     TEMB+1
        LDA     TEMP+1
        ADC     #0
        STA     TEMB
        SEC
        LDA     EXP+1
        SBC     TEMB+1
        STA     EXP+1
        TAY
        LDA     EXP
        SBC     TEMB
        STA     EXP
        BNE     HRA20           ;CHECK FOR POSITIVE OUT OF RANGE
        TYA
        BMI     HRA30
HRA10:
        SEC
        RTS
HRA20:
        CMP     #255            ;CHECK FOR NEGATIVE OUT OF RANGE
        BNE     HRA30
        TYA
        BMI     HRA10
HRA30:
        CLC
        RTS
;FIND NEXT NON-BLANK
; IF FOUND THEN C=1 ELSE C=0
FNDNB:
        LDA     MAXCL           ;IF MAX >127
        BMI     J30             ;IS NO GOOD
        LDX     COLP            ;GET COL POINTER
J10:
        CPX     MAXCL           ;IF POINTER <= MAXCL
        BEQ     *+4             ;BRANCH IF EQUAL
        BCS     J30             ;BRANCH IF >
        LDA     LINE,X          ;GET CHAR
        CMP     #BLANK          ;IF A BLANK
        BEQ     *+6             ;THEN BRANCH
        STX     CSB             ;ELSE SAVE POINTER IN CSB
        SEC
        RTS
        INX                     ;BUMP POINTER
        STX     COLP
        BNE     J10             ;LOOP ALWAYS
;DID NOT FIND A NON-BLANK
J30:
        CLC                     ;WAS ALL BLANKS
        RTS
;FIND END OF CURRENT STRING
;  IF FOUND THEN C=1 ELSE C=0
FNDEN:
        LDY     #0
        STY     CSL
        LDX     COLP            ;GET POINTER
I10:
        CPX     MAXCL           ;TEST AGAINST MAX
        BEQ     *+4             ;BRANCH IF OK
        BCS     I30             ;BRANCH IF TOO BIG
        LDA     LINE,X          ;GET CHAR
        CMP     #BLANK          ;IF A BLANK
        BEQ     I20             ;THEN BRANCH
        CMP     #'='            ;IF AN =
        BEQ     I20             ;THEN BRANCH
        CMP     #SEMICO         ;IF NOT A SEMI
        BNE     I40             ;THEN BRANCH
I20:
        CPY     #0              ;IS Y=0
        BNE     I60             ;BRANCH IF NOT
I25:
        DEX
        STX     CSE             ;UPDATE END OF STRING
        SEC
        RTS
I30:
        CPY     #0
        BEQ     I25
        CLC
        RTS
I40:
        CMP     #APOST          ;IS IT AN APOSTROPHE
        BNE     I60             ;BRANCH IF NOT
        INY                     ;ELSE BUMP TEMP
        CPY     #2              ;IF 2
        BNE     I60             ;CONTINUE ELSE
        LDY     #0              ;RESET TEMP
I60:
        INX                     ;BUMP POINTER
        INC     CSL
        BNE     I10             ;LOOP ALWAYS
;FIND NON-EMBEDDED COMMA OR RIGHT PAREN
; IF FOUND THEN C=1 ELSE C=0
FNCMP:
        LDX     COLP            ;GET POINTER
K40:
        CPX     MAXCL           ;COMPARE TO MAX
        BEQ     *+4
        BCS     K10             ;END OF LINE
        LDA     LINE,X          ;GET CHAR
        CMP     #APOST          ;IF NOT STRING START
        BNE     K20             ;BRANCH
K30:
        JSR     INCRP           ;SKIP OVER STRING
        STX     COLP
        BCS     K10
        LDA     LINE,X          ;GET NEW CHAR
        CMP     #APOST          ;IF NOT APOSTROPHE
        BNE     K30             ;THEN BRANCH
        INX
        STX     COLP            ;BUMP POINTER
        BNE     K40
K20:
        LDA     LINE,X          ;GET CHAR
        CMP     #BLANK          ;IF BLANK
        BEQ     K10             ;DONE
        CMP     #')'
        BEQ     K15
        CMP     #','
        BEQ     K15
        INX
        STX     COLP            ;BUMP POINTER
        BNE     K40
K10:
        CLC                     ;ERROR
K15:
        RTS
;TEST A CHAR TO SEE IF ALPHANUMERIC
; IF ALPHANUMERIC THEN C=1 ELSE C=0
ALNUM:
        JSR     ALPH
        BCC     NUMRC
        RTS
;TEST A CHAR TO SEE IF ALPHA
; IF ALPHA THEN C=1 ELSE C=0
ALPH:
        LDA     LINE,X          ;GET CHAR
        CMP     #'A'            ;IF LESS THAN A
        BCC     *+7             ;NOT ALPHA
        CMP     #'Z'+1          ;IF LESS THAN Z+1
        BCC     *+4             ;IS ALPHA
        CLC                     ;NOT ALPHA
        RTS
        SEC                     ;ALPHA
        RTS
;TEST A CHAR TO SEE IF NUMBER
; IF NUMBER THEN C=1 ELSE C=0
NUMRC:
        LDA     LINE,X          ;GET CHAR
        CMP     #'0'            ;IF LESS THAN 0
        BCC     *+7             ;NOT NUMBER
        CMP     #'9'+1          ;IF LESS THAN 9+1
        BCC     *+4             ;IS A NUMBER
        CLC                     ;NOT NUMBER
        RTS
        SEC                     ;NUMBER
        RTS
;CONSTRUCT A SYMBOL
; IF NON-ALPHA CHAR THEN C=0 ELSE C=1
CONSYM:
        LDY     #$FF            ;USE Y AS COUNTER
C10:
        INY                     ;BUMP Y
        CPY     SYMLEN          ;AND TEST
        BEQ     C15
        CPY     LEN             ;IF ALL CHAR IN SYMBOL
        BCS     C30             ;GO FILL BLANKS
        JSR     ALNUM
        BCS     C20
        CLC                     ;NON-ALPHANUMERIC
C15:
        RTS
C20:
        LDA     LINE,X          ;GET CHAR
        STA     SYM,Y
        INX                     ;BUMP POINTER
        BCS     C10
C30:
        LDA     #BLANK          ;FILL IN BLANKS
        STA     SYM,Y
        BCS     C10
;EVALUATE EXPRESSION
; ON EXIT ERCOL POINTS TO BAD CHAR IF ANY
;         X POINTS TO NEXT CHAR IF GOOD EXPR
;         RETURN IS SET AS FOLLOWS
;          -1 IF OK AND EXP IS SET TO VALUE
;           0 IF UNDEFINED SYMBOL
;           1 IF UNINTERPRETABLE
EVAL:
        LDA     #0              ;INITIALIZE
        STA     EXP
        STA     EXP+1
        LDA     #1
        STA     RETURN
        LDA     #%11111110      ;SET SIGN TO PLUS
        AND     FLAGS+1
        STA     FLAGS+1
        STX     ERCOL
        STX     J
        JSR     ENDTST          ;IF MORE
        BCC     *+3             ;CONTINUE
        RTS
;GET INITIAL OPERATION
        LDY     #'+'            ;SET TO PLUS
        CMP     #'-'            ;IF NOT MINUS
        BNE     D15             ;OK
        TAY                     ;SET TO MINUS
D11A:
        JSR     INCRP           ;POINT TO NEXT CHAR
        BCC     D15
        RTS
D15:
        STY     OP              ;SAVE OPER
        STX     ERCOL
        LDA     #0              ;INITIALIZE
        STA     LOW             ;FLAGS
        STA     HIGH
        JSR     ENDTST          ;IF MORE
        BCC     *+3             ;CONTINUE
        RTS
        CMP     #'<'            ;IF NOT <
        BNE     D150
        INC     LOW             ;ELSE BUMP LOW
        BNE     D151
D150:
        CMP     #'>'            ;IF NOT >
        BNE     D158
        INC     HIGH
D151:
        JSR     INCRP
        BCC     D158
        RTS
D158:
        STX     ERCOL
        JSR     NUMRC           ;IS CHAR A NUMBER
        BCC     *+7             ;NO - NOT BASE 10
        LDY     #10             ;IS BASE 10
        JMP     D55             ;GET CHAR AND EVAL
        CMP     #'$'            ;IS CHAR A $
        BNE     *+7             ;NO - NOT HEX
        LDY     #16             ;ELSE IS HEX
        JMP     D50             ;GO EVALUATE
        CMP     #'@'            ;IS CHAR A @
        BNE     *+7             ;NO - NOT OCTAL
        LDY     #8              ;ELSE IS OCTAL
        JMP     D50             ;GO EVALUATE
        CMP     #'%'            ;IS CHAR A %
        BNE     *+7             ;NO - NOT BASE 2
        LDY     #2              ;ELSE IS BINARY
        JMP     D50             ;GO EVALUATE
        JSR     ALPH            ;IS IT ALPHA
        BCC     D46             ;NO CHECK FOR PC
;PROCESS A SYMBOL
        JSR     FNDLN           ;FIND LENGTH
        SEC                     ;DROP BY ONE
        SBC     #1
        CMP     SYMLEN          ;IF NOT TOO BIG
        BCC     D43             ;CONTINUE
        RTS
D43:
        JSR     CONSYM          ;CONSTRUCT SYMBOL
        JSR     FIND
        BCC     *+5
        JMP     D60
        BVS     *+5             ;BRANCH IF NOT DEFINED
        JSR     SETCHN          ;CREATE IT
        LDA     BYWOR           ;IF .BYT OR .WOR
        BNE     D44E            ;BRANCH
        LDA     ORG             ;IF EQU OR ORG
        BNE     D44E            ;BRANCH
        LDA     EXP+1           ;ERROR IF EXPR
        BNE     D452
        LDA     EXP
        BNE     D452
        LDA     OP              ;ERROR IF NOT +
        CMP     #'+'
        BNE     D44F
        STX     ERCOL
        DEX                     ;ERROR IF EXPR AFTER SYMBOL
        JSR     INCRP
        BCS     D44E
        JSR     ENDTST
        BCC     D452
D44E:
        JMP     D200
D44F:
        LDX     J
        STX     ERCOL
D452:
        RTS
;EVALUATE FIELD WITH PC (*)
D46:
        CMP     #'*'            ;IF NOT ASTERIX
        BNE     D47             ;CONTINUE
        LDA     PC              ;SAVE PC
        STA     VAL+1           ;IN
        LDA     PC+1            ;VALUE
        STA     VAL
        INX                     ;NEXT CHAR
        BNE     D60             ;DO OP
;GET A SINGLE CHAR
D47:
        CMP     #APOST          ;IF '
        BEQ     *+3             ;MAYBE OK
        RTS
        JSR     INCRP           ;NEXT POS
        BCC     *+3             ;NOT END
        RTS
        LDA     LINE,X          ;GET CHAR
        CMP     #APOST          ;SEE IF ANOTHER APOST
        BNE     D47A            ;BRANCH IF NOT
        JSR     INCRP           ;BUMP X
        BCS     STROPR          ;ERROR IF END
        LDA     LINE,X          ;NOW GET NEXT
        CMP     #APOST          ;SEE IF APOST AGAIN
        BNE     STROPR          ;BRANCH IF IS
D47A:
        STA     VAL+1           ;STORE
        LDA     #0              ;CLEAR
        STA     VAL             ;HIGH
        JSR     INCRP           ;NEXT
        BCS     D60
        LDA     LINE,X          ;GET CHAR
        CMP     #APOST          ;IF '
        BNE     STROPR
        JSR     INCRP
        BCS     D60
        LDA     LINE,X
        CMP     #APOST
        BNE     D60
STROPR:
        LDX     ERCOL
        RTS
        INX                     ;NEXT POS
        BNE     D60             ;DO OPER
;EVALUATE NUMERIC FIELD
D50:
        JSR     INCRP           ;NEXT CHAR
        BCC     *+3             ;CONTINUE IF OK
        RTS
        STX     ERCOL
        JSR     ALNUM
        BCS     D55             ;IF NUMBER CONTINUE
        RTS
D55:
        STY     BASE            ;SAVE BASE
;GET LENGTH
        JSR     FNDLN           ;POINT TO NEXT
;COMPUTE VALUE
        JSR     NUMBER          ;COMPUTE
        BCS     D60             ;CONTINUE IF OK
        RTS
;DO OPER
D60:
        LDA     LOW             ;LOW ONLY?
        BEQ     D68             ;NO SO JUNP
        LDA     #0              ;IS OW ONLY SO CLEAR HIGH
        STA     VAL
        BEQ     D69
D68:
        LDA     HIGH            ;HIGH ONLY?
        BEQ     D69             ;NO
        LDA     VAL             ;IS SO PUT HIGH
        STA     VAL+1           ;IN LOW
        LDA     #0              ;CLEAR HIGH
        STA     VAL
D69:
        LDA     OP              ;GET OPER
        CMP     #'+'            ;IF NOT ADD
        BNE     D65             ;BRANCH
;ADD OPERATION
        LDA     EXP+1           ;GET LOW
        CLC                     ;ADD
        ADC     VAL+1           ;LOW OF NUMBER
        STA     EXP+1           ;SAVE
        LDA     EXP             ;THEN DO
        ADC     VAL             ;SAME FOR
        STA     EXP             ;HIGH
        LDA     #0              ;PUT CARRY
        ROL     A               ;IN A
        TAY                     ;THEN Y
        JSR     CMPSGN          ;COMPARE SIGNS
        BNE     D62             ;BRANCH IF DIFFERENT
        TYA                     ;IF CARRY
        BNE     D61             ;THEN OVERFLOW
        JMP     D70             ;ELSE CONTINUE
D61:
        LDA     #8              ;GET OVERFLOW MASK
        ORA     FLAGS+1         ;SET FLAG
        STA     FLAGS+1         ;SAVE
        JMP     D70             ;CONTINUE
D62:
        TYA                     ;CHECK CARRY
        BEQ     D63             ;IF NONE IS NEG
        LDA     #254            ;GET POS MASK
        AND     FLAGS+1         ;SET
        STA     FLAGS+1         ;SAVE
        JMP     D70
D63:
        LDA     #1              ;NEGATIVE MASK
        ORA     FLAGS+1         ;SET SIGN
        STA     FLAGS+1         ;SAVE
        JMP     D70             ;CONTINUE
D65:
        CMP     #'-'            ;IF NOT -
        BNE     TRYMUL          ;TRY MULT
;SUBTRACT OPERATION SECTION
        LDA     EXP+1           ;GET LOW
        SEC                     ;SUBTRACT
        SBC     VAL+1           ;NUMBER
        STA     EXP+1           ;SAVE
        LDA     EXP             ;DO
        SBC     VAL             ;SAME
        STA     EXP             ;FOR HIGH
        LDA     #0              ;SAVE
        ROL     A               ;CARRY
        TAY
        JSR     CMPSGN          ;COMPARE SIGNS
        BNE     D67             ;BRANCH IF DIFFERENT
        TYA                     ;GET CARRY
        BEQ     D66             ;IF NONE BRANCH
        LDA     #254            ;SET POS
        AND     FLAGS+1         ;MASK
        STA     FLAGS+1         ;FOR EXPR
        JMP     D70             ;CONTINUE
D66:
        LDA     #1              ;SET NEG
        ORA     FLAGS+1         ;MASK
        STA     FLAGS+1         ;FOR EXPR
        JMP     D70             ;CONTINUE
D67:
        STY     TEMP            ;SAVE CARRY
        LDA     #1              ;GET EXP
        AND     FLAGS+1         ;SIGN
        EOR     TEMP            ;COMPARE TO CARRY
        BNE     *+5             ;BRANCH IF NOT EQUAL
        JMP     D70             ;ELSE CONTINUE
        LDA     #8              ;LOAD
        ORA     FLAGS+1         ;OVERFLOW MASK
        STA     FLAGS+1         ;FOR EXP
        JMP     D70
TRYMUL:
        CMP     #'*'            ;IF NOT MULT
        BNE     TRYDIV          ;TRY DIVISION
;MULTIPLICATION OPERATION
        LDA     #0              ;CLEAR
        STA     ACC+1           ;ACCUM
        STA     ACC
        JSR     SMEXP           ;MAKE EXP SIGN/MAGN
        JSR     SMVAL           ;SAME FOR VAL
        TXA                     ;SAVE
        PHA                     ;CURRENT INDEX
        LDX     #16             ;DO 16 BITS
MULLPE:
        LSR     VAL             ;SHIFT MULT
        ROR     VAL+1           ;RIGHT
        BCC     NOADD           ;IF ZERO NO ADD
        CLC                     ;ELSE
        LDA     ACC+1           ;GET ACCUM
        ADC     EXP+1           ;ADD EXP
        STA     ACC+1           ;SAVE
        LDA     ACC             ;SAME
        ADC     EXP             ;FOR
        STA     ACC             ;HIGH
NOADD:
        ASL     EXP+1           ;MULT EXP
        ROL     EXP             ;BY TWO
        DEX                     ;COUNT DOWN
        BNE     MULLPE          ;LOOP IF MORE
        PLA                     ;RESTORE
        TAX                     ;X
ENDMUL:
        LDA     ACC+1           ;SET
        STA     EXP+1           ;EXP
        LDA     ACC             ;TO ACCUM
        STA     EXP             ;VALUE
        JSR     CMPSGN          ;COMPARE SIGNS
        BNE     EXPNEG          ;NEGATIVE
        LDA     #254            ;ELSE
        AND     FLAGS+1         ;POSITIVE
        STA     FLAGS+1         ;RESULT
        JMP     D70
EXPNEG:
        LDA     #1              ;SET SIGN
        ORA     FLAGS+1         ;TO NEG
        STA     FLAGS+1         ;IN FLAGS
        JSR     TCPEXP          ;MAKE TWOS COMPL
        JMP     D70             ;CONTINUE
TRYDIV:
        CMP     #'/'            ;IF NOT DIV
        BEQ     DODIV           ;ERROR ELSE OK
        LDX     J
        STX     ERCOL
        RTS
;DIVISION OPERATION
DODIV:
        LDA     #0              ;CLEAR
        STA     ACC+1           ;ACCUM
        STA     ACC
        JSR     SMEXP           ;CONVERT
        JSR     SMVAL           ;TO SIGN/MAGN
        LDA     VAL+1           ;IF DIVISOR
        ORA     VAL             ;NOT ZERO
        BNE     DIVLPE          ;THEN OK
        LDX     J
        STX     ERCOL
        RTS
DIVLPE:
        SEC                     ;SUBTRACT
        LDA     EXP+1           ;VAL
        SBC     VAL+1           ;FROM EXP
        STA     EXP+1           ;UNTIL
        LDA     EXP             ;A
        SBC     VAL             ;BORROW
        STA     EXP
        BCC     ENDMUL          ;THEN DONE
        INC     ACC+1           ;BUMP LOW
        BNE     DIVLPE          ;LOOP IF NO CARRY
        INC     ACC             ;ELSE BUMP HIGH
        BNE     DIVLPE          ;LOOP ALWAYS
;END OPER
D70:
        CPX     MAXCL           ;SEE IF END
        BEQ     D71             ;NO
        BPL     D100            ;YES DONE
D71:
        JSR     ENDTST          ;AT END OF EXPR
        BCS     D100            ;YES BUT BAD
        LDY     LINE,X          ;GET OP
        STX     J
        JMP     D11A            ;START OVER
;EXITS
D100:
        LDA     #255            ;GOOD
        STA     RETURN          ;RETURN
        RTS
D200:
        LDA     #0              ;UNDEFINED
        STA     RETURN          ;SYMBOL
        RTS
;FINDS LENGTH OF FIELD
; LOOPS UNTIL NON-ALPHANUMERIC FOUND
; ERCOL MUST = X
; RESULT IN LEN
FNDLN:
        JSR     INCRP           ;BUMP POINTER
        BCS     HLN220
        JSR     ALNUM
        BCS     FNDLN
HLN220:
        TXA                     ;GET ENDING
        SEC                     ;SUBTRACT
        SBC     ERCOL           ;START
        STA     LEN             ;SAVE ANSWER
        LDX     ERCOL
        RTS
;COMPARE SIGNS OF EXP AND VAL
CMPSGN:
        LDA     #1              ;GET SIGN
        AND     FLAGS+1         ;OF EXP
        ASL     A               ;MOVE TO VAL POS
        STA     TEMP            ;SAVE
        LDA     #2              ;GET SIGN
        AND     FLAGS+1         ;OF VAL
        EOR     TEMP            ;SEE IF DIFFERENT
        RTS
;CONVERT EXP TO SIGN/MAGN
SMEXP:
        LDA     #1              ;GET
        AND     FLAGS+1         ;SIGN
        BEQ     SM1             ;DONE IF
;CONVERT EXPR
TCPEXP:
        CLC                     ;ELSE DO
        LDA     EXP+1           ;A
        EOR     #$FF            ;TWO'S
        ADC     #1              ;COMPLEMENT
        STA     EXP+1
        LDA     EXP
        EOR     #$FF
        ADC     #0
        STA     EXP
SM1:
        RTS
;CONVERT VAL TO SIGN/MAGN
SMVAL:
        LDA     #2              ;GET
        AND     FLAGS+1         ;SIGN
        BEQ     SM1             ;DONE IF +
        CLC                     ;ELSE DO
        LDA     VAL+1           ;A
        EOR     #$FF            ;TWO'S
        ADC     #1              ;COMPLEMENT
        STA     VAL+1
        LDA     VAL
        EOR     #$FF
        ADC     #0
        STA     VAL
        RTS
;TEST FOR END OF STRING
; IF FOUND THEN C=1 ELSE C=0
ENDTST:
        LDA     LINE,X          ;GET CHAR
        CMP     #BLANK          ;IF BLANK
        BEQ     DD10            ;SET CARRY
        CMP     #','            ;IF COMMA
        BEQ     DD10            ;SET CARRY
        CMP     #')'            ;IF RIGHT PAREN
        BEQ     DD10            ;SET CARRY
        CMP     #SEMICO         ;IF SEMI
        BEQ     DD10            ;SET CARRY
        CLC                     ;ELSE CLEAR
DD10:
        RTS
;CONVERT INPUT STRING TO NUMBER
; IF OK THEN C=1 ELSE C=0
NUMBER:
        LDA     #0              ;CLEAR
        STA     VAL             ;VALUE
        STA     VAL+1
E10:
        LDA     LINE,X          ;GET CHAR
        JSR     NUMRC           ;IF NOT NUMBER
        BCC     E20             ;THEN BRANCH
        AND     #$F             ;REMOVE ZONE
        BPL     E30             ;JUMP
E20:
        JSR     ALPH            ;IF NOT ALPHA
        BCC     E40             ;IS ERROR
        SEC
        SBC     #$37            ;REMOVE ZONE
E30:
        CMP     BASE            ;IS BASE VALID
        BCC     E50             ;YES
E40:
        CLC                     ;ELSE BAD BASE
        RTS
E50:
        STA     COLCNT
        TXA
        PHA
        LDY     BASE            ;GET BASE
        CPY     #2              ;IS IT 2
        BNE     E60             ;NO
        LDX     #1              ;SHIFT ONE
        BNE     E90
E60:
        CPY     #8              ;IS IT 8
        BNE     E70             ;NO
        LDX     #3              ;SHIFT THREE
        BNE     E90
E70:
        CPY     #16             ;IS IT 16
        BNE     E80             ;NO
        LDX     #4              ;SHIFT FOUR
        BNE     E90
E80:
        CPY     #10             ;IF NOT 10
        BNE     E40             ;IS INVALID
        LDA     VAL             ;SAVE
        STA     TEMP            ;VAL
        LDA     VAL+1
        STA     TEMP+1
        LDX     #3              ;10 MEANS 3 SHIFTS + 1 SHIFT
E90:
        ASL     VAL+1           ;SHIFT
        ROL     VAL             ;LEFT
        BCC     E100            ;BRANCH IF NO CARRY
        LDA     FLAGS+1         ;ELSE OVERFLOW
        ORA     #8
        STA     FLAGS+1
E100:
        DEX                     ;COUNT DOWN
        BNE     E90             ;LOOP IF MORE
        CPY     #10             ;IF NOT BASE 10
        BNE     E120            ;DONE
        ASL     TEMP+1          ;MUST DO ANOTHER
        ROL     TEMP
        BCC     E115            ;IF CLEAR OK
        LDA     FLAGS+1         ;ELSE SET
        ORA     #8              ;OVERFLOW
        STA     FLAGS+1
E115:
        LDA     VAL+1           ;ADD PARTS
        CLC
        ADC     TEMP+1
        STA     VAL+1
        LDA     VAL
        ADC     TEMP
        STA     VAL
        BCC     E120            ;NO OVERFLOW
        LDA     FLAGS+1
        ORA     #8              ;SET OVERFLOW
        STA     FLAGS+1
E120:
        LDA     COLCNT          ;GET FIRST
        CLC                     ;ADD
        ADC     VAL+1           ;TO VAL
        STA     VAL+1
        LDA     VAL
        ADC     #0
        STA     VAL
        BCC     E130
        LDA     FLAGS+1         ;SET
        ORA     #8              ;OVERFLOW
        STA     FLAGS+1
E130:
        PLA
        TAX
        INX                     ;BUMP POINTER
        DEC     LEN             ;DROP COUNT
        BEQ     E140
        JMP     E10             ;LOOP FOR MORE
E140:
        SEC
        RTS
;SEARCH SYMBOL TABLE
; IF FOUND AND DEFINED THEN C=1 AND V=0
; IF FOUND AND NOT DEFINED THEN C=0 AND V=1
; IF NOT FOUND THEN C=0 AND V=0
; SYMTBL CONTAINS NEXT AVAILABLE ADDRESS
FIND:
        LDA     STSAVE          ;GET START
        STA     SYMTBL          ;SET POINTER
        LDA     STSAVE+1
        STA     SYMTBL+1
        LDA     #1
        STA     SYMPTR+1
        LDA     #0
        STA     SYMPTR
G10:
        CLV
        LDA     SYMPTR
        CMP     NOSYM
        BCC     G20
        BNE     G50
        LDA     SYMPTR+1
        CMP     NOSYM+1
        BEQ     G20
        BCS     G50
G20:
        LDY     SYMLEN          ;GET LENGTH
        DEY                     ;DROP BY ONE
G30:
        LDA     (SYMTBL),Y
        BPL     G32
        AND     #$7F
        BIT     KLUDG           ;SET V
G32:
        CMP     SYM,Y
        BNE     G70
        DEY
        BPL     G30
        LDY     SYMLEN
        LDA     (SYMTBL),Y
        STA     VAL
        INY
        LDA     (SYMTBL),Y
        STA     VAL+1
        BVS     G50
        RTS
G50:
        CLC                     ;NO MATCH
        RTS
;TRY NEXT SYMBOL
G70:
        LDA     SYMTBL          ;GET LOW ADDR
        CLC                     ;ADD LENGTH
        ADC     SYMLEN
        STA     SYMTBL
        BCC     G751
        INC     SYMTBL+1
G751:
        CLC                     ;ADD TWO
        LDA     SYMTBL
        ADC     #2
        STA     SYMTBL
        BCC     G75             ;SKIP IF NO CARRY
        INC     SYMTBL+1
G75:
        INC     SYMPTR+1
        BNE     G10
        INC     SYMPTR
        JMP     G10
;CREATE UNDEFINED SYMBOL
SETCHN:
        LDA     #$FF            ;SET
        STA     VAL             ;NULL
        STA     VAL+1           ;VALUE
        LDA     SYM             ;SET
        ORA     #$80            ;UNDEFINED
        STA     SYM             ;FLAG
;INSERT A NEW SYMBOL INTO TABLE
;IF V=1 JUST UPDATE ENTRY WITH NEW VALUES
;IF V=0 THEN CREATE NEW ENTRY BY BUMPING NOSYM
INSERT:
        LDA     SYMTBL+1
        CMP     TBLSZ+1
        BCC     G105
        BNE     G110
        LDA     SYMTBL
        CMP     TBLSZ
        BCS     G110
G105:
        LDY     SYMLEN          ;PUT SYMBOL AND VALUE IN TABLE
        DEY                     ;DROP BY ONE
G100:
        LDA     SYM,Y           ;GET CHAR
        STA     (SYMTBL),Y      ;INSERT
        DEY                     ;NEXT CHAR
        BPL     G100            ;LOOP IF MORE
        LDY     SYMLEN
        LDA     VAL
        STA     (SYMTBL),Y
        LDA     VAL+1
        INY
        STA     (SYMTBL),Y
        BVS     G104            ;ONLY DEFINING UNDEFINED
        INC     NOSYM+1
        BNE     G104
        INC     NOSYM
G104:
        RTS
G110:
        SEC
        RTS
;FILL LINE UNTIL LF OR EOF
; EXPAND TAB (CTL-I) DURING FILL
; CONVERT ALL NON-EMBEDDED ALPHA TO UPPERCASE
LINEIN:
        LDA     #0              ;CLEAR
        STA     MAXCL           ;INDEX
        STA     MAXECH          ;AND ECHO INDEX
        STA     STRING          ;AND CONVERT FLAG
GNC:
        JSR     GNX             ;GET NEXT BYTE
        LDX     MAXECH          ;GET ECHO INDEX
        STA     ECHBUF,X        ;SAVE IN ECHO BUFFER
        CMP     #APOST          ;SEE IF APOST
        BEQ     INSTR           ;IS SO START STRING
        CMP     #QUOTE          ;NOW CHECK FOR DOUBLE QUOTE
        BNE     NTS             ;ISN'T SO NOT STRING START OR END
INSTR:
        PHA                     ;SAVE CHAR
        LDA     STRING          ;ELSE GET FLAG
        EOR     #$FF            ;COMPLEMENT
        STA     STRING          ;AND SAVE
        PLA                     ;GET CHAR BACK
NTS:
        BIT     STRING          ;TEST FLAG
        BMI     NLCC            ;BRANCH IF SET
;NOT IN STRING SO COVERT LOWERCASE TO UPPERCASE
        CMP     #'A'            ;IF < A
        BCC     NLCC            ;DO NOTHING
        CMP     #'Z'+1          ;IF OVER Z
        BCS     NLCC            ;DO NOTHING
        AND     #$5F            ;ELSE MAKE UPPER
NLCC:
        LDX     MAXCL           ;GET INDEX
        STA     LINE,X          ;SAVE CHAR
        CMP     #TAB            ;IF NOT TAB
        BNE     NTT             ;BRANCH
        INC     MAXECH          ;BUMP ECHO POINTER
;EXPAND TAB
CTB:
        LDA     #BLANK          ;GET BLANK
        STA     LINE,X          ;STORE
        INC     MAXCL           ;BUMP INDEX
        LDX     MAXCL           ;GET INDEX
        CPX     #LINESZ+1       ;IF TOO BIG
        BCS     ER23            ;IS ERROR
        TXA                     ;IF INDEX
        AND     #7              ;NOT MOD 8
        BNE     CTB             ;EXPAND
        BEQ     GNC             ;ELSE NEXT CHAR
;NOT A TAB
NTT:
        CMP     #EOF            ;IF AN EOF
        BEQ     EXT             ;DONE
        CMP     #LF             ;IF LF
        BEQ     EXT             ;DONE
        INC     MAXECH          ;BUMP ECHO POINTER
        INC     MAXCL           ;NEXT
        LDA     MAXCL           ;GET INDEX
        CMP     #LINESZ+2       ;IF NOT TOO BIG
        BCC     GNC             ;GET NEXT
;LINE TOO LONG
ER23:
        LDA     #CR             ;SET
        STA     LINE+LINESZ
        STA     ECHBUF+LINESZ   ;BUFFER END
        LDA     #LF             ;END
        STA     LINE+LINESZ+1
        STA     ECHBUF+LINESZ+1 ;FOR BOTH
        SEC                     ;ERROR
RDE:
        RTS
;NORMAL
EXT:
        CLC
        RTS
;GET NEXT SOURCE CHAR
GNX:
        LDA     SRCIND          ;IF INDEX
        CMP     #<(SRCBUF+SRCLNG);IS LESS
        LDA     SRCIND+1        ;THAN
        SBC     #>(SRCBUF+SRCLNG);MAXIMUM
        BCC     BUFULL          ;USE IT
        JSR     CLSIND          ;ELSE SET TO START
        LDA     #SRCLNG/128     ;SET NUMBER
        STA     RDSCCN          ;RECORDS
RDESLP:
        LDA     SRCIND          ;GET BUFFER
        LDY     SRCIND+1        ;START
        JSR     SETBUF          ;SET IT
        JSR     SSRFCB          ;POINT TO FCB
        JSR     RDERCR          ;READ RECORD
        BEQ     RDESOK          ;BRANCH IF OK
        CMP     #1              ;IF A ONE
        BEQ     *+5             ;IS JUST EOF
        JMP     DOSERR          ;ELSE IS ERROR
        LDY     #0              ;CLEAR INDEX
        LDA     #EOF            ;GET AN EOF
        STA     (SRCIND),Y      ;INSERT IT
        BNE     ENDRDE          ;AND EXIT
RDESOK:
        CLC                     ;ADD
        LDA     SRCIND          ;128
        ADC     #128            ;TO
        STA     SRCIND          ;SOURCE
        BCC     *+4             ;INDEX
        INC     SRCIND+1        ;THEN
        DEC     RDSCCN          ;DROP COUNT
        BNE     RDESLP          ;LOOP IF MORE
ENDRDE:
        JSR     CLSIND          ;SET INDEX TO START
BUFULL:
        LDY     #0              ;CLEAR INDEX
        LDA     (SRCIND),Y      ;GET CHAR
        AND     #$7F            ;MASK PARITY
        CMP     #EOF            ;IF NOT EOF
        BNE     *+3             ;GO BUMP INDEX
        RTS                     ;ELSE DONE
        INC     SRCIND          ;BUMP LOW
        BNE     *+4             ;THEN AS NEEDED
        INC     SRCIND+1        ;BUMP HIGH
        RTS
;SET SOURCE INDEX TO START
CLSIND:
        LDA     #<SRCBUF        ;GET
        LDY     #>SRCBUF        ;ADDRESS
        STA     SRCIND          ;AND
        STY     SRCIND+1        ;SET
        RTS
;SEARCH OPCODE TABLE FOR VALID CODE
; IF FOUND THEN C=1 ELSE C=0
OPFND:
        LDA     #<OPRNDS        ;GET LOW
        STA     OPRTBL          ;SAVE
        LDA     #>OPRNDS        ;THEN
        STA     OPRTBL+1        ;HIGH
        LDX     #0              ;CLEAR OPCODE NUMBER
G200:
        LDY     #2              ;OFFSET FOR COMPARE
G210:
        LDA     SYM,Y           ;GET CHAR
        CMP     (OPRTBL),Y      ;COMPARE
        BNE     G220            ;NO MATCH
        DEY                     ;NEXT CHAR
        BPL     G210            ;TRY NEXT
;FOUND VALID
        LDA     KTMPL,X         ;GET TEMPLATE
        STA     OPTEM           ;SAVE
        LDA     KCODE,X
        STA     OPBAS           ;SAVE
        RTS
;NO MATCH
G220:
        LDA     OPRTBL          ;GET LOW ADDR
        CLC                     ;POINT
        ADC     #3              ;TO
        STA     OPRTBL          ;NEXT
        BCC     *+4             ;OPCODE
        INC     OPRTBL+1        ;IN
        INX                     ;BUMP NUMBER
        CPX     #57             ;LOOKED AT ALL?
        BMI     G200            ;NO
        CLC                     ;NOT FOUND
        RTS
;MAKE AN ENTRY IN LENGTH TABLE
; X=COL WITH ERROR
; Y=LENGTH
; A=ERROR CODE
LTINS:
        STA     LTBL+4          ;SAVE ERROR
        STY     LTBL            ;SAVE LENGTH
        STX     LTBL+1          ;AND COL
        LDA     PC
        STA     LTBL+2          ;SAVE PC
        LDA     PC+1
        STA     LTBL+3
        TYA                     ;ADD
        CLC                     ;LENGTH
        ADC     PC              ;TO PC
        STA     PC
        BCC     *+4
        INC     PC+1
        LDA     LTBL+4          ;GET ERROR FLAG
        BNE     LTI             ;BRANCH IF ERROR
        LDA     #%00000100      ;TEST PRINT FLAG
        AND     FLAGS
        BEQ     *+5             ;NO PRINT
        JMP     PRTLN
        JMP     PRT170          ;GO DO KIM OUTPUT
LTI:
        STA     EROR
        SED
        CLC
        LDA     ERCT+1
        ADC     #1
        STA     ERCT+1
        LDA     ERCT
        ADC     #0
        STA     ERCT
        CLD
        LDA     BYWOR           ;GET BYTE/WORD FLAG
        BNE     *+7             ;BRANCH IF SET
        LDA     #0              ;ELSE CLEAR
        STA     CODE            ;OPCODE
        LDA     #%00010100      ;CHECK FOR
        AND     FLAGS           ;ERROR PRINT
        BEQ     *+8             ;NO
        JSR     PRTLN
        JMP     ERRHND
        JMP     PRT170          ;GO DO KIM FILE
;PRINT THE SYMBOL TABLE
;PRINTS ONE SYMBOL PER LINE
NSTAT:
        LDA     STSAVE          ;POINT TO START
        STA     SYMTBL
        LDA     STSAVE+1
        STA     SYMTBL+1
        LDA     #1              ;START AT BEGINNING
        STA     SYMPTR+1
        LDA     #0
        STA     SYMPTR
R20:
        CLV
        LDA     SYMPTR
        CMP     NOSYM
        BEQ     R30
        BCC     R42
R25:
        RTS
R30:
        LDA     SYMPTR+1
        CMP     NOSYM+1
        BEQ     R42
        BCS     R25
R42:
        JSR     OUTCL1
        LDY     #0              ;SYMBOL AND VALUE (* IF UNDEF)
R43A:
        LDA     (SYMTBL),Y
        BPL     R43B
        AND     #$7F
        BIT     KLUDG           ;SET V
R43B:
        JSR     OUTPUT
        INY
        CPY     SYMLEN          ;COMPARE TO LENGTH
        BNE     R43A
        JSR     OUTCL2
        BVC     R43C
        LDY     #4
        JSR     PRAST
        BEQ     R43D
R43C:
        LDA     (SYMTBL),Y
        JSR     NUMA
        INY
        LDA     (SYMTBL),Y
        JSR     NUMA
R43D:
        JSR     CRLF
        CLC
        LDA     SYMTBL          ;ADD LENGTH
        ADC     SYMLEN          ;TO TABLE POINTER
        STA     SYMTBL
        BCC     R431
        INC     SYMTBL+1
R431:
        CLC                     ;ADD TWO
        LDA     SYMTBL
        ADC     #2
        STA     SYMTBL
        BCC     R432            ;SKIP IF NO CARRY
        INC     SYMTBL+1
R432:
        INC     SYMPTR+1
        BNE     R20
        INC     SYMPTR
        JMP     R20
;PRINT NUMBER * IN Y
PRAST:
        LDA     #'*'            ;GET *
        JSR     OUTCNT
        DEY
        BNE     PRAST
        RTS
;END OF ASSEMBLY CODE (.END)
H10:
        LDX     #0
        TXA
        TAY
        JSR     LTINS
        BIT     PASNUM          ;TEST PASS NUMBER
        BPL     H10X            ;SKIP IF FIRST
        JSR     CR2
        LDA     #$40
        AND     FLAGS
        BEQ     MNOS
        JSR     CR2
        JSR     SORT            ;DO FINAL SORT
        JSR     NSTAT
        JSR     CRLF            ;AND A LAST CR AND LF
MNOS:
        LDA     #<ENDMSG        ;POINT TO
        LDY     #>ENDMSG        ;END MESSAGE
        JSR     WRCNMS          ;PRINT IT
        JSR     CCRLF
H10X:
        LDX     #$FB
        TXS
        SEC
        RTS
;PRINT OUTPUT LINE
PRTLN:
        LDA     #<CODE
        STA     CDEPTR
        LDA     #>CODE
        STA     CDEPTR+1
        LDA     LTBL+2
        STA     PC
        LDA     LTBL+3
        STA     PC+1
        LDA     LTBL
PRT10:
        PHA
        LDA     #0
        STA     COLCNT
        JSR     OUTCL1
        LDA     PC+1
        JSR     NUMC2
        LDA     PC
        JSR     NUMC2
        JSR     OUTCL1          ;SEND A BLANK
        PLA
        BNE     PRT20           ;OK IF NOT ZERO
        PHA                     ;SAVE ZERO AGAIN
        LDA     LCDPT           ;GET MULT LINES FLAG
        BNE     PRT140          ;BRANCH IF SET
        JSR     OUTTB           ;SEND TAB
        JSR     OUTTB           ;AND ANOTHER
        JMP     PRT130          ;GO ECHO LINE
;WAS SOMETHING TO PRINT
PRT20:
        TAX
        CMP     #4
        BCC     PRT40
        LDX     #3
        SEC
        SBC     #3
        JMP     PRT50
PRT40:
        LDA     #0
PRT50:
        PHA
PRT60:
        DEX
        BMI     PRT100
        LDY     #0
        LDA     (CDEPTR),Y
PRT70:
        JSR     NUMC2
PRT80:
        JSR     OUTCL1
        INC     PC
        BNE     *+4
        INC     PC+1
        INC     CDEPTR
        BNE     PRT60
        INC     CDEPTR+1
        BNE     PRT60
PRT100:
        LDA     LCDPT
        BNE     PRT140
        LDX     MAXCL
        BMI     PRT140
        JSR     OUTTB           ;SEND A TAB
PRT130:
        JSR     ECHOPR          ;NOW DO LINE
PRT140:
        JSR     CRLF
        INC     LCDPT
        PLA
        BEQ     PRT170
        TAX
        LDA     #128
        AND     FLAGS
        BNE     PRT160
        TXA
        JMP     PRT10
PRT160:
        CLC
        TXA
        ADC     PC
        STA     PC
        BCC     PRT170
        INC     PC+1
PRT170:
        BIT     PASNUM
        BPL     EXTKIM          ;EXIT IF FIRST PASS
        LDA     LTBL
        BEQ     EXTKIM          ;OR IF NO OUTPUT
        STA     KIMCNT
        LDA     FLAGS           ;GET FLAG
        AND     #%00100000      ;ISOLATE KIM BIT
        BEQ     EXTKIM          ;EXIT IF KIM DISABLED
        BIT     NKMFLG          ;SEE IF COMMAND LINE Z
        BPL     *+3             ;IT WASN'T SO CONTINUE
EXTKIM:
        RTS                     ;ELSE DONE
;FOLLOWING CODE ACTUALLY DOES KIM OUTPUT
        LDA     BYTCNT
        BNE     NONEW
NWKIM:
        LDA     LTBL+2          ;INITIALIZE PROGRAM COUNTER
        STA     FRSTPC+1
        STA     CURNPC+1
        LDA     LTBL+3
        STA     FRSTPC
        STA     CURNPC
NONEW:
        LDA     LTBL+2
        CMP     CURNPC+1
        BEQ     *+8
W0:
        JSR     WRKMRC
        JMP     NWKIM
        LDA     LTBL+3
        CMP     CURNPC
        BNE     W0
        LDY     #0
W1:
        LDX     BYTCNT
KFL:
        LDA     CODE,Y
        STA     KIMREC,X
        INC     CURNPC+1
        BNE     *+4
        INC     CURNPC
        INY
        INX
        STX     BYTCNT
        DEC     KIMCNT
        BNE     *+7
        CPX     #BYTSRC
        BEQ     WRKMRC
        RTS
        CPX     #BYTSRC
        BNE     KFL
        TYA
        PHA
        JSR     WRKMRC
        PLA
        TAY
        LDA     CURNPC+1
        STA     FRSTPC+1
        LDA     CURNPC
        STA     FRSTPC
        JMP     W1
;WRITE KIM RECORD
WRKMRC:
        LDA     #0              ;CLEAR CHECKSUM
        STA     CHKSUM+1
        STA     CHKSUM
        LDA     BYTCNT          ;GET BYTE COUNT
        BNE     *+3
        RTS                     ;DONE IF ZERO
;START OUTPUT WITH SEMICOLON
        LDA     #SEMICO
        JSR     KIMOUT
        LDA     BYTCNT
        JSR     ADDCK           ;ADD COUNT TO CHECKSUM
        JSR     KIMBYT
        LDA     BYTCNT          ;ADJUST TO GET ADDRESS
        CLC
        ADC     #2
        STA     BYTCNT
        LDA     #1
        STA     KINDEX
WRK1:
        LDX     KINDEX
        LDA     BYTCNT,X
        JSR     ADDCK           ;ADD TO CHECKSUM
        JSR     KIMBYT
        INC     KINDEX
        DEC     BYTCNT
        BNE     WRK1
        LDA     CHKSUM          ;SEND HIGH
        JSR     KIMBYT          ;CHECKSUM
        LDA     CHKSUM+1        ;THEN
        JSR     KIMBYT          ;LOW PART
        LDA     #CR
        JSR     KIMOUT
        LDA     #LF
        JMP     KIMOUT
;ADD BYTE IN A TO CHECKSUM AND SAVE A
ADDCK:
        PHA                     ;SAVE BYTE
        CLC                     ;NOW DO ADD
        ADC     CHKSUM+1
        STA     CHKSUM+1
        BCC     ADDCKX          ;DONE IF NO CARRY
        INC     CHKSUM          ;ELSE BUMP HIGH
ADDCKX:
        PLA                     ;GET INPUT BYTE
        RTS
;PRINT LINE AS IN BUFFER
ECHOPR:
        LDX     #$FF
        DEC     MAXECH          ;DROP LIMIT
ECH10:
        INX                     ;BUMP INDEX
        CPX     MAXECH          ;COMPARE TO MAX
        BCS     ECH20
        LDA     ECHBUF,X        ;GET CHAR
        JSR     OUTPUT          ;SEND
        JMP     ECH10           ;AND LOOP
ECH20:
        RTS
;PRINT ERROR MESSAGE AND POINTER
ERRHND:
        BIT     PASNUM          ;TEST PASS NUMBER
        BMI     ERH01           ;CONTINUE IF SECOND
        RTS                     ;ELSE DONE
ERH01:
        LDA     #<ERRMSG        ;POINT TO
        LDY     #>ERRMSG        ;ERROR MESSAGE
        JSR     WRLSMS          ;WRITE IT
        JSR     OUTTB           ;SEND A TAB
        LDX     LTBL+1          ;GET ERROR COLUMN
ERH10:
        DEX
        BMI     ERH20
        JSR     OUTCL1
        JMP     ERH10
ERH20:
        LDA     #'^'
        JSR     OUTPUT
        JSR     CRLF
        LDA     EROR            ;GET ERROR NUMBER
        ASL     A               ;MULT BY TWO
        TAX                     ;MAKE INTO INDEX
        LDA     ERRVEC,X        ;GET LOW
        LDY     ERRVEC+1,X      ;AND HIGH ADDRESS
        JSR     WRLSMS          ;WRITE MESSAGE
        JMP     CRLF            ;AND CR LF
;PRINT BYTE AND ADJUST COLUMN COUNT
NUMC2:
        INC     COLCNT
        INC     COLCNT
        JMP     NUMA
;OUTPUT BLANKS AND ADJUST COUNT
OUTCL4:
        JSR     OUTCL1
        JSR     OUTCL1
OUTCL2:
        JSR     OUTCL1
OUTCL1:
        LDA     #BLANK
OUTCNT:
        INC     COLCNT
        JMP     OUTPUT
;SEND A TAB
OUTTB:
        LDA     #TAB            ;GET IT
        JMP     OUTPUT          ;AND SEND
;CR LF ROUTINES
CR4:
        JSR     CRLF
        JSR     CRLF
CR2:
        JSR     CRLF
        JMP     CRLF
;-------------------------------
;PROCESS A SINGLE LINE
;-------------------------------
PROCES:
        LDA     #0
        LDX     #13
        STA     FLAGS+1,X
        DEX
        BPL     *-3
        LDX     #LINESZ-5       ;CLEAR
        STA     CODE,X          ;ALL OF
        DEX                     ;CODE
        BPL     *-4             ;BUFFER
        JSR     LINEIN          ;GET THE INPUT LINE
        DEX
        DEX
        STX     MAXCL
        CMP     #EOF
        BNE     NTEOF           ;CONTINUE IF NOT EOF
        LDA     #CR             ;STUFF CR AND LF
        STA     ECHBUF
        LDA     #LF
        STA     ECHBUF+1
        LDX     #255            ;SET COLUMN TO -1
        STA     MAXCL
        LDX     #1
        STX     MAXECH          ;SET MAX ECHO COL TO 1
        JMP     H10
;NOT EOF SO PROCESS LINE
NTEOF:
        SED                     ;SET DECIMAL MODE
        LDA     LINENO+1        ;BUMP LINE NUMBER BY 1
        ADC     #1
        STA     LINENO+1
        LDA     LINENO
        ADC     #0
        STA     LINENO
        CLD                     ;BACK TO BINARY MODE
        JSR     FNDNB           ;GET FIRST NON-BLANK
        BCS     H88
;BLANK LINE SO IGNORE
HL0000:
        LDY     #0
HLY000:
        LDX     #0
        TXA
        JMP     LTS1
;THERE IS SOMETHING IN THE LINE OTHER THAN BLANKS
H88:
        JSR     NUMRC           ;SEE IF FIRST CHAR A NUMBER
        BCC     H88B            ;JUMP IF NOT
        JSR     INCRP           ;NUMBER SO GO TO NEXT CHAR
        STX     PARST           ;PREPARE TO USE
        STX     COLP
        BCS     HL0000          ;HIT EOL SO IGNORE LINE
        BCC     H88             ;NOT EOL SO LOOP UNTIL PAST NUMBER
;AT THIS POINT LINE NUMBER HAS BEEN IGNORED & WE ARE READY TO CONTINUE PARSING
;THIS IS ALSO MAIN LOOP ENTRY AFTER SUCCESSIVE FIELDS ARE EVALUATED
H88B:
        JSR     FNDNB           ;FIND NON-BLANK
        BCC     HL0000          ;NONE SO IGNORE BLANK LINE
H88A:
        LDA     LINE,X          ;GET THE CHARACTER
        CMP     #SEMICO         ;IF START OF COMMENT THEN ALSO IGNORE
        BEQ     HL0000
        JSR     FNDEN           ;FIND END OF CHARACTER SEQUENCE
        BCS     H1              ;JUMP IF FOUND
HL303B:
        LDA     #3              ;ELSE ERR03 - ILLEGAL OR MISSING OPCODE
HL3AAB:
        LDY     #3
HLYAAB:
        LDX     CSB
        JMP     LTS1
;HAVE FOUND A CHARACTER STRING - START TESTING IT
H1:
        LDX     CSB             ;GO BACK TO STRING START
        LDA     LINE,X          ;GET CHAR
        CMP     #'.'            ;SEE IF START OF DIRECTIVE
        BNE     *+5             ;IF NOT THEN JUMP
        JMP     H5              ;IF IS GO TO DIRECTIVE PROCESSING SECTION
        CMP     #'*'            ;SEE IF PC PROCESSING
        BNE     *+5             ;IF NOT THEN JUMP
        JMP     H102            ;IF IS PROCESS PC CHANGE
;AT THIS POINT WE EITHER HAVE A LABEL OR AN OPCODE BUT NEED TO CHECK LENGTH
        LDY     CSL             ;GET CHAR STRING LENGTH
        CPY     SYMLEN          ;COMPARE TO MAX
        BCC     H76             ;OK IS LESS
        BEQ     H76             ;OK IF SAME
;ERR09 - LABEL TOO LONG
        LDA     #9
HL3AAX:
        LDY     #3
        JMP     LTS1
;THERE IS A STRING THAT MAY BE LABEL OR OPCODE
H76:
        STY     LEN             ;SET LENGTH
        JSR     CONSYM          ;TRY TO CONSTRUCT SYMBOL
        BCS     H76OK           ;JUMP IF ALL ALPHA-NUMERIC
        LDA     #10             ;ELSE ERR10 - NON-ALPHANUMERIC
        BNE     HL3AAX
H76OK:
        LDA     CSL             ;SEE IF SYMBOL IS RIGHT LENGTH
        CMP     #3              ;FOR OPCODE
        BNE     CSLNT3          ;JUMP IF NOT
        JSR     OPFND           ;SEE IF OPCODE
        BCC     CSLNT3          ;NOT SO PROCESS AS LABEL
        JMP     H201            ;IS SO PROCESS OPCODE
;AT THIS POINT WE HAVE A STRING THAT LOOKS LIKE A LABEL
CSLNT3:
        LDA     LABL            ;FIRST SEE IF ALREADY A LABEL
        BNE     HL303B          ;ERR03 IF IS - ILLEGAL OPCODE
        INC     LABL            ;BUT NOW SAY THERE IS A LABEL
        LDX     COLP            ;POINT TO START
        JSR     ALPH            ;SEE IF ALPHA
        BCS     H94             ;OK IF IS
        LDA     #8              ;ELSE ERR08 - LABEL DOES NOT START WITH ALPHA
        BNE     HL3AAX
;LABEL STARTS WITH ALPHA
H94:
        LDA     SYM+1           ;SEE IF SINGLE CHARACTER LONG
        CMP     #BLANK          ;JUMP MORE THAN ONE CHAR
        BNE     H93
        LDA     SYM
        CMP     #'A'            ;TEST FOR ILLEGAL LABEL
        BEQ     H97             ;A IS ILLEGAL
        CMP     #'X'
        BEQ     H97             ;X IS ILLEGAL
        CMP     #'Y'
        BEQ     H97             ;Y IS ILLEGAL
        CMP     #'S'
        BEQ     H97             ;S IS ILLEGAL
        CMP     #'P'
        BNE     H93             ;NOT P SO LEGAL
;ERR20 - LABEL IS A RESERVED SINGLE CHARACTER
H97:
        LDA     #20
        JMP     HL3AAX
;LABEL IS NOT RESERVED AND IS NOT OPCODE
H93:
        STX     LSST
        LDX     #0
;PUSH SYMBOL AND THEN SYMBOL LENGTH ONTO STACK
H8845:
        LDA     SYM,X           ;GET CHAR
        PHA                     ;PUSH ONTO STACK
        INX                     ;BUMP POINTER
        CPX     SYMLEN          ;COMPARE TO MAX
        BNE     H8845           ;LOOP IF MORE
        LDA     CSL             ;NOW GET LENGTH
        PHA                     ;AND PUSH IT
        LDX     CSE             ;POINT TO END OF STRING
        INX                     ;AND GO ONE PAST
        STX     COLP            ;SAVE AS POINTER
        JSR     FNDNB           ;LOOK FOR NON BLANK
        BCC     H120            ;NONE FOUND
        LDA     LINE,X
        CMP     #'='
        BEQ     H121
H120:
        JSR     FIND            ;SEE IF EXITING LABEL
        BCC     H95             ;EITHER NOT FOUND OR NOT NOT DEFINED
;LABEL IS EXISTING LABEL AND IS DEFINED SO MAKE SURE IT IS NOT BEING CHANGED
        LDA     VAL             ;FIRST TEST HIGH
        CMP     PC+1
        BNE     MRO2            ;ERROR IF DIFFERENT
        LDA     VAL+1           ;NOW TEST LOW
        CMP     PC
        BEQ     H95A            ;OK IF SAME
;ERR02 - LABEL PREVIOUSLY DEFINED
MRO2:
        LDY     #3
        JMP     HLY02L
;AT THIS POINT WE HAVE A VALID LABEL SO CREATE OR UPDATE ENTRY
;V FLAG MUST NOT HAVE BEEN ALTERED SINCE JSR FIND WAS EXECUTED AT H120
;AS THAT FLAG DETERMINES IF INSERT CREATES NEW ENTRY OR JUST UPDATES
;VALUE OF EXISTING ENTRY
H95:
        LDA     PC+1            ;SET VAL TO CURRENT PC
        STA     VAL
        LDA     PC
        STA     VAL+1
        JSR     INSERT          ;DO INSERT OR UPDATE
H95A:
        LDX     CSB             ;TEST START OF STRING
        CPX     LSST            ;AGAINST LABEL START
        BEQ     *+5             ;IF SAME THEN DONE WITH LINE
        JMP     H88A            ;ELSE LOOP TO FIND NEXT FIELD
        JMP     HL0000
;PROCESS PC REFERENCE STATEMENT
H102:
        INC     ORG             ;SET FLAG TO SAY AN ORG IS IN LINE
        INC     COLP
        STX     LSST
        JSR     FNDNB           ;FIND NEXT NON BLANK
        BCS     H103            ;GOT ONE SO CONTINUE
        JMP     HL307B          ;ELSE ERR07 - RAN OFF LINE
H103:
        LDA     LINE,X          ;GET THAT NEXT CHAR
        CMP     #'='            ;SEE IF =
        BEQ     H121            ;IS SO OK
        LDA     #22             ;IF NOT IS ERR22 - EXPECTING = FOR ORG
        JMP     HL3AAX
;ENTRY POINT FOR NORMAL * = PROCESSING AS WELL AS <LABEL> = PROCESSING
H121:
        INC     ORG             ;MAKE SURE FLAG SET
        JSR     INCRP           ;BUMP POINTER
        STX     COLP            ;AND SAVE
        BCC     *+5             ;OK IF NOT EOL
        JMP     HL307B          ;ELSE ERR07 - RAN OFF LINE
        JSR     FNDNB           ;FIND A NON-BLANK
        BCS     H104            ;GOT ONE
        LDY     #0              ;ELSE ERR
        JMP     HLY07E
H104:
        JSR     EVAL
        LDA     RETURN
        BMI     H105
        BNE     H8806
        LDA     #11             ;ELSE ERR11 - FORWARD REFERENCE IN EQUATE OR ORG
        JMP     HL3AAJ
H8806:
        LDA     #13             ;ERR13 - INVALID EXPRESSION
        JMP     HL3AAJ
H105:
        LDA     ORG
        CMP     #1
        BEQ     H9
        LDA     #1
        AND     FLAGS+1
        BEQ     H150
        LDX     CSB
        LDA     #21
        LDY     #0
        JSR     LTINS
        LDX     #0
        STX     PC
        STX     PC+1
        JMP     NXT
H150:
        LDX     #0
        TXA
        TAY
        JSR     LTINS
        LDA     EXP
        STA     PC+1
        LDA     EXP+1
        STA     PC
        JMP     NXT
H9:
        PLA
        STA     CSL
        LDX     SYMLEN          ;GET LENGTH
        DEX                     ;AND DROP
H8846:
        PLA
        STA     SYM,X
        DEX
        BPL     H8846
        JSR     FIND
        BCC     H106
        LDA     VAL
        CMP     EXP
        BNE     MR01
        LDA     VAL+1
        CMP     EXP+1
        BEQ     H106A
MR01:
        LDY     #0
HLY02L:
        LDA     #2
        LDX     LSST
        JMP     LTS1
H106:
        LDA     EXP
        STA     VAL
        LDA     EXP+1
        STA     VAL+1
        JSR     INSERT
H106A:
        JMP     HL0000
;ASSEMBLER DIRECTIVE PROCESSING
;SEARCH DIRECTIVE TABLE AND PROCESS IF FOUND
H5:
        LDX     CSB             ;GET STRING START
        INX                     ;GO PAST "."
        LDA     #<ASMDIR        ;INITIALIZE POINTER TO TABLE START
        STA     TBLPTR
        LDA     #>ASMDIR
        STA     TBLPTR+1
        LDA     #3              ;SET LENGTH TO 3
        STA     LEN
        JSR     CONSYM          ;BUILD A SYMBOL
        DEX                     ;DROP INDEX SO POINTING TO THIRD CHAR
;LOOP ENTRY FOR SEARCH
H8847:
        JSR     INCRP           ;GO TO NEXT CHAR
        BCS     H8849           ;JUMP IF EOL
        LDA     LINE,X          ;ELSE GET CHAR
        CMP     #BLANK          ;TEST AGAINST BLANK
        BNE     H8847           ;LOOP IF NOT TO HANDLE FULL LENGTH DIRECTIVES
H8849:
        STX     COLP            ;SAVE POINTER
        BCS     H8835           ;JUMP IF VALID DIRECTIVE
HL014B:
        LDY     #0              ;ELSE SAY ERR14 - INVALID DIRECTIVE
        LDA     #14
        JMP     HLYAAB
;START TESTING SYMBOL AGAINST VALID DIRECTIVE TABLE ENTRIES
H8835:
        LDX     #NUMASM-1       ;SET X TO LAST ENTRY
H9938:
        LDY     #2              ;Y IS CHAR INDEX STARTING AT END
H9939:
        LDA     SYM,Y           ;GET SYMBOL CHAR
        CMP     (TBLPTR),Y      ;COMPARE TO TABLE ENTRY CHAR
        BNE     H9940           ;JUMP IF NO MATCH
        DEY                     ;MATCH SO FAR SO DROP INDEX
        BPL     H9939           ;LOOP IF MORE TO TEST
        TXA                     ;FULL MATCH SO SET X TO 2X
        ASL     A
        TAX
        LDA     ASMJMP,X        ;GET ENTRY ADDRESS AND
        STA     TBLPTR          ;SET POINTER
        LDA     ASMJMP+1,X
        STA     TBLPTR+1
;FOLLOWING LINE MAY BE REDUNDANT - NEED TO DOUBLE CHECK
        LDA     FLAGS           ;GET FLAGS FOR DIRECTIVE USE
        JMP     (TBLPTR)        ;GO TO ENTRY POINT
;THERE WAS NOT A MATCH SO TRY NEXT TABLE ENTRY
H9940:
        LDA     TBLPTR
        CLC
        ADC     #3
        STA     TBLPTR
        BCC     *+4
        INC     TBLPTR+1
        DEX                     ;DROP COUNTER
        BPL     H9938           ;LOOP IF MORE
        BMI     HL014B          ;ELSE ERROR
;EXECUTE .PAG DIRECTIVE
PAGE:
        LDA     FLAGS           ;GET FLAGS
        AND     #%00000100      ;TEST LIST
        BEQ     NOPAGE          ;BRANCH IF NO LIST
        LDA     $100+2          ;GET SIM PAGE
        STA     GETFF+2
GETFF:
        LDA     $FF00+62        ;GET FORMFEED CODE
        JSR     OUTPUT          ;SEND IT
NOPAGE:
        JMP     HL0000          ;AND CONTINUE
;PROCESS .BYT DIRECTIVE
H111:
        LDY     #1              ;VALUE FOR .BYT FOR FLAG
        BNE     H13A            ;JUMP ALWAYS
;PROCESS .WOR DIRECTIVE
H113:
        LDY     #2              ;VALUE FOR .WOR FOR FLAG
H13A:
        STY     BYWOR           ;SAVE .BYT OR .WOR FLAG
        JSR     FNDNB           ;FIND NEXT NON-BLANK
        BCS     HBW10
        JMP     HLY07E
HBW10:
        JSR     EVAL            ;EVALUATE EXPRESSION
        LDA     RETURN          ;GET RETURN CODE
        BEQ     HBW40           ;UNDEFINED SYMBOL
        BPL     HBW60           ;UNINTERPRETABLE
        STX     COLP            ;ELSE SET POINTER TO NEXT
        LDX     BYWOR           ;GET FLAG
        LDY     #0              ;POINT TO LOW PART OF CODE
        LDA     EXP+1           ;GET LOW PART OF RESULT
        STA     CODE,Y          ;SAVE IN CODE BUFFER
        CPX     #2              ;SEE IF .WOR
        BNE     HBW20A          ;JUMP IF NOT
        LDA     EXP             ;IF .WOR GET HIGH PART
        INY                     ;BUMP CODE INDEX
        STA     CODE,Y          ;AND SAVE HIGH PART
HBW20A:
        LDA     FLAGS+1
        AND     #9
        BNE     HBW20B
        CPX     #1
        BNE     HBW20C
        LDA     EXP
        BEQ     HBW20C
HBW20B:
        LDY     BYWOR
        LDA     #4
        LDX     CSB
        JMP     HIYAAX
HBW20C:
        LDY     BYWOR
HIY00X:
        LDA     #0
HIYAAX:
        JSR     LTINS
HBW30:
        LDX     COLP            ;GET POINTER
        CPX     MAXCL           ;SEE IF AT MAX
        BEQ     *+4             ;OK IF IS
        BCS     EXTBYT          ;DONE IF PAST LAST
        LDA     LINE,X          ;AND CHAR
        CMP     #','            ;SEE IF COMMA
        BEQ     GOTCMA          ;OK IF IS
        CMP     #BLANK          ;SEE IF SPACE
        BEQ     EXTBYT          ;EXIT IF IS
BADOPR:
        JMP     HL318B          ;BAD OPERAND FORMAT
EXTBYT:
        JMP     NXT             ;ELSE END OF LINE
GOTCMA:
        JSR     INCRP
        STX     COLP
        JSR     FNDNB
        BCS     HBW10
        JMP     HL307B
HBW40:
        LDA     #6
        BNE     HIJAAJ
;EXPRESSION EVALUATION SAID EXPRESSION UNINTERPRETABLE
;SO TEST FOR STRING
HBW60:
        LDA     LINE,X          ;GET FIRST CHAR
        STA     STRDEL          ;SAVE FOR LATER USE
        CMP     #APOST          ;SEE IF '
        BEQ     HBW60V          ;IS SO MAY BE STRING
        CMP     #QUOTE          ;ALSO CHECK "
        BNE     HBW60A          ;NOT SO IS ERR13 - INVALID EXP
HBW60V:
        CPX     CSB             ;MAY BE START OF STRING SO CHECK
        BNE     HBW60A          ;JUMP TO ERR13 IF INDEX AND STRING START NOT =
        LDY     BYWOR           ;GET MODE FLAG
        CPY     #1              ;SEE IF .BYT
        BEQ     HBW60B          ;IS SO GET STRING
HBW60A:
        LDA     #13
HIJAAJ:
        PHA                     ;SAVE ERROR CODE
        JSR     FNCMP           ;SKIP TO NEXT FIELD
        PLA                     ;GET ERROR CODE BACK
        LDY     BYWOR
        LDX     ERCOL
        JMP     HIYAAX
;START PROCESSING .BYT '....'
HBW60B:
        STX     COLP            ;SAVE POINTER
        LDY     #0              ;SET INDEX TO START
;LOOP ENTRY FOR .BYT '....' PROCESSING
HBW70:
        LDX     COLP            ;GET POINTER
        JSR     INCRP           ;GO TO NEXT CHAR
        STX     COLP            ;SAVE POINTER
        BCC     *+5             ;JUMP IS NOT EOL
        JMP     HLY07B          ;ELSE RAN OFF EOL ERROR
        LDA     LINE,X          ;GET CHAR
        CMP     STRDEL          ;SEE IF SAME AS START DELIMITER
        BNE     HBW80           ;IF NOT GO TEST FOR VALID
;HAVE A VALID STRING DELIMITER
        LDX     COLP            ;GET POINTER
        JSR     INCRP           ;GO TO NEXT CHAR
        STX     COLP            ;SAVE POINTER
        BCS     HIY00X          ;IF EOL GO TO EOL PROCESSING
        LDA     LINE,X          ;GET CHAR
        CMP     STRDEL          ;SEE IF SAME AS FIRST DELIMITER
        BNE     HIY00X          ;NOT SO NOT DOUBLE
;HAVE A CHARACTER - SEE IF VALID
HBW80:
        CMP     #BLANK          ;SEE IF LESS THAN SPACE
        BCC     HBW80A          ;IS SO ENTER 0
        CMP     #DELETE         ;SEE IF < DELETE
        BCC     HBW80B          ;IS SO VALID CHAR
HBW80A:
        LDA     #0
HBW80B:
        STA     CODE,Y          ;SAVE CHAR IN CODE BUFFER
        INY                     ;POINT TO NEXT BUFFER POSITION
        JMP     HBW70           ;AND LOOP FOR MORE
;PROCESS .OPT DIRECTIVE
H301:
        JSR     FNDNB
        BCS     *+5
        JMP     HL0000
        LDX     CSB
        LDA     #3
        STA     LEN
        JSR     CONSYM
        BCS     *+5
        JMP     HL014B
        LDA     #<OPTDIR
        STA     TBLPTR
        LDA     #>OPTDIR
        STA     TBLPTR+1
        LDX     #NUMSAV-1
        JMP     H9938
;GENERATE KIM FILE
KIM:
        ORA     #%00100000      ;SET BIT
        BNE     H390
;DO NOT GENERATE KIM FILE
NOKIM:
        AND     #%11011111      ;CLEAR BIT
        JMP     H390
H323:
        AND     #127
        JMP     H390
H302:
        ORA     #128
        BNE     H390
H303:
        ORA     #64
        BNE     H390
H304:
        AND     #191
        JMP     H390
H307:
        ORA     #16
        BNE     H390
H308:
        AND     #239
        JMP     H390
H311:
        ORA     #4
        BNE     H390
H312:
        AND     #251
H390:
        STA     FLAGS
H390A:
        JSR     FNCMP
        BCS     H8840
H8839:
        JMP     HL0000
H8840:
        LDA     LINE,X
        CMP     #','
        BNE     H8839
        INX
        STX     COLP
        JMP     H301
;OPCODE & OPERAND PSOCESSING SECTION
;FIRST CLEAR FLAGS AND VALUES
H201:
        LDA     #0
        STA     OPTYP
        STA     OPLEN
        STA     NOPV
        TAY
        LDA     OPBAS           ;THIS WAS SET BY OPFND
        STA     CODE
        LDA     OPTEM
        CMP     #20
        BNE     H17
HL1000:
        LDY     #1
        JMP     HLY000
H17:
        LDA     CSE
        STA     COLP
        INC     COLP
        JSR     FNDNB
        BCS     H9917
        LDY     #3
;ERR07 - RAN OFF LINE AT CSE
HLY07E:
        LDA     #7
        LDX     CSE
        JMP     LTS1
H9917:
        LDA     LINE,X
        CMP     #SEMICO
        BNE     H9934
HL307B:
        LDY     #3
HLY07B:
        LDA     #7
        JMP     HLYAAB
H9934:
        CMP     #'A'
        BNE     H39
        CPX     MAXCL
        BEQ     H9965
        LDY     LINE+1,X
        CPY     #BLANK
        BNE     H39
H9965:
        LDY     OPTEM
        LDA     KLTBL-1,Y
        BMI     HL305B
        CLC
        ADC     OPBAS
        STA     CODE
        JMP     HL1000
HL305B:
        LDA     #5
        JMP     HL3AAB
H39:
        CMP     #'#'
        BNE     H24
        LDA     #10
        JMP     H831
H24:
        CMP     #'('
        BNE     H23
        LDA     #5
H831:
        STA     OPTYP
        INC     CSB
        JSR     INCRP
        BCC     H23
        JMP     HL307B
;EVALUATE THE OPERAND
H23:
        JSR     EVAL
        LDA     RETURN          ;TEST RESULT CODE
        BMI     H20             ;JUMP IF IT WAS GOOD!
        LDA     OPTYP           ;IF BAD SEE IF WAS IMMEDIATE MODE
        CMP     #10
        BEQ     H9935           ;IF SO MAY BE SINGLE ASCII CHAR
        LDA     RETURN
        BEQ     H202
;AT THIS POINT WE HAVE A GOOFY EXPRESSION
;MAKE A CHECK FOR RELATIVE ADDRESSING SO ONLY TWO BYTES
;GET ALLOCATED DURING FIRST PASS
        LDA     OPTEM           ;GET TEMPLATE
        CMP     #14             ;SEE IF RELATIVE
        BEQ     BAD2BY          ;IF SO ALLOCATE ONLY TWO BYTES
;GOOFY EXPRESSION AND 3 BYTE INSTRUCTION
HL313J:
        LDA     #13
HL3AAJ:
        LDX     ERCOL
        JMP     HL3AAX
;BAD EXPRESSION AND IMMEDIATE MODE
H9935:
        LDA     LINE,X          ;GET CHARACTER
;FIRST SEE IF A SINGLE CHARACTER
        CMP     #APOST          ;LOOK FOR STARTING '
        BNE     BAD2BY          ;NO SO SAY IS BAD
        JSR     INCRP           ;BUMP POINTER
        BCC     *+7             ;JUMP IF NOT AT END
        LDY     #2              ;ELSE FLAG AS ERROR
        JMP     HLY07B
        LDA     LINE,X          ;GET CHAR AFTER '
        CMP     #BLANK          ;SEE IF SMALLER THAN SPACE
        BCC     H9921           ;IS SO VALUE 0
        CMP     #DELETE         ;SEE IF SMALLER THAN DELETE
        BCC     H9922           ;IS SO STORE AS RESULT
H9921:
        LDA     #0              ;CLEAR LOW BYTE (HL ORDER)
H9922:
        STA     EXP+1           ;STORE LOW (0 OR CHAR)
        LDA     #0              ;HIGH PART ALWAYS 0
        STA     EXP
        LDA     #%11110110      ;SET FLAG ASNO OVERFLOW & POS
        AND     FLAGS+1
        STA     FLAGS+1
        JSR     INCRP           ;LOOK FOR NEXT CHAR
;CODE AT THIS POINT ALLOWS SINGLE CHARACTER TO BE TERMINATED BY
;END OF LINE OR A BLANK - THIS IS CANDIDATE FOR CHANGE TO RESTRICT
;SYNTAX.
        BCS     H20             ;REACHED EOL
        LDA     LINE,X          ;GET CHAR
        CMP     #BLANK          ;SEE IF SPACE
        BEQ     H20             ;IF SO OK
;WE HAVE A BAD 2-BYTE INSTRUCTION SO ERR 13
BAD2BY:
        LDA     #13
HL2AAJ:
        LDX     ERCOL
        LDY     #2
        JMP     LTS1
H202:
        INC     NOPV
        LDA     #2
        STA     OPLEN
H20:
        JSR     FNCMP           ;FIND NON-EMBEDDED , OR )
        BCC     H500            ;JUMP IF NONE FOUND
        LDA     LINE,X          ;GET THE CHAR
        CMP     #')'
        BNE     H51
        INC     OPTYP
        INC     OPTYP
        LDA     OPBAS
        CMP     #$4C
        BEQ     H140
        JSR     INCRP
        BCC     *+5             ;OK IF A CHAR
        JMP     HL307B
        LDA     LINE,X          ;GET CHAR
        CMP     #','            ;SEE IF COMMA
        BEQ     H51A            ;BRANCH IF N),
        BNE     HL318B          ;ELSE N) IS ILLEGAL
H51:
        LDA     LINE,X
        CMP     #','
        BNE     H203
        LDA     OPBAS           ;GET BASE OPCODE
        CMP     #$4C            ;SEE IF JMP
        BNE     H51A            ;JUMP IF NOT
;IF IS THEN IS ILLEGAL OPERAND FOR JMP
HL318B:
        LDA     #18             ;ERROR 18
        JMP     HL3AAB
H51A:
        JSR     INCRP           ;LOOK FOR NEXT CHAR
        BCC     H203            ;JUMP IF OK
        JMP     HL307B
H203:
        LDA     LINE,X          ;GET CHAR
        CMP     #'X'
        BNE     H25
        INC     OPTYP
        JMP     H40
H25:
        CMP     #'Y'
        BEQ     H27
        LDA     #12
        JMP     HL3AAX
H27:
        INC     OPTYP
        INC     OPTYP
        BNE     H40
H500:
        LDA     OPBAS           ;GET BASE OPCODE
        CMP     #$4C            ;SEE IF JMP
        BNE     H40             ;JUMP IF NOT
H140:
        LDA     OPTYP
        BNE     H145
H140A:
        LDY     #2
        STY     OPLEN
        JMP     H46
H145:
        CMP     #7
        BNE     HL318B
        LDA     #32
        JSR     INCRP
        BCS     H140A
        LDY     LINE,X
        CPY     #BLANK
        BEQ     H140A
        BNE     HL318B
H40:
        LDA     NOPV
        BNE     H41
        LDA     #2
        STA     OPLEN
        LDA     OPTEM
        CMP     #14
        BNE     H22
        LDA     PC
        STA     TEMP
        LDA     PC+1
        STA     TEMP+1
        JSR     RELADR
        BCS     HOP70
        LDA     #17             ;RELATIVE BRANCH OUT OF RANGE ERROR
HL2AAB:
        LDY     #2              ;DO A TWO BYTE ERROR FOR CODE IN A
        JMP     HLYAAB          ;DO IT
HOP70:
        LDA     #0
        STA     EXP
H22:
        LDA     OPTYP
        CMP     #6
        BCC     H400
        CMP     #10
        BCS     H400
        JSR     INDADR
        BCS     H400
        LDA     #19             ;INDIRECT OPERAND OUT-OF-RANGE
        JMP     HL2AAJ          ;DO TWO BYTE ERROR
H400:
        LDA     EXP
        BNE     H41
        LDA     #1
        STA     OPLEN
        LDA     OPTYP
        CLC
        ADC     #2
        STA     OPTYP
H50:
        CMP     #13
        BCC     H45
        LDA     #15
        JMP     HL3AAB
H41:
        LDA     OPTYP
        CLC
        ADC     #13
        STA     OPTYP
H47:
        CMP     #16
        BCS     H49
H45:
        TAY
        DEY
        LDA     KLUDG,Y
        CLC
        ADC     OPTEM
        TAY
        LDA     KLTBL,Y
        BPL     H46
H49:
        LDA     NOPV
        BEQ     H48
        LDA     OPLEN
        CMP     #2
        BEQ     *+5
        JMP     HL318B
        DEC     OPLEN
        LDA     OPTYP
        SEC
        SBC     #11
        STA     OPTYP
        JMP     H50
H48:
        LDA     OPLEN
        CMP     #1
        BEQ     *+5
        JMP     HL318B
        INC     OPLEN
        LDA     OPTYP
        CLC
        ADC     #11
        STA     OPTYP
        JMP     H47
H46:
        CLC
        ADC     OPBAS
        LDY     #0
        STA     CODE,Y
        LDA     NOPV
        BNE     HL301X
        INY
        LDA     EXP+1
        STA     CODE,Y
        INY
        LDA     OPLEN
        CMP     #1
        BEQ     H9931A
        LDA     EXP
        STA     CODE,Y
H9931A:
        LDA     #9
        AND     FLAGS+1
        BEQ     H9931B
HLJ04B:
        LDY     OPLEN
        INY
        LDA     #4
        JMP     HLYAAB
H9931B:
        LDA     OPLEN
        CMP     #1
        BNE     HLJ000
        LDA     EXP
        BNE     HLJ04B
HLJ000:
        LDY     OPLEN
        INY
        JMP     HLY000
HL301X:
        LDA     CODE
        LDY     #3
        AND     #$1F
        CMP     #$10
        BNE     *+3
        DEY
        LDA     #1
;GENERAL ERROR HANDLER
;FIRST INSERTS AN ERROR CODE INTO TABLE
;THEN RESETS STACK SO THAT SYSTEM RETURNS TO RECOVERY POINT
;REGARDLESS OF HOW FAR DOWN THE PARSER HAS GONE.
;ASM RESETS STACK TO $FF SO THIS IS WHAT DEFINES RECOVERY POINT
;	STACK = $FD --> AFTER JSR DOPASS (EITHER 1ST OR 2ND)
;	STACK = $FB --> AFTER JSR PROCES
;C=0 SO DOPASS WILL TRY NEXT LINE
LTS1:
        JSR     LTINS           ;SAVE CODE
NXT:
        LDX     #$FB            ;RECOVER TO JSR PROCES
        TXS
        CLC                     ;NOT EOF
        RTS
;DO ONE PASS THROUGH THE SOURCE FILE
DOPASS:
        LDA     #<(SRCBUF+SRCLNG);SET INDEX
        LDY     #>(SRCBUF+SRCLNG);TO
        STA     SRCIND          ;ILLEGAL
        STY     SRCIND+1        ;VALUE
        JSR     PROCES
        BCC     *-3
        RTS
;-------------------------------
;MAIN PROCESSING ROUTINE
;-------------------------------
MAIN:
        LDA     #<STRMSG        ;POINT TO
        LDY     #>STRMSG        ;START MESSAGE
        JSR     WRCNMS          ;WRITE IT
;CLEAR PAGE ZERO
        LDX     #2              ;SET INDEX
        LDA     #0              ;CLEAR A
CLRZP:
        STA     $00,X           ;CLEAR MEM
        INX                     ;BUMP COUNT
        CPX     #LASTZP         ;COMPARE TO END
        BNE     CLRZP           ;LOOP IF MORE
;MAKE SURE SYMLEN AT LEAST 6
        LDA     SYMLEN          ;GET SYMBOL LENGTH
        CMP     #6              ;AND TEST
        BCS     SYMLOK          ;OK IF >= 6
        LDA     #6              ;ELSE FORCE TO 6
        STA     SYMLEN
;CHECK DEFAULT FCB FOR VALID UFN FOR SOURCE
SYMLOK:
        LDX     #8
SFB:
        LDA     DFLFCB,X
        CMP     #'?'
        BEQ     BDF             ;IS AN AFN SO NOT VALID
        STA     SRCFCB,X
        STA     KIMFCB,X
        STA     LSTFCB,X        ;INSERT IN LIST FCB
        DEX
        BPL     SFB
        BMI     *+5
BDF:
        JMP     DOSERR          ;ABORT FOR DISK ERROR
        LDA     DFLFCB+9        ;GET SOURCE LOC IF ANY
        CMP     #BLANK          ;SEE IF BLANK
        BEQ     USEDFL          ;USE DEFAULT IF IS
        JSR     CHKDRV          ;CHECK FOR LEGAL
        STA     SRCFCB          ;AND SET
        LDA     DFLFCB+10       ;TRY FOR KIM
        CMP     #BLANK          ;SEE IF NONE
        BEQ     USEDFL          ;USE DEFAULT IF SO
        CMP     #'Z'            ;SEE IF Z
        BNE     TRYKAH          ;IF NOT TRY FOR A-H
        SEC                     ;ELSE SET NO KIM FLAG
        ROR     NKMFLG
        BMI     TSTPRN          ;THEN GO TRY PRN
TRYKAH:
        JSR     CHKDRV          ;ELSE GO CHECK
        STA     KIMFCB          ;AND SET
TSTPRN:
        LDA     DFLFCB+11       ;TRY LIST
        CMP     #BLANK          ;DO SAME FOR IT
        BEQ     USEDFL          ;IF BLANK
        CMP     #'X'            ;SEE IF X
        BNE     TRYLST          ;IF NOT TRY Z
        SEC                     ;SET CONSOLE OUTPUT
        ROR     LSTFLG
        BMI     USEDFL          ;AND PRESS ON
TRYLST:
        CMP     #'Z'            ;SEE IF Z
        BNE     TRYAH           ;IF NOT TRY A TO H
        SEC                     ;SET NO LIST FLAG
        ROR     NLSFLG
        BMI     USEDFL          ;AND PRESS
TRYAH:
        JSR     CHKDRV          ;THEN CHECK
        STA     LSTFCB          ;AND SET
USEDFL:
        JSR     SSRFCB
        JSR     OPNFIL
        BEQ     BDF
        JSR     DLTKIM
        BIT     NKMFLG          ;TEST NO KIM FLAG
        BMI     SKPKIM          ;SKIP IF SET
        JSR     SKMFCB
        JSR     CRTFIL
        BEQ     BDF
        JSR     SKMFCB
        JSR     OPNFIL
        BEQ     BDF
SKPKIM:
        JSR     SLSFCB          ;POINT TO LIST FCB
        JSR     DLTFIL          ;DELETE IT
        LDA     LSTFLG          ;SEE IF NO .PRN FILE
        ORA     NLSFLG
        BMI     SKPLST          ;IF SO SKIP AHEAD
        JSR     SLSFCB          ;POINT AGAIN
        JSR     CRTFIL          ;NOW MAKE IT
        BEQ     BDF             ;EXIT IF BAD
        JSR     SLSFCB          ;POINT ONCE MORE
        JSR     OPNFIL          ;OPEN IT
        BEQ     BDF             ;EXIT IF BAD
SKPLST:
        LDA     #%11110100      ;SET DEFAULT
        STA     FLAGS           ;FLAGS
;CALCULATE SYMBOL TABLE START ADDRESS
        LDA     #<SYM           ;GET BUFFER START
        LDY     #>SYM
        CLC                     ;NO ADD SYMBOL LENGTH
        ADC     SYMLEN
        STA     STSAVE          ;SET LOW
        BCC     STHIOK          ;HIGH OK IF NO CARRY
        INY                     ;ELSE BUMP HIGH
STHIOK:
        STY     STSAVE+1        ;SAVE HIGH
;NOW CALCULATE UPPER LIMIT
        LDA     PEM+1           ;GET PEM ADDRESS
        LDY     PEM+2
        SEC                     ;DROP BY SYMBOL LENGTH
        SBC     SYMLEN
        STA     TBLSZ
        BCS     *+3
        DEY
        STY     TBLSZ+1
        SEC                     ;DROP BY TWO MORE
        LDA     TBLSZ
        SBC     #2
        STA     TBLSZ
        BCS     NTBORW          ;DONE IF NO BORROW
        DEC     TBLSZ+1
NTBORW:
        LDX     #$FF
        TXS
        LDA     #<PS1MSG        ;SEND START OF PASS 1 MSG
        LDY     #>PS1MSG
        JSR     WRCNMS
        JSR     DOPASS
        LDA     #<SRTMSG        ;POINT TO
        LDY     #>SRTMSG        ;END OF PASS ONE MESSAGE
        JSR     WRCNMS          ;PRINT IT
        LDA     #0
        STA     LINENO
        STA     LINENO+1
        STA     PC
        STA     PC+1
        STA     ERCT
        STA     ERCT+1
        STA     BYTCNT
        STA     SRCFCB+12
        STA     SRCFCB+13       ;CLEAR BOTH EXTENT BYTES
        STA     SRCFCB+32
        LDA     #%11110100      ;SET DEFAULT
        STA     FLAGS           ;FLAGS
        LDA     #$FF            ;CHANGE
        STA     PASNUM          ;PASS NUMBER
        JSR     SSRFCB
        JSR     OPNFIL
        JSR     SORT            ;SORT SYMBOL TABLE
        JSR     CCRLF           ;SEND CR AND LF TO CONSOLE
        LDA     #<PS2MSG        ;SEND START OF PASS 2 MSG
        LDY     #>PS2MSG
        JSR     WRCNMS
        JSR     CLKIND          ;CLEAR KIM INDEX
        JSR     CLLIND          ;CLEAR LIST INDEX
        JSR     DOPASS
        LDA     #<ERNMSG        ;POINT TO
        LDY     #>ERNMSG        ;ERROR COUNT MESSAGE
        JSR     WRCNMS          ;WRITE IT
        LDA     ERCT            ;THEN HIGH
        JSR     CNUMA           ;BYTE OF COUNT
        LDA     ERCT+1          ;THEN LOW
        JSR     CNUMA           ;BYTE OF COUNT
        JSR     CCRLF           ;SEND A LAST CR AND LF
        BIT     NKMFLG          ;TEST FOR NO KIM
        BMI     SKKMFO          ;DONE IF SET
        JSR     WRKMRC
FLSHKM:
        SEC                     ;SEE IF
        LDA     KIMIND          ;WHOLE
        SBC     #<KIMBUF        ;NUMBER
        AND     #127            ;SECTORS
        BEQ     WHLREC          ;BRANCH IF IT IS
        LDA     #EOF            ;ELSE INSERT
        JSR     KIMOUT          ;AN EOF
        JMP     FLSHKM          ;AND LOOP
WHLREC:
        JSR     WRTKIM          ;WRITE LAST SECTOR
        JSR     SKMFCB
        JSR     CLSFIL
SKKMFO:
        LDA     LSTFLG          ;SEE IF NO LIST
        ORA     NLSFLG
        BMI     EXTSYS          ;EXIT IF NONE
FLSHLS:
        SEC                     ;SEE IF LIST
        LDA     LSTIND          ;INDEX A WHOLE
        SBC     #<LSTBUF        ;NUMBER SECTORS
        AND     #127            ;OF 128
        BEQ     WHLLST          ;JUMP IF IT IS
        LDA     #EOF            ;ELSE GET AN EOF
        JSR     OUTPUT          ;SEND TO BUFFER
        JMP     FLSHLS          ;AND LOOP
WHLLST:
        JSR     WRTLST          ;NOW WRITE FILE
        JSR     SLSFCB          ;POINT TO IT
        JSR     CLSFIL          ;CLOSE IT
EXTSYS:
        JMP     WRMBTE
;MESSAGES
PS1MSG:
        .BYTE   "START OF PASS 1",CR,LF,"$"
PS2MSG:
        .BYTE   "START OF PASS 2",CR,LF,"$"
ENDMSG:
        .BYTE   "END OF PASS 2$"
STRMSG:
        .BYTE   "DOS/65 ASSEMBLER",CR,LF
        .BYTE   "VERSION 2.11-A",CR,LF,"$"
ILDMSG:
        .BYTE   "ILLEGAL DRIVE DESIGNATOR$"
SRTMSG:
        .BYTE   "END OF PASS 1",CR,LF
        .BYTE   "SORTING SYMBOL TABLE"
        .BYTE   " - PLEASE WAIT$"
ERNMSG:
        .BYTE   "NUMBER OF ERRORS = $"
ERRMSG:
        .BYTE   "**ERROR**$"
PERMSG:
        .BYTE   CR,LF,"DOS/65 FILE ERROR - ASSEMBLY "
        .BYTE   "ABORTED$"
;ERROR MESSAGE VECTOR TABLE
ERRVEC:
        .WORD   0,ERR01,ERR02,ERR03,ERR04
        .WORD   ERR05,ERR06,ERR07,ERR08,ERR09
        .WORD   ERR10,ERR11,ERR12,ERR13,ERR14
        .WORD   ERR15,ERR16,ERR17,ERR18,ERR19
        .WORD   ERR20,ERR21,ERR22,ERR23,ERR24
        .WORD   ERR25
;ASSEMBLER ERROR MESSAGES
ERR01:
        .BYTE   "UNDEFINED SYMBOL$"
ERR02:
        .BYTE   "LABEL PREVIOUSLY DEFINED$"
ERR03:
        .BYTE   "ILLEGAL OR MISSING OPCODE$"
ERR04:
        .BYTE   "ADDRESS NOT VALID$"
ERR05:
        .BYTE   "ACCUMULATOR MODE NOT ALLOWED$"
ERR06:
        .BYTE   "FORWARD REFERENCE IN .BYT OR "
        .BYTE   ".WOR$"
ERR07:
        .BYTE   "RAN OFF END OF LINE$"
ERR08:
        .BYTE   "LABEL DOES NOT BEGIN WITH "
        .BYTE   "ALPHABETIC CHARACTER$"
ERR09:
        .BYTE   "LABEL TOO LONG$"
ERR10:
        .BYTE   "LABEL OR OPCODE CONTAINS "
        .BYTE   "NON-ALPHANUMERIC$"
ERR11:
        .BYTE   "FORWARD REFERENCE IN EQUATE "
        .BYTE   "OR ORG$"
ERR12:
        .BYTE   "INVALID INDEX - MUST BE X OR"
        .BYTE   " Y$"
ERR13:
        .BYTE   "INVALID EXPRESSION$"
ERR14:
        .BYTE   "UNDEFINED ASSEMBLER DIRECTIVE$"
ERR15:
        .BYTE   "INVALID OPERAND FOR PAGE ZERO "
        .BYTE   "MODE$"
ERR16:
        .BYTE   "INVALID OPERAND FOR ABSOLUTE "
        .BYTE   "MODE$"
ERR17:
        .BYTE   "RELATIVE BRANCH OUT OF RANGE$"
ERR18:
        .BYTE   "ILLEGAL OPERAND TYPE FOR THIS "
        .BYTE   "INSTRUCTION$"
ERR19:
        .BYTE   "OUT OF BOUNDS ON INDIRECT "
        .BYTE   "ADDRESSING$"
ERR20:
        .BYTE   "A,X,Y,S, AND P ARE RESERVED "
        .BYTE   "LABELS$"
ERR21:
        .BYTE   "PROGRAM COUNTER NEGATIVE - "
        .BYTE   "RESET TO 0$"
ERR22:
        .BYTE   "INVALID CHARACTER - EXPECTING"
        .BYTE   " = FOR ORG$"
ERR23:
        .BYTE   "SOURCE LINE TOO LONG$"
ERR24:
        .BYTE   "DIVIDE BY ZERO IN EXPRESSION$"
ERR25:
        .BYTE   "SYMBOL TABLE OVERFLOW$"
;DIRECTIVE AND OPTION JUMP TABLE
ASMJMP:
        .WORD   H312,H311,H308,H307
        .WORD   NOKIM,KIM,H304,H303,H302
        .WORD   H323,H301,H10,PAGE
        .WORD   H113,H111
;ASSEMBLER DIRECTIVES
ASMDIR:
        .BYTE   "BYTWORPAGENDOPT"
;OPTION PARAMETERS
OPTDIR:
        .BYTE   "GENNOGSYMNOSKIMNOK"
        .BYTE   "ERRNOELISNOL"
;OP-CODES
OPRNDS:
        .BYTE   "ADCANDASLBCCBCSBEQBITBMI"
        .BYTE   "BNEBPLBRKBVCBVSCLCCLDCLI"
        .BYTE   "CLVCMPCPXCPYDECDEXDEYEOR"
        .BYTE   "INCINXINYJMPJSRLDALDXLDY"
        .BYTE   "LSRNOPORAPHAPHPPLAPLPROL"
        .BYTE   "RORRTIRTSSBCSECSEDSEISTA"
        .BYTE   "STXSTYTAXTAYTSXTXATXSTYA"
KLUDG:
        .BYTE   255,13,27,41,55,69,83,97
        .BYTE   111,125,139,153,167,181,195
KLTBL:
        .BYTE   255,255,255,255,4,255,255,255
        .BYTE   255,255,255,255,255,255,4,4
        .BYTE   255,255,0,4,0,4,0,0
        .BYTE   4,0,255,0,20,20,255,255
        .BYTE   16,255,255,20,255,16,255,16
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,16,255,20,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,0,0,32,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,255,255,16,16,255,255
        .BYTE   255,255,255,255,255,255,255,255
        .BYTE   255,255,8,255,255,255,255,0
        .BYTE   255,0,255,255,0,255,255,255
        .BYTE   12,12,0,0,8,12,8,12
        .BYTE   8,8,12,8,255,255,28,28
        .BYTE   255,255,24,255,255,28,255,255
        .BYTE   255,24,255,255,24,24,255,255
        .BYTE   255,255,255,255,255,255,$1C,255
        .BYTE   255,255
;TEMPLATE TABLE THAT DEFINES GROUPS OF OPCODES
;THAT HAVE THE SAME ADDRESSING MODES
;THIS COMMENT INCLUDES 65C02 OPCODES NOT YET IN ASM
; 1=ADC,AND,CMP,EOR,LDA,ORA,SBC
; 2=STA
; 3=JMP
; 4=JSR
; 5=ASL,LSR,ROL,ROR
; 6=CPX,CPY
; 7=BIT
; 8=LDY
; 9=STX
; 10=STY
; 11=LDX
; 12=DEC,INC
; 13 NOT USED
; 14=BCC,BCS,BEQ,BMI,BNE,BPL,BRA,BVC,BVS
; 15-19 NOT USED
; 20=ALL IMPLIED (E.G., TAY AND BRK)
KTMPL:
        .BYTE   1,1,5,14,14,14,7,14
        .BYTE   14,14,20,14,14,20,20,20
        .BYTE   20,1,6,6,12,20,20,1
        .BYTE   12,20,20,3,4,1,11,8
        .BYTE   5,20,1,20,20,20,20,5
        .BYTE   5,20,20,1,20,20,20,2
        .BYTE   9,10,20,20,20,20,20,20
;TABLE OF BASE OPCODES ARRANGED IN SAME
;ORDER AS OPRNDS TABLE
;THE ENTRY IN THIS TABLE IS THE ACTUAL OPCODE
;FOR TEMPLATE GROUPS 4, 14, AND 20.  FOR ALL
;OTHERS, THE ENTRY IS THE SMALLEST NUMERICAL
;OPCODE FOR THAT MNEMONIC.
KCODE:
        .BYTE   97,33,6,144,176,240,36,48
        .BYTE   208,16,0,80,112,24,216,88
        .BYTE   184,193,224,192,198,202,136,65
        .BYTE   230,232,200,76,32,161,162,160
        .BYTE   70,234,1,72,8,104,40,38
        .BYTE   $66,64,96,225,56,248,120,129
        .BYTE   134,132,170,168,186,138,154,152
;SOURCE FCB
SRCFCB:
        .BYTE   0
        .RES    8
        .BYTE   "ASM",0,0,0
        .RES    17
        .BYTE   0
;KIM FCB
KIMFCB:
        .BYTE   0
        .RES    8
        .BYTE   "KIM",0,0,0
        .RES    17
        .BYTE   0
;LIST FCB
LSTFCB:
        .BYTE   0
        .RES    8
        .BYTE   "PRN",0,0,0
        .RES    17
        .BYTE   0
;SOURCE DISK BUFFER
SRCBUF:
        .RES    SRCLNG
;KIM DISK BUFFER
KIMBUF:
        .RES    KIMLNG
;LIST DISK BUFFER
LSTBUF:
        .RES    LSTLNG
;CODE BUFFER
CODE:
        .RES    LINESZ-4
;LINE BUFFER
LINE:
        .RES    LINESZ+2
;INPUT ECHO BUFFER
ECHBUF: ;ECHO BUFFER
        .RES    LINESZ+2
;SYMBOL BUFFER
;LENGTH IS DETERMINED BY SYMLEN
SYM:
        .END
