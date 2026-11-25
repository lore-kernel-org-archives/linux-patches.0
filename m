Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618127;
	b=5nx1FBlAozT6eVA8sLWLK/MX09r4Jy+eTz66ugVY2eip+lYXecJW2gwCi3FrsPpNtnZD
	 MkHmdoIKfqb60XztcKaiVOF4hw5fFlTV4NZhkQjKymWZymETGaHDoCNVU41SF7ws11z3r
	 2MvQbmN8hfJYy7PKNzdxgTvwY5HuQrNyMsSNvMCVMnoutC3bTVZDqNKTiGw0N7bkUvwu7
	 Dxzo+li1kkw/O7VhsSXxDHN2wZ0pj+V0XIN0BQ+2qPpadnaWSC5GxvtPIiekRhq0wxSSe
	 NlR30moYc9/WCdZ8g6JtvOOoG8U6GNnOCEEC4s1wDaxH9YmrYnh72wQUnMUyn9Bmzrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9MPwhoXgDdbAYm324U8I/OIcNk6n4E/B/ByP9RVUDg=;
	b=gGnPk/EmIvxlZaa5BfFZg8KlmFml1NB8B0eYIaHn9oxCtStsxuRhYgXpT5zuvNLr+5wr
	 FC8cknlhIhwaoOqQP4Sysd9dE1wTunAJL8OZ9UJoN1kvN+oW+CsdXWkLFLhLsxJbWCbpO
	 bFU2znC8ZpxszBKUfOwhAoPlDVZLGFmm5NUgDINQgzIkLiE3keqT317/Ynf3m1IwraMSf
	 WyZeMgn5NZ2XMbrGYG5Ek4pgXc7TRtrkbFYN3aOpGkrEisZvf6Ro0c8DIR8mncxWF3ib4
	 y080pobQmsJHq2tVfddxEb10sCmEGgtzLIYV84ek5p6SqJ+as3p0cYO+FmkUOlczuVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdqS3MXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF56606A31E;
	Wed, 25 Nov 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdqS3MXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1931F000C4;
	Wed, 25 Nov 2026 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618127;
	bh=u9MPwhoXgDdbAYm324U8I/OIcNk6n4E/B/ByP9RVUDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdqS3MXhcOSfFA75dtX/VQaDiiSLU8xi+6vQ5czJTJmWMAV9dYIqI8NkDuyh7iz7x
	 uodKmEIwq5LkCpR6fpvaWps6651ukKNxAKqNdyZeD1TlBzagnyvidC3FUJLf0HxOXA
	 /Un6eKHc7cRLwNmgyq+gEtKq4RSJe/W2C/sdhjes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0182/1005] bpf: Prepare static analysis passes for callx instruction
Date: Wed, 25 Nov 2026 15:25:20 +0100
Message-ID: <20261125143826.004988521@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 373e3fd0bff0e276fd76c86c830cdb16a3457776 ]

BPF_JMP | BPF_CALL | BPF_X (callx) will be an indirect call of static
subprog with address in dst_reg. The passes that run before the main
verifier pass don't know which subprog callx calls.
Teach them to treat callx as a call with unknown callee:

- const_fold: callx clobbers R0-R5 like any other call. Otherwise
  bpf_prune_dead_branches() could rewrite a live conditional jump.

- live regs: callx uses R1-R5 and dst_reg, defines R0-R5.

- stack liveness: func instances are keyed by (callsite, depth) and
  cannot describe a callsite with multiple callees. Don't create
  instances for callees of callx. If any callx argument is derived
  from fp mark stack of all frames as read at callx insn and keep slots
  of outer frames alive 'before' the callsite while the callee is
  verified. Same as for callbacks that are not known statically.
  The callee is analyzed as standalone instance.

- backtracking: treat callx as a call of static subprog, same as
  BPF_PSEUDO_CALL.

callx is still rejected as unknown opcode. No functional change.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260924031042.1690890-5-alexei.starovoitov@gmail.com
Stable-dep-of: cdefba74b53f ("bpf: Don't trust pointers spilled in slots that a callee can write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  6 ++++++
 kernel/bpf/backtrack.c       | 20 +++++++++++--------
 kernel/bpf/const_fold.c      |  3 ++-
 kernel/bpf/liveness.c        | 38 +++++++++++++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index baf390c86406c..a253ca2c6e5d3 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -1076,6 +1076,12 @@ static inline bool bpf_pseudo_kfunc_call(const struct bpf_insn *insn)
 	       insn->src_reg == BPF_PSEUDO_KFUNC_CALL;
 }
 
+/* callx: indirect call of a bpf subprog whose address is in insn->dst_reg */
+static inline bool bpf_is_callx(const struct bpf_insn *insn)
+{
+	return insn->code == (BPF_JMP | BPF_CALL | BPF_X);
+}
+
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
 				      const char *fmt, va_list args);
 __printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
diff --git a/kernel/bpf/backtrack.c b/kernel/bpf/backtrack.c
index 44d107fd96c4d..50c66115ab45e 100644
--- a/kernel/bpf/backtrack.c
+++ b/kernel/bpf/backtrack.c
@@ -406,15 +406,18 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 		if (class == BPF_STX)
 			bt_set_reg(bt, sreg);
 	} else if (class == BPF_JMP || class == BPF_JMP32) {
-		if (bpf_pseudo_call(insn)) {
-			int subprog_insn_idx, subprog;
+		if (bpf_pseudo_call(insn) || bpf_is_callx(insn)) {
+			int subprog_insn_idx, subprog = -1;
 
-			subprog_insn_idx = idx + insn->imm + 1;
-			subprog = bpf_find_subprog(env, subprog_insn_idx);
-			if (subprog < 0)
-				return -EFAULT;
+			if (bpf_pseudo_call(insn)) {
+				subprog_insn_idx = idx + insn->imm + 1;
+				subprog = bpf_find_subprog(env, subprog_insn_idx);
+				if (subprog < 0)
+					return -EFAULT;
+			}
 
-			if (bpf_subprog_is_global(env, subprog)) {
+			/* callx calls static subprogs only */
+			if (subprog >= 0 && bpf_subprog_is_global(env, subprog)) {
 				/* check that jump history doesn't have any
 				 * extra instructions from subprog; the next
 				 * instruction after call to global subprog
@@ -531,7 +534,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 			 * necessary. In the former we never do that.
 			 */
 			from_subprog_call = subseq_idx - 1 >= 0 &&
-					    bpf_pseudo_call(&env->prog->insnsi[subseq_idx - 1]);
+					    (bpf_pseudo_call(&env->prog->insnsi[subseq_idx - 1]) ||
+					     bpf_is_callx(&env->prog->insnsi[subseq_idx - 1]));
 
 			r0_precise = from_subprog_call && bt_is_reg_set(bt, BPF_REG_0);
 
diff --git a/kernel/bpf/const_fold.c b/kernel/bpf/const_fold.c
index d8d2d00380aef..e090f368e9256 100644
--- a/kernel/bpf/const_fold.c
+++ b/kernel/bpf/const_fold.c
@@ -191,7 +191,8 @@ static void const_reg_xfer(struct bpf_verifier_env *env, struct const_arg_info *
 		dst->val = val;
 		break;
 	case BPF_JMP:
-		if (opcode != BPF_CALL)
+		/* both 'call imm' and 'callx reg' clobber caller saved registers */
+		if (BPF_OP(insn->code) != BPF_CALL)
 			break;
 process_call:
 		for (r = BPF_REG_0; r <= BPF_REG_5; r++)
diff --git a/kernel/bpf/liveness.c b/kernel/bpf/liveness.c
index c7aa5c8fc34cf..b01cdabaf3bf5 100644
--- a/kernel/bpf/liveness.c
+++ b/kernel/bpf/liveness.c
@@ -464,12 +464,29 @@ int bpf_live_stack_query_init(struct bpf_verifier_env *env, struct bpf_verifier_
 	return 0;
 }
 
+/*
+ * Stack slots of outer frames that the callee may read are accounted as read
+ * by the @callsite insn itself, i.e. they are live before @callsite and may be
+ * dead after it, when:
+ * - @callsite calls a callback, which may be called several times;
+ * - @callsite is callx. Its callee is not known when stack liveness is
+ *   computed, so there is no func instance for it at @callsite. While
+ *   the verifier is in the callee lookup_instance() finds its standalone
+ *   instance that knows nothing about outer frames. What the callee may read
+ *   there is recorded by record_call_access().
+ */
+static bool callee_stack_access_at_callsite(struct bpf_verifier_env *env, u32 callsite)
+{
+	return bpf_calls_callback(env, callsite) ||
+	       bpf_is_callx(&env->prog->insnsi[callsite]);
+}
+
 bool bpf_stack_slot_alive(struct bpf_verifier_env *env, u32 frameno, u32 half_spi)
 {
 	/*
 	 * Slot is alive if it is read before q->insn_idx in current func instance,
 	 * or if for some outer func instance:
-	 * - alive before callsite if callsite calls callback, otherwise
+	 * - alive before callsite if callsite calls callback or is callx, otherwise
 	 * - alive after callsite
 	 */
 	struct live_stack_query *q = &env->liveness->live_stack_query;
@@ -502,7 +519,7 @@ bool bpf_stack_slot_alive(struct bpf_verifier_env *env, u32 frameno, u32 half_sp
 		/* Get callsite from verifier state, not from instance callchain */
 		callsite = q->callsites[i];
 
-		alive = bpf_calls_callback(env, callsite)
+		alive = callee_stack_access_at_callsite(env, callsite)
 			? is_live_before(instance, callsite, rel, half_spi)
 			: is_live_before(instance, callsite + 1, rel, half_spi);
 		if (alive)
@@ -1601,7 +1618,15 @@ static int record_call_access(struct bpf_verifier_env *env,
 	if (bpf_pseudo_call(insn))
 		return 0;
 
-	if (bpf_get_call_summary(env, insn, &cs))
+	if (bpf_is_callx(insn))
+		/*
+		 * The callee is not known statically. Assume that all arg
+		 * slots are passed and let record_arg_access() conservatively
+		 * mark the stack of all frames as read if any of them is
+		 * derived from a frame pointer.
+		 */
+		arg_slot_cnt = MAX_BPF_FUNC_REG_ARGS + MAX_STACK_ARG_SLOTS;
+	else if (bpf_get_call_summary(env, insn, &cs))
 		arg_slot_cnt = cs.arg_slot_cnt;
 
 	for (r = BPF_REG_1; r < BPF_REG_1 + min(arg_slot_cnt, MAX_BPF_FUNC_REG_ARGS); r++) {
@@ -1695,7 +1720,7 @@ static void print_subprog_arg_access(struct bpf_verifier_env *env,
 		bool has_extra = false;
 		u8 cls = BPF_CLASS(insns[idx].code);
 		bool is_ldx_stx_call = cls == BPF_LDX || cls == BPF_STX ||
-				       insns[idx].code == (BPF_JMP | BPF_CALL);
+				       (cls == BPF_JMP && BPF_OP(insns[idx].code) == BPF_CALL);
 
 		verbose(env, "%3d: ", idx);
 		bpf_verbose_insn(env, &insns[idx]);
@@ -1887,7 +1912,7 @@ static int compute_subprog_args(struct bpf_verifier_env *env,
 		if (err)
 			goto err_free;
 
-		if (insn->code == (BPF_JMP | BPF_CALL)) {
+		if (BPF_CLASS(insn->code) == BPF_JMP && BPF_OP(insn->code) == BPF_CALL) {
 			err = record_call_access(env, instance, at_in[i], idx);
 			if (err)
 				goto err_free;
@@ -2389,6 +2414,9 @@ static void compute_insn_live_regs(struct bpf_verifier_env *env,
 				use = GENMASK(min_t(u8, cs.arg_slot_cnt, MAX_BPF_FUNC_REG_ARGS), 1);
 			def = mask_widen(def);
 			use = mask_widen(use);
+			/* callx reads the address of the callee from dst_reg */
+			if (bpf_is_callx(insn))
+				use |= dst;
 			break;
 		default:
 			def = 0;
-- 
2.53.0



