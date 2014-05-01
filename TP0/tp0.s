	.file	1 "tp0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.data
	.type	encoderActivo, @object
	.size	encoderActivo, 1
encoderActivo:
	.byte	1
	.align	2
	.type	vecHexa, @object
	.size	vecHexa, 16
vecHexa:
	.byte	48
	.byte	49
	.byte	50
	.byte	51
	.byte	52
	.byte	53
	.byte	54
	.byte	55
	.byte	56
	.byte	57
	.byte	65
	.byte	66
	.byte	67
	.byte	68
	.byte	69
	.byte	70
	.rdata
	.align	2
$LC0:
	.ascii	"version\000"
	.align	2
$LC1:
	.ascii	"help\000"
	.align	2
$LC2:
	.ascii	"input\000"
	.align	2
$LC3:
	.ascii	"output\000"
	.align	2
$LC4:
	.ascii	"action\000"
	.data
	.align	2
	.type	long_options, @object
	.size	long_options, 96
long_options:
	.word	$LC0
	.word	0
	.word	0
	.word	118
	.word	$LC1
	.word	0
	.word	0
	.word	104
	.word	$LC2
	.word	1
	.word	0
	.word	105
	.word	$LC3
	.word	1
	.word	0
	.word	111
	.word	$LC4
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
	.frame	$fp,32,$ra		# vars= 16, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,32
	.cprestore 0
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,32($fp)
	sw	$a1,36($fp)
	lw	$v0,36($fp)
	andi	$v0,$v0,0xf0
	sw	$v0,8($fp)
	lw	$v0,36($fp)
	andi	$v0,$v0,0xf
	sw	$v0,12($fp)
	lw	$v0,8($fp)
	sra	$v0,$v0,4
	sw	$v0,16($fp)
	lw	$v0,12($fp)
	sw	$v0,20($fp)
	lw	$a0,32($fp)
	lw	$v1,16($fp)
	la	$v0,vecHexa
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,32($fp)
	addu	$a0,$v0,1
	lw	$v1,20($fp)
	la	$v0,vecHexa
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,32($fp)
	addu	$v0,$v0,2
	sb	$zero,0($v0)
	move	$sp,$fp
	lw	$fp,28($sp)
	addu	$sp,$sp,32
	j	$ra
	.end	encoder
	.size	encoder, .-encoder
	.rdata
	.align	2
$LC5:
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
	la	$a1,$LC5
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
$LC6:
	.ascii	"Error al leer el archivo de entrada\n\000"
	.text
	.align	2
	.globl	leer
	.ent	leer
leer:
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
	lw	$a0,48($fp)
	la	$t9,fgetc
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,48($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,6
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L27
	la	$a0,__sF+176
	la	$a1,$LC6
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L27:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	leer
	.size	leer, .-leer
	.rdata
	.align	2
$LC7:
	.ascii	"Error al escribir el archivo de salida\n\000"
	.text
	.align	2
	.globl	escribir_error
	.ent	escribir_error
escribir_error:
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
	la	$a0,__sF+176
	la	$a1,$LC7
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
	.end	escribir_error
	.size	escribir_error, .-escribir_error
	.align	2
	.globl	procesarArchivos
	.ent	procesarArchivos
procesarArchivos:
	.frame	$fp,64,$ra		# vars= 24, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,64
	.cprestore 16
	sw	$ra,56($sp)
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,64($fp)
	sw	$a1,68($fp)
	lw	$a0,64($fp)
	la	$t9,leer
	jal	$ra,$t9
	sw	$v0,32($fp)
$L30:
	lw	$v1,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L32
	b	$L31
$L32:
	lbu	$v0,encoderActivo
	beq	$v0,$zero,$L33
	addu	$v0,$fp,40
	move	$a0,$v0
	lw	$a1,32($fp)
	la	$t9,encoder
	jal	$ra,$t9
	addu	$v0,$fp,40
	move	$a0,$v0
	lw	$a1,68($fp)
	la	$t9,fputs
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L35
	la	$t9,escribir_error
	jal	$ra,$t9
	b	$L35
$L33:
	lw	$a0,64($fp)
	la	$t9,leer
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$a0,32($fp)
	lw	$a1,28($fp)
	la	$t9,decoder
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$a0,24($fp)
	lw	$a1,68($fp)
	la	$t9,fputc
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L35
	la	$t9,escribir_error
	jal	$ra,$t9
$L35:
	lw	$a0,64($fp)
	la	$t9,leer
	jal	$ra,$t9
	sw	$v0,32($fp)
	b	$L30
$L31:
	lw	$v1,64($fp)
	la	$v0,__sF
	beq	$v1,$v0,$L37
	lw	$a0,64($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L37:
	lw	$v1,68($fp)
	la	$v0,__sF+88
	beq	$v1,$v0,$L29
	lw	$a0,68($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L29:
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	procesarArchivos
	.size	procesarArchivos, .-procesarArchivos
	.rdata
	.align	2
$LC8:
	.ascii	"encode\000"
	.align	2
$LC9:
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
	la	$a1,$LC8
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L40
	li	$v0,1			# 0x1
	sb	$v0,encoderActivo
$L40:
	lw	$a0,40($fp)
	la	$a1,$LC9
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L39
	sb	$zero,encoderActivo
$L39:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	comprobarAction
	.size	comprobarAction, .-comprobarAction
	.rdata
	.align	2
$LC10:
	.ascii	"Usage:\n\000"
	.align	2
$LC11:
	.ascii	"\t ./tp0 -h\n\000"
	.align	2
$LC12:
	.ascii	"\t ./tp0 -v\n\000"
	.align	2
$LC13:
	.ascii	"Options:\n\000"
	.align	2
$LC14:
	.ascii	"\t -v, --version, Shows the version of TP. \n\000"
	.align	2
$LC15:
	.ascii	"\t -h, --help , Show help \n\000"
	.align	2
$LC16:
	.ascii	"\t -i, --input, Location of the input file\n\000"
	.align	2
$LC17:
	.ascii	"\t -o, --output, Location of the output file\n\000"
	.align	2
$LC18:
	.ascii	"\t -a, --action, Program action: encode (default) or dec"
	.ascii	"ode \n\000"
	.align	2
$LC19:
	.ascii	"Example: \n\000"
	.align	2
$LC20:
	.ascii	"\t ./tp0 -a encode -i /input -o /output -h\n\000"
	.align	2
$LC21:
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
	la	$a0,$LC10
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC11
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC12
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC13
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC14
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC15
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC16
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC17
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC18
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC19
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC20
	la	$t9,printf
	jal	$ra,$t9
	la	$a0,$LC21
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
$LC22:
	.ascii	"vhi:o:a:\000"
	.align	2
$LC23:
	.ascii	"66.20-Organizacion de Computadoras TP Version 0.0\n\000"
	.align	2
$LC24:
	.ascii	"r\000"
	.align	2
$LC25:
	.ascii	"Error al abrir el archivo input %s\n\000"
	.align	2
$LC26:
	.ascii	"w\000"
	.align	2
$LC27:
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
	sw	$a2,72($fp)
	sw	$a3,76($fp)
	sw	$zero,32($fp)
	addu	$v0,$fp,32
	sw	$v0,16($sp)
	lw	$a0,64($fp)
	lw	$a1,68($fp)
	la	$a2,$LC22
	la	$a3,long_options
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,36($fp)
$L44:
	lw	$v1,36($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L46
	b	$L45
$L46:
	lw	$v0,36($fp)
	addu	$v0,$v0,-97
	sw	$v0,44($fp)
	lw	$v1,44($fp)
	sltu	$v0,$v1,22
	beq	$v0,$zero,$L47
	lw	$v0,44($fp)
	sll	$v1,$v0,2
	la	$v0,$L56
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L56:
	.gpword	$L54
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L49
	.gpword	$L50
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L52
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L47
	.gpword	$L48
	.text
$L48:
	la	$a0,$LC23
	la	$t9,printf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,40($fp)
	b	$L43
$L49:
	la	$t9,imprimirAyuda
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,40($fp)
	b	$L43
$L50:
	lw	$a0,optarg
	la	$a1,$LC24
	la	$t9,fopen
	jal	$ra,$t9
	move	$v1,$v0
	lw	$v0,72($fp)
	sw	$v1,0($v0)
	lw	$v0,72($fp)
	lw	$v0,0($v0)
	bne	$v0,$zero,$L47
	la	$a0,__sF+176
	la	$a1,$LC25
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L52:
	lw	$a0,optarg
	la	$a1,$LC26
	la	$t9,fopen
	jal	$ra,$t9
	move	$v1,$v0
	lw	$v0,76($fp)
	sw	$v1,0($v0)
	lw	$v0,76($fp)
	lw	$v0,0($v0)
	bne	$v0,$zero,$L47
	la	$a0,__sF+176
	la	$a1,$LC27
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L54:
	lw	$a0,optarg
	la	$t9,comprobarAction
	jal	$ra,$t9
$L47:
	addu	$v0,$fp,32
	sw	$v0,16($sp)
	lw	$a0,64($fp)
	lw	$a1,68($fp)
	la	$a2,$LC22
	la	$a3,long_options
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,36($fp)
	b	$L44
$L45:
	sw	$zero,40($fp)
$L43:
	lw	$v0,40($fp)
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	opciones
	.size	opciones, .-opciones
	.align	2
	.globl	main
	.ent	main
main:
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
	la	$v0,__sF
	sw	$v0,24($fp)
	la	$v0,__sF+88
	sw	$v0,28($fp)
	addu	$v0,$fp,28
	lw	$a0,56($fp)
	lw	$a1,60($fp)
	addu	$a2,$fp,24
	move	$a3,$v0
	la	$t9,opciones
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	bne	$v0,$zero,$L58
	lw	$a0,24($fp)
	lw	$a1,28($fp)
	la	$t9,procesarArchivos
	jal	$ra,$t9
$L58:
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
