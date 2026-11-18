Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043237;
	b=Fkj2u9zH38/dIXGZpI1JnNtplarcMyB/lOLDSMi4id7dHPGqxPDBPtOi9v6ImFgWAynn
	 aJ1cy7t0oQzz2JWrZvg2A/ktKP65FgPCGbckzfG/ElsM4LuCh0iFRf7VK564AldZh0yYa
	 mzUFh9CaW5nQlVgXpMG32dVmFYgU1ybWm2LNkB1l6vNV8Mm1iqhlGjWkixj47xrQg9s11
	 q+zhxXy8EbZJq6q4HZR5fBoXtGJfzWw1Ilj92c38s4O3zvHPnDdpxmW/SK3HR0cuDo3P0
	 R3/AI8FrxoMbWo7hwEgfncEYkYmWIDkHQ0/8dXENOtAwhlPsK3vMBKwzJwgViWsjKKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ss+ljuU8J8ZAiEz09vciktTYlWXsQ1XNMsTe6ZPqxI=;
	b=vnG4nBnCWmuPJD1gcCzsa794grV/40ZwynqEuOloMILCf6Q08zJuseyYSZ19+9oZwGH7
	 F8b+sgRcBxd4gYfB6vNG0csxrQrZyLoWqVIybU5VDkogoXrfCebNJiGo2kXH7ov3P+E2f
	 nVSyUb8G0pvyfkVGI5ICCYuhf57WMvCRN4CdcLWVvy2dwxTpWH2qrKnqpxjSd50iXR3ia
	 0wFxFszsOFj9AyFdfRBK7vnHIeIZe3uXWJUY9DrDQczdd2b4j2zgd4pqbUCc/43tseHuh
	 HitwiUV3HTXCuMNMOGXhVINdRWpHtadeTnN4utSJPGypIcW2EFSk910AWLk0dPv5BTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ie+8BmBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F45606A31C;
	Wed, 18 Nov 2026 23:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ie+8BmBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BC61F000C4;
	Wed, 18 Nov 2026 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043236;
	bh=7ss+ljuU8J8ZAiEz09vciktTYlWXsQ1XNMsTe6ZPqxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ie+8BmBBe9q+VORzsIezCJdCQ1y7iPixPvdStPA2Y3f8WHcfq5TQe+3GHre6p3WcX
	 xfX0/hc1lsTVvgZxa2M8qH19rexnNFg6D6zey0GZW93S4X1UGG0jD6HaeD/LDM7LkZ
	 sus9srnUDjoNE/MHUhdbvsqokP1BpaualTJAciOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0138/2857] riscv, bpf: Add support for BPF_MOVSX in RV32 JIT
Date: Wed, 18 Nov 2026 15:19:32 +0100
Message-ID: <20261118150206.324468514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit c6a08afdfe3a81b1a54e921921e9481dd6c78f8a ]

The current rv32 bpf jit compiler incorrectly treats BPF_MOVSX as a
standard zero-extended move operation. The bpf instruction set allows
sign-extension moves by reusing the BPF_MOV opcode with the instruction
offset set to 8, 16, or 32.

Update the bpf_jit_emit_insn() function to check the offset field for
both ALU and ALU64 MOV operations. If the offset is non-zero, emit the
correct slli and srai instructions to perform the sign extension.

Before this patch:
[   19.549705] test_bpf: #82 ALU_MOVSX | BPF_B jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.551354] test_bpf: #83 ALU_MOVSX | BPF_H jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.552576] test_bpf: #84 ALU64_MOVSX | BPF_B jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.553542] test_bpf: #85 ALU64_MOVSX | BPF_H jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.554807] test_bpf: #86 ALU64_MOVSX | BPF_W jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)

After this patch:
[   17.931172] test_bpf: #82 ALU_MOVSX | BPF_B jited:1 125 PASS
[   17.932198] test_bpf: #83 ALU_MOVSX | BPF_H jited:1 124 PASS
[   17.933039] test_bpf: #84 ALU64_MOVSX | BPF_B jited:1 124 PASS
[   17.933918] test_bpf: #85 ALU64_MOVSX | BPF_H jited:1 124 PASS
[   17.934751] test_bpf: #86 ALU64_MOVSX | BPF_W jited:1 122 PASS

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/bpf/20260714002451.4091139-3-visitorckw@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp32.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index cfe6814baa49c..346b90783f2ff 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -973,6 +973,24 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
 	switch (code) {
 	case BPF_ALU64 | BPF_MOV | BPF_X:
+		if (insn->off != 0) {
+			const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+			const s8 *rs = bpf_get_reg64(src, tmp2, ctx);
+
+			if (insn->off == 8) {
+				emit(rv_slli(lo(rd), lo(rs), 24), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 24), ctx);
+			} else if (insn->off == 16) {
+				emit(rv_slli(lo(rd), lo(rs), 16), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 16), ctx);
+			} else {
+				emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+			}
+			emit(rv_srai(hi(rd), lo(rd), 31), ctx);
+			bpf_put_reg64(dst, rd, ctx);
+			break;
+		}
+		fallthrough;
 
 	case BPF_ALU64 | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_K:
@@ -1023,6 +1041,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_zext64(dst, ctx);
 			break;
 		}
+		if (insn->off != 0) {
+			const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
+			const s8 *rs = bpf_get_reg32(src, tmp2, ctx);
+
+			if (insn->off == 8) {
+				emit(rv_slli(lo(rd), lo(rs), 24), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 24), ctx);
+			} else if (insn->off == 16) {
+				emit(rv_slli(lo(rd), lo(rs), 16), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 16), ctx);
+			}
+			bpf_put_reg32(dst, rd, ctx);
+			break;
+		}
 		fallthrough;
 
 	case BPF_ALU | BPF_ADD | BPF_X:
-- 
2.53.0



