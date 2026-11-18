Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022020;
	b=z0EoZyGt9tpwzxcY5ym/1M+OgA4Tmamf4rIGBKj0ravI/x581t0zFqLdumawUuETT99B
	 PzuES3EBUAfsQlEqjuZG2yGURjUBuYIbE4fCMbErsjqY65bqWFHKYk1L6/Zur1h/BlW2F
	 NyQdYEnNZdwcfETcQWdLQW2N5pnpb/rZG2veoXLRtztT+dE039mYwnX9XCtAjC+O64X1M
	 r88FItquipqfj/HX9zzLexFYRSqhq1G0nEvTOBglaioghpDYVa8ohto1vfqR9snVwSI/d
	 7eBzQmJB9AYkDS5vgajetQMpbewjp0gzagrln3wvL+17licK8MfB0GgJevMe5jeIE8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V3fsJOfyWzj+yuWKAW1EXZAM/Xpq++P8XVApD61pXDQ=;
	b=w0rPLXfkMFtMNp97RqGoKxW4H7Y9xv24Xc7ftS14SWWjcmXrkybgdesXZSYjtmYxn5Te
	 LC2o5WTelhRpu+f6Q0qP+pqAabNwxL1sHsnU00EM9sAQkptbgwDOH/yUsaQH+vqd5vyJv
	 +xZpae+IRIhWD63hdYUtg4TaMBOonLrqD4ZtB8ZNAvlEpAg+z+HQaEgkcGstwenJ7HRzN
	 wYfRu7pFdG2+HgvOjMKPhCbGxMBFI/ObAdeQd87CF0xYS1QbXW2guIt07tFaJJwxEslpW
	 lM2RoJBXUBBfUaLScldwRFVIwaHMCGUhegveQIQ6kvBkKGkhLVGgOLUqtr8XZDbPAjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOJqpGdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8612606A320;
	Wed, 18 Nov 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOJqpGdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AC71F000C6;
	Wed, 18 Nov 2026 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022020;
	bh=V3fsJOfyWzj+yuWKAW1EXZAM/Xpq++P8XVApD61pXDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOJqpGdWD3g2+ob8ewilwrDCuADati+1IBX7IIY6nZjH1UQxjApd6ZT/i4i8ukjm2
	 7QrHPwvDaBesh3hXMy2Ccg/j0P+0FJQJKWfHN8mQeCQHPFVwr5BHSIXoJ5bfPOlbID
	 U77opcom8Ldh09crpdVaFHdVSFve9tV35ICcbTGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2514/2651] riscv, bpf: Remap BPF_REG_0 and RV_REG_TCC
Date: Wed, 18 Nov 2026 16:02:34 +0100
Message-ID: <20261118150415.229072725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit f80a09c486e7c2a0e4ca43dbff7570df668484c5 ]

To prepare for supporting bpf stack arguments and unifying the calling
convention between bpf2bpf calls and kfunc calls, remap BPF_REG_0 to t6
and RV_REG_TCC to t5.

In the riscv abi, a0-a7 are designated for function argument passing.
Freeing a5 and a6 allows bpf2bpf calls to pass extra arguments (6th to
8th) via a5-a7 consistently with kfuncs.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20260905085857.14143-2-pulehui@huaweicloud.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Stable-dep-of: 4d0f560f4926 ("bpf: Keep stack arguments in arch_bpf_timed_may_goto()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c                        | 10 +++++-----
 arch/riscv/net/bpf_timed_may_goto.S                    |  8 ++++----
 .../testing/selftests/bpf/progs/verifier_jit_inline.c  |  2 +-
 tools/testing/selftests/bpf/progs/verifier_ldsx.c      |  6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 33322764234c1..d09dc27320b26 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -23,11 +23,11 @@
 /* fentry and TCC init insns will be skipped on tailcall */
 #define RV_TAILCALL_OFFSET ((RV_FENTRY_NINSNS + 1) * 4)
 
-#define RV_REG_TCC RV_REG_A6
+#define RV_REG_TCC RV_REG_T5
 #define RV_REG_ARENA RV_REG_S7 /* For storing arena_vm_start */
 
 static const int regmap[] = {
-	[BPF_REG_0] =	RV_REG_A5,
+	[BPF_REG_0] =	RV_REG_T6,
 	[BPF_REG_1] =	RV_REG_A0,
 	[BPF_REG_2] =	RV_REG_A1,
 	[BPF_REG_3] =	RV_REG_A2,
@@ -47,13 +47,13 @@ static const int pt_regmap[] = {
 	[RV_REG_A2] = offsetof(struct pt_regs, a2),
 	[RV_REG_A3] = offsetof(struct pt_regs, a3),
 	[RV_REG_A4] = offsetof(struct pt_regs, a4),
-	[RV_REG_A5] = offsetof(struct pt_regs, a5),
 	[RV_REG_S1] = offsetof(struct pt_regs, s1),
 	[RV_REG_S2] = offsetof(struct pt_regs, s2),
 	[RV_REG_S3] = offsetof(struct pt_regs, s3),
 	[RV_REG_S4] = offsetof(struct pt_regs, s4),
 	[RV_REG_S5] = offsetof(struct pt_regs, s5),
 	[RV_REG_T0] = offsetof(struct pt_regs, t0),
+	[RV_REG_T6] = offsetof(struct pt_regs, t6),
 };
 
 enum {
@@ -239,7 +239,7 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	emit_addi(RV_REG_SP, RV_REG_SP, stack_adjust, ctx);
 	/* Set return value. */
 	if (!is_tail_call)
-		emit_addiw(RV_REG_A0, RV_REG_A5, 0, ctx);
+		emit_addiw(RV_REG_A0, regmap[BPF_REG_0], 0, ctx);
 	emit_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
 		  is_tail_call ? RV_TAILCALL_OFFSET : 0, ctx);
 }
@@ -1101,7 +1101,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
 	if (save_ret)
-		stack_size += 16; /* Save both A5 (BPF R0) and A0 */
+		stack_size += 16; /* Save both RV_REG_T6 (BPF R0) and RV_REG_A0 */
 	retval_off = stack_size;
 
 	stack_size += nr_arg_slots * 8;
diff --git a/arch/riscv/net/bpf_timed_may_goto.S b/arch/riscv/net/bpf_timed_may_goto.S
index 02c637d874205..fcf850f244c90 100644
--- a/arch/riscv/net/bpf_timed_may_goto.S
+++ b/arch/riscv/net/bpf_timed_may_goto.S
@@ -10,7 +10,7 @@
  *	- output: updated count in BPF_REG_AX (t0)
  *
  * Calls bpf_check_timed_may_goto(ptr) with the standard RISC-V ABI, where
- * ptr = BPF_REG_FP (s5) + BPF_REG_AX (t0). BPF R0-R5 (a5, a0-a4) are saved
+ * ptr = BPF_REG_FP (s5) + BPF_REG_AX (t0). BPF R0-R5 (t6, a0-a4) are saved
  * across the call; BPF_REG_FP (s5) is callee-saved and needs no saving.
  */
 
@@ -20,8 +20,8 @@ SYM_FUNC_START(arch_bpf_timed_may_goto)
 	REG_S	s0, 6*SZREG(sp)
 	addi	s0, sp, 8*SZREG
 
-	/* Save BPF registers R0-R5 (a5, a0-a4) */
-	REG_S	a5, 5*SZREG(sp)
+	/* Save BPF registers R0-R5 (t6, a0-a4) */
+	REG_S	t6, 5*SZREG(sp)
 	REG_S	a0, 4*SZREG(sp)
 	REG_S	a1, 3*SZREG(sp)
 	REG_S	a2, 2*SZREG(sp)
@@ -38,7 +38,7 @@ SYM_FUNC_START(arch_bpf_timed_may_goto)
 	REG_L	a2, 2*SZREG(sp)
 	REG_L	a1, 3*SZREG(sp)
 	REG_L	a0, 4*SZREG(sp)
-	REG_L	a5, 5*SZREG(sp)
+	REG_L	t6, 5*SZREG(sp)
 
 	REG_L	s0, 6*SZREG(sp)
 	REG_L	ra, 7*SZREG(sp)
diff --git a/tools/testing/selftests/bpf/progs/verifier_jit_inline.c b/tools/testing/selftests/bpf/progs/verifier_jit_inline.c
index 02e562f56f9d3..5b92da2ab75cf 100644
--- a/tools/testing/selftests/bpf/progs/verifier_jit_inline.c
+++ b/tools/testing/selftests/bpf/progs/verifier_jit_inline.c
@@ -11,7 +11,7 @@ __jited("	addq	%gs:{{.*}}, %rax")
 __arch_arm64
 __jited("	mrs	x8, SP_EL0")
 __arch_riscv64
-__jited("	mv	a5, tp")
+__jited("	mv	t6, tp")
 __arch_loongarch
 __jited("	move	$a5, $tp")
 int inline_bpf_get_current_task(void)
diff --git a/tools/testing/selftests/bpf/progs/verifier_ldsx.c b/tools/testing/selftests/bpf/progs/verifier_ldsx.c
index ed0a0f159bc12..614f64d4534b7 100644
--- a/tools/testing/selftests/bpf/progs/verifier_ldsx.c
+++ b/tools/testing/selftests/bpf/progs/verifier_ldsx.c
@@ -287,11 +287,11 @@ __jited("ldrsh	x22, [x11, #0x18]")
 __jited("add	x11, x0, x28")
 __jited("ldrsb	x22, [x11, #0x20]")
 __arch_riscv64
-__jited("add	t2, a5, s7")
+__jited("add	t2, t6, s7")
 __jited("lw	s3, 0x10(t2)")
-__jited("add	t2, a5, s7")
+__jited("add	t2, t6, s7")
 __jited("lh	s3, 0x18(t2)")
-__jited("add	t2, a5, s7")
+__jited("add	t2, t6, s7")
 __jited("lb	s3, 0x20(t2)")
 __jited("add	t2, a0, s7")
 __jited("lw	s4, 0x10(t2)")
-- 
2.53.0



