#include<mips/regdef.h>
#include<sys/syscall.h>

#####		ENCODING		#####
	.text
	.align	2
	.globl	byte_encoder
	.ent	byte_encoder

byte_encoder:    # void byte_encoder (char* valorHexa, unsigned int numInt)

########## STACK FRAME ##########
#define BE_FSIZE 16

########## CALLER ARGS ##########
#define BE_FRAME_A1 20
#define BE_FRAME_A0 16

##########     SRA     ##########
#define BE_FRAME_FP 12
#define BE_FRAME_GP 8

##########     LTA     ##########
#define BE_FRAME_LNIBBLE 4
#define BE_FRAME_HNIBBLE 0

##########     ABA     ##########
# no hay por ser funcion leaf

	.frame	$fp, BE_FSIZE, ra		# (2 SRA + 2 LTA) * 4 bytes
	subu	sp, sp, BE_FSIZE
	
	sw	$fp, BE_FRAME_FP(sp)		# guardo fp en BE_FRAME_FP + sp
	sw	gp, BE_FRAME_GP(sp)			# guardo gp en BE_FRAME_GP + sp
	move	$fp, sp					# llevo fp a la pos del sp
	
	# Argumento de funcion
	sw	a0, BE_FRAME_A0($fp)		# a0: char* valorHexa
	sw	a1, BE_FRAME_A1($fp)		# a1: unsigned int numInt
	
	andi	t0, a1, 0xf0			# t0 = highNibble de numInt
	sra	t0, t0, 4					# highNibble >> 4
	sw	t0, BE_FRAME_HNIBBLE($fp)	# guardo la variable local en el SFrame
	
	andi	t1, a1, 0x0f			# t1 = lowNibble de numInt
	sw	t1, BE_FRAME_LNIBBLE($fp)	# guardo la variable local t1 en el stack frame

	lb	t2, vecHexa(t0)				# t2 = vecHexa[t0]; -> t2: primer caracter hexa
	sb	t2, 0(a0)					# a0[0] = t2; es decir: valorHexa[0] = t2
	
	lw	a0, BE_FRAME_A0($fp)		# tengo a0 nuevamente char* valorHexa (por seguridad)

	lb	t3, vecHexa(t1)				# t3 = vecHexa[t1]; -> t3: segundo caracter hexa
	sb	t3, 1(a0)					# a0[1] = t3; es decir: valorHexa[1] = t3
	
	lw	$fp, BE_FRAME_FP(sp)		# recupero fp
	addu	sp, sp, BE_FSIZE		# destruyo el stack frame
	
	jr	ra
	
	.end	byte_encoder
	.size	byte_encoder, .-byte_encoder



	.align	2
	.globl	encode
	.ent	encode
	
encode:								# int encode (int infd, int outfd)

########## STACK FRAME ##########
#define ENC_FSIZE 48

########## CALLER ARGS ##########
#define ENC_FRAME_A1 52
#define ENC_FRAME_A0 48

##########     SRA     ##########
# se agrega un word de padding
#define ENC_FRAME_RA 40
#define ENC_FRAME_FP 36
#define ENC_FRAME_GP 32

##########     LTA     ##########
# el siguiente string tiene dos caracteres
#define ENC_FRAME_STRING 24
#define ENC_FRAME_BYTES 20
#define ENC_FRAME_CARACTER 16

##########     ABA     ##########
#define ENC_FRAME_ARG3 12
#define ENC_FRAME_ARG2 8
#define ENC_FRAME_ARG1 4
#define ENC_FRAME_ARG0 0

	.frame	$fp, ENC_FSIZE, ra
	subu	sp, sp, ENC_FSIZE
	.cprestore	ENC_FRAME_GP
	sw	ra, ENC_FRAME_RA(sp)
	sw	$fp, ENC_FRAME_FP(sp)
	move	$fp, sp
	
	sw	a0, ENC_FRAME_A0($fp)
	sw	a1, ENC_FRAME_A1($fp)
	sw	zero, ENC_FRAME_CARACTER($fp)	# caracter = 0
	
read_y_loop:
	addu a1,$fp,ENC_FRAME_CARACTER		# a1 = &caracter
	li	a2,1							# a2 = 1, para leer un byte
	li	v0,	SYS_read					# read: a0=infd, a1=&caracter, a2=1
	syscall								# en v0 = cantidad de bytes que leo o negativo si hubo error
	bltz	v0, error_read				# salto si hubo un error de lectura
	
	bgtz	v0, while_encode			# entro al while si es > 0 (si es 0, es eof)
	b	return_encode					# salta en caso de que sea menor o igual a 0
	
while_encode:
	sw	v0, ENC_FRAME_BYTES($fp)		# salvo v0 por llamada de funcion de byte_encoder
	addu a0, $fp, ENC_FRAME_STRING		# a0 = $fp + ENC_FRAME_STRING (inicio del char*)
	lw	a1, ENC_FRAME_CARACTER($fp)		# a1 = caracter leido
	la	t9, byte_encoder				# carga en t9 donde esta byte_encoder
	jal	t9								# salta a byte_encoder

	lw	a0, ENC_FRAME_A1($fp)			# en a0 tengo outfd
	addu a1, $fp, ENC_FRAME_STRING		# a1 = $fp + ENC_FRAME_STRING (inicio del char*)
	li	a2, 2							# cargo en a2 el 2, para escribir dos bytes
	li	v0, SYS_write					# llamo a write
	syscall
	bltz	v0, error_write				# si es menor a 0, hubo un error de escritura
	
	lw	a0, ENC_FRAME_A0($fp)			# a0 = infd
	b read_y_loop

error_write:
	sub	v0, zero, 2						# error2: -2
	sw	v0, ENC_FRAME_BYTES($fp)
	b return_encode

error_read:
	sub	v0, zero, 1						# error1: -1
	sw	v0, ENC_FRAME_BYTES($fp)
	
return_encode:
	lw  v0, ENC_FRAME_BYTES($fp)
	lw	ra, ENC_FRAME_RA(sp)
	lw	$fp, ENC_FRAME_FP(sp)
	addu	sp,sp, ENC_FSIZE
	
	jr	ra
	
	.end	encode
	.size	encode, .-encode
	
	.rdata
	.align	2
	.size	vecHexa, 16
vecHexa:
	.byte	48				#'0'
	.byte	49				#'1'
	.byte	50				#'2'
	.byte	51				#'3'
	.byte	52				#'4'
	.byte	53				#'5'
	.byte	54				#'6'
	.byte	55				#'7'
	.byte	56				#'8'
	.byte	57				#'9'
	.byte	65				#'A'
	.byte	66				#'B'
	.byte	67				#'C'
	.byte	68				#'D'
	.byte	69				#'E'
	.byte	70				#'F'
	
#####		DECODING		#####
	.text
	.align	2
	.globl	correrReferencia
	.ent	correrReferencia
	
correrReferencia:					# int correrReferencia  (int numInt)

########## STACK FRAME ##########
#define CR_FSIZE 8

########## CALLER ARGS ##########
#define CR_FRAME_A0 8

##########     SRA     ##########
#define CR_FRAME_FP 4
#define CR_FRAME_GP 0

	.frame	$fp, CR_FSIZE, ra			
	subu	sp, sp, CR_FSIZE
	sw	$fp, CR_FRAME_FP(sp)
	sw	gp, CR_FRAME_GP(sp)
	move	$fp,sp
	
	sw	a0, CR_FRAME_A0($fp)		# En a0 tengo el parametro numInt
	
	slt t0, a0, 58					# si numInt < 58 -> t0 = 1
	sgt t1, a0, 47					# si numInt > 47 -> t1 = 1
	and t0,	t0, t1 					# si t0 and t1 = 1 -> t0 = 1
	beqz t0, comparacion2			# si no esta en ese rango se compara en siguiente
	lw v0, CR_FRAME_A0($fp)			# se almacena en v0 el a0=numInt
	sub v0, v0, 48					# se tiene en v0 = numInt - 48
	b return
				
comparacion2:
	slt t0, a0, 71					# idem al anterior con otro rango	
	sgt t1, a0, 64
	and t0,	t0, t1 
	beqz t0, comparacion3
	lw v0, CR_FRAME_A0($fp)
	sub v0, v0, 55
	b return
	
comparacion3:
	slt t0, a0, 103					# idem al anterior con otro rango	
	sgt t1, a0, 96
	and t0,	t0, t1 
	beqz t0,error_caracterNoHexa
	lw v0, CR_FRAME_A0($fp)
	sub v0, v0, 87
	b return
	
error_caracterNoHexa:
	sub	v0, zero, 3					# error3: -3
	
return:
	lw	$fp, CR_FRAME_FP(sp)
	addu	sp, sp, CR_FSIZE
	jr	ra
	.end	correrReferencia
	.size	correrReferencia, .-correrReferencia
	
	
	
	.align	2
	.globl	byte_decoder
	.ent	byte_decoder
	
byte_decoder:						# int byte_decoder (int numPri, int numSeg)

########## STACK FRAME ##########
#define BD_FSIZE 40

########## CALLER ARGS ##########
#define BD_FRAME_A1 44
#define BD_FRAME_A0 40

##########     SRA     ##########
# se agrega un word de padding
#define BD_FRAME_RA 32
#define BD_FRAME_FP 28
#define BD_FRAME_GP 24

##########     LTA     ##########
#define BD_FRAME_LNIBBLE 20
#define BD_FRAME_HNIBBLE 16

##########     ABA     ##########
#define BD_FRAME_ARG3 12
#define BD_FRAME_ARG2 8
#define BD_FRAME_ARG1 4
#define BD_FRAME_ARG0 0

	.frame	$fp, BD_FSIZE, ra
	subu	sp, sp, BD_FSIZE
	.cprestore BD_FRAME_GP
	
	sw	ra, BD_FRAME_RA(sp)
	sw	$fp, BD_FRAME_FP(sp)
	move	$fp, sp
		
	sw	a0, BD_FRAME_A0($fp)			# en a0 tengo numPri
	sw	a1, BD_FRAME_A1($fp)			# en a1 tengo numSeg
	
	la	t9, correrReferencia
	jal	t9
	sw	v0, BD_FRAME_HNIBBLE($fp) 		# highNibble = correrReferencia (numPri)
	bltz	v0, returnValor				# si es menor a 0 -> error, fin decode
	
	lw	a0, BD_FRAME_A1($fp)			# cargo en a0 el numSeg
	la	t9, correrReferencia
	jal	t9
	sw	v0, BD_FRAME_LNIBBLE($fp)		# lowNibble = correrReferencia(numSeg)
	bltz	v0, returnValor				# si es menor a 0 -> error, fin decode
	
	lw		t0, BD_FRAME_HNIBBLE($fp)
	sll		t0, t0, 4					# t0 = highNibble << 4
	andi	t0,t0,0xf0					# aseguro ceros en nibble menos significativo
	lw		t1, BD_FRAME_LNIBBLE($fp)	# t1 = lowNibble
	andi	t1, t1, 0xf					# aseguro ceros en nibble mas significativo
	or		v0, t0, t1					# v0 = highNibble | lowNibble
	
returnValor:
	lw	ra, BD_FRAME_RA(sp)
	lw	$fp, BD_FRAME_FP(sp)
	addu	sp, sp, BD_FSIZE
	jr	ra
	.end	byte_decoder
	.size	byte_decoder, .-byte_decoder
	
	
	
	.align	2
	.globl	decode
	.ent	decode
	
decode:

########## STACK FRAME ##########
#define DEC_FSIZE 48

########## CALLER ARGS ##########
#define DEC_FRAME_A1 52
#define DEC_FRAME_A0 48

##########     SRA     ##########
# se agrega un word de padding
#define DEC_FRAME_RA 40
#define DEC_FRAME_FP 36
#define DEC_FRAME_GP 32

##########     LTA     ##########
#define DEC_FRAME_C 28
#define DEC_FRAME_CARACTER2 24
#define DEC_FRAME_BYTES 20
#define DEC_FRAME_CARACTER 16

##########     ABA     ##########
#define DEC_FRAME_ARG3 12
#define DEC_FRAME_ARG2 8
#define DEC_FRAME_ARG1 4
#define DEC_FRAME_ARG0 0

	.frame	$fp, DEC_FSIZE, ra			# 56
	subu	sp, sp, DEC_FSIZE
	.cprestore DEC_FRAME_GP				# 40
	sw	ra, DEC_FRAME_RA(sp)			# 48
	sw	$fp, DEC_FRAME_FP(sp)			# 44
	sw	gp, DEC_FRAME_GP(sp)			# 40
	move	$fp, sp
	
	sw	a0, DEC_FRAME_A0($fp)			# en a0 tengo infd			
	sw	a1, DEC_FRAME_A1($fp)			# en a1 tengo outfd
	sw	zero, DEC_FRAME_C($fp)			# c = 0
	sw	zero, DEC_FRAME_CARACTER2($fp)	# caracter2 = 0
	sw	zero, DEC_FRAME_CARACTER($fp)	# caracter = 0
	
read_y_loop_decode:
	addu a1, $fp, DEC_FRAME_CARACTER	# a1 = &caracter
	li	a2, 1							# cargo a2 con 1, para leer un byte
	li	v0, SYS_read					# llama a read(a0,a1,a2) -> resultado en v0
	syscall
	bltz	v0, error_read_decode		# si v0 < 0 hubo error en lectura
	
	bgtz	v0, while_decode			# entro al while si es > 0 (si es 0, es eof)
	b	return_decode

while_decode:
	lw	a0, DEC_FRAME_A0($fp)			# a0 = infd
	addu  a1, $fp, DEC_FRAME_CARACTER2	# a1 = &caracter2
	li	a2, 1							# a2 = 1, para leer un byte
	li	v0, SYS_read					# llama a read(a0,a1,a2) -> resultado v0
	syscall
	bltz	v0, error_read_decode		# si v0 < 0, hubo error de lectura
	sw	v0, DEC_FRAME_BYTES($fp)		# bytesLeidos = v0
	
	lw	a0, DEC_FRAME_CARACTER($fp)		# a0 = caracter 
	lw	a1, DEC_FRAME_CARACTER2($fp)	# a1 = caracter2
	la	t9, byte_decoder
	jal	t9
	sw	v0,	DEC_FRAME_C($fp)			# c = byte_encoder(a0,a1)
	bltz	v0, return_decode			# si c < 0 -> error: caracter no hexa

	lw	a0, DEC_FRAME_A1($fp)			# a0 = outfd
	addu a1, $fp, DEC_FRAME_C			# a1 = &c
	li	a2, 1							# a2 = 1, para escribir un byte
	li	v0, SYS_write					# llama a write(outfd,&c,1) -> resultado v0
	syscall
	bltz	v0, error_write_decode		# si v0 < 0, hubo error de escritura
	
	lw	a0, DEC_FRAME_A0($fp)			# a0 = infd
	b	read_y_loop_decode

error_read_decode:
	sub	v0, zero, 1						# error1: -1
	b	return_decode
	
error_write_decode:
	sub	v0, zero, 2						# error2: -2

return_decode:
	lw	ra, DEC_FRAME_RA(sp)
	lw	$fp, DEC_FRAME_FP(sp)
	addu	sp, sp, DEC_FSIZE
	jr	ra
	.end	decode
	.size	decode, .-decode



.globl	b16_errmsg
	.rdata
	.align	2

#########		b16_errmg		#########

b16_errmsg: .word noerror, error1, error2, error3
	
	.size b16_errmsg, 16
	.align 0

noerror: .asciiz "Sin Errores\n\000"
error1: .asciiz "Error al leer el archivo de entrada\n\000"
error2: .asciiz "Error al escribir el archivo de salida\n\000"
error3: .asciiz "Contiene caracteres que no pertenecen al codigo Hexa\n\000"
