Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829585;
	b=qP8NuqkHafQzmFgxMfPsQilN7Wmrn9sFvNdT+wu5An7WZcZ2AHaOWvRGn5ap4JvLFklc
	 /mwH7zR1pjVQQ8plADBbBDthsLf1doWJp4aWb0WisQEMO7RPDJgNFc2yNdnr6OFYjMGzy
	 bFibi2sOfEWH+HMslZYjnqQQ15FIkf191OOpY/aSwdoBxvHr6V3PYOqNrlzNf50VQkaP8
	 wBJkdfpKQ9CdGTM/xNy7q5JpaTxVba4YKVV84gS2+EifVODqpPkfyFK8odz7BcOxPtIDv
	 PnVdYYJXdR7uDeMaiiYUdrzgtVatO158JWoytXCwuNQ9SxHvi02C0MItS0GCfM+5iyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71TulCmlbzNSmdj5nN/9bya2jiBZelc9dmC+CWXtgrY=;
	b=lf2Qxd2Ch84s35+i+GxB/xQXUXQKHSKpkzU7pZyktuuGsEKkQw+7t/Rjhmw4cSB5AfJa
	 0nIbqwwIj+wL5heIPq88KAxGM3743NAG5ByKCpaSaHXDBsS6M6IlFnb6TSIjS77O27vK6
	 maRuci1WW8/fXdoTx5Ihi02NA/HEsCT7RsPSna1mGh96hiojlrtSCUdCFOpICBifMqz4Y
	 UK7k0ZkdZ4Or8X9DVB8Kp4IWBvhr9FjuLRbuH0X1AiQ0R1dF7GjMjNsifKJA01GfFXT7J
	 sv9+ZQbhMadMA2LPk/RGnlKsxz4ildY4Dcboc+c3yp68RaDLRa/ei5zV7Iay6Sn0IAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEVSJ38g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447AA606B399;
	Wed,  4 Nov 2026 21:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEVSJ38g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94681F00919;
	Wed,  4 Nov 2026 21:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829585;
	bh=71TulCmlbzNSmdj5nN/9bya2jiBZelc9dmC+CWXtgrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEVSJ38g+W89+BYDvTEdA23PNdSAMC9QL0YzAUmI4FnmO2GvhKKh4UlsypnPn3zRa
	 zz4VI9m4Etazoky0V0GXmOQE42F2ZizO78PICVC4SFoG6ipy6idzoP6UUo0gMbQpyR
	 AajzYBo+EnhhRn7xqM5ATTsm+FIKEJtLPK3Y8XPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0216/1005] riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT
Date: Wed,  4 Nov 2026 15:59:09 -0500
Message-ID: <20261104211049.865121647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 592dd86fbf811..89153946a4e46 100644
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
@@ -1041,7 +1046,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm32(tmp2, imm, ctx);
 			src = tmp2;
 		}
-		emit_alu_r32(dst, src, ctx, BPF_OP(code));
+		emit_alu_r32(dst, src, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_MOV | BPF_K:
@@ -1065,7 +1070,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		 * src is ignored---choose tmp2 as a dummy register since it
 		 * is not on the stack.
 		 */
-		emit_alu_r32(dst, tmp2, ctx, BPF_OP(code));
+		emit_alu_r32(dst, tmp2, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
-- 
2.53.0



