Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829652;
	b=j0fD9VxIAOBdkrFUAv02BuO9p4bnGKLsIPajb8W4x19Ub9IyhHqCKXzGED8NN3bSPPcW
	 2npqvh7alPbZK3NDPIIfmJyezJWeu8pTItGzk9C7vSehenCuNIQlHAobpTwjScxz6jITN
	 p/3keD2KQJ0eIjPS7gfT6vQReiXSCT8NrfidbFGFeF7xyC74AglyCeQ5kYE4CimgGIlMb
	 D5C4TL6q+q0zqe8XrLGOKuTvUn5eJbLjllZqtMMan4uE26a6qbzYBOj33PE2oBUASV8ps
	 GfTfqnsBXjChufCy2kZEEzqwFw1o2pQX+fZyt15mvvIJcbCxn/ikGLkR+iIERqY+rog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2kB6VfYetYYo2afpxDIrbi+HuCduDUgnTqzzKDsNi9A=;
	b=F4xtTthgV+qc6jwICMJAbw0FyYK7tCecIteVvBmT+HvN8BP7VOWs6qEmEXRyNyrDQ/IL
	 t1jkkbMeB3HQHA9eO/aBYP7zB35DGMJU1KqMeAYi7lCJnEoTVhS+TdKMDuD58VbDPHBno
	 LmAVYqRQIfg0xFdzF6r446hdkLr+mJAIXB4qIp3ZrgJMRV2Kf0IgUmAw2krzK0TsZVj3N
	 +Ad1w1nKKuYxrjeoxsvfEO7ZV3ZNOuNbjqsL4aTGj33axSCKmhRfKWj9uZF2ZG1bvf3dH
	 t8pAhYwI4Me2oI89AOGE/eMbl8KW49+xrpOzAfTsTYszcH8YPu9U1p2T65D5SPp69OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7wkOn9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30393606AC15;
	Wed,  4 Nov 2026 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7wkOn9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD131F00A17;
	Wed,  4 Nov 2026 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829652;
	bh=2kB6VfYetYYo2afpxDIrbi+HuCduDUgnTqzzKDsNi9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7wkOn9UdOsWsvASRphKggLGlSh1FmARqMPon8piowe7Wnr/L9bH43OvX192ppWSw
	 LNepx/9DiJ0rTceWP+7maxkQloSqSo94w6kyKmRrDgcxvfKK7z93e0exLpMErSvztd
	 pRjbKHO6GZdzdUZnf3v4j5UAGUdfXMOMcSyqJgBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0221/1005] riscv, bpf: Add support for BPF_MOVSX in RV32 JIT
Date: Wed,  4 Nov 2026 15:59:14 -0500
Message-ID: <20261104211050.009405594@linuxfoundation.org>
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



