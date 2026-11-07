Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060777;
	b=QP4LXfQVHtSvQfKlBhimdoUvYbtj642cilR44OM2rvexerU525x/AxVURxAd76gLeobN
	 Fo2h5w+hZ8nYzNyMXa9hVK+XXDL4is64HVmtRhDTBpfwxr9pYNupKPv2UjOD76SXxMfA4
	 r6fzJu7b7y9xRSgzXsm/hUIpNaoeWAbehG1xXLWdXwyTFiHpGRv5JUeEMRF4QA85tvM86
	 KKFlgtrDzg/x1BZPUlNHe0eIy6w3/v0miwPgaQrK5tbKdQlZ/WzbvYJcyZyNpcu1fJspM
	 KAJt8lXl4fhUbWwuJLIA4BqjSc2m+X2tJusthRAdWPSnK82jrA8+JEWoLuYxiL140tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+DB2FCbL8YHfCk2q1zr5qXIjhaiw75ttesRlKxRmpI=;
	b=N0fKNDoekx/6Qoo2tl+kiEQ50PCPz+Gx+/6fTdVv33aSef73rs7AsgriqA7p8XXIRP1i
	 cM58Xtg6dt3SSvfpVsQBtZ0VOJ+xRsscoxmF+xfQJBO/X0xfUgOyIa+qMy5LFi3a34UHd
	 7dQT2I0S24N0VyfeSpLXqCESi/qU9vLXpXBbZCvlbF5Ng3rKhtU7PBqoQldf5RSgMKVnq
	 5d1p+lFCWcaPmi89Ns+NOoCGybinwqE0Wn+nYa3rwlyj4kjNc97b0rTxo2Aekv8U1LIRJ
	 7AG2Pwzyc8YhiK5Q7WnEJjCVV1Z2Sp0ycUyyZ15K6F/JEZ3m11GjqaX3fDbiAzz7xCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mszsJa+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E7F606A326;
	Sat,  7 Nov 2026 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mszsJa+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C821F0089F;
	Sat,  7 Nov 2026 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060777;
	bh=Q+DB2FCbL8YHfCk2q1zr5qXIjhaiw75ttesRlKxRmpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mszsJa+9yqoicLFIciKru+sNBNouvjJQNYh410lbpUjfTCeZlag0kVhN9KrsGgk3a
	 TY11pzlG1B3jOw5nfGRSXOkNgrn5j2YlMKHD5k22KfYlnf8PKP7CmLDPYrdFkoBD2f
	 Pw2DohdWzG+pYwvBHc070G6VFgxzgOE9xOnljY4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0184/1536] riscv, bpf: Add support for BPF_MOVSX in RV32 JIT
Date: Sat,  7 Nov 2026 08:36:40 -0500
Message-ID: <20261107135002.827848801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 89153946a4e46..39e2b0b907dc3 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -972,6 +972,24 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
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
@@ -1022,6 +1040,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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



