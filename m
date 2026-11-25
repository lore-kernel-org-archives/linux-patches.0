Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619998;
	b=Acm2GvzNW1i68E/CPLmpkiAEJ13Gk2hvSyjFj1mZPsW7QGXX+HHtm4yLoTemgEYHN1gv
	 W/XgFOBYxLi3h0U4JQlEKS0V0piyG9fbHtuDdR/MISG+KovB3DS8ElfX5WqPmoVyH6Ezj
	 pqdPe/WtVDWwBwywA/vyME9V8esdad12TK0+mhq5C9g18rkL7Yg/lEhFY5EIr9Z12L0o4
	 WmA/iZ7MK8V58wZgAdOBycnegOE/t+mdeCeJU10XicWWHmIrLiWlm/nU8OgKMquURuxLY
	 LHCEaS5CSmgk2GHYcVsGUXsOg4GZoDIB3wXgShCOOnzn1zwL79GRwLmKyIm3VGxQofA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSZeWqcA775yUgkQuBDlAHJnwt7Xt2d0+F/+POCC+aE=;
	b=xvaKPaPF1K8MMO9E9p9tRKlO264yVp+BtjJkx7ALsJB1oN/aQCk8Zic+/5NXA5Fg0wy0
	 0XCtOIgkeNMsV1E7GrOV0OGzdDwNNf8i0F/zBQCzB//jtjlKz/93eqd3H7cRv5orxnLoj
	 Q01L0TNVmqMu1vK1LAX1WeHDxN1U1jmHw0xIDJLnCXF9YmKdglACbcEZjq/Fs9u9bgOEv
	 95v+TfZMhcA4ygl4y5mAsXh6caQYp+qXojw06pNh0nHIZ/N1G8tun84Th2jLbkZ5BsLj4
	 PR13P36Mxh3gNaysLUO6SV8HCKv17fZ+QkZxVJZPxukQZqEaDPxIoxeZrylMc+QvGSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i+q/qQxx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B379606A326;
	Wed, 25 Nov 2026 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+q/qQxx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC91F000C4;
	Wed, 25 Nov 2026 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619998;
	bh=CSZeWqcA775yUgkQuBDlAHJnwt7Xt2d0+F/+POCC+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+q/qQxxkJ6/3/3/iI4Oh5O/rjHn8eJvfYA7maLhqI0AfZWp49s88h25OnA+AIuIq
	 CDdWnbVwXjgHh+mu2PqUzAvfeAoP85ed5t9x/1hL9RiqdUeCpB0/d0cJi285V33F2u
	 KDFDcyKJd1EZup1jV/mBr7JFncofJ8+XW3R4KItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0774/1005] LoongArch: BPF: Make use of beqz and bnez for trampoline branches
Date: Wed, 25 Nov 2026 15:35:12 +0100
Message-ID: <20261125143839.875305983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 6dd070681326ef2fef5e008b8c3d0ae9634de222 upstream.

Currently, the implementation for BPF trampoline branches does not match
the existing technical comments. The code uses larch_insn_gen_beq, where
the comment indicates beqz should be used.

While the BPF trampoline size is restricted within a single memory page
(at most 64KB on LoongArch) and cannot cross the original 16-bit branch
offset limit of the reg2i16 format, switching to the beqz instruction
(which belongs to the reg1i21 format) avoids explicitly specifying the
zero register during dynamic JIT encoding, resulting in cleaner assembly
generation.

While at it, also apply the same optimization to the bne instruction by
replacing it with bnez and adding a corresponding comment.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/inst.h |   21 +++++++++++++++++++++
 arch/loongarch/kernel/inst.c      |   28 ++++++++++++++++++++++++++++
 arch/loongarch/net/bpf_jit.c      |    5 +++--
 3 files changed, 52 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -535,6 +535,8 @@ u32 larch_insn_gen_lu32id(enum loongarch
 u32 larch_insn_gen_lu52id(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm);
 u32 larch_insn_gen_beq(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm);
 u32 larch_insn_gen_bne(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm);
+u32 larch_insn_gen_beqz(enum loongarch_gpr rj, int imm);
+u32 larch_insn_gen_bnez(enum loongarch_gpr rj, int imm);
 u32 larch_insn_gen_jirl(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm);
 
 static inline bool signed_imm_check(long val, unsigned int bit)
@@ -592,6 +594,25 @@ DEF_EMIT_REG1I20_FORMAT(lu12iw, lu12iw_o
 DEF_EMIT_REG1I20_FORMAT(lu32id, lu32id_op)
 DEF_EMIT_REG1I20_FORMAT(pcaddu18i, pcaddu18i_op)
 
+#define DEF_EMIT_REG1I21_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rj, int offset)	\
+{									\
+	unsigned int immediate_l, immediate_h;				\
+									\
+	immediate_l = offset & 0xffff;					\
+	offset >>= 16;							\
+	immediate_h = offset & 0x1f;					\
+									\
+	insn->reg1i21_format.opcode = OP;				\
+	insn->reg1i21_format.immediate_l = immediate_l;			\
+	insn->reg1i21_format.rj = rj;					\
+	insn->reg1i21_format.immediate_h = immediate_h;			\
+}
+
+DEF_EMIT_REG1I21_FORMAT(beqz, beqz_op)
+DEF_EMIT_REG1I21_FORMAT(bnez, bnez_op)
+
 #define DEF_EMIT_REG2_FORMAT(NAME, OP)					\
 static inline void emit_##NAME(union loongarch_instruction *insn,	\
 			       enum loongarch_gpr rd,			\
--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -428,6 +428,34 @@ u32 larch_insn_gen_bne(enum loongarch_gp
 	return insn.word;
 }
 
+u32 larch_insn_gen_beqz(enum loongarch_gpr rj, int imm)
+{
+	union loongarch_instruction insn;
+
+	if ((imm & 3) || imm < -SZ_4M || imm >= SZ_4M) {
+		pr_warn("The generated beqz instruction is out of range.\n");
+		return INSN_BREAK;
+	}
+
+	emit_beqz(&insn, rj, imm >> 2);
+
+	return insn.word;
+}
+
+u32 larch_insn_gen_bnez(enum loongarch_gpr rj, int imm)
+{
+	union loongarch_instruction insn;
+
+	if ((imm & 3) || imm < -SZ_4M || imm >= SZ_4M) {
+		pr_warn("The generated bnez instruction is out of range.\n");
+		return INSN_BREAK;
+	}
+
+	emit_bnez(&insn, rj, imm >> 2);
+
+	return insn.word;
+}
+
 u32 larch_insn_gen_jirl(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm)
 {
 	union loongarch_instruction insn;
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1768,7 +1768,7 @@ static int invoke_bpf_prog(struct jit_ct
 	/* update branch with beqz */
 	if (ctx->image) {
 		int offset = (void *)(&ctx->image[ctx->idx]) - (void *)branch;
-		*branch = larch_insn_gen_beq(LOONGARCH_GPR_A0, LOONGARCH_GPR_ZERO, offset);
+		*branch = larch_insn_gen_beqz(LOONGARCH_GPR_A0, offset);
 	}
 
 	/* arg1: prog */
@@ -2081,9 +2081,10 @@ static int __arch_prepare_bpf_trampoline
 		emit_insn(ctx, std, regmap[BPF_REG_0], LOONGARCH_GPR_FP, -(retval_off - 8));
 	}
 
+	/* update branches with bnez */
 	for (i = 0; ctx->image && i < fmod_ret->nr_nodes; i++) {
 		int offset = (void *)(&ctx->image[ctx->idx]) - (void *)branches[i];
-		*branches[i] = larch_insn_gen_bne(LOONGARCH_GPR_T1, LOONGARCH_GPR_ZERO, offset);
+		*branches[i] = larch_insn_gen_bnez(LOONGARCH_GPR_T1, offset);
 	}
 
 	/* Set "is_return" flag for fsession */


