Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214678;
	b=sUU61ToL7perWdtTHi2Y+Z5fr50wmopXvy0A2afdyYy4XgoJkBgNnyGQzCU1yd3mLqli
	 SLVA0v/RqY+k2tGbtucZKlY1HTH8wapXF5IXc1wnHaEXOWrfqCF4K9GKhpO76i4JOeH5z
	 4Jd7UEnKDe7p7V9sIE6dMLfuo87Bjtu7WqzjCt3DFDw54j9HIZZEkoyvLg03LTIbPGISj
	 OQPWCh2o3DdWSdu257IxivzuP0PVwhBUtXIKD6sKGBoJkb8EjFgJyj+K+VSZtfSlq0wYd
	 vJYqBTjJ6iyB2xXFzbOzTGdZCQau+/ATN+nxCrhLmZ2WG0y+Q6B9Xbq7kYHrjhDkU7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=REyuPWM199pgTz2iqSja3imXcbVNMrXm2TE2DGdzCFs=;
	b=lnXl/8aos7J4TWivUn52wT2/qoko75GH9MWjNR5CsTQql0zAevo94e/P+PIV+PA2M2SN
	 EDg++ZTnDRFo9UiB7ZHEaZfRYboNstj4jTgoRjvrPmttgB61b2J66Y1Xn+a/lqI2/dSBy
	 yi2n26oK+B2uw6hoAiEbWlMaBT5r1JXnQlORcjQPE842pEB2utrsz4jsfXLSVMfqrjcPt
	 R+JzRehUQl4WAUEozGkgi8Xs646Mf2705ZKVimMSXurJ75Mg0pQe4WxOs1//OnKtnYSvC
	 YoGB4EZwixINohMecFl4n/szXw3dS3naKMpBuyoZ/25zBYrFMKax5BNTOFqgv3qbklw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNS82Voo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01D7606A31D;
	Wed, 28 Oct 2026 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNS82Voo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC79B1F01825;
	Wed, 28 Oct 2026 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214677;
	bh=REyuPWM199pgTz2iqSja3imXcbVNMrXm2TE2DGdzCFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNS82VoodnyODrxTrFQX0Oa+o9Rv5gJllREyxnbMLDwt+31KynR4SWh09L4TOJa1G
	 oSzbtJDcLPTI32X768e6ntE4hyQ7M2ptVHG3ZCq6Zu8V40SDpAlFLU5gIeDacGbK64
	 3xqpyn16nOrijVe0SQITW3IAvEkN5cRdhgrv1/B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0941/1887] bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing
Date: Wed, 28 Oct 2026 17:50:37 +0100
Message-ID: <20261028170520.825759781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fuad Tabba <tabba@google.com>

[ Upstream commit ef06fd16d48704eac868441d98d4ef083d8f3d07 ]

struct bpf_plt contains a u64 target field. Currently, the BPF JIT
allocator requests an alignment of 4 bytes (sizeof(u32)) for the JIT
buffer.

Because the base address of the JIT buffer can be 4-byte aligned (e.g.,
ending in 0x4 or 0xc), the relative padding logic in build_plt() fails
to ensure that target lands on an 8-byte boundary.

This leads to two issues:
1. UBSAN reports misaligned-access warnings when dereferencing the
   structure.
2. More critically, target is updated concurrently via WRITE_ONCE() in
   bpf_arch_text_poke() while the JIT'd code executes ldr. On arm64,
   64-bit loads/stores are only guaranteed to be single-copy atomic if
   they are 64-bit aligned. A misaligned target risks a torn read,
   causing the JIT to jump to a corrupted address.

Fix this by increasing the allocation alignment requirement to 8 bytes
(sizeof(u64)) in bpf_jit_binary_pack_alloc(). This anchors the base of
the JIT buffer to an 8-byte boundary, allowing the relative padding math
in build_plt() to correctly align the target field.

Fixes: b2ad54e1533e ("bpf, arm64: Implement bpf_arch_text_poke() for arm64")
Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20260226075525.233321-1-tabba@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index e66218aed831d..1a8627ab4f2cc 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1589,7 +1589,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	extable_offset = round_up(prog_size + PLT_TARGET_SIZE, extable_align);
 	image_size = extable_offset + extable_size;
 	header = bpf_jit_binary_alloc(image_size, &image_ptr,
-				      sizeof(u32), jit_fill_hole);
+				      sizeof(u64), jit_fill_hole);
 	if (header == NULL) {
 		prog = orig_prog;
 		goto out_off;
-- 
2.53.0



