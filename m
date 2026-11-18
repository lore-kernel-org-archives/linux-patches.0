Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017281;
	b=U9usVQrusZ9j2bZptyQbo4eJX5BPWPJRZODm0kieSKgVAZuclLy8/I3ZJxf92Ke7N0qz
	 QTGbFFy/KW+UIkRTngX/DL7BJU3OPlVZCCdHh0B+wBvDfUkTvJ+ht16S2iwf0ez5U9aSm
	 DXDH24mU8+KwfVgw56z5DLPYErpzwu8PucXnYvtB5FLAuPdDfKpOiGSd6UTyfmaqU9bNN
	 hK/Q0P1bhVHtmYbgQb8PQH1OpCT0xlWYBkhE2T7jQCPN+FvCCWNTQP8Qvg5IHEck4CX4J
	 DspjM+nUes7uVIHoEpjLwkKGsPybRGex+DIXsKaklWbgMZAV0dn2VMtYSt8Fsm0993A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oU1j8obGRfFl1qqGF332vBk+MD02OoCNFNYhNSj9y6k=;
	b=JNojEaNeywtDItsSF3vLQCgJ6RCbSV/8e19mJQB1r/K00L9O+EXjCr++K8x75CkScqym
	 zlu/uTNmFccYIWYnwXzWAalFWzwO3DAZg65aiyFDfupZBmglMglTqL/OmESe1BwXRTjxx
	 dlK0tfoRemc8wtS3DXpEOPzCk2wyMkuQU3j38TAh+PrCZnSQKGLFnm2rgMqhAWgosRsfm
	 HEpDiLpUvgdVbWkv5YP1DeOB3jngkITrY3oEJlyw7GfsxdIx1hfVlUprfyPv6bebY9icN
	 IXnQL+40lmxj+pbVqrAnAWvmvHfKDJDga6SoM3gJkrJtRX/5P4+GbQvWxwJ/pVYCiTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omy0Tfiv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B24606A31C;
	Wed, 18 Nov 2026 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omy0Tfiv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D5C1F000C4;
	Wed, 18 Nov 2026 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017280;
	bh=oU1j8obGRfFl1qqGF332vBk+MD02OoCNFNYhNSj9y6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omy0TfivA7p572buP4S3R3BIFghm4FV6cOXWA5N8rdNuyc+0mryS531G6LEA1yWV6
	 GIF3fud8QXRLibA/RTBYKlitOyUtn4BG+I1Q72q8UXbWcUUCrg0POMFxyjz++HxHW1
	 F6xOpWCN+GwhZsvbap03eYRX2Qb66zcOB4N5dTAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0787/2651] bpf: Look at frame 0 when telling async callback entries apart
Date: Wed, 18 Nov 2026 15:33:47 +0100
Message-ID: <20261118150316.219131124@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit e55220162aae99622d9e80d4700e51c13a6f2a16 ]

push_async_cb() sets in_async_callback_fn and async_entry_cnt on the
callback's own frame, which is frame 0 of the fresh state it starts, and
setup_func_entry() copies neither, so a subprog called by the callback
carries neither. Two places read them from the innermost frame instead.

is_state_visited() skips the infinite loop check when two states differ
in async_entry_cnt, because seeing the same state on a second entry into
an async callback is not a loop. A callback which re-arms itself and
calls a subprog therefore compares the two entries at a loop inside that
subprog, where the innermost frame is the subprog's and has no flag set,
and the state is rejected:

  infinite loop detected at insn 60

push_callback_call() numbers a new entry as the caller's count plus one.
When the callback re-arms itself from a subprog, the caller is that
subprog's frame with a count of 0, so every entry is numbered 1, the
check above never sees a difference, and a loop anywhere in such a
callback is rejected the same way.

Read the flag and the count from frame 0 in both places. A loop within a
single entry still has a matching count and is still caught, and frame 0
of a non-async state does not have the flag set, so nothing else changes.

The two other readers are already correct: check_return_code() reads
frame[0], and the one in do_check() is reached only after an early return
for curframe != 0.

Fixes: bfc6bb74e4f1 ("bpf: Implement verifier support for validation of async callbacks.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924162609.1746610-2-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c   | 4 ++--
 kernel/bpf/verifier.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index 012b82513a3bc..3c5f1dc80220e 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -1275,10 +1275,10 @@ int bpf_is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			continue;
 
 		if (sl->state.branches) {
-			struct bpf_func_state *frame = sl->state.frame[sl->state.curframe];
+			struct bpf_func_state *frame = sl->state.frame[0];
 
 			if (frame->in_async_callback_fn &&
-			    frame->async_entry_cnt != cur->frame[cur->curframe]->async_entry_cnt) {
+			    frame->async_entry_cnt != cur->frame[0]->async_entry_cnt) {
 				/* Different async_entry_cnt means that the verifier is
 				 * processing another entry into async callback.
 				 * Seeing the same state is not an indication of infinite
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 07ac0986f1449..1a16546c2937d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9923,7 +9923,7 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
 		callee = async_cb->frame[0];
-		callee->async_entry_cnt = caller->async_entry_cnt + 1;
+		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
 		/* Convert bpf_timer_set_callback() args into timer callback args */
 		err = set_callee_state_cb(env, caller, callee, insn_idx);
-- 
2.53.0



