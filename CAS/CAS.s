	.text
	.file	"CAS.c"
	.globl	atomic_cas                      # -- Begin function atomic_cas
	.p2align	4, 0x90
	.type	atomic_cas,@function
atomic_cas:                             # @atomic_cas
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movl	-16(%rbp), %ecx
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	#APP
	lock		cmpxchgl	%ecx, (%rdx)
	#NO_APP
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	atomic_cas, .Lfunc_end0-atomic_cas
	.cfi_endproc
                                        # -- End function
	.globl	thread_func                     # -- Begin function thread_func
	.p2align	4, 0x90
	.type	thread_func,@function
thread_func:                            # @thread_func
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	shared_var(%rip), %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	movl	-12(%rbp), %esi
	movl	-16(%rbp), %edx
	leaq	shared_var(%rip), %rdi
	callq	atomic_cas
	cmpl	-12(%rbp), %eax
	je	.LBB1_3
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
	movl	shared_var(%rip), %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)
	jmp	.LBB1_1
.LBB1_3:
	xorl	%eax, %eax
                                        # kill: def $rax killed $eax
	addq	$16, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	thread_func, .Lfunc_end1-thread_func
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movl	$0, -4(%rbp)
	movl	$0, -36(%rbp)
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	cmpl	$2, -36(%rbp)
	jge	.LBB2_4
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	movslq	-36(%rbp), %rax
	leaq	-32(%rbp), %rdi
	shlq	$3, %rax
	addq	%rax, %rdi
	xorl	%eax, %eax
	movl	%eax, %ecx
	leaq	thread_func(%rip), %rdx
	movq	%rcx, %rsi
	callq	pthread_create@PLT
# %bb.3:                                #   in Loop: Header=BB2_1 Depth=1
	movl	-36(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -36(%rbp)
	jmp	.LBB2_1
.LBB2_4:
	movl	$0, -40(%rbp)
.LBB2_5:                                # =>This Inner Loop Header: Depth=1
	cmpl	$2, -40(%rbp)
	jge	.LBB2_8
# %bb.6:                                #   in Loop: Header=BB2_5 Depth=1
	movslq	-40(%rbp), %rax
	movq	-32(%rbp,%rax,8), %rdi
	xorl	%eax, %eax
	movl	%eax, %esi
	callq	pthread_join@PLT
# %bb.7:                                #   in Loop: Header=BB2_5 Depth=1
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -40(%rbp)
	jmp	.LBB2_5
.LBB2_8:
	movl	shared_var(%rip), %esi
	leaq	.L.str(%rip), %rdi
	movb	$0, %al
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$48, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.type	shared_var,@object              # @shared_var
	.bss
	.globl	shared_var
	.p2align	2
shared_var:
	.long	0                               # 0x0
	.size	shared_var, 4

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"shared_var: %d\n"
	.size	.L.str, 16

	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym atomic_cas
	.addrsig_sym thread_func
	.addrsig_sym pthread_create
	.addrsig_sym pthread_join
	.addrsig_sym printf
	.addrsig_sym shared_var
