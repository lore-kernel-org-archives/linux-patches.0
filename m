Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618124;
	b=sR1OYuXgyzZIl6lnxur1B+hU5JYLw2MWOkJrol8KHPaUF3YrEAISNvCqJxpJmYWejZpq
	 bS+Z+WQK95iuGiK79l6akeI6UFP7vDFpwt5HvNgvxLLRdKuKBokwY8pEO+n/a1veRqs/L
	 3Vqo19fUg2nsA0fl6GfQ2ZY/jBEEudIm68XIQkBhhdLzbDhV5l21rX6WvSrkhFL5fhDxO
	 ENWwASbPqSRraLHUpFXtiDjBbyqyvdCuZjLJtx4ah/p9Y33DeVoqxPYKjaCssUcltUg7H
	 FuySdyfxHPNBwSL31uFXiPmjJyGZLA2BO8o8mCM/fpvFr/BpSWHEGqZDjSThoadt9bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dr78bYtjaNj+fUdXzg8ZBkq5laVlRArTpNOKw0MK6h4=;
	b=JsAfMKbPJIlBuLwEjuOxRKZ+Gmp4QqoVncX7TOqsW+PMXlAMeJIi5IblrsQl8w0LQx3H
	 A70prGfTsFHJswrbkMzvs0KdcWlsKEQ+y/vJN2kmT3CbR3qigJQkRM61OcQKtZVZ28Xw0
	 qpnBnHlszCbvnDa0AduUhiATNZ8oxZ76eUPiMomEaqwHNyqKTvxMF/cLrFer3+xfP/65V
	 K9W1PPFKY/sq0lvRPbQBAGUIdwcxUUYk4hYBkhKVh4lbgaFZZi8ojX/iMKxhNHBcIP1VI
	 p9woFzE8mEz90HxE7sDWx/szM2rSNmEdK83pqlL4Dr6Pi7roVa7RHvgI5B/vfggBBmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJ8LdjjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970D2606A31E;
	Wed, 25 Nov 2026 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJ8LdjjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83261F000C4;
	Wed, 25 Nov 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618124;
	bh=dr78bYtjaNj+fUdXzg8ZBkq5laVlRArTpNOKw0MK6h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJ8LdjjE8WeieywC5B9lV46BEDH0nf2ZsXKs+8+QDShhkViDek9m1ARRoXv5O/c45
	 qZkcVl5b2M0PuTRpmM11EOd1mYHopYHGKGFmmHG/BkCqesyOvaMflxEYT3L5r23j3j
	 /JJWEvfOeaRYW11GH7xq6Kbt06aHPkfQeY1drNLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0181/1005] bpf: Rename bpf_call_summary::num_params to arg_slot_cnt
Date: Wed, 25 Nov 2026 15:25:19 +0100
Message-ID: <20261125143825.981978967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit c6ff4e06033fede2fd1d41232ae942add649b759 ]

The field 'num_params' counts the argument registers and outgoing
stack slots a helper or kfunc call takes. The next patch gives a
16-byte parameter two slots, so the name stops describing what the
field holds.

Rename 'num_params' to 'arg_slot_cnt'. No functional change.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260912195232.988528-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: cdefba74b53f ("bpf: Don't trust pointers spilled in slots that a callee can write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  2 +-
 kernel/bpf/liveness.c        | 10 +++++-----
 kernel/bpf/verifier.c        |  8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 0eda96e1162f3..baf390c86406c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -1053,7 +1053,7 @@ static inline struct bpf_subprog_info *subprog_info(struct bpf_verifier_env *env
 }
 
 struct bpf_call_summary {
-	u8 num_params;
+	u8 arg_slot_cnt;
 	bool is_void;
 	bool fastcall;
 };
diff --git a/kernel/bpf/liveness.c b/kernel/bpf/liveness.c
index e1340e73cbeda..c7aa5c8fc34cf 100644
--- a/kernel/bpf/liveness.c
+++ b/kernel/bpf/liveness.c
@@ -1596,21 +1596,21 @@ static int record_call_access(struct bpf_verifier_env *env,
 {
 	struct bpf_insn *insn = &env->prog->insnsi[insn_idx];
 	struct bpf_call_summary cs;
-	int r, err, num_params = 5;
+	int r, err, arg_slot_cnt = 5;
 
 	if (bpf_pseudo_call(insn))
 		return 0;
 
 	if (bpf_get_call_summary(env, insn, &cs))
-		num_params = cs.num_params;
+		arg_slot_cnt = cs.arg_slot_cnt;
 
-	for (r = BPF_REG_1; r < BPF_REG_1 + min(num_params, MAX_BPF_FUNC_REG_ARGS); r++) {
+	for (r = BPF_REG_1; r < BPF_REG_1 + min(arg_slot_cnt, MAX_BPF_FUNC_REG_ARGS); r++) {
 		err = record_arg_access(env, instance, insn, &at[r], r - 1, insn_idx);
 		if (err)
 			return err;
 	}
 
-	for (r = 0; r < MAX_STACK_ARG_SLOTS && r < num_params - MAX_BPF_FUNC_REG_ARGS; r++) {
+	for (r = 0; r < MAX_STACK_ARG_SLOTS && r < arg_slot_cnt - MAX_BPF_FUNC_REG_ARGS; r++) {
 		err = record_arg_access(env, instance, insn, &at[MAX_BPF_REG + r],
 					r + MAX_BPF_FUNC_REG_ARGS, insn_idx);
 		if (err)
@@ -2386,7 +2386,7 @@ static void compute_insn_live_regs(struct bpf_verifier_env *env,
 			def = ALL_CALLER_SAVED_REGS;
 			use = def & ~BIT(BPF_REG_0);
 			if (bpf_get_call_summary(env, insn, &cs))
-				use = GENMASK(min_t(u8, cs.num_params, MAX_BPF_FUNC_REG_ARGS), 1);
+				use = GENMASK(min_t(u8, cs.arg_slot_cnt, MAX_BPF_FUNC_REG_ARGS), 1);
 			def = mask_widen(def);
 			use = mask_widen(use);
 			break;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ed356a03a57b..4bb0f362f44a8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17985,11 +17985,11 @@ bool bpf_get_call_summary(struct bpf_verifier_env *env, struct bpf_insn *call,
 			       (bpf_verifier_inlines_helper_call(env, call->imm) ||
 				bpf_jit_inlines_helper_call(call->imm));
 		cs->is_void = fn->ret_type == RET_VOID;
-		cs->num_params = 0;
+		cs->arg_slot_cnt = 0;
 		for (i = 0; i < ARRAY_SIZE(fn->arg_type); ++i) {
 			if (fn->arg_type[i] == ARG_DONTCARE)
 				break;
-			cs->num_params++;
+			cs->arg_slot_cnt++;
 		}
 		return true;
 	}
@@ -18001,7 +18001,7 @@ bool bpf_get_call_summary(struct bpf_verifier_env *env, struct bpf_insn *call,
 		if (err < 0)
 			/* error would be reported later */
 			return false;
-		cs->num_params = btf_type_vlen(meta.func_proto);
+		cs->arg_slot_cnt = btf_type_vlen(meta.func_proto);
 		cs->fastcall = meta.kfunc_flags & KF_FASTCALL;
 		cs->is_void = btf_type_is_void(btf_type_by_id(meta.btf, meta.func_proto->type));
 		return true;
@@ -18110,7 +18110,7 @@ static void mark_fastcall_pattern_for_call(struct bpf_verifier_env *env,
 	 * - includes R1-R5 if corresponding parameter has is described
 	 *   in the function prototype.
 	 */
-	clobbered_regs_mask = GENMASK(cs.num_params, cs.is_void ? 1 : 0);
+	clobbered_regs_mask = GENMASK(cs.arg_slot_cnt, cs.is_void ? 1 : 0);
 	/* e.g. if helper call clobbers r{0,1}, expect r{2,3,4,5} in the pattern */
 	expected_regs_mask = ~clobbered_regs_mask & ALL_CALLER_SAVED_REGS;
 
-- 
2.53.0



