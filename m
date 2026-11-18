Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017432;
	b=Y9yrm8YSNy3JwOYfftyckJs9U4LhSSRH9Q3UzP7f4b55VEkBHAPwOMDOASv5BHOxcdFo
	 oacoIKoxw8GMRKeXv5fU5pVaCB+4yfJ/G5+L/vJEv9HWbrudjuIcyR3f5btYHuziYO24K
	 Df7rnm11KwaIdbSvWAmlCvngQbZC3PnTuQG7/1bWuiNKML4t4OlH0yuiVLrlBaJSxYgeR
	 9OTHZTb8PkPfVYiJGq3fU/y3MG5jx/Fra5BFjp1a3AR2wIl/1X2wSnYWgWT2RKuwjPMxZ
	 brhQUdZcoj27YDzdIXIKbqmu/rPmCUxeyZvCuB8KXpsy3tdZ8n8D6mX4CZOt07qoe/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCNYgkEk8BB9ILIPJZuGmEdD//oe7MB2c1Lx7DwPAmk=;
	b=Pjzb6sqPHhwTKa9N+UJ2iBqvoJGluusgCwb1tqULkxPH2BTEplZh05iUQlxMdVMlOyiq
	 HDUA4lOzL6/FPaII6P9+XvSNU+oxv/gOb0V4vYCfI1APweSA5Olub2z+Gm552YZSj/CA6
	 5SWJzVzosEUepPLY7mJwhNCXBN7lTLSoYJiyWZuTXy+C20w0N3rnuZ1r1ktZk1CpbO9OL
	 Uuaw4PiRfzcKB5axAkBrpYDFCDmjqpqXzkxBnHng303d4PQjgyS74aqSqO9L5NOYPYTXA
	 UNd5uJEToEapzUvVLkyGdsacKr8ai0v0wwk3Y8b8pfsLwbBlP2zPtTwoaROATUS0yaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I3sh/yEZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65540606A325;
	Wed, 18 Nov 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3sh/yEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07681F000C4;
	Wed, 18 Nov 2026 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017432;
	bh=wCNYgkEk8BB9ILIPJZuGmEdD//oe7MB2c1Lx7DwPAmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3sh/yEZb9yCAQhPZVJzQN3Qb33FyzmoPqwAxRBt4ouIxYpQgcctXZOWUKmQGtKXh
	 /YQCfK3rOqbkelH8u44R5Vs0QPWbAMQxnslVx1UsVD01WXg7kPxdGeGS/878MhsaID
	 Ouu5hr95ZyIR31jZN/de7PhHAJmdEPrli2FL2tnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0883/2651] bpf: Avoid quadratic successor rescan in bpf_compute_scc
Date: Wed, 18 Nov 2026 15:35:23 +0100
Message-ID: <20261118150319.647257379@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3852e19cb9547ffdf9e3fbf3c8decd2c78c85217 ]

The iterative Tarjan DFS in bpf_compute_scc() emulates recursion with an
explicit 'dfs' stack: when a successor has not been visited yet, the
successor is pushed and the walk restarts at the top of the loop. On the
way back to a vertex the successor scan starts over at index zero, so a
vertex with k successors rescans up to k successors on each of its up to k
descents, i.e. O(k^2) work.

For ordinary instructions k <= 2 and this is irrelevant. For a gotox the
successors are the jump table of the containing subprogram, whose size is
bounded only by the max_entries of the insn_array map, so k can reach the
1M instruction complexity limit. Loading such a program keeps a CPU busy
in the loop for a very long time before verification even begins.

Record in 'dfs_pos' the successor index each frame stopped at and resume
the scan there. Each edge is therefore examined a bounded number of times
and the walk becomes linear in the number of edges.

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260925175244.1136329-2-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cfg.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index 842c7d1eabccc..5cfd02c42afd5 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -749,7 +749,7 @@ int bpf_compute_scc(struct bpf_verifier_env *env)
 	struct bpf_insn_aux_data *aux = env->insn_aux_data;
 	const u32 insn_cnt = env->prog->len;
 	int stack_sz, dfs_sz, err = 0;
-	u32 *stack, *pre, *low, *dfs;
+	u32 *stack, *pre, *low, *dfs, *dfs_pos;
 	u32 i, j, t, w;
 	u32 next_preorder_num;
 	u32 next_scc_id;
@@ -762,13 +762,16 @@ int bpf_compute_scc(struct bpf_verifier_env *env)
 	 * - 'stack' accumulates vertices in DFS order, see invariant comment below;
 	 * - 'pre[t] == p' => preorder number of vertex 't' is 'p';
 	 * - 'low[t] == n' => smallest preorder number of the vertex reachable from 't' is 'n';
-	 * - 'dfs' DFS traversal stack, used to emulate explicit recursion.
+	 * - 'dfs' DFS traversal stack, used to emulate explicit recursion;
+	 * - 'dfs_pos[k] == j' => the frame 'dfs[k]' resumes visiting its
+	 *   successors at index 'j'.
 	 */
 	stack = kvcalloc(insn_cnt, sizeof(int), GFP_KERNEL_ACCOUNT);
 	pre = kvcalloc(insn_cnt, sizeof(int), GFP_KERNEL_ACCOUNT);
 	low = kvcalloc(insn_cnt, sizeof(int), GFP_KERNEL_ACCOUNT);
 	dfs = kvcalloc(insn_cnt, sizeof(*dfs), GFP_KERNEL_ACCOUNT);
-	if (!stack || !pre || !low || !dfs) {
+	dfs_pos = kvcalloc(insn_cnt, sizeof(*dfs_pos), GFP_KERNEL_ACCOUNT);
+	if (!stack || !pre || !low || !dfs || !dfs_pos) {
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -851,6 +854,7 @@ int bpf_compute_scc(struct bpf_verifier_env *env)
 		stack_sz = 0;
 		dfs_sz = 1;
 		dfs[0] = i;
+		dfs_pos[0] = 0;
 dfs_continue:
 		while (dfs_sz) {
 			w = dfs[dfs_sz - 1];
@@ -860,13 +864,22 @@ int bpf_compute_scc(struct bpf_verifier_env *env)
 				next_preorder_num++;
 				stack[stack_sz++] = w;
 			}
-			/* Visit 'w' successors */
+			/* Visit remaining 'w' successors */
 			succ = bpf_insn_successors(env, w);
-			for (j = 0; j < succ->cnt; ++j) {
+			for (j = dfs_pos[dfs_sz - 1]; j < succ->cnt; ++j) {
 				if (pre[succ->items[j]]) {
 					low[w] = min(low[w], low[succ->items[j]]);
 				} else {
-					dfs[dfs_sz++] = succ->items[j];
+					/*
+					 * Once DFS for succ->items[j] is complete,
+					 * pre[succ->items[j]] is non-zero, hence
+					 * resuming at 'j' allows to follow the
+					 * low[w] = min(...) update branch above.
+					 */
+					dfs_pos[dfs_sz - 1] = j;
+					dfs_pos[dfs_sz] = 0;
+					dfs[dfs_sz] = succ->items[j];
+					dfs_sz++;
 					goto dfs_continue;
 				}
 			}
@@ -916,5 +929,6 @@ int bpf_compute_scc(struct bpf_verifier_env *env)
 	kvfree(pre);
 	kvfree(low);
 	kvfree(dfs);
+	kvfree(dfs_pos);
 	return err;
 }
-- 
2.53.0



