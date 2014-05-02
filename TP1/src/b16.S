#include<mips/regdef.h>
#include<sys/syscall.h>

	.section .mdebug.abi32
	.previous
	.abicalls
	.data
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
	.text
	.align	2
	.globl	byte_encoder
	.ent	byte_encoder
byte_encoder:
	.frame	$fp,32,ra		# vars= 16, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,32
	.cprestore 0
	sw	$fp,28(sp)
	sw	gp,24(sp)
	move	$fp,sp
	sw	a0,32($fp)
	sw	a1,36($fp)
	lw	v0,36($fp)
	andi	v0,v0,0xf0
	sw	v0,8($fp)
	lw	v0,36($fp)
	andi	v0,v0,0xf
	sw	v0,12($fp)
	lw	v0,8($fp)
	sra	v0,v0,4
	sw	v0,16($fp)
	lw	v0,12($fp)
	sw	v0,20($fp)
	lw	a0,32($fp)
	lw	v1,16($fp)
	la	v0,vecHexa
	addu	v0,v1,v0
	lbu	v0,0(v0)
	sb	v0,0(a0)
	lw	v0,32($fp)
	addu	a0,v0,1
	lw	v1,20($fp)
	la	v0,vecHexa
	addu	v0,v1,v0
	lbu	v0,0(v0)
	sb	v0,0(a0)
	move	sp,$fp
	lw	$fp,28(sp)
	addu	sp,sp,32
	j	ra
	.end	byte_encoder
	.size	byte_encoder, .-byte_encoder
	.align	2
	.globl	encode
	.ent	encode
encode:
	.frame	$fp,56,ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,56
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
	bgez	v0,$L15
	li	v0,-500			# 0xfffffffffffffe0c
	sw	v0,28($fp)
$L15:
	.set	noreorder
	nop
	.set	reorder
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
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
