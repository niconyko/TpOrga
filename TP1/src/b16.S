#include<mips/regdef.h>
#include<sys/syscall.h>

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
	bgtz	v0,label1		#salgo del while si es mayor a 0 (en este caso si es 0 pq es eof)
	b	return				#salta en caso de que sea menor o igual a0
	
label1:
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
	
label2:
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
	b return

error_read:
	li	v0,-500				
	sw	v0,28($fp)
	
return:
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
