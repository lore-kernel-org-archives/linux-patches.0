Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019388;
	b=FNJmQNAfctUQY7l62hcQHCNzW8MUoF9DIilfqAnMzItgH6qG0xnv8UrMLMv6iEjspXyQ
	 PRfpdGhxGOuKZ2sM1RkJaP4itZQO31Szce5fbNzGgMWqEX0JrJIyvsvOE0FfvCWGIcMeo
	 L5wb4GTDkUjap+qGzZFZXpLb4GpYyyr17ZVWUZvk+etKPUxEimEHeyrReW8IoW4LGRtxn
	 jf00sc9Jva/RqpGzqxIy0Fbbg4YLhO8m/I9cMlGjaXPqFK41MuZgej/r4f4V1uWdNa1jD
	 3UuyixhZMZ/BDEO+hQ+CxzRCpwtAB3LdoRZo0UK76peSlS7wafdTNhFVfAPsL0LMFcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qal1ijP4hQuPznbYHc/04G/pOHq24ggUFCq/j1ycJj8=;
	b=ba/qMkWfL5BtEnAnuoNXdimQGaruDXq9HHLHaFTNp0ZQ1qVxgb1wsbFHfrwCOtF6Nc6Y
	 S+XU1PxF9QRa2mg4OrHtWjg0jCafKxn5Cy6LB/Ud7GpQLME74SrZk0FHOvVmvi29kceaq
	 Z5xlgw/iGRen9vR5pd0GDmnthpTwa0+gUlbs5Txd+nItTAP2gNXmFaOU8rTJP7q4qDhjy
	 BFDRnfvEn3AmTIjg7JLy1OTUnBW7p4P1MHeRPBt3ZolSbcdYwf2jqWdAVk6hR/38TPJfU
	 KXRV8rI6fNl1GxYJHkBtLeLrcQ2xahG6vthj+7hiTuQXLGpOVKAkKKqxH6Mg+v8YIrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJAOxhOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF09160A2604;
	Wed, 18 Nov 2026 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJAOxhOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192E41F000C4;
	Wed, 18 Nov 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019388;
	bh=Qal1ijP4hQuPznbYHc/04G/pOHq24ggUFCq/j1ycJj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJAOxhOo0/dGl3jqPW2Sz93knfYIwgvBMNq5iOHTaiL2U5jwI4LaUg4j1MFB0mP6q
	 ykX6n1Fo0uNaHE9E1C1/Dzp4gE7c9/CM7vtfku4XpFimJM8/UEDv4470LtNhKAeHRc
	 ZpHv+q6Wt7dN6ZYyMrqdwW/h+yPcHAsPT5kMiLlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1579/2651] bpf: Save DFS postorder numbers for program instructions
Date: Wed, 18 Nov 2026 15:46:59 +0100
Message-ID: <20261118150344.765250845@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit f414d20879ae1bac413619b8352701a7da2a1c0e ]

Dominator intersections and SCEV worklist scheduling need to compare
instructions by their DFS postorder rank. Save per-instruction
postorder numbers alongside the existing postorder sequence.

This commit modifies bpf_compute_postorder() to actually do the DFS
traversal, instead of scheduling traversal of all siblings at once.

Consider a graph:

  A -> B
  A -> C
  C -> B

Old result: C, B, A
DFS result: B, C, A

Fixes: efcda22aa541 ("bpf: compute instructions postorder per subprogram")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009-scev-minimal-rebase-v3-21-bcba9bc53ac9@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/cfg.c             | 56 ++++++++++++++++++++++--------------
 kernel/bpf/const_fold.c      |  2 ++
 kernel/bpf/verifier.c        |  1 +
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 32fb808f3ff0b..fac29ea44b930 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -960,6 +960,7 @@ struct bpf_verifier_env {
 		 * see bpf_subprog_info->postorder_start.
 		 */
 		int *insn_postorder;
+		int *postorder_nums;
 		int cur_stack;
 		/* current position in the insn_postorder vector */
 		int cur_postorder;
diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index a11ff94e77ac8..c4c3badde6c9c 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -703,6 +703,11 @@ int bpf_check_cfg(struct bpf_verifier_env *env)
 	return ret;
 }
 
+struct dfs_state {
+	u32 traversed:1;
+	u32 next_succ:31;
+};
+
 /*
  * For each subprogram 'i' fill array env->cfg.insn_subprogram sub-range
  * [env->subprog_info[i].postorder_start, env->subprog_info[i+1].postorder_start)
@@ -710,43 +715,52 @@ int bpf_check_cfg(struct bpf_verifier_env *env)
  */
 int bpf_compute_postorder(struct bpf_verifier_env *env)
 {
-	u32 cur_postorder, i, top, stack_sz, s;
-	int *stack = NULL, *postorder = NULL, *state = NULL;
-	struct bpf_iarray *succ;
+	int *stack = NULL, *postorder = NULL, *postorder_nums = NULL;
+	int subprog_idx, stack_sz, cur, s, cur_postorder, start;
+	struct dfs_state *state = NULL;
+	struct bpf_iarray *succ = NULL;
 
+	postorder_nums = kvzalloc_objs(int, env->prog->len, GFP_KERNEL_ACCOUNT);
 	postorder = kvzalloc_objs(int, env->prog->len, GFP_KERNEL_ACCOUNT);
-	state = kvzalloc_objs(int, env->prog->len, GFP_KERNEL_ACCOUNT);
 	stack = kvzalloc_objs(int, env->prog->len, GFP_KERNEL_ACCOUNT);
-	if (!postorder || !state || !stack) {
+	state = kvzalloc_objs(struct dfs_state, env->prog->len, GFP_KERNEL_ACCOUNT);
+	if (!postorder_nums || !postorder || !stack || !state) {
+		kvfree(postorder_nums);
 		kvfree(postorder);
-		kvfree(state);
 		kvfree(stack);
+		kvfree(state);
 		return -ENOMEM;
 	}
 	cur_postorder = 0;
-	for (i = 0; i < env->subprog_cnt; i++) {
-		env->subprog_info[i].postorder_start = cur_postorder;
-		stack[0] = env->subprog_info[i].start;
+	for (subprog_idx = 0; subprog_idx < env->subprog_cnt; subprog_idx++) {
+		start = env->subprog_info[subprog_idx].start;
+		env->subprog_info[subprog_idx].postorder_start = cur_postorder;
+		stack[0] = start;
 		stack_sz = 1;
+		state[start].traversed = true;
 		do {
-			top = stack[stack_sz - 1];
-			state[top] |= DISCOVERED;
-			if (state[top] & EXPLORED) {
-				postorder[cur_postorder++] = top;
+			cur = stack[stack_sz - 1];
+			succ = bpf_insn_successors(env, cur);
+			if (state[cur].next_succ == succ->cnt) {
+				postorder_nums[cur] = cur_postorder;
+				postorder[cur_postorder] = cur;
+				cur_postorder++;
 				stack_sz--;
 				continue;
 			}
-			succ = bpf_insn_successors(env, top);
-			for (s = 0; s < succ->cnt; ++s) {
-				if (!state[succ->items[s]]) {
-					stack[stack_sz++] = succ->items[s];
-					state[succ->items[s]] |= DISCOVERED;
-				}
+			s = succ->items[state[cur].next_succ];
+			if (!state[s].traversed) {
+				state[s].traversed = true;
+				state[s].next_succ = 0;
+				stack[stack_sz] = s;
+				stack_sz++;
+				continue;
 			}
-			state[top] |= EXPLORED;
+			state[cur].next_succ++;
 		} while (stack_sz);
 	}
-	env->subprog_info[i].postorder_start = cur_postorder;
+	env->subprog_info[subprog_idx].postorder_start = cur_postorder;
+	env->cfg.postorder_nums = postorder_nums;
 	env->cfg.insn_postorder = postorder;
 	env->cfg.cur_postorder = cur_postorder;
 	kvfree(stack);
diff --git a/kernel/bpf/const_fold.c b/kernel/bpf/const_fold.c
index 7f1b30059cc87..d8d2d00380aef 100644
--- a/kernel/bpf/const_fold.c
+++ b/kernel/bpf/const_fold.c
@@ -394,5 +394,7 @@ int bpf_prune_dead_branches(struct bpf_verifier_env *env)
 	/* recompute postorder, since CFG has changed */
 	kvfree(env->cfg.insn_postorder);
 	env->cfg.insn_postorder = NULL;
+	kvfree(env->cfg.postorder_nums);
+	env->cfg.postorder_nums = NULL;
 	return bpf_compute_postorder(env);
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6faf5eab48ffd..25cec4556e61a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21611,6 +21611,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr,
 	vfree(env->insn_aux_data);
 	kvfree(env->fd_array);
 	bpf_stack_liveness_free(env);
+	kvfree(env->cfg.postorder_nums);
 	kvfree(env->cfg.insn_postorder);
 	kvfree(env->scc_info);
 	kvfree(env->succ);
-- 
2.53.0



