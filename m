Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020937;
	b=hWQ2IkOFf1lIIJs9ThOHv1XkRIRtez/FjeonQ2+mW39bBsE+zSxsgJxxeRt4FkqPmyDM
	 M4O6Oo6q90a6s64g2+uGdp4j70+pZQP6C4oLpVodASiG64mQUxSw3uIPsJTXMKfWbO9km
	 8zBJbiTGeziSravPaOmilFuu5zGAEEReqbKRzkuAxa0pn6DkzAdczcqFBQmTAI/QOz6yE
	 PBYEuQRJVtKG4HD2+Qo3Yg3a447TI8QbiXfMZycVaCoKTtLCUkmIaxbHjh0p2pX5hgxaJ
	 JGk2SdUj3y8LZ9Svj/hUnCaeVuDR4RywlORP5qybw5Z+j83UXROHap1yecUYZhZP6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jx5tBrM6Ska4fbd8vqwPfQeV/XhCWI5vEXKrNLyqzv4=;
	b=xdDbSx1xjl4UrtT1F5/G4+12qDVrwrNLl1pLYz1AbB5znLP59g/tEguzPja1f+71pvTJ
	 s62DuaANLgP8n4azMpCZzK+0EzNaLSSMqjLfOsAX/7BG79KRufIA2MFHcHC3+HRMxJyUd
	 EngdA2z+mkDXWMKu/5GEmSqGoedBBvlUNgeZ9EKCigdVEv+tQZhCOYxGhYtC5KorpDYll
	 rbcEX+sBkykdggTuDFjqeapbik1rGAd54z9Wy1LtIiGo754bXfMlzU2VGcthjYm78tMgY
	 +4dNnsBr+BYJ5ELILMrCXdrPD5GZ/HVsUi0x74SAFaP/GdphuMGdfRpZ4FqiHXl+dEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qt/8ot8u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427A0606A339;
	Wed, 18 Nov 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt/8ot8u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A721F000C5;
	Wed, 18 Nov 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020937;
	bh=jx5tBrM6Ska4fbd8vqwPfQeV/XhCWI5vEXKrNLyqzv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt/8ot8uYwkZawayVMyynpFohiJH8z0FZQT5FZqNozuYPyhIe5iDU010q1NxZjRxh
	 i1b2zoykAtxJLYTSJzu+F1xK7QtomihKhHah/Zv5c57Cc329ey3nTzTTh9XC1TZC+J
	 4BioJjr2wMTFP+q/X5QdPS5VON7X6hmkHAlKz+5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2128/2651] bpf: Dont take a dynptr argument for a local dynptr
Date: Wed, 18 Nov 2026 15:56:08 +0100
Message-ID: <20261118150402.510149866@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b7f97db88948aa511bcd989978f181e1367e0e8b ]

A global function is verified on its own. A dynptr which it gets as an
argument is assumed to be of type BPF_DYNPTR_TYPE_LOCAL, but the callers
may pass one of any type, that of an skb for example.

The type decides whether a write through the dynptr invalidates packet
pointers, and whether a slice of it is invalidated together with them.
Inside of the function neither happens. It can take a packet pointer from
its context argument, or a slice from the dynptr, write through the dynptr
and go on using the pointer, although the write may have reallocated the
head of the skb.

Assume the type of an skb dynptr instead. Nothing becomes forbidden for the
dynptr itself, and a clone inherits the caution. The dynptr which the
callback of bpf_user_ringbuf_drain() gets is known to be local, and stays
so.

Fixes: a64bfe618665 ("bpf: add support for passing dynptr pointer to global subprog")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-11-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 090576a79d9fa..b31b96cbdc8b3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19734,8 +19734,12 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog,
 				reg->type = SCALAR_VALUE;
 				mark_reg_unknown(env, regs, i);
 			} else if (arg->arg_type == ARG_PTR_TO_DYNPTR) {
-				/* assume unspecial LOCAL dynptr type */
-				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_LOCAL, true, ++env->id_gen, 0);
+				/*
+				 * The callers may hand in a dynptr of any type.
+				 * Take it for that of an skb, so that a write
+				 * through it and its slices are treated with care.
+				 */
+				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_SKB, true, ++env->id_gen, 0);
 			} else if (base_type(arg->arg_type) == ARG_PTR_TO_MEM) {
 				reg->type = PTR_TO_MEM;
 				reg->type |= arg->arg_type &
-- 
2.53.0



