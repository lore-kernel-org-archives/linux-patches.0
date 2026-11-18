Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017255;
	b=tUPvmRsZlKlYPbCXGVIZ8QWx7omSGwSRTns7ZGj9hrzxt1ePE2DrkMdAtyx7rxiYY/QX
	 yPbR8o6Wop6fIoW0uaG5wpwQ5OBWbiUPuChSaqV4gD2XsbIuHB2F8ucFydOTa8LFw4gxo
	 7aMnmBee228+gfsdOeArKPV2zp26aGZPzxLKC/6RxiCwSOqVlZXdr9/u82CpfFzwEKD36
	 iWqtVPyqx22S0159ORd/6EiNRw0SPwy2OuSP2Fecda1YknCWygb+VNjJBtXwuSRVhkqp/
	 fEVpqPX63YpIwVGtUIaTpcIZrr21XEMK3O+3xny0an9E/NWXvtemWINM1nzkbQUNfqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tj3OrVAnpOiPXgDSGEj0IA5c1+X82Jr9c+3Iap5fmpk=;
	b=zwZbpnxa37O6ke3k4XihTebdDyafUtI9FznqvxhzcgYiNP4QzpYhkziiOVWvj7uuwMQ7
	 Hfb7yTyDO9go26HG+vqyVq8mOBSXNV6Whk4wkHUMGN1uIsRF9w79jBzS9z/xfCmZD4rVc
	 ZVceApvatSSNHISzrXX/QzU4WM8hfbbuZTH9+yytvNXWefiYskOVSONOfhE7NBDfmY6/y
	 KnYLhAXyay0N86JUzzml51WaZtAmJnrfdh4NW6+jzsN9j6R7/1BoauwLiZTHBUko9oRvz
	 Ny8fAzEddDfW2RCe5HMwAWkXdhrzZgfzFlvmZrOw1RS5X9Dr9OY2OWkHDD+KzF4XPnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTNjZ38H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94FC606A320;
	Wed, 18 Nov 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTNjZ38H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1937D1F000C4;
	Wed, 18 Nov 2026 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017255;
	bh=Tj3OrVAnpOiPXgDSGEj0IA5c1+X82Jr9c+3Iap5fmpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTNjZ38Ho7jPIDRx8XMKnATxlUmYiLtmM5+imsNi262EvIvhC+ZZ17EIeIOcb9H2+
	 TYhi8qfZrseRGWF2GB+2WdXenhBJ4dn6ixhrtybjOM4BgDtYaH0pOJOnq5QAeAamy6
	 PfVVI2FZWGUUyMAxDXDG6F+pAR0FkTXmqGo8bHv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0818/2651] bpf: Dont converge a loop on an iterator that was created anew
Date: Wed, 18 Nov 2026 15:34:18 +0100
Message-ID: <20261118150317.344163083@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6f3ee3516305da3043f1787e3890381a54151730 ]

When the verifier reaches bpf_iter_*_next() in a state that is equal to
a state that is still being explored it concludes that the loop
converged, since an active iterator will be drained eventually.
states_equal() matches ids through idmap, so the same is concluded for
an iterator that was destroyed and created again since the old state:

  bpf_iter_num_new(&it, 0, 10);
  loop:
          if (bpf_ktime_get_ns())
                  goto remake;
  next:
          if (!bpf_iter_num_next(&it))
                  goto out;
          goto loop;
  remake:
          bpf_iter_num_destroy(&it);
          bpf_iter_num_new(&it, 0, 10);
          goto next;

Such prog is accepted when the call of bpf_iter_num_next() is the first
prune point after bpf_iter_num_new() and it never returns. Otherwise
it's rejected with "infinite loop detected".

Require the iterator to have the same id in both states.

Fixes: 06accc8779c1 ("bpf: add support for open-coded iterator loops")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924233130.1213812-8-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index 0e04116b31f2e..b7ca2e07a807d 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -1335,8 +1335,9 @@ int bpf_is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			 */
 			if (is_iter_next_insn(env, insn_idx)) {
 				if (states_equal(env, &sl->state, cur, RANGE_WITHIN)) {
-					struct bpf_func_state *cur_frame, *iter_frame;
+					struct bpf_func_state *cur_frame, *iter_frame, *old_frame;
 					struct bpf_reg_state *iter_state, *iter_reg;
+					struct bpf_reg_state *old_iter;
 					int spi;
 
 					cur_frame = cur->frame[cur->curframe];
@@ -1351,7 +1352,16 @@ int bpf_is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 					spi = bpf_get_spi(iter_reg->var_off.value);
 					iter_frame = bpf_func(env, iter_reg);
 					iter_state = &bpf_stack_slot(iter_frame, spi)->spilled_ptr;
-					if (iter_state->iter.state == BPF_ITER_STATE_ACTIVE) {
+					old_frame = sl->state.frame[iter_reg->frameno];
+					old_iter = &bpf_stack_slot(old_frame, spi)->spilled_ptr;
+					/*
+					 * states_equal() matches ids through idmap.
+					 * The loop converged only if it's the same
+					 * iterator. The one that was destroyed and
+					 * created again starts from the beginning.
+					 */
+					if (iter_state->iter.state == BPF_ITER_STATE_ACTIVE &&
+					    iter_state->id == old_iter->id) {
 						loop = true;
 						goto hit;
 					}
-- 
2.53.0



