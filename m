Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622657;
	b=XDNt7RQ3+x1nihbqFZ/AP2vT0GzkgwaynD4xrH87wBAh24kT/cks8ZGiglvYOuaQRXje
	 Swrygg8Adk0a6gzLUL3wmD+3si2I/iAlg8GQH2c2P1LupyLhzbUNfvGa8u1nRWlwXBGJo
	 PUN901r3lpD42dGwzN6K2XFCrVlYtYZzai3WSBR+gVaeyaB+XbNjsC1KnWubw3DiRILYd
	 hju542XGFFR4tMy+mNNeYlVE1jSjRBlIlfiONrGycZihIRXLSXWHeKjPzzVrsJ/cj1CeH
	 o0Sr8isjq0B4dU93ZOMw+nFVUJs+fBLJzgeAoowUgdU1e9nCaw6ZiSO4ovHVotr995w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NnGg9wdkAWy0EQlkcMkbeP6rNWFwT/M7wWXrOK7CeY4=;
	b=PfNO2s2wimJwVQ5Gc0hWK+eo/SzHLd298ghgLLbumXddrTU3vBsN4DdvDPUI0asOXTds
	 XXEvaVP8gZ48jkM242BAMf+hYjRFjAQslR0cLNzAFiPMGrFZk56xbVpGiEbQOPGn3dc48
	 oVGEMQ2pklWOZEq5L/sxPEJxahCIxvi2si/rH7d92iT3goHQumuoKAAhE0Lrw1L7A9ght
	 W5RVsx5m1lYCAY+oo4P8k+6rLD2U4oBBeaUeLSNhgzUPIGbwfe2oPm4zrItsFwSSw0ROn
	 6CUkgmV7MmoK6f9rqiK2wBcvxHW075K2uug4zWDRm6SQksyn1y3Lk5J8TgSLqfXC6tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y6JiNe42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB692606A323;
	Wed, 25 Nov 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y6JiNe42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A09F1F000CF;
	Wed, 25 Nov 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622657;
	bh=NnGg9wdkAWy0EQlkcMkbeP6rNWFwT/M7wWXrOK7CeY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6JiNe42vxBF7dInjzfviwt7cWI8VLmxA0OHjsKF54oV80kMpsK64yf6AxG+084pM
	 b/ayvQ8UtMOCASVtG+m4jd1FEYtK3N+GnxvYuCCMse7sk163KtudGSZKtMbOM4maGy
	 hT9EXUq7MqGG08XNefHxA2/Ro3vyP7w8oAZpEqxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 608/990] bpf: Dont take a dynptr argument for a local dynptr
Date: Wed, 25 Nov 2026 15:32:55 +0100
Message-ID: <20261125143836.334541116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Kept this branch's ARG_PTR_TO_DYNPTR | MEM_RDONLY condition and dropped the extra 0 argument to the four-argument __mark_dynptr_reg(), changing the type to BPF_DYNPTR_TYPE_SKB. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1890c0ba642ab..0d93bcdcef81a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24006,8 +24006,12 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 				reg->type = SCALAR_VALUE;
 				mark_reg_unknown(env, regs, i);
 			} else if (arg->arg_type == (ARG_PTR_TO_DYNPTR | MEM_RDONLY)) {
-				/* assume unspecial LOCAL dynptr type */
-				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_LOCAL, true, ++env->id_gen);
+				/*
+				 * The callers may hand in a dynptr of any type.
+				 * Take it for that of an skb, so that a write
+				 * through it and its slices are treated with care.
+				 */
+				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_SKB, true, ++env->id_gen);
 			} else if (base_type(arg->arg_type) == ARG_PTR_TO_MEM) {
 				reg->type = PTR_TO_MEM;
 				reg->type |= arg->arg_type &
-- 
2.53.0



