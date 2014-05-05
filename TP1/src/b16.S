#include<mips/regdef.h>
#include<sys/syscall.h>

#####		ENCODE		#####
	.text
	.align	2
	.globl	byte_encoder
	.ent	byte_encoder

byte_encoder:						# void byte_encoder (char* valorHexa, unsigned int numInt)

########## STACK FRAME ##########
#define BE_FSIZE 16

########## CALLER ARGS ##########
#define BE_FRAME_A1 20
#define BE_FRAME_A0 16

##########	   SRA     ##########
#define BE_FRAME_FP 12
#define BE_FRAME_GP 8

##########     LTA     ##########
#define BE_FRAME_LNIBBLE 4
#define BE_FRAME_HNIBBLE 0

	.frame	$fp, BE_FSIZE, ra		# (2 SRA + 2 LTA) * 4 bytes; no hay ABA por ser funcion leaf
	subu	sp, sp, BE_FSIZE
	
	sw	$fp, BE_FRAME_FP(sp)		# guardo fp en BE_FRAME_FP + sp
	sw	gp, BE_FRAME_GP(sp)			# guardo gp en BE_FRAME_GP + sp
	move	$fp, sp					# llevo fp a la pos del sp
	
	# Argumento de funcion
	sw	a0, BE_FRAME_A0($fp)    	# a0: char* valorHexa
	sw	a1, BE_FRAME_A1($fp)    	# a1: unsigned int numInt
	
	andi	t0, a1, 0xf0			# t0 = highNibble de numInt
	sra	t0, t0, 4					# highNibble >> 4
	sw	t0, BE_FRAME_HNIBBLE($fp)	# guardo la variable local t0 en el stack frame
	
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

##########	   SRA     ##########
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

	.frame	$fp, ENC_FSIZE, ra		# 56
	subu	sp, sp, ENC_FSIZE
	.cprestore	ENC_FRAME_GP		# 40
	sw	ra, ENC_FRAME_RA(sp)		# 48
	sw	$fp, ENC_FRAME_FP(sp)		# 44
	move	$fp, sp
	
	sw	a0, ENC_FRAME_A0($fp)		# 56
	sw	a1, ENC_FRAME_A1($fp)		# 60
	sw	zero, ENC_FRAME_CARACTER($fp)	# caracter = 0
	
read_y_loop:
	addu a1,$fp,ENC_FRAME_CARACTER	# en a1 tengo &caracter ya que esa es la direccion de caracter=0 
	li	a2,1						# cargo a2 con 1, para leer un byte
	li	v0,	SYS_read				# tengo los 3 argumento del read: a0=infd, a1=&caracter, a2=1
	syscall							# en v0 tengo la cantidad de bytes que leo o negativo si hubo error
	
	bltz	v0, error_read			# salto si hubo un error de lectura
	
loop:
	bgtz	v0, while_encode		# entro al while si es mayor a 0 (en este caso si es 0, es eof)
	b	return_encode				# salta en caso de que sea menor o igual a 0
	
while_encode:
	sw	v0, ENC_FRAME_BYTES($fp)	# salvo v0 por llamada de funcion de byte_encoder
	addu a0, $fp, ENC_FRAME_STRING	# cargo en a0 la direccion $fp + ENC_FRAME_STRING (comienzo del char*)
	lw	a1, ENC_FRAME_CARACTER($fp)	# a1 = caracter leido
	la	t9, byte_encoder			# carga en t9 donde esta byte_encoder
	jal	t9							# salta a byte_encoder
	
#	lw v0, 28($fp)			#cargo en v0, lo que tenia en v0 antes de llamar a byte_encoder			 !!!!!!!!!

	lw	a0, ENC_FRAME_A1($fp)		# en a0 tengo outfd
	addu a1, $fp, ENC_FRAME_STRING	# cargo en a1 la direccion $fp + ENC_FRAME_STRING (comienzo del char*)
	li	a2, 2						# cargo en a2 el 2, para escribir dos bytes
	li	v0, SYS_write				# llamo a write
	syscall
	
	bltz	v0, error_write			# si es menor a 0, hubo un error de escritura
	
	lw	a0, ENC_FRAME_A0($fp)		# cargo a0 con infd
	b read_y_loop

error_write:
	li	v0,-499
	sw	v0, ENC_FRAME_BYTES($fp)	# 28
	b return_encode

error_read:
	li	v0,-500				
	sw	v0, ENC_FRAME_BYTES($fp)	# 28
	
return_encode:
	lw  v0, ENC_FRAME_BYTES($fp)	# 28
#	move	sp,$fp
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
	
############	DECODE 	#########
	.text
	.align	2
	.globl	correrReferencia
	.ent	correrReferencia
	
correrReferencia:
	.frame	$fp, 24, ra			
	subu	sp, sp, 24
	#.cprestore 0
	sw	$fp, 20(sp)
	sw	gp,16(sp)
	move	$fp,sp
	
	sw	a0, 24($fp)			#En a0 tengo el parametro numInt
	
	slt t0, a0, 58			#si numInt < 58 => t0 = 1
	sgt t1, a0, 47			#si numInt > 47	=> t1 = 1
	and t0,	t0, t1 			#si t0 and t1 = 1 => t0 =1
	beqz t0, comparacion2	#si no esta en ese rango se compara en siguiente
	lw v0, 24($fp)			#se almacena en v0 el a0=nunInt
	addu v0, v0, -48		#se tiene en v0 = numInt - 48
	b return
				
comparacion2:
	slt t0, a0, 71			#idem al anterior con otro rango	
	sgt t1, a0, 64
	and t0,	t0, t1 
	beqz t0, comparacion3
	lw v0, 24($fp)
	addu v0, v0, -55
	b return
	
comparacion3:
	slt t0, a0, 103			#idem al anterior con otro rango	
	sgt t1, a0, 96
	and t0,	t0, t1 
	beqz t0,error_caracterNoHexa
	lw v0, 24($fp)
	addu v0, v0,-87
	b return
	
error_caracterNoHexa:
	li v0, -498
	
return:
	move	sp, $fp
	lw	$fp, 20(sp)
	addu	sp, sp, 24
	j	ra
	.end	correrReferencia
	.size	correrReferencia, .-correrReferencia
	
	.align	2
	.globl	byte_decoder
	.ent	byte_decoder
	
byte_decoder:
	.frame	$fp, 36, ra			
	subu	sp, sp, 36
	.cprestore 32
	
	sw	ra, 28(sp)
	sw	$fp, 24(sp)	
	move	$fp, sp
		
	sw	a0, 36($fp)				#en a0 tengo numPri
	sw	a1, 40($fp)				#en a1 tengo numSeg
	
	la	t9,correrReferencia		#corroreReferencia(numPri)
	jal	t9
	sw	v0,16($fp) 				
	bgez	v0,label1			#si es mayor o igual a 0 =>label1
	lw	v0, 16($fp)				#guardo valor1 en 16+$fp
	b	returnValor	
label1:
	lw	a0,40($fp)				#cargo en a0 el numSeg
	la	t9,correrReferencia		#corroReferencia(numSeg)
	jal	t9
	sw	v0,20($fp)				#guardo valor2 en 20+$fp
	bgez	v0, label2			#si es mayor o igual a 0 =>label2
	b	returnValor
label2:
	lw	v0, 16($fp)				#en v0 tengo valor1
	sll	v0, v0, 4				#en v0 = v0 << 4
	andi	t0,v0,0xf0			#highNibble t0 = v0 and 0xf0
	lw	v0, 20($fp)				#en v0 tengo valor2
	andi	v0, v0, 0xf			#en v0 tengo valor2 & 0xF
	or	v0,v0,t0				#en v0 tengo v0 or t0
returnValor:
	move	sp, $fp
	lw	ra, 28(sp)
	lw	$fp, 24(sp)
	addu	sp, sp, 36
	j	ra
	.end	byte_decoder
	.size	byte_decoder, .-byte_decoder
	
	.align	2
	.globl	decode
	.ent	decode
decode:
	.frame	$fp, 56, ra		
	subu	sp, sp, 56
	.cprestore 40
	sw	ra, 48(sp)
	sw	$fp, 44(sp)
	sw	gp, 40(sp)
	move	$fp, sp
	
	sw	a0, 56($fp)				#en a0 tengo infd			
	sw	a1, 60($fp)				#en a1 tengo outfd
	sw	zero, 24($fp)			#guardo c= zero en 24+fp
	sw	zero, 28($fp)			#guardo caracter2= zero en 28+fp
	sw	zero, 32($fp)			#guardo caracter=zero en 24+fp
	
	addu	a1, $fp, 32			#en a1 tengo la direccion de caracter &caracter
	li	a2, 1					#cargo en a2=1
	li	v0, SYS_read			#llama a read(a0,a1,a2) =>resultado en v0
	syscall				
	
	bltz	v0, error_read_decode		#si v0 < 0 hubo error en lectura
	b loop_decode
	
error_read_decode:
	li	v0, -500	
	b	return_decode
	
error_caracter_NoHexa:
	b return_decode
	
error_write_decode:
	li	v0,-499			# 0xfffffffffffffe0d
	b	return_decode
	
loop_decode:
	bgtz	v0, label1_decode
	b	return_decode

label1_decode:
	addu  a1, $fp, 28		#en v0 $fp+28 tengo &caracter2 
	lw	a0, 56($fp)			#en a0 tengo infd
	li	a2, 1				#cargo en a2=1
	li	v0, SYS_read		#llamo a read(a0,a1,a2) =>resultado v0
	syscall
	
	bltz	v0, error_read_decode

	lw	a0, 32($fp)			#cargo en a0 =caracter 
	lw	a1, 28($fp)			#cargo en en a1=caracter2
	sw	v0,36($fp)			#guardo v0 por el sig jal
	la	t9, byte_decoder	#llamo a byte_encoder(a0,a1)
	jal	t9
	sw	v0,	24($fp)			#guardo vo en 24+fp = c
	bltz	v0, error_caracter_NoHexa

	lw	a0,60($fp)			#cargo en a0 outff
	addu	a1,$fp,24		#cargo en a1 = &c
	li	a2,1				#cargo en a2 = 1
	li	v0,SYS_write		#llamo write(outfd,&c,1)
	syscall
	
	bltz	v0, error_write_decode		
	
	addu	a1, $fp, 32		#cargo	a1 el &caracter 32+fp  
	lw	a0, 56($fp)			#cargo en a0 infd
	li	a2,1			
	li	v0, SYS_read		#llamo a  read(a0,a1,a2) =>resultado v0
	syscall
	
	bltz	v0,error_read_decode
	b	loop_decode

return_decode:	
	move	sp, $fp
	lw	ra, 48(sp)
	lw	$fp, 44(sp)
	addu	sp, sp, 56
	j	ra	
	.end	decode
	.size	decode, .-decode

.globl	b16_errmsg
	.rdata
	.align	2

#######		b16_errmg		#########

b16_errmsg: .word error1, error2, error3
	
	.size b16_errmsg, 12
	.align 0

error1: .asciiz "Error al leer el archivo de entrada\n\000"
error2: .asciiz "Error al escribir el archivo de salida\n\000"
error3: .asciiz "Contiene caracteres que no pertenecen al codigo Hexa\n\000"

