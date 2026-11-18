Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020828;
	b=k93HRKNONNUXsg6WNMjHglOalAky/956Ovsa3jYjViRudWDzfJxwQz/ZKT1MmeZLfi5k
	 NJXF92F6IEPxUJeK065u5XmD32Fzs9pGZA6Jh3a8PG6S9Hpye1H+AGbzepd9+wpXjBjtW
	 gY7EZ54nlvmUd5p8u+gGvf5CMs2mBR5gIgwamgKf7H0LB5nIBBNUnGCW2NKMAsxN3RWrz
	 5qQiK4jb3lontAdWFjbjNrwTp+LW6jLLxOVLs7rB7Nv56NxXdJtB2HlEPnJwL4iOmAcI/
	 7moOYpVn0HqGLkw1J9OugzW3q66CQ3P3XpoQm8KE875s+XDaqg96C3XcvGoxf4cwg2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQPTgehLSN5mcp7Q/snpXI8qgt4OYJpX44ZcXoOcyU8=;
	b=oTnHh7tSbJvHg2teoB7B+x1nPwQg5BdAW9jnNswwKlD53HqJp04q/2QNIOGjAYrIwdm5
	 KPIs9MxkbRHvQ5ihPX5t5U5kImI4qSPyxyT/rCsfvFbQ5jV2C4etEpGdJIzAvR8kgmcii
	 9LcytIR4ErJ2HKuHylFbFAET9/m0lHnOuPDxrsrTK8+98hQobwuDBq4LpnmJVwakSoY3H
	 MbWE6d9gud+lUrQu/oziSgNAj4yuz/LANz6CVD8fsOWQmijXjRe5XtiWLhVPuT5mCG0mC
	 aZLvg/euFgvA5sdBM4SZfw0/pDaoSAOXD3Wz8Bnd0IEGZiFXA4IZslIelNSXurRg1GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXT2xn8T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2060A260D;
	Wed, 18 Nov 2026 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXT2xn8T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A6C1F000C4;
	Wed, 18 Nov 2026 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020828;
	bh=oQPTgehLSN5mcp7Q/snpXI8qgt4OYJpX44ZcXoOcyU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXT2xn8Twx+kZC6ibijx+Dvnt6PQAEiCqeJSKSUE1/rA0ZG6AefNNdacwX3vguqyE
	 zCc0jXHbJGw+LNvU5NQpVPBkr89QgKtCEMXLO0adDDQezZkaTB+L+AkF/wQ25elkwv
	 ZLKfwkpeOrHTn41JgIevJXf4khDHjzRdyXQaAZC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2089/2651] bpf: Report non-sleepable kfunc programs accurately
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150401.226632141@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit dac3b7a30d7e5384a61ee46f476dc2c45ceb9453 ]

A sleepable kfunc call can fail either because the program is not
sleepable or because an otherwise sleepable program has entered a
non-sleepable critical section. check_kfunc_call() checks these
conditions separately. The first check is only gated by in_sleepable(),
so the shared diagnostic can blame an active RCU, preemption-disabled,
IRQ-disabled, or locked region even though leaving that region would not
make the program sleepable. Adding a second diagnostic entry point only
to force the program context would duplicate the API.

Reject the call once based on in_sleepable_context(). Teach the shared
bpf_diag_ctx_forbidden() reporter and non_sleepable_context_description()
to consider active RCU, preempt, IRQ, and lock regions only when the
program is sleepable, and to fall back to the non-sleepable program
otherwise. A non-sleepable program can still hold that context state, so
relying on the existing no-context fallback alone would keep blaming the
critical section.

Select the suggestion at the kfunc, helper, and global-function sites
according to that cause, and choose between the two existing kfunc
verifier messages the same way, so a sleepable program is told to leave
the critical section and a non-sleepable program is told to become
sleepable.

This avoids a diagnostic-only wrapper while retaining context history for
sleepable programs that enter a forbidden region.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/2e42a1a2bf45f4d2aba7495bdc9f147558055740e2f3c8b9dae255f6c57fc13c@mail.kernel.org/
Link: https://patch.msgid.link/20260924170646.2366016-5-memxor@gmail.com
Stable-dep-of: 9bdd5e7f5d83 ("bpf: Forbid sleeping in hash map for_each callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/diagnostics.c | 21 +++++++-------
 kernel/bpf/verifier.c    | 62 ++++++++++++++++++++++++----------------
 2 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/kernel/bpf/diagnostics.c b/kernel/bpf/diagnostics.c
index ffca5723b287e..67cd75d1cf382 100644
--- a/kernel/bpf/diagnostics.c
+++ b/kernel/bpf/diagnostics.c
@@ -1088,16 +1088,17 @@ void bpf_diag_ctx_forbidden(struct bpf_verifier_env *env, u32 insn_idx,
 	const char *constraint, *context;
 	u32 depth;
 
-	if (env->cur_state->active_rcu_locks)
-		ctx_kind = BPF_DIAG_CONTEXT_RCU;
-	else if (env->cur_state->active_preempt_locks)
-		ctx_kind = BPF_DIAG_CONTEXT_PREEMPT;
-	else if (env->cur_state->active_irq_id)
-		ctx_kind = BPF_DIAG_CONTEXT_IRQ;
-	else if (env->cur_state->active_locks)
-		ctx_kind = BPF_DIAG_CONTEXT_LOCK;
-	else
-		ctx_kind = BPF_DIAG_CONTEXT_NONE;
+	ctx_kind = BPF_DIAG_CONTEXT_NONE;
+	if (env->cur_state->in_sleepable) {
+		if (env->cur_state->active_rcu_locks)
+			ctx_kind = BPF_DIAG_CONTEXT_RCU;
+		else if (env->cur_state->active_preempt_locks)
+			ctx_kind = BPF_DIAG_CONTEXT_PREEMPT;
+		else if (env->cur_state->active_irq_id)
+			ctx_kind = BPF_DIAG_CONTEXT_IRQ;
+		else if (env->cur_state->active_locks)
+			ctx_kind = BPF_DIAG_CONTEXT_LOCK;
+	}
 
 	depth = diag_context_depth(env, ctx_kind);
 	opts = (struct bpf_diag_history_opts) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 25cec4556e61a..2ee66a02ac95d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10020,11 +10020,16 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		}
 
 		if (env->subprog_info[subprog].might_sleep && !in_sleepable_context(env)) {
+			const char *suggestion;
+
 			verbose(env, "sleepable global function %s() called in %s\n",
 				sub_name, non_sleepable_context_description(env));
+			if (in_sleepable(env))
+				suggestion = "Move the call outside the critical section, or use a non-sleepable function.";
+			else
+				suggestion = "Mark the program sleepable if the program type allows it, or use a non-sleepable function.";
 			operation = bpf_diag_fmt(env, "sleepable global function %s()", sub_name);
-			bpf_diag_ctx_forbidden(env, *insn_idx, operation,
-				"Move the call outside the critical section, or use a non-sleepable function.");
+			bpf_diag_ctx_forbidden(env, *insn_idx, operation, suggestion);
 			return -EINVAL;
 		}
 
@@ -10872,14 +10877,16 @@ static inline bool in_sleepable_context(struct bpf_verifier_env *env)
 
 static const char *non_sleepable_context_description(struct bpf_verifier_env *env)
 {
-	if (env->cur_state->active_rcu_locks)
-		return "rcu_read_lock region";
-	if (env->cur_state->active_preempt_locks)
-		return "non-preemptible region";
-	if (env->cur_state->active_irq_id)
-		return "IRQ-disabled region";
-	if (env->cur_state->active_locks)
-		return "lock region";
+	if (in_sleepable(env)) {
+		if (env->cur_state->active_rcu_locks)
+			return "rcu_read_lock region";
+		if (env->cur_state->active_preempt_locks)
+			return "non-preemptible region";
+		if (env->cur_state->active_irq_id)
+			return "IRQ-disabled region";
+		if (env->cur_state->active_locks)
+			return "lock region";
+	}
 	return "non-sleepable prog";
 }
 
@@ -10971,12 +10978,17 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	}
 
 	if (fn->might_sleep && !in_sleepable_context(env)) {
+		const char *suggestion;
+
 		verbose(env, "sleepable helper %s#%d in %s\n", func_id_name(func_id), func_id,
 			non_sleepable_context_description(env));
+		if (in_sleepable(env))
+			suggestion = "Move the helper call outside the critical section, or use a non-sleepable helper.";
+		else
+			suggestion = "Mark the program sleepable if the program type allows it, or use a non-sleepable helper.";
 		operation = bpf_diag_fmt(env, "sleepable helper %s#%d",
 					 func_id_name(func_id), func_id);
-		bpf_diag_ctx_forbidden(env, insn_idx, operation,
-			"Move the helper call outside the critical section, or use a non-sleepable helper.");
+		bpf_diag_ctx_forbidden(env, insn_idx, operation, suggestion);
 		return -EINVAL;
 	}
 
@@ -13941,11 +13953,20 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	}
 
 	sleepable = bpf_is_kfunc_sleepable(&meta);
-	if (sleepable && !in_sleepable(env)) {
-		verbose(env, "program must be sleepable to call sleepable kfunc %s\n", func_name);
+	if (sleepable && !in_sleepable_context(env)) {
+		const char *suggestion;
+
+		if (in_sleepable(env)) {
+			verbose(env, "kernel func %s is sleepable within %s\n",
+				func_name, non_sleepable_context_description(env));
+			suggestion = "Move the kfunc call outside the critical section, or use a non-sleepable kfunc.";
+		} else {
+			verbose(env, "program must be sleepable to call sleepable kfunc %s\n",
+				func_name);
+			suggestion = "Mark the program sleepable if the program type allows it, or use a non-sleepable kfunc.";
+		}
 		operation = bpf_diag_fmt(env, "sleepable kfunc %s", func_name);
-		bpf_diag_ctx_forbidden(env, insn_idx, operation,
-			"Mark the program sleepable if the program type allows it, or use a non-sleepable kfunc.");
+		bpf_diag_ctx_forbidden(env, insn_idx, operation, suggestion);
 		return -EACCES;
 	}
 
@@ -14045,15 +14066,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			invalidate_rcu_protected_refs(env);
 	}
 
-	if (sleepable && !in_sleepable_context(env)) {
-		verbose(env, "kernel func %s is sleepable within %s\n",
-			func_name, non_sleepable_context_description(env));
-		operation = bpf_diag_fmt(env, "sleepable kfunc %s", func_name);
-		bpf_diag_ctx_forbidden(env, insn_idx, operation,
-			"Move the kfunc call outside the critical section, or use a non-sleepable kfunc.");
-		return -EACCES;
-	}
-
 	if (in_rbtree_lock_required_cb(env) && (rcu_lock || rcu_unlock)) {
 		verbose(env, "Calling bpf_rcu_read_{lock,unlock} in unnecessary rbtree callback\n");
 		return -EACCES;
-- 
2.53.0



