Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050907;
	b=e5tMoVWutaOeNn3fo9ooLxuREE6WeAU4B92876GPGa6wrJQ/qdT1m+yFbZ2FRqb0T8x4
	 LQx+iPiGGmlcCigls34JGAtncG7GjcMXPqJPQNiNV5vQNSDo/jgzXTJwqOKnhGbUK1GpQ
	 PAL1YEjziIUDwuZZhdtA8njFzLI4AaBZ/4HEjjiOaDnYGJUx5ybjZRT/84Ab6tEp1T8d0
	 7VVTk2kplwWl/nS25D6G0sKiWV7Nw8yoSsIXLmxnxvQig0h/I1/VcLlxvAy39RuL0jn3C
	 zvXTCRB1Mpvg4o8mbnWc/PzPHyjuWpmOFXJtrYBusIMlCeusWFWoL5VIV7sJrHOwCDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZZe7HzcUGoLyXsxYUZFPT3mKUfdxx9yjqZW0t0GASoE=;
	b=sqRQ6YuYxAHCvPhaOatjSfQMTJT4tTndV3rJ6qv7oj5UUUwtxoJxMjxDUFeuf8OexczO
	 v8tU37sRR/aMngeHzA6/DH3OXMSSe9c733wgtquUftDr+kCWSJLlhXKTZysfRZkLeIfuq
	 rzIWUbTk9lAD1+BPiMSqErGtfwg7VJ+8Mk2CacIgn2CGPrT3sOqzyyWsCVvF2n02j0mlj
	 o92RMkbCN32MmL994iZMndKyy9UZHVvmn3tMRuXlUBepfeiBPKQNolR8JJl3El/XPd5aN
	 fn5P83xphJu8JKmFbdB9d7qC8yuxFIf0GZREJSLVQsrbCWeUoo6BGzbnPUH61QAq2Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8kYTRrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E96606A31C;
	Thu, 19 Nov 2026 01:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8kYTRrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB51E1F000C4;
	Thu, 19 Nov 2026 01:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050907;
	bh=ZZe7HzcUGoLyXsxYUZFPT3mKUfdxx9yjqZW0t0GASoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8kYTRrBdxL8iHZif+S42gSA5F/2zs+M21zc3r6AJwOea2tihW6oVpGzvx0z3QQk0
	 qWJ3vgUdnOBWKZQy2/O1/HOic2YsM6vDCsVvT5mzUDsJWxZ9Q0LBT53yonMN4+E2vR
	 GhFEErLHGvAKMntd7cSr89YQZLVIfeZXjQpcm8KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0021/2214] bpf, arm64: Fix off-by-one in check_imm signed range check
Date: Wed, 18 Nov 2026 15:28:17 +0100
Message-ID: <20261118150010.982581679@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 1dd8be4ec722ce54e4cace59f3a4ba658111b3ec upstream.

check_imm(bits, imm) is used in the arm64 BPF JIT to verify that
a branch displacement (in arm64 instruction units) fits into the
signed N-bit immediate field of a B, B.cond or CBZ/CBNZ encoding
before it is handed to the encoder. The macro currently tests for
(imm > 0 && imm >> bits) || (imm < 0 && ~imm >> bits) which admits
values in [-2^N, 2^N) — effectively a signed (N+1)-bit range. A
signed N-bit field only holds [-2^(N-1), 2^(N-1)), so the check
admits one extra bit of range on each side.

In particular, for check_imm19(), values in [2^18, 2^19) slip past
the check but do not fit into the 19-bit signed imm19 field of
B.cond. aarch64_insn_encode_immediate() then masks the raw value
into the 19-bit field, setting bit 18 (the sign bit) and flipping
a forward branch into a backward one. Same class of issue exists
for check_imm26() and the B/BL encoding. Shift by (bits - 1)
instead of bits so the actual signed N-bit range is enforced.

Fixes: e54bcde3d69d ("arm64: eBPF JIT compiler")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260415121403.639619-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -493,8 +493,8 @@ static int build_insn(const struct bpf_i
 	int ret;
 
 #define check_imm(bits, imm) do {				\
-	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
-	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
+	if ((((imm) > 0) && ((imm) >> ((bits) - 1))) ||		\
+	    (((imm) < 0) && (~(imm) >> ((bits) - 1)))) {	\
 		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
 			i, imm, imm);				\
 		return -EINVAL;					\


