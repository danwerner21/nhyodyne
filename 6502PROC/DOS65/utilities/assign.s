;
; File generated by cc65 v 2.18 - Ubuntu 2.19-1
;
	.fopt		compiler,"cc65 v 2.18 - Ubuntu 2.19-1"
	.setcpu		"65SC02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_cputs
	.import		_cprintf
	.import		_strncmp
	.import		_strncpy
	.import		_strtok
	.import		_strtoul
	.export		_floppy35720dcb
	.export		_floppy35144dcb
	.export		_floppy525360dcb
	.export		_floppy52512dcb
	.export		_hdddcb
	.export		_ramdcb
	.export		_romdcb
	.export		_prtusage
	.export		_prtdevice
	.export		_prttable
	.export		_parsecmd
	.export		_mapdrive
	.export		_updatedosmap
	.export		_toupper
	.export		_main

.segment	"DATA"

_floppy35720dcb:
	.byte	$5E
	.byte	$01
	.byte	$24
	.byte	$00
	.byte	$04
	.byte	$00
	.byte	$01
	.byte	$7F
	.byte	$00
_floppy35144dcb:
	.byte	$5E
	.byte	$01
	.byte	$24
	.byte	$00
	.byte	$04
	.byte	$00
	.byte	$01
	.byte	$7F
	.byte	$00
_floppy525360dcb:
	.byte	$5E
	.byte	$01
	.byte	$24
	.byte	$00
	.byte	$04
	.byte	$00
	.byte	$01
	.byte	$7F
	.byte	$00
_floppy52512dcb:
	.byte	$5E
	.byte	$01
	.byte	$24
	.byte	$00
	.byte	$04
	.byte	$00
	.byte	$01
	.byte	$7F
	.byte	$00
_hdddcb:
	.byte	$FF
	.byte	$07
	.byte	$40
	.byte	$00
	.byte	$10
	.byte	$00
	.byte	$02
	.byte	$FF
	.byte	$01
_ramdcb:
	.byte	$7F
	.byte	$00
	.byte	$40
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$01
	.byte	$FF
	.byte	$00
_romdcb:
	.byte	$BF
	.byte	$00
	.byte	$40
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$01
	.byte	$FF
	.byte	$00

.segment	"RODATA"

L00F3:
	.byte	$20,$20,$20,$20,$41,$53,$53,$49,$47,$4E,$20,$44,$3A,$3D,$5B,$7B
	.byte	$44,$3A,$7C,$3C,$64,$65,$76,$69,$63,$65,$3E,$5B,$3C,$75,$6E,$69
	.byte	$74,$6E,$75,$6D,$3E,$5D,$3A,$5B,$3C,$73,$6C,$69,$63,$65,$6E,$75
	.byte	$6D,$3E,$5D,$7D,$5D,$20,$7B,$2F,$66,$6C,$61,$67,$73,$7D,$20,$0A
	.byte	$0D,$00
L00FF:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$41,$53,$53,$49,$47,$4E
	.byte	$20,$43,$3A,$3D,$49,$44,$45,$30,$3A,$31,$09,$28,$61,$73,$73,$69
	.byte	$67,$6E,$20,$43,$3A,$20,$74,$6F,$20,$49,$44,$45,$20,$75,$6E,$69
	.byte	$74,$30,$2C,$20,$73,$6C,$69,$63,$65,$20,$31,$29,$20,$0A,$0D,$00
L00F6:
	.byte	$20,$20,$20,$20,$20,$20,$65,$78,$3A,$20,$41,$53,$53,$49,$47,$4E
	.byte	$09,$09,$28,$64,$69,$73,$70,$6C,$61,$79,$20,$61,$6C,$6C,$20,$61
	.byte	$63,$74,$69,$76,$65,$20,$64,$72,$69,$76,$65,$20,$61,$73,$73,$69
	.byte	$67,$6E,$6D,$65,$6E,$74,$73,$29,$20,$0A,$0D,$00
L00FC:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$41,$53,$53,$49,$47,$4E
	.byte	$20,$43,$3A,$3D,$46,$44,$30,$3A,$09,$28,$61,$73,$73,$69,$67,$6E
	.byte	$20,$43,$3A,$20,$74,$6F,$20,$66,$6C,$6F,$70,$70,$79,$20,$75,$6E
	.byte	$69,$74,$20,$30,$29,$20,$0A,$0D,$00
L00F9:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$41,$53,$53,$49,$47,$4E
	.byte	$20,$2F,$3F,$09,$09,$28,$64,$69,$73,$70,$6C,$61,$79,$20,$76,$65
	.byte	$72,$73,$69,$6F,$6E,$20,$61,$6E,$64,$20,$75,$73,$61,$67,$65,$29
	.byte	$20,$0A,$0D,$00
L0114:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$50,$50,$49,$44,$45,$31
	.byte	$3A,$20,$53,$45,$43,$4F,$4E,$44,$41,$52,$59,$20,$50,$50,$49,$44
	.byte	$45,$20,$46,$49,$58,$45,$44,$20,$44,$49,$53,$4B,$0A,$0D,$00
L011A:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$2F,$33,$35,$20,$20,$20
	.byte	$20,$20,$33,$2E,$35,$20,$49,$4E,$43,$48,$20,$46,$4C,$4F,$50,$50
	.byte	$59,$20,$28,$44,$45,$46,$41,$55,$4C,$54,$29,$0A,$0D,$00
L013A:
	.byte	$41,$73,$73,$69,$67,$6E,$65,$64,$20,$64,$72,$69,$76,$65,$20,$6D
	.byte	$75,$73,$74,$20,$62,$65,$20,$69,$6E,$20,$74,$68,$65,$20,$72,$61
	.byte	$6E,$67,$65,$20,$6F,$66,$20,$41,$2D,$48,$2E,$0A,$0D,$00
L0111:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$50,$50,$49,$44,$45,$30
	.byte	$3A,$20,$50,$52,$49,$4D,$41,$52,$59,$20,$50,$50,$49,$44,$45,$20
	.byte	$46,$49,$58,$45,$44,$20,$44,$49,$53,$4B,$0A,$0D,$00
L010E:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$46,$44,$31,$3A,$20,$20
	.byte	$20,$20,$46,$4C,$4F,$50,$50,$59,$20,$44,$49,$53,$4B,$20,$55,$4E
	.byte	$49,$54,$20,$31,$0A,$0D,$00
L010B:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$46,$44,$30,$3A,$20,$20
	.byte	$20,$20,$46,$4C,$4F,$50,$50,$59,$20,$44,$49,$53,$4B,$20,$55,$4E
	.byte	$49,$54,$20,$30,$0A,$0D,$00
L011D:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$2F,$35,$32,$35,$20,$20
	.byte	$20,$20,$35,$2E,$32,$35,$20,$49,$4E,$43,$48,$20,$46,$4C,$4F,$50
	.byte	$50,$59,$0A,$0D,$00
L00B5:
	.byte	$0A,$0D,$20,$44,$4F,$53,$2F,$36,$35,$20,$44,$72,$69,$76,$65,$20
	.byte	$61,$73,$73,$69,$67,$6E,$6D,$65,$6E,$74,$3A,$0A,$0D,$00
L0108:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$4D,$44,$31,$3A,$20,$20
	.byte	$20,$20,$52,$4F,$4D,$20,$44,$49,$53,$4B,$0A,$0D,$00
L0105:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$4D,$44,$30,$3A,$20,$20
	.byte	$20,$20,$52,$41,$4D,$20,$44,$49,$53,$4B,$0A,$0D,$00
L01A4:
	.byte	$55,$6E,$6B,$6F,$77,$6E,$20,$64,$65,$76,$69,$63,$65,$20,$61,$73
	.byte	$73,$69,$67,$6E,$6D,$65,$6E,$74,$2E,$20,$0A,$0D,$00
L0102:
	.byte	$0A,$0D,$20,$50,$4F,$53,$53,$49,$42,$4C,$45,$20,$44,$45,$56,$49
	.byte	$43,$45,$53,$3A,$0A,$0D,$00
L0117:
	.byte	$0A,$0D,$20,$50,$4F,$53,$53,$49,$42,$4C,$45,$20,$46,$4C,$41,$47
	.byte	$53,$3A,$0A,$0D,$00
L01C2:
	.byte	$43,$68,$61,$6E,$67,$65,$64,$20,$74,$6F,$3A,$20,$20,$25,$63,$3A
	.byte	$3D,$00
L013D:
	.byte	$43,$75,$72,$72,$65,$6E,$74,$6C,$79,$3A,$20,$20,$20,$25,$63,$3A
	.byte	$3D,$00
L00F0:
	.byte	$20,$55,$73,$61,$67,$65,$3A,$20,$0A,$0D,$00
L00E8:
	.byte	$55,$4E,$4B,$4E,$4F,$57,$4E,$00
L0199:
	.byte	$50,$50,$49,$44,$45,$31,$3A,$00
L018E:
	.byte	$50,$50,$49,$44,$45,$30,$3A,$00
L00DA	:=	L00E8+0
L01DB:
	.byte	$28,$37,$32,$30,$4B,$29,$00
L01D7:
	.byte	$28,$33,$36,$30,$4B,$29,$00
L0145:
	.byte	$3A,$25,$75,$20,$0A,$0D,$00
L00C2	:=	L01C2+11
L00E4:
	.byte	$50,$50,$49,$44,$45,$00
L00CA:
	.byte	$3A,$25,$69,$0A,$0D,$00
L01D3:
	.byte	$2F,$35,$32,$35,$00
L0150:
	.byte	$4D,$44,$30,$3A,$00
L015B:
	.byte	$4D,$44,$31,$3A,$00
L0166:
	.byte	$46,$44,$30,$3A,$00
L0171	:=	L01D3+0
L017A:
	.byte	$46,$44,$31,$3A,$00
L0185	:=	L01D3+0
L01CA:
	.byte	$3A,$25,$75,$20,$00
L00DF:
	.byte	$46,$44,$00
L01DE	:=	L00F3+63
L00D5:
	.byte	$4D,$44,$00
L00EB:
	.byte	$25,$69,$00
L01A9	:=	L0199+6
L00A7	:=	L01C2+16
L0099	:=	L01C2+16
L008A	:=	L01CA+3
L0085	:=	L01CA+3
L0080	:=	L01CA+3
L01AE	:=	L0199+6

; ---------------------------------------------------------------
; void __near__ prtusage (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_prtusage: near

.segment	"CODE"

	lda     #<(L00F0)
	ldx     #>(L00F0)
	jsr     _cputs
	lda     #<(L00F3)
	ldx     #>(L00F3)
	jsr     _cputs
	lda     #<(L00F6)
	ldx     #>(L00F6)
	jsr     _cputs
	lda     #<(L00F9)
	ldx     #>(L00F9)
	jsr     _cputs
	lda     #<(L00FC)
	ldx     #>(L00FC)
	jsr     _cputs
	lda     #<(L00FF)
	ldx     #>(L00FF)
	jsr     _cputs
	lda     #<(L0102)
	ldx     #>(L0102)
	jsr     _cputs
	lda     #<(L0105)
	ldx     #>(L0105)
	jsr     _cputs
	lda     #<(L0108)
	ldx     #>(L0108)
	jsr     _cputs
	lda     #<(L010B)
	ldx     #>(L010B)
	jsr     _cputs
	lda     #<(L010E)
	ldx     #>(L010E)
	jsr     _cputs
	lda     #<(L0111)
	ldx     #>(L0111)
	jsr     _cputs
	lda     #<(L0114)
	ldx     #>(L0114)
	jsr     _cputs
	lda     #<(L0117)
	ldx     #>(L0117)
	jsr     _cputs
	lda     #<(L011A)
	ldx     #>(L011A)
	jsr     _cputs
	lda     #<(L011D)
	ldx     #>(L011D)
	jmp     _cputs

.endproc

; ---------------------------------------------------------------
; void __near__ prtdevice (unsigned char)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_prtdevice: near

.segment	"CODE"

	jsr     pusha
	lda     (sp)
	and     #$F0
	beq     L00D3
	cmp     #$10
	beq     L00D8
	cmp     #$20
	beq     L00DD
	cmp     #$30
	beq     L00E2
	bra     L00E6
L00D3:	lda     #<(L00D5)
	ldx     #>(L00D5)
	jsr     _cputs
	bra     L00D1
L00D8:	lda     #<(L00DA)
	ldx     #>(L00DA)
	jsr     _cputs
	jmp     incsp1
L00DD:	lda     #<(L00DF)
	ldx     #>(L00DF)
	jsr     _cputs
	bra     L00D1
L00E2:	lda     #<(L00E4)
	ldx     #>(L00E4)
	jsr     _cputs
	bra     L00D1
L00E6:	lda     #<(L00E8)
	ldx     #>(L00E8)
	jsr     _cputs
	jmp     incsp1
L00D1:	lda     #<(L00EB)
	ldx     #>(L00EB)
	jsr     pushax
	ldy     #$02
	lda     (sp),y
	and     #$0F
	jsr     pusha0
	ldy     #$04
	jsr     _cprintf
	jmp     incsp1

.endproc

; ---------------------------------------------------------------
; void __near__ prttable (__near__ unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_prttable: near

.segment	"CODE"

	jsr     pushax
	jsr     decsp2
	lda     #<(L00B5)
	ldx     #>(L00B5)
	jsr     _cputs
	ldx     #$00
	txa
L01F4:	jsr     stax0sp
	cmp     #$10
	txa
	sbc     #$00
	bvc     L00BE
	eor     #$80
L00BE:	bpl     L00B8
	lda     #<(L00C2)
	ldx     #>(L00C2)
	jsr     pushax
	ldy     #$03
	jsr     ldaxysp
	jsr     asrax1
	ldy     #$41
	jsr     incaxy
	jsr     pushax
	ldy     #$04
	jsr     _cprintf
	ldy     #$05
	jsr     pushwysp
	ldy     #$03
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	ina
	bne     L00C8
	inx
L00C8:	ldy     #$02
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	jsr     tosaddax
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	jsr     _prtdevice
	lda     #<(L00CA)
	ldx     #>(L00CA)
	jsr     pushax
	ldy     #$03
	jsr     ldaxysp
	clc
	ldy     #$04
	adc     (sp),y
	sta     ptr1
	txa
	iny
	adc     (sp),y
	sta     ptr1+1
	lda     (ptr1)
	jsr     pusha0
	ldy     #$04
	jsr     _cprintf
	jsr     ldax0sp
	ina
	bne     L01F4
	inx
	bra     L01F4
L00B8:	jmp     incsp4

.endproc

; ---------------------------------------------------------------
; int __near__ parsecmd (__near__ unsigned char *, __near__ unsigned char *, __near__ unsigned char *, __near__ unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_parsecmd: near

.segment	"CODE"

	jsr     pushax
	jsr     push0
	ldy     #$09
	jsr     ldaxysp
	jsr     decax1
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	jsr     pusha
	jsr     decsp4
	ldy     #$0C
	jsr     ldaxysp
	sta     ptr1
	stx     ptr1+1
	lda     #$00
	sta     (ptr1)
	ldy     #$0A
	jsr     ldaxysp
	sta     ptr1
	stx     ptr1+1
	lda     #$00
	sta     (ptr1)
	ldy     #$08
	jsr     ldaxysp
	sta     ptr1
	stx     ptr1+1
	lda     #$00
	sta     (ptr1)
	ldy     #$04
	lda     (sp),y
	cmp     #$80
	bcc     L0076
	lda     #$7F
	sta     (sp),y
L0076:	lda     (sp),y
	clc
	ldy     #$0D
	adc     (sp),y
	sta     ptr1
	lda     #$00
	iny
	adc     (sp),y
	sta     ptr1+1
	lda     #$00
	sta     (ptr1)
	ldy     #$10
	jsr     pushwysp
	lda     #<(L0080)
	ldx     #>(L0080)
	jsr     _strtok
	ldy     #$02
	jsr     staxysp
	jsr     push0
	lda     #<(L0085)
	ldx     #>(L0085)
	jsr     _strtok
	ldy     #$02
	jsr     staxysp
	jsr     push0
	lda     #<(L008A)
	ldx     #>(L008A)
	jsr     _strtok
	jsr     stax0sp
	cpx     #$00
	bne     L01F5
	cmp     #$00
	beq     L008C
L01F5:	ldy     #$0A
	jsr     pushwysp
	ldy     #$05
	jsr     pushwysp
	ldx     #$00
	lda     #$05
	jsr     _strncpy
L008C:	ldy     #$02
	lda     (sp),y
	iny
	ora     (sp),y
	beq     L00A9
	ldy     #$05
	jsr     pushwysp
	lda     #<(L0099)
	ldx     #>(L0099)
	jsr     _strtok
	ldy     #$02
	jsr     staxysp
	cpx     #$00
	bne     L01F6
	cmp     #$00
	beq     L00A9
L01F6:	ldy     #$0E
	jsr     pushwysp
	ldy     #$07
	jsr     pushwysp
	ldx     #$00
	lda     #$1D
	jsr     _strncpy
	ldx     #$00
	lda     #$01
	ldy     #$05
	jsr     staxysp
	jsr     push0
	lda     #<(L00A7)
	ldx     #>(L00A7)
	jsr     _strtok
	ldy     #$02
	jsr     staxysp
	cpx     #$00
	bne     L01F7
	cmp     #$00
	beq     L00A9
L01F7:	ldy     #$0C
	jsr     pushwysp
	ldy     #$07
	jsr     pushwysp
	ldx     #$00
	lda     #$1D
	jsr     _strncpy
	ldx     #$00
	lda     #$02
	ldy     #$05
	jsr     staxysp
L00A9:	ldy     #$06
	jsr     ldaxysp
	ldy     #$0F
	jmp     addysp

.endproc

; ---------------------------------------------------------------
; void __near__ mapdrive (__near__ unsigned char *, __near__ unsigned char *, __near__ unsigned char *, __near__ unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_mapdrive: near

.segment	"CODE"

	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	ldx     #$00
	and     #$5F
	ldy     #$41
	jsr     decaxy
	jsr     pusha
	lda     #$FF
	jsr     pusha
	jsr     decsp4
	lda     #$00
	jsr     pusha
	ldy     #$06
	lda     (sp),y
	cmp     #$08
	bcc     L0134
	lda     #<(L013A)
	ldx     #>(L013A)
	jmp     L01FE
L0134:	lda     #<(L013D)
	ldx     #>(L013D)
	jsr     pushax
	ldy     #$08
	ldx     #$00
	lda     (sp),y
	ldy     #$41
	jsr     incaxy
	jsr     pushax
	ldy     #$04
	jsr     _cprintf
	ldx     #$00
	ldy     #$06
	lda     (sp),y
	asl     a
	bcc     L0200
	inx
	clc
L0200:	ldy     #$0D
	adc     (sp),y
	sta     ptr1
	txa
	iny
	adc     (sp),y
	sta     ptr1+1
	lda     (ptr1)
	jsr     _prtdevice
	lda     #<(L0145)
	ldx     #>(L0145)
	jsr     pushax
	ldx     #$00
	ldy     #$08
	lda     (sp),y
	asl     a
	bcc     L0201
	inx
	clc
L0201:	ldy     #$0F
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ina
	bne     L014A
	inx
L014A:	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	jsr     pusha0
	ldy     #$04
	jsr     _cprintf
	ldy     #$0A
	jsr     ldaxysp
	jsr     _toupper
	ldy     #$0C
	jsr     pushwysp
	lda     #<(L0150)
	ldx     #>(L0150)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L014D
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_ramdcb)
	ldx     #>(_ramdcb)
	jsr     _updatedosmap
L014D:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L015B)
	ldx     #>(L015B)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L0158
	ina
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_romdcb)
	ldx     #>(_romdcb)
	jsr     _updatedosmap
L0158:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L0166)
	ldx     #>(L0166)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L016E
	lda     #$20
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_floppy35720dcb)
	ldx     #>(_floppy35720dcb)
	jsr     _updatedosmap
	ldy     #$0A
	jsr     pushwysp
	lda     #<(L0171)
	ldx     #>(L0171)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L016E
	ldy     #$06
	lda     (sp),y
	jsr     pusha
	lda     #<(_floppy525360dcb)
	ldx     #>(_floppy525360dcb)
	jsr     _updatedosmap
L016E:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L017A)
	ldx     #>(L017A)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L0182
	lda     #$21
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_floppy35720dcb)
	ldx     #>(_floppy35720dcb)
	jsr     _updatedosmap
	ldy     #$0A
	jsr     pushwysp
	lda     #<(L0185)
	ldx     #>(L0185)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L0182
	ldy     #$06
	lda     (sp),y
	jsr     pusha
	lda     #<(_floppy525360dcb)
	ldx     #>(_floppy525360dcb)
	jsr     _updatedosmap
L0182:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L018E)
	ldx     #>(L018E)
	jsr     pushax
	ldx     #$00
	lda     #$07
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L018B
	lda     #$30
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_hdddcb)
	ldx     #>(_hdddcb)
	jsr     _updatedosmap
L018B:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L0199)
	ldx     #>(L0199)
	jsr     pushax
	ldx     #$00
	lda     #$07
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L0196
	lda     #$31
	ldy     #$05
	sta     (sp),y
	iny
	lda     (sp),y
	jsr     pusha
	lda     #<(_ramdcb)
	ldx     #>(_ramdcb)
	jsr     _updatedosmap
L0196:	ldy     #$05
	lda     (sp),y
	cmp     #$FF
	bne     L01A1
	lda     #<(L01A4)
	ldx     #>(L01A4)
	jsr     pushax
	ldy     #$02
	jsr     _cprintf
	jmp     L012E
L01A1:	ldy     #$0C
	jsr     pushwysp
	lda     #<(L01A9)
	ldx     #>(L01A9)
	jsr     _strtok
	ldy     #$03
	jsr     staxysp
	jsr     push0
	lda     #<(L01AE)
	ldx     #>(L01AE)
	jsr     _strtok
	ldy     #$03
	jsr     staxysp
	cpx     #$00
	bne     L0207
	cmp     #$00
	beq     L0208
L0207:	ldy     #$06
	jsr     pushwysp
	lda     #$03
	jsr     leaa0sp
	jsr     pushax
	ldx     #$00
	lda     #$0A
	jsr     _strtoul
	sta     (sp)
	ldx     #$00
L0208:	ldy     #$06
	lda     (sp),y
	asl     a
	bcc     L0202
	inx
	clc
L0202:	ldy     #$0D
	adc     (sp),y
	sta     ptr1
	txa
	iny
	adc     (sp),y
	sta     ptr1+1
	ldy     #$05
	lda     (sp),y
	sta     (ptr1)
	ldx     #$00
	iny
	lda     (sp),y
	asl     a
	bcc     L0203
	inx
	clc
L0203:	ldy     #$0D
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ina
	bne     L01BF
	inx
L01BF:	sta     ptr1
	stx     ptr1+1
	lda     (sp)
	sta     (ptr1)
	lda     #<(L01C2)
	ldx     #>(L01C2)
	jsr     pushax
	ldy     #$08
	ldx     #$00
	lda     (sp),y
	ldy     #$41
	jsr     incaxy
	jsr     pushax
	ldy     #$04
	jsr     _cprintf
	ldx     #$00
	ldy     #$06
	lda     (sp),y
	asl     a
	bcc     L0204
	inx
	clc
L0204:	ldy     #$0D
	adc     (sp),y
	sta     ptr1
	txa
	iny
	adc     (sp),y
	sta     ptr1+1
	lda     (ptr1)
	jsr     _prtdevice
	lda     #<(L01CA)
	ldx     #>(L01CA)
	jsr     pushax
	ldx     #$00
	ldy     #$08
	lda     (sp),y
	asl     a
	bcc     L0205
	inx
	clc
L0205:	ldy     #$0F
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ina
	bne     L01CF
	inx
L01CF:	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	jsr     pusha0
	ldy     #$04
	jsr     _cprintf
	ldy     #$0A
	jsr     pushwysp
	lda     #<(L01D3)
	ldx     #>(L01D3)
	jsr     pushax
	ldx     #$00
	lda     #$04
	jsr     _strncmp
	stx     tmp1
	ora     tmp1
	bne     L01D0
	lda     #<(L01D7)
	ldx     #>(L01D7)
	bra     L01FF
L01D0:	lda     #<(L01DB)
	ldx     #>(L01DB)
L01FF:	jsr     _cputs
	lda     #<(L01DE)
	ldx     #>(L01DE)
L01FE:	jsr     _cputs
L012E:	ldy     #$0F
	jmp     addysp

.endproc

; ---------------------------------------------------------------
; void __near__ updatedosmap (unsigned char, unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_updatedosmap: near

.segment	"CODE"

	jsr     pushax
	lda     $002E
	ldx     $002E+1
	jsr     pushax
	ldx     #$00
	ldy     #$04
	lda     (sp),y
	asl     a
	bcc     L020A
	inx
	clc
L020A:	adc     (sp)
	pha
	txa
	ldy     #$01
	adc     (sp),y
	tax
	pla
	ldy     #$10
	jsr     decaxy
	jsr     pushw
	jsr     decsp2
	ldx     #$00
	txa
L020C:	jsr     stax0sp
	cmp     #$09
	txa
	sbc     #$00
	bvc     L01EC
	eor     #$80
L01EC:	bpl     L01E6
	jsr     ldax0sp
	clc
	ldy     #$02
	adc     (sp),y
	sta     sreg
	txa
	iny
	adc     (sp),y
	sta     sreg+1
	jsr     ldax0sp
	clc
	ldy     #$06
	adc     (sp),y
	sta     ptr1
	txa
	iny
	adc     (sp),y
	sta     ptr1+1
	lda     (ptr1)
	sta     (sreg)
	jsr     ldax0sp
	ina
	bne     L020C
	inx
	bra     L020C
L01E6:	ldy     #$09
	jmp     addysp

.endproc

; ---------------------------------------------------------------
; void __near__ toupper (__near__ unsigned char *)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_toupper: near

.segment	"CODE"

	jsr     pushax
	bra     L0122
L0120:	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	cmp     #$61
	bcc     L0124
	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	cmp     #$7B
	bcs     L0124
	jsr     ldax0sp
	sta     sreg
	stx     sreg+1
	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	and     #$5F
	sta     (sreg)
L0124:	jsr     ldax0sp
	ina
	bne     L012D
	inx
L012D:	jsr     stax0sp
L0122:	jsr     ldax0sp
	sta     ptr1
	stx     ptr1+1
	lda     (ptr1)
	bne     L0120
	jmp     incsp2

.endproc

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	lda     $002E
	ldx     $002E+1
	jsr     pushax
	lda     $0030
	ldx     $0030+1
	jsr     pushax
	ldy     #$5C
	jsr     subysp
	lda     $0030
	ldx     $0030+1
	jsr     pushax
	lda     #$3E
	jsr     leaa0sp
	jsr     pushax
	lda     #$22
	jsr     leaa0sp
	jsr     pushax
	lda     #$06
	jsr     leaa0sp
	jsr     _parsecmd
	ldy     #$5A
	jsr     staxysp
	cpx     #$00
	bne     L0058
	cmp     #$00
	beq     L005A
	cmp     #$01
	beq     L005E
	cmp     #$02
	beq     L0061
	bra     L0210
L005A:	ldy     #$5F
	jsr     ldaxysp
	jsr     _prttable
	bra     L0058
L005E:	jsr     _prtusage
	bra     L0058
L0061:	ldy     #$61
	jsr     pushwysp
	lda     #$3E
	jsr     leaa0sp
	jsr     pushax
	lda     #$22
	jsr     leaa0sp
	jsr     pushax
	lda     #$06
	jsr     leaa0sp
	jsr     _mapdrive
L0058:	ldx     #$00
L0210:	txa
	ldy     #$60
	jmp     addysp

.endproc

