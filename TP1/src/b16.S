#include<mips/regdef.h>
#include<sys/syscall.h>

#####		ENCODE		#####
	.text
	.align	2
	.globl	byte_encoder
	.ent	byte_encoder
	
byte_encoder:
	.frame	$fp, 32, ra		
	subu	sp, sp, 32 
	
	sw	$fp, 28(sp)  		#guardo fp en 28 + sp
	sw	gp, 24(sp)   		#guardo gp en 24 + sp
	move	$fp, sp	 		# llevo fp a la pos del sp
	
	#Argumento de funcion
	sw	a0, 32($fp)    		#a0 char* valorHexa
	sw	a1, 36($fp)    		#uint numInt
	
	andi v0, a1, 0xf0   	# vo = highNible
	andi v1, a1, 0x0f  		#v1 = lowNibble
	
	sra v0, v0, 4   		# highNibble >> 4
	
	la	t0,vecHexa   		#t0 dir de vecHexa  
	addu	v0,v0,t0  		# v0 tengo v0 + vecHexa donde v0=highNibble
	
	lbu	v0,0(v0)    		#cargo el byte en v0 al que apunta dir de v0 + VecHexa
	sb	v0,0(a0)  			#guardo el  byte v0 a lo que apunta a0 --> valorHexa[0]
	
	lw	a0,32($fp)   		#tengo a0 nuevamente char* valorHexa  
	
	addu	a0,a0,1  		# tengo a0 mas 1byte creo tengo valorHexa + 1 -- valorHexa[1]
	
	la	t0,vecHexa   		#t0 dir de vecHexa
	addu	v1,v1,t0  		#vecHexa + v1
	lbu	v1, 0(v1)   		#cargo el byte en a0 de la dir apuntada por vecHexa+1
	sb	v1, 0(a0)   		#guardo v1 en valorHexa[1]
	
	move	sp, $fp  		#muevo sp a donde esta fp
	lw	$fp, 28(sp)  		#recupero fp
	
	addu	sp, sp, 32      
	
	j	ra
	
	.end	byte_encoder
	.size	byte_encoder, .-byte_encoder
	
	.align	2
	.globl	encode
	.ent	encode
	
encode:
	
	.frame	$fp, 56, ra		
	subu	sp, sp, 56
	.cprestore 40 
	sw	ra,48(sp)
	sw	$fp,44(sp)
	move $fp, sp	
	
	sw	a0, 56($fp)
	sw	a1, 60($fp)
	sw	zero, 24($fp)		
	
	addu	a1,$fp,24		#en a1 tengo &caracter ya que ese es la direccion de caracter=0 
	li	a2,1				#cargo a2 con 1,
	li	v0,	SYS_read		#tengo los 3 argumento del read a0=inf, a1=&carac , a2=1
	syscall					#en v0 tengo lo que leo o negativo si hubo error
	
	bltz	v0, error_read	#salto si hubo un error de lectura
	
loop:
	bgtz	v0,label1_encode		#salgo del while si es mayor a 0 (en este caso si es 0 pq es eof)
	b	return_encode			#salta en caso de que sea menor o igual a0
	
label1_encode:
	sw	v0, 28($fp)			#salvo v0 por llamada de funcion de byte_encoder
	addu a0, $fp, 32		#cargo a0 la direccion $fp+32 que es el string char*
	lw	a1, 24($fp)			#carga a1 lo que esta en 24+$fp ya que es caracter read escribe en 24+$fp ya q le pase esa direccion
	la	t9, byte_encoder	#carga en t9 donde esta byte_encoder
	jal	t9					#salta a byte_encoder
	
	lw v0, 28($fp)			#cargo en v0, lo que tenia en v0 antes de llamar a byte_encoder
	addu	a1, $fp, 32		#en a1 tengo la dir $fp+32 que es el char* string
	lw	a0, 60($fp)			#en a0 tengo outfd
	li	a2, 2				#cargo en a2 el 2	
	li	v0,SYS_write		#llamo a write
	syscall
	
	bltz	v0,error_write  #si es menor a 0 hubo un error de escritura
	
	lw	a0,56($fp)			#cargo a0 con infd
	addu	a1,$fp,24		#cargo a1 con &caracter que esta en $fp + 24 
	li	a2,1				#cargo a2 con 1
	li	v0,SYS_read
	syscall
	
	bltz	v0, error_read	#si es menor a 0 error lectura
	b	loop				#sigue con el while si no hubo errores

error_write:
	li	v0,-499				
	sw	v0,28($fp)
	b return_encode

error_read:
	li	v0,-500				
	sw	v0,28($fp)
	
return_encode:
	lw  v0,28($fp)		
	move	sp,$fp
	lw	ra,48(sp)
	lw	$fp,44(sp)
	addu	sp,sp,56
	
	j	ra
	
	.end	encode
	.size	encode, .-encode
	
	.data
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

