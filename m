Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051188;
	b=qEpcS84M/Er/JAgVaucNJEMwWIDwqS4lonyFOhC+LQABFc8SQSDtlppx2MPOTwmXL1Kr
	 8hI5JkJIKNXe69AZZJH4lW5RUaAiuzuxyDlLH8oo0GYh28TrgJ4KMgcdAhl9IaNnXe9UJ
	 N0UAFK1hJzg7y4Ww/k6DCO3fnQJn/Yl16Ab1FZCMlz9zvX8M3KpVBDUyC7elaKJBDD9Bi
	 +kN7VjAaC1ZmNk5JLZ6PEn0nQopt/D/fr/98DA1iNZ6qjGSxvIFrhC0zn6cqIay0yr+tD
	 Lw1ApuNmQxKD7eySA8730R85+fEcf48VHkK00+d4GOwoWBMb4BXSpPLciyzqQsQMgug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFAtK5d/nNgMZ10HfYx3VnFgBIRdfC0YZ9jLtrBjIGE=;
	b=GSRW5cMjQ8I2XJnvuRNI8FnQqvXZr2sJ4nlJdtwOgxrjQFVq7h3uH5zFlaXMvg9ULIUi
	 GxrcpN3d9Snd7df2NZXVKv8VAhbOTK7MYPzkjo97/G4z7kEqim3NI9M141CN4+8Y2OVlA
	 /+Z1pH+OaIeLBbS01m2oBd4+zP0RpTes8SYjbwHPv6IZI+xm/tjCGdrZuDEj+im0E7BHh
	 eI+8X9D3dehrRJE1uHanitMSks8/4d2ZeBFlZanyCJ0WFTfXAZibqIh3PhNfgyrXBgwv4
	 bwfWZZvITngl23KjWrJBsgcA4nxcZCR8m0+CT09wqEj1gPabl6XMOawLof3ZambE4hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uanq3J2s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F7606A320;
	Thu, 19 Nov 2026 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uanq3J2s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953371F000C4;
	Thu, 19 Nov 2026 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051188;
	bh=HFAtK5d/nNgMZ10HfYx3VnFgBIRdfC0YZ9jLtrBjIGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uanq3J2sZQw+Tb6BKVvCFfG0AkN9S3cf7CqemWSUfHOfWpOuinQoCeSjcvVKgUI6I
	 x+VuX03o7W/hNo3d1ZuSstuMbbF+vEK5upE5Wcnf/9WcZpieyWUPrF36+gXlQy5mdH
	 TPziltNFrxWjLrEPkWZDVJGAjMbKOHpcuN1GRhP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0119/2214] riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT
Date: Wed, 18 Nov 2026 15:29:55 +0100
Message-ID: <20261118150014.808241679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 2e0fa2389c50fd3a69bb738efa74e127b7516938 ]

The current rv32 bpf jit compiler incorrectly treats BPF_SDIV and
BPF_SMOD as unsigned operations. The BPF instruction set allows
signed division and modulo by reusing the BPF_DIV and BPF_MOD opcodes
with the instruction offset set to 1.

Update the emit_alu_r32() function to accept an 'is_sdiv' variable and
emit the correct div and rem instructions when the offset is 1.

Before this patch:
[   44.161771] test_bpf: #165 ALU_SDIV_X: -6 / 2 = -3 jited:1 ret 2147483645 != -3 (0x7ffffffd != 0xfffffffd)FAIL (1 times)
[   44.167385] test_bpf: #166 ALU_SDIV_K: -6 / 2 = -3 jited:1 ret 2147483645 != -3 (0x7ffffffd != 0xfffffffd)FAIL (1 times)
[   44.171053] test_bpf: #169 ALU_SMOD_X: -7 % 2 = -1 jited:1 ret 1 != -1 (0x1 != 0xffffffff)FAIL (1 times)
[   44.172081] test_bpf: #170 ALU_SMOD_K: -7 % 2 = -1 jited:1 ret 1 != -1 (0x1 != 0xffffffff)FAIL (1 times)

After this patch:
[   16.002192] test_bpf: #165 ALU_SDIV_X: -6 / 2 = -3 jited:1 95 PASS
[   16.002983] test_bpf: #166 ALU_SDIV_K: -6 / 2 = -3 jited:1 1059 PASS
[   16.017167] test_bpf: #169 ALU_SMOD_X: -7 % 2 = -1 jited:1 136 PASS
[   16.023002] test_bpf: #170 ALU_SMOD_K: -7 % 2 = -1 jited:1 109 PASS

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/bpf/20260714002451.4091139-2-visitorckw@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp32.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index e6497424cbf60..bd4961cf349f9 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -509,12 +509,15 @@ static void emit_alu_r64(const s8 *dst, const s8 *src,
 }
 
 static void emit_alu_r32(const s8 *dst, const s8 *src,
-			 struct rv_jit_context *ctx, const u8 op)
+			 struct rv_jit_context *ctx,
+			 const struct bpf_insn *insn)
 {
 	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
 	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
 	const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
 	const s8 *rs = bpf_get_reg32(src, tmp2, ctx);
+	u8 op = BPF_OP(insn->code);
+	bool is_signed = insn->off == 1;
 
 	switch (op) {
 	case BPF_MOV:
@@ -539,10 +542,12 @@ static void emit_alu_r32(const s8 *dst, const s8 *src,
 		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_DIV:
-		emit(rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(is_signed ? rv_div(lo(rd), lo(rd), lo(rs)) :
+				 rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_MOD:
-		emit(rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(is_signed ? rv_rem(lo(rd), lo(rd), lo(rs)) :
+				 rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_LSH:
 		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
@@ -1044,7 +1049,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm32(tmp2, imm, ctx);
 			src = tmp2;
 		}
-		emit_alu_r32(dst, src, ctx, BPF_OP(code));
+		emit_alu_r32(dst, src, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_MOV | BPF_K:
@@ -1068,7 +1073,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		 * src is ignored---choose tmp2 as a dummy register since it
 		 * is not on the stack.
 		 */
-		emit_alu_r32(dst, tmp2, ctx, BPF_OP(code));
+		emit_alu_r32(dst, tmp2, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
-- 
2.53.0



