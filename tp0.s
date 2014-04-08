	.file	1 "tp0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	encoderActivo
	.data
	.type	encoderActivo, @object
	.size	encoderActivo, 1
encoderActivo:
	.byte	1
	.globl	decoderActivo
	.globl	decoderActivo
	.section	.bss
	.align	0
	.type	decoderActivo, @object
	.size	decoderActivo, 1
decoderActivo:
	.space	1
	.globl	finput
	.globl	finput
	.align	2
	.type	finput, @object
	.size	finput, 4
finput:
	.space	4
	.globl	foutput
	.globl	foutput
	.align	2
	.type	foutput, @object
	.size	foutput, 4
foutput:
	.space	4
	.rdata
	.align	2
$LC0:
	.ascii	"0\000"
	.align	2
$LC1:
	.ascii	"1\000"
	.align	2
$LC2:
	.ascii	"2\000"
	.align	2
$LC3:
	.ascii	"3\000"
	.align	2
$LC4:
	.ascii	"4\000"
	.align	2
$LC5:
	.ascii	"5\000"
	.align	2
$LC6:
	.ascii	"6\000"
	.align	2
$LC7:
	.ascii	"7\000"
	.align	2
$LC8:
	.ascii	"8\000"
	.align	2
$LC9:
	.ascii	"9\000"
	.align	2
$LC10:
	.ascii	"A\000"
	.align	2
$LC11:
	.ascii	"B\000"
	.align	2
$LC12:
	.ascii	"C\000"
	.align	2
$LC13:
	.ascii	"D\000"
	.align	2
$LC14:
	.ascii	"E\000"
	.align	2
$LC15:
	.ascii	"F\000"
	.globl	vecHexa
	.data
	.align	2
	.type	vecHexa, @object
	.size	vecHexa, 64
vecHexa:
	.word	$LC0
	.word	$LC1
	.word	$LC2
	.word	$LC3
	.word	$LC4
	.word	$LC5
	.word	$LC6
	.word	$LC7
	.word	$LC8
	.word	$LC9
	.word	$LC10
	.word	$LC11
	.word	$LC12
	.word	$LC13
	.word	$LC14
	.word	$LC15
	.rdata
	.align	2
$LC16:
	.ascii	"version\000"
	.align	2
$LC17:
	.ascii	"help\000"
	.align	2
$LC18:
	.ascii	"input\000"
	.align	2
$LC19:
	.ascii	"output\000"
	.align	2
$LC20:
	.ascii	"action\000"
	.data
	.align	2
	.type	long_options, @object
	.size	long_options, 96
long_options:
	.word	$LC16
	.word	0
	.word	0
	.word	118
	.word	$LC17
	.word	0
	.word	0
	.word	104
	.word	$LC18
	.word	1
	.word	0
	.word	105
	.word	$LC19
	.word	1
	.word	0
	.word	111
	.word	$LC20
	.word	1
	.word	0
	.word	97
	.word	0
	.word	0
	.word	0
	.word	0
	.text
	.align	2
	.globl	encoder
	.ent	encoder
encoder:
	.frame	$fp,72,$ra		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$ra,64($sp)
	sw	$fp,60($sp)
	sw	$gp,56($sp)
	move	$fp,$sp
	sw	$a0,72($fp)
	lw	$v0,72($fp)
	andi	$v0,$v0,0xf0
	sw	$v0,24($fp)
	lw	$v0,72($fp)
	andi	$v0,$v0,0xf
	sw	$v0,28($fp)
	lw	$v0,24($fp)
	sra	$v0,$v0,4
	sw	$v0,32($fp)
	lw	$v0,28($fp)
	sw	$v0,36($fp)
	lw	$v0,32($fp)
	sll	$v1,$v0,2
	la	$v0,vecHexa
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	sw	$v0,40($fp)
	lw	$v0,36($fp)
	sll	$v1,$v0,2
	la	$v0,vecHexa
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	sw	$v0,44($fp)
	li	$a0,3			# 0x3
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,48($fp)
	lw	$a0,48($fp)
	lw	$a1,40($fp)
	la	$t9,strcpy
	jal	$ra,$t9
	lw	$a0,48($fp)
	lw	$a1,44($fp)
	la	$t9,strcat
	jal	$ra,$t9
	lw	$v0,48($fp)
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	encoder
	.size	encoder, .-encoder
	.rdata
	.align	2
$LC21:
	.ascii	"Contiene caracteres que no pertenecen al codigo Hexa\n\000"
	.text
	.align	2
	.globl	correrReferencia
	.ent	correrReferencia
correrReferencia:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	lw	$v0,48($fp)
	slt	$v0,$v0,48
	bne	$v0,$zero,$L19
	lw	$v0,48($fp)
	slt	$v0,$v0,58
	beq	$v0,$zero,$L19
	lw	$v0,48($fp)
	addu	$v0,$v0,-48
	sw	$v0,24($fp)
	b	$L18
$L19:
	lw	$v0,48($fp)
	slt	$v0,$v0,65
	bne	$v0,$zero,$L21
	lw	$v0,48($fp)
	slt	$v0,$v0,71
	beq	$v0,$zero,$L21
	lw	$v0,48($fp)
	addu	$v0,$v0,-55
	sw	$v0,24($fp)
	b	$L18
$L21:
	lw	$v0,48($fp)
	slt	$v0,$v0,97
	bne	$v0,$zero,$L23
	lw	$v0,48($fp)
	slt	$v0,$v0,103
	beq	$v0,$zero,$L23
	lw	$v0,48($fp)
	addu	$v0,$v0,-87
	sw	$v0,24($fp)
	b	$L18
$L23:
	la	$a0,__sF+176
	la	$a1,$LC21
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L18:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	correrReferencia
	.size	correrReferencia, .-correrReferencia
	.align	2
	.globl	decoder
	.ent	decoder
decoder:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	lw	$a0,56($fp)
	la	$t9,correrReferencia
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$a0,60($fp)
	la	$t9,correrReferencia
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$v0,24($fp)
	sll	$v0,$v0,4
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	andi	$v0,$v0,0xf0
	sw	$v0,32($fp)
	lw	$v0,28($fp)
	andi	$v0,$v0,0xf
	sw	$v0,28($fp)
	lbu	$v1,32($fp)
	lbu	$v0,28($fp)
	or	$v0,$v1,$v0
	sb	$v0,36($fp)
	lb	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	decoder
	.size	decoder, .-decoder
	.rdata
	.align	2
$LC22:
	.ascii	"%s\000"
	.align	2
$LC23:
	.ascii	"%c\000"
	.text
	.align	2
	.globl	procesarArchivos
	.ent	procesarArchivos
procesarArchivos:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	lw	$a0,56($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,36($fp)
$L27:
	lw	$v1,36($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L29
	b	$L28
$L29:
	lbu	$v0,encoderActivo
	beq	$v0,$zero,$L30
	lw	$a0,36($fp)
	la	$t9,encoder
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,60($fp)
	beq	$v0,$zero,$L31
	lw	$a0,24($fp)
	lw	$a1,60($fp)
	la	$t9,fputs
	jal	$ra,$t9
	b	$L32
$L31:
	la	$a0,$LC22
	lw	$a1,24($fp)
	la	$t9,printf
	jal	$ra,$t9
$L32:
	lw	$a0,24($fp)
	la	$t9,free
	jal	$ra,$t9
	b	$L33
$L30:
	lw	$a0,56($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$a0,36($fp)
	lw	$a1,32($fp)
	la	$t9,decoder
	jal	$ra,$t9
	sb	$v0,28($fp)
	lw	$v0,60($fp)
	beq	$v0,$zero,$L34
	lb	$v0,28($fp)
	move	$a0,$v0
	lw	$a1,60($fp)
	la	$t9,fputc
	jal	$ra,$t9
	b	$L33
$L34:
	lb	$v0,28($fp)
	la	$a0,$LC23
	move	$a1,$v0
	la	$t9,printf
	jal	$ra,$t9
$L33:
	lw	$a0,56($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,36($fp)
	b	$L27
$L28:
	lw	$a0,56($fp)
	la	$t9,fclose
	jal	$ra,$t9
	lw	$v0,60($fp)
	beq	$v0,$zero,$L26
	lw	$a0,60($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L26:
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	procesarArchivos
	.size	procesarArchivos, .-procesarArchivos
	.align	2
	.globl	EntradaEncoderStandar
	.ent	EntradaEncoderStandar
EntradaEncoderStandar:
	.frame	$fp,72,$ra		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$ra,64($sp)
	sw	$fp,60($sp)
	sw	$gp,56($sp)
	move	$fp,$sp
	move	$a0,$zero
	la	$t9,isatty
	jal	$ra,$t9
	sltu	$v0,$zero,$v0
	sb	$v0,24($fp)
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L38
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,40($fp)
	b	$L39
$L38:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,40($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L39:
	lw	$v0,40($fp)
	sw	$v0,28($fp)
	sb	$zero,44($fp)
	lw	$v1,28($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L42
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L42
	b	$L41
$L42:
	lw	$v1,28($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L40
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L41
	b	$L40
$L41:
	li	$v0,1			# 0x1
	sb	$v0,44($fp)
$L40:
	lbu	$v0,44($fp)
	sb	$v0,32($fp)
$L43:
	lbu	$v0,32($fp)
	beq	$v0,$zero,$L45
	b	$L37
$L45:
	lw	$a0,28($fp)
	la	$t9,encoder
	jal	$ra,$t9
	sw	$v0,36($fp)
	lw	$v0,foutput
	beq	$v0,$zero,$L46
	lw	$a0,foutput
	la	$a1,$LC22
	lw	$a2,36($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	b	$L47
$L46:
	la	$a0,$LC22
	lw	$a1,36($fp)
	la	$t9,printf
	jal	$ra,$t9
$L47:
	lw	$a0,36($fp)
	la	$t9,free
	jal	$ra,$t9
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L48
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,48($fp)
	b	$L49
$L48:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,48($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L49:
	lw	$v0,48($fp)
	sw	$v0,28($fp)
	sb	$zero,52($fp)
	lw	$v1,28($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L52
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L52
	b	$L51
$L52:
	lw	$v1,28($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L50
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L51
	b	$L50
$L51:
	li	$v0,1			# 0x1
	sb	$v0,52($fp)
$L50:
	lbu	$v0,52($fp)
	sb	$v0,32($fp)
	b	$L43
$L37:
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	EntradaEncoderStandar
	.size	EntradaEncoderStandar, .-EntradaEncoderStandar
	.align	2
	.globl	EntradaDecoderStandar
	.ent	EntradaDecoderStandar
EntradaDecoderStandar:
	.frame	$fp,80,$ra		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$ra,72($sp)
	sw	$fp,68($sp)
	sw	$gp,64($sp)
	move	$fp,$sp
	move	$a0,$zero
	la	$t9,isatty
	jal	$ra,$t9
	sltu	$v0,$zero,$v0
	sb	$v0,24($fp)
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L54
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,40($fp)
	b	$L55
$L54:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,40($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L55:
	lw	$v0,40($fp)
	sw	$v0,28($fp)
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L56
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,44($fp)
	b	$L57
$L56:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,44($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L57:
	lw	$v0,44($fp)
	sw	$v0,32($fp)
	sb	$zero,48($fp)
	lw	$v1,28($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L60
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L60
	b	$L59
$L60:
	lw	$v1,28($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L58
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L59
	b	$L58
$L59:
	li	$v0,1			# 0x1
	sb	$v0,48($fp)
$L58:
	lbu	$v0,48($fp)
	sb	$v0,36($fp)
$L61:
	lbu	$v0,36($fp)
	beq	$v0,$zero,$L63
	b	$L53
$L63:
	lw	$a0,28($fp)
	lw	$a1,32($fp)
	la	$t9,decoder
	jal	$ra,$t9
	sb	$v0,37($fp)
	lw	$v0,foutput
	beq	$v0,$zero,$L64
	lb	$v0,37($fp)
	move	$a0,$v0
	lw	$a1,foutput
	la	$t9,fputc
	jal	$ra,$t9
	b	$L65
$L64:
	lb	$v0,37($fp)
	la	$a0,$LC23
	move	$a1,$v0
	la	$t9,printf
	jal	$ra,$t9
$L65:
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L66
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,52($fp)
	b	$L67
$L66:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,52($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L67:
	lw	$v0,52($fp)
	sw	$v0,28($fp)
	sb	$zero,56($fp)
	lw	$v1,28($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L70
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L70
	b	$L69
$L70:
	lw	$v1,28($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L68
	lbu	$v0,24($fp)
	bne	$v0,$zero,$L69
	b	$L68
$L69:
	li	$v0,1			# 0x1
	sb	$v0,56($fp)
$L68:
	lbu	$v0,56($fp)
	sb	$v0,36($fp)
	lbu	$v0,36($fp)
	bne	$v0,$zero,$L61
	lw	$v0,__sF+4
	addu	$v0,$v0,-1
	sw	$v0,__sF+4
	bgez	$v0,$L72
	la	$a0,__sF
	la	$t9,__srget
	jal	$ra,$t9
	sw	$v0,60($fp)
	b	$L73
$L72:
	la	$v0,__sF
	lw	$v1,0($v0)
	move	$a0,$v1
	lbu	$a0,0($a0)
	sw	$a0,60($fp)
	addu	$v1,$v1,1
	sw	$v1,0($v0)
$L73:
	lw	$v0,60($fp)
	sw	$v0,32($fp)
	b	$L61
$L53:
	move	$sp,$fp
	lw	$ra,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$ra
	.end	EntradaDecoderStandar
	.size	EntradaDecoderStandar, .-EntradaDecoderStandar
	.rdata
	.align	2
$LC24:
	.ascii	"encode\000"
	.align	2
$LC25:
	.ascii	"decode\000"
	.text
	.align	2
	.globl	comprobarAction
	.ent	comprobarAction
comprobarAction:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	lw	$a0,40($fp)
	la	$a1,$LC24
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L75
	li	$v0,1			# 0x1
	sb	$v0,encoderActivo
	sb	$zero,decoderActivo
$L75:
	lw	$a0,40($fp)
	la	$a1,$LC25
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L74
	sb	$zero,encoderActivo
	li	$v0,1			# 0x1
	sb	$v0,decoderActivo
$L74:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	comprobarAction
	.size	comprobarAction, .-comprobarAction
	.rdata
	.align	2
$LC26:
	.ascii	"Usage:\n\000"
	.align	2
$LC27:
	.ascii	"\t ./tp0 -h\n\000"
	.align	2
$LC28:
	.ascii	"\t ./tp0 -v\n\000"
	.align	2
$LC29:
	.ascii	"Options:\n\000"
	.align	2
$LC30:
	.ascii	"\t -v, --version, Shows the version of TP. \n\000"
	.align	2
$LC31:
	.ascii	"\t -h, --help , Show help \n\000"
	.align	2
$LC32:
	.ascii	"\t -i, --input, Location of the input file\n\000"
	.align	2
$LC33:
	.ascii	"\t -o, --output, Location of the output file\n\000"
	.align	2
$LC34:
	.ascii	"\t -a, --action, Program action: encode (default) or dec"
	.ascii	"ode \n\000"
	.align	2
$LC35:
	.ascii	"Example: \n\000"
	.align	2
$LC36:
	.ascii	"\t ./tp0 -a encode -i /input -o /output -h\n\000"
	.align	2
$LC37:
	.ascii	"\t ./tp0 -a decode\n\000"
	.text
	.align	2
	.globl	imprimirAyuda
	.ent	imprimirAyuda
imprimirAyuda:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC26
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC27
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC28
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC29
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC30
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC31
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC32
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC33
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC34
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC35
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC36
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC37
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	imprimirAyuda
	.size	imprimirAyuda, .-imprimirAyuda
	.rdata
	.align	2
$LC38:
	.ascii	"vhi:o:a:\000"
	.align	2
$LC39:
	.ascii	"66.20-Organizacion de Computadoras TP Version 0.0\n\000"
	.align	2
$LC40:
	.ascii	"r\000"
	.align	2
$LC41:
	.ascii	"Error al abrir el archivo input %s\n\000"
	.align	2
$LC42:
	.ascii	"w\000"
	.align	2
$LC43:
	.ascii	"Error al abrir el archivo output %s \n\000"
	.text
	.align	2
	.globl	opciones
	.ent	opciones
opciones:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,64
	.cprestore 24
	sw	$ra,56($sp)
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,64($fp)
	sw	$a1,68($fp)
	sw	$zero,32($fp)
	addu	$v0,$fp,32
	sw	$v0,16($sp)
	lw	$a0,64($fp)
	lw	$a1,68($fp)
	la	$a2,$LC38
	la	$a3,long_options
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,36($fp)
$L79:
	lw	$v1,36($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L81
	b	$L80
$L81:
	lw	$v0,36($fp)
	addu	$v0,$v0,-97
	sw	$v0,44($fp)
	lw	$v1,44($fp)
	sltu	$v0,$v1,22
	beq	$v0,$zero,$L82
	lw	$v0,44($fp)
	sll	$v1,$v0,2
	la	$v0,$L91
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L91:
	.gpword	$L89
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L84
	.gpword	$L85
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L87
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L82
	.gpword	$L83
	.text
$L83:
	la	$a0,$LC39
	la	$t9,printf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,40($fp)
	b	$L78
$L84:
	la	$t9,imprimirAyuda
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,40($fp)
	b	$L78
$L85:
	lw	$a0,optarg
	la	$a1,$LC40
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,finput
	lw	$v0,finput
	bne	$v0,$zero,$L82
	la	$a0,__sF+176
	la	$a1,$LC41
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L87:
	lw	$a0,optarg
	la	$a1,$LC42
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,foutput
	lw	$v0,foutput
	bne	$v0,$zero,$L82
	la	$a0,__sF+176
	la	$a1,$LC43
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L89:
	lw	$a0,optarg
	la	$t9,comprobarAction
	jal	$ra,$t9
$L82:
	addu	$v0,$fp,32
	sw	$v0,16($sp)
	lw	$a0,64($fp)
	lw	$a1,68($fp)
	la	$a2,$LC38
	la	$a3,long_options
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,36($fp)
	b	$L79
$L80:
	sw	$zero,40($fp)
$L78:
	lw	$v0,40($fp)
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	opciones
	.size	opciones, .-opciones
	.align	2
	.globl	controlarOpciones
	.ent	controlarOpciones
controlarOpciones:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	lw	$v0,finput
	beq	$v0,$zero,$L93
	lw	$a0,finput
	lw	$a1,foutput
	la	$t9,procesarArchivos
	jal	$ra,$t9
	b	$L92
$L93:
	lbu	$v0,encoderActivo
	beq	$v0,$zero,$L95
	la	$t9,EntradaEncoderStandar
	jal	$ra,$t9
	b	$L92
$L95:
	la	$t9,EntradaDecoderStandar
	jal	$ra,$t9
$L92:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	controlarOpciones
	.size	controlarOpciones, .-controlarOpciones
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$a0,48($fp)
	lw	$a1,52($fp)
	la	$t9,opciones
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	bne	$v0,$zero,$L98
	la	$t9,controlarOpciones
	jal	$ra,$t9
$L98:
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
