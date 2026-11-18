Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018793;
	b=QzJ4273VsHvCpskuUYlVKuDX9p+WFT1wMjUUj3C+X5x1IL0/tOrSFxGMgZdc/IX1PhnF
	 AM2qPpr1wtLFVMX89BFq6gDtyX3S45wbfUHng8au+RWVyp8BvnJU/4lwApiw5lmRKM8fy
	 6ghjxKgVOg1FnGaQnhLEmW5qv7w4GJzDjAsne9cMDPA+KOO9i88g+hVQIxiC8I7NjtrOn
	 h3/VkIbQB6Up6A6zx1ASuQ8OTs5UbUtgRzxT9UcaWTLu4oOgxZ9cf+cU7qxrbZlNl1C08
	 qHDR9IMwrQ1j+UmXSMbJ0F731vlMnYbrPztc1rNOKJ9pRAXF3Z9PLwaextAGfPtqE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aEs5/vH59BtXp/1vwxoLisYFehaw8evwRNRsHPd2g9E=;
	b=NTgRbyDiMM4WZzivbINmuUBGbCbvurzBrXUPFqEWt8/4JOsIdWSDTHxHkLS2Qj8xkXK1
	 BjRmlfkQvCxDeMcCA3YqiOYFyDno8ZDCgtxd9i3XmdE16ARN5ktKg8aIN5f5llu3ICUjf
	 Bzwx/lPJDYVKmC/q5BIpdgDhBLpD0UQLd65zmckZOgrRPMLnyAYTwFRSEmDD0FgFQ2QLd
	 A16gb3/SGyRTIEN+Nryr5z7jM1uUm4vrvCdI2L+AF21qrto0ii9mo8LbefR8EyEo5o1dZ
	 LU2AriJYSPsOG1MXHR/n0ifTZtfIrBSPG4AKIdh0F3e4F/SbiOEDzcIHQHQzJm21N5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbZK3y7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41468606A330;
	Wed, 18 Nov 2026 16:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbZK3y7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A6D1F000C4;
	Wed, 18 Nov 2026 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018792;
	bh=aEs5/vH59BtXp/1vwxoLisYFehaw8evwRNRsHPd2g9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbZK3y7luWosseuJvZcaLe6hYqZsHkbBxd0UVuV1vOX52vpwNk9gL9WT02OrVABVq
	 6gkU0m15/qY1n2KLZ6wqwZQyFoUm76y4urnB72XoUh+47hYwj8zFY7sS5Cge9isnTw
	 eqoDFG2X44Uy5HOd73sGTX7GoHdwtnR/9BePjpbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Xu Yunxiang <xyx2021@mail.ustc.edu.cn>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1367/2651] bpf: Destroy callee-local dynptrs on subprog return
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150337.246937038@linuxfoundation.org>
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

From: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>

[ Upstream commit b65cc81792eb07436879d9f0be8ebd18a78fffb4 ]

A data slice is valid only while the specific dynptr that produced it
remains valid. prepare_func_exit() copies a subprogram return value into
the caller and then frees the callee state without applying the normal
destruction semantics to dynptrs in the callee stack.

A callee can therefore derive a slice from a local dynptr, return or spill
the slice into its caller, and then let the dynptr disappear with the
callee frame. The slice retains the id of a dynptr that is no longer in the
verifier state, so the verifier continues to accept accesses through it.

Before the object relationship refactor, bpf_dynptr_data() slices from
referenced dynptrs also carried the shared reference id, allowing a later
release to catch some of these escaped slices. The refactor made those
slices precise children of their source dynptr and exposed the missing
teardown as an accepted stale access even after the shared resource is
released.

Add destroy_dynptrs_in_stack_slots() to apply the existing dynptr teardown
to an inclusive range of stack slots. Reuse it for dynptr initialization,
variable-offset stack writes, and the entire callee stack before freeing
the frame. The teardown rejects losing the last dynptr for a referenced
resource and invalidates the dynptr and all its descendants, including
slices held in the caller. Propagate errors through prepare_func_exit().

Reuse the existing teardown API and diagnostic. Update the affected
callback test expectation in this change so the commit remains test-clean.

Fixes: 308c7a0ae885 ("bpf: Refactor object relationship tracking and fix dynptr UAF bug")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/CAMB2axOmdHwSrHihSRskDywkCmEGQOX+6dZPN_A9u-HhxY3UDA@mail.gmail.com
Link: https://lore.kernel.org/r/CAMB2axMmrTb+UZ84UD48MwMtXbk1s9bWtreU3AOfjzU0fPT0BA@mail.gmail.com
Link: https://lore.kernel.org/bpf/20260927120422.1042107-2-xyx2021@mail.ustc.edu.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 40 +++++++++++++------
 .../testing/selftests/bpf/progs/dynptr_fail.c |  4 +-
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6e76a9712d0b2..6faf5eab48ffd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -669,6 +669,21 @@ static void mark_dynptr_cb_reg(struct bpf_verifier_env *env,
 static int destroy_if_dynptr_stack_slot(struct bpf_verifier_env *env,
 				        struct bpf_func_state *state, int spi);
 
+static int destroy_dynptrs_in_stack_slots(struct bpf_verifier_env *env,
+					  struct bpf_func_state *state,
+					  int first_spi, int last_spi)
+{
+	int spi, err;
+
+	for (spi = first_spi; spi <= last_spi; spi++) {
+		err = destroy_if_dynptr_stack_slot(env, state, spi);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int mark_stack_slots_dynptr(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 				   enum bpf_arg_type arg_type, int insn_idx,
 				   struct ref_obj_desc *ref_obj, struct bpf_dynptr_desc *dynptr)
@@ -682,7 +697,7 @@ static int mark_stack_slots_dynptr(struct bpf_verifier_env *env, struct bpf_reg_
 		return spi;
 
 	/* We cannot assume both spi and spi - 1 belong to the same dynptr,
-	 * hence we need to call destroy_if_dynptr_stack_slot twice for both,
+	 * hence we need to destroy dynptrs in both slots,
 	 * to ensure that for the following example:
 	 *	[d1][d1][d2][d2]
 	 * spi    3   2   1   0
@@ -690,10 +705,7 @@ static int mark_stack_slots_dynptr(struct bpf_verifier_env *env, struct bpf_reg_
 	 * case they do belong to same dynptr, second call won't see slot_type
 	 * as STACK_DYNPTR and will simply skip destruction.
 	 */
-	err = destroy_if_dynptr_stack_slot(env, state, spi);
-	if (err)
-		return err;
-	err = destroy_if_dynptr_stack_slot(env, state, spi - 1);
+	err = destroy_dynptrs_in_stack_slots(env, state, spi - 1, spi);
 	if (err)
 		return err;
 
@@ -3696,14 +3708,10 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 	    (!value_reg && is_bpf_st_mem(insn) && insn->imm == 0))
 		writing_zero = true;
 
-	for (i = min_off; i < max_off; i++) {
-		int spi;
-
-		spi = bpf_get_spi(i);
-		err = destroy_if_dynptr_stack_slot(env, state, spi);
-		if (err)
-			return err;
-	}
+	err = destroy_dynptrs_in_stack_slots(env, state, bpf_get_spi(max_off - 1),
+					     bpf_get_spi(min_off));
+	if (err)
+		return err;
 
 	/* Variable offset writes destroy any spilled pointers in range. */
 	for (i = min_off; i < max_off; i++) {
@@ -10463,6 +10471,12 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		bpf_diag_mod_end(env);
 	}
 
+	/* Invalidate callee-local dynptrs and their slices before the frame goes away. */
+	err = destroy_dynptrs_in_stack_slots(env, callee, 0,
+					     callee->allocated_stack / BPF_REG_SIZE - 1);
+	if (err)
+		return err;
+
 	/* for callbacks like bpf_loop or bpf_for_each_map_elem go back to callsite,
 	 * there function call logic would reschedule callback visit. If iteration
 	 * converges is_state_visited() would prune that visit eventually.
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index 1cd61d72c166f..55c9a6be7fc56 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -125,9 +125,9 @@ static int missing_release_callback_fn(__u32 index, void *data)
 	return 0;
 }
 
-/* Any dynptr initialized within a callback must have bpf_dynptr_put called */
+/* A callback cannot return with the last dynptr for a referenced resource. */
 SEC("?raw_tp")
-__failure __msg("Unreleased reference id")
+__failure __msg("cannot overwrite referenced dynptr")
 int ringbuf_missing_release_callback(void *ctx)
 {
 	bpf_loop(10, missing_release_callback_fn, NULL, 0);
-- 
2.53.0



