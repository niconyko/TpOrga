#include<mips/regdef.h>
#include<sys/syscall.h>
	.text
	.align	2
	.globl	byte_encoder
	.ent	byte_encoder
byte_encoder:
	.frame	$fp, 32, ra		# vars= 16, regs= 2/0, args= 0, extra= 8
	
	subu	sp, sp, 32 
	
	sw	$fp, 28(sp)  		#guardo fp en 28 + sp
	sw	gp, 24(sp)   		#guardo gp en 24 + sp
	move	$fp, sp	 		# llevo fp a la pos del sp
	sw	a0, 32($fp)    		#a0 char* valorHexa
	sw	a1, 36($fp)    		#uint numInt
	
	andi v0, a1, 0xf0   	# vo = highNible
	andi v1, a1, 0x0f  		#v1 = lowNibble
	
	sra v0, v0, 4   		# highNibble >> 4
	
	la	t0,vecHexa   		#t0 dir de vecHexa  
	addu	v0,v0,t0  		# v0 tengo v0 + vecHexa v0 Puede ser 0,1,2,3,..,15
	
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
	.cprestore 16
	sw	ra,48(sp)
	sw	$fp,44(sp)
	sw	gp,40(sp)
	move	$fp,sp
	sw	a0,56($fp)
	sw	a1,60($fp)
	sw	zero,24($fp)
	lw	a0,56($fp)
	addu	a1,$fp,24
	li	a2,1			# 0x1
	la	t9,read
	jal	ra,t9
	sw	v0,28($fp)
	lw	v0,28($fp)
	bgez	v0,$L16
	li	v0,-500			# 0xfffffffffffffe0c
	sw	v0,28($fp)
	
$L16:
	lw	v0,28($fp)
	bgtz	v0,$L18
	b	$L17
$L18:
	addu	v0,$fp,32
	move	a0,v0
	lw	a1,24($fp)
	la	t9,byte_encoder
	jal	ra,t9
	addu	v0,$fp,32
	lw	a0,60($fp)
	move	a1,v0
	li	a2,2			# 0x2
	la	t9,write
	jal	ra,t9
	bgez	v0,$L19
	li	v0,-499			# 0xfffffffffffffe0d
	sw	v0,28($fp)
	b	$L16
$L19:
	lw	a0,56($fp)
	addu	a1,$fp,24
	li	a2,1			# 0x1
	la	t9,read
	jal	ra,t9
	sw	v0,28($fp)
	lw	v0,28($fp)
	bgez	v0,$L16
	li	v0,-500			# 0xfffffffffffffe0c
	sw	v0,28($fp)
	b	$L16
$L17:
	lw	v0,28($fp)
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
