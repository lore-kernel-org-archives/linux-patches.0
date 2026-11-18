Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017443;
	b=JgDOB2XS0yPGRgXi83dq05giTQ5rgCJNgiPhvJZEzRBBoIKEtAnFm80sURYNvOpOS4rc
	 fvMfJ0R8zLjOarBA0f8Wk9dCjPD9vWAoreIQabWN+KJvxESihF6BQ88K0sXfPWQPNafZW
	 PWGqHxp0eNjuIn9NtodgBoXwWOyI5LHftWBdFDm0OSp2HFLewRXW83wPLXN4/bM5F6rYP
	 Zi7xGZo99H85tM0l3Pc2GzX7Kpqb6WPNZ2qsQaE9J4/KUv9rbKfpj8suMk2WfXZl4E7GI
	 GCoxgUQEz3N3V8aFbiUxdrv/BdsdTAqIlqnIy1ewI6D4FAZOh0Qnw4ZhC9SsuSDTbjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5sB1jURkuHjGwzLQ6oycB+QfH4N3OE3z43+DQ3un/Nk=;
	b=AFHeybGHH2eueyXW3GVaaUujApxe+dNRKnqNbkstOjgh65npNfnWtVU4hzCAa5gHlUtF
	 p1RWaemZU54fh6BlRwIJW39c47RuCwotHS2nVXUK2CS5VujSHl73Xn/kMDeVRv6U0WnxO
	 hutOrnhdPG8+ovtuR20Je1HBfniIPg9oXF+qxgkbIMOEz5aYsa/TYp/glHSLK0k2ahDme
	 DJ7i6roCkIfMRslnUgyIX+M4BnEZS4SJPuDQX/yv9fqk5yeBhlHDCyoaOzMZiOlEyq+PC
	 dkmlwe7rQtOFO+lzPn+iOl9iAWYA1sWH17YhL/lqz39tn0cgxKiOepFP8ArnbsOOYcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qe5T0mLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D9D606A32A;
	Wed, 18 Nov 2026 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qe5T0mLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B491F000C8;
	Wed, 18 Nov 2026 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017443;
	bh=5sB1jURkuHjGwzLQ6oycB+QfH4N3OE3z43+DQ3un/Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qe5T0mLpvEShaEkj6nOmisaCn7E7zbblHizU6g2B8rLqJBg9Zl7H8/7Iz9pqpTRVg
	 b3LLcjsOSYSeNdNS1KQ27+F+OwlpBCM3kAPmpzZg8+7AeyCPW2L6bVeB/Wvg6xbfsI
	 5e7Eilnl9OE4+aEOszGsRJfODN9YryJHXS7b61ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0886/2651] bpf: Leave out the hidden exit edge of a subprogram without an exit
Date: Wed, 18 Nov 2026 15:35:26 +0100
Message-ID: <20261118150319.755037732@linuxfoundation.org>
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

[ Upstream commit 939bb6270ee32cfef0631b30ff07a9e0b8806e64 ]

visit_abnormal_return_insn() gives tail_call and ld_{abs,ind} insns a
second successor, the exit_idx of their subprogram, so that the hidden
exit from the subprogram is part of the CFG. check_subprogs() only
assigns exit_idx when it walks over a BPF_EXIT, and a subprogram whose
last insn jumps back into itself never has one, so exit_idx stays zero
and the edge points at insn 0 of the program:

  0: r0 = 0
  1: r0 = *(u8 *)skb[0]
  2: goto -2

For a subprogram other than main, update_insn() then reads the liveness
masks at a negative relative index. Such a subprogram can still load
when it leaves through a bpf_throw(), so mark exit_idx as unset in that
case and leave the hidden edge out, as there is no exit for it to reach.

Fixes: e40f5a6bf88a ("bpf: correct stack liveness for tail calls")
Fixes: ee861486e377 ("bpf: Fix ld_{abs,ind} failure path analysis in subprogs")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260925175244.1136329-5-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  6 +++++-
 kernel/bpf/cfg.c             | 10 +++++++---
 kernel/bpf/verifier.c        |  1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 18d809f5aa3d1..d7a297527f49b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -825,7 +825,11 @@ struct bpf_subprog_info {
 	u32 start; /* insn idx of function entry point */
 	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
 	u32 postorder_start; /* The idx to the env->cfg.insn_postorder */
-	u32 exit_idx; /* Index of one of the BPF_EXIT instructions in this subprogram */
+	/*
+	 * Index of one of the BPF_EXIT instructions in this subprogram, or
+	 * U32_MAX when it has none.
+	 */
+	u32 exit_idx;
 	u16 stack_depth; /* max. stack depth used by this function */
 	u16 stack_extra;
 	u32 insns_total;
diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index 6404f70252916..a11ff94e77ac8 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -445,17 +445,21 @@ static int visit_abnormal_return_insn(struct bpf_verifier_env *env, int t)
 {
 	struct bpf_subprog_info *subprog;
 	struct bpf_iarray *jt;
+	u32 n;
 
 	if (env->insn_aux_data[t].jt)
 		return 0;
 
-	jt = bpf_iarray_realloc(NULL, 2);
+	/* A subprogram without an exit has no hidden exit edge to take. */
+	subprog = bpf_find_containing_subprog(env, t);
+	n = subprog->exit_idx == U32_MAX ? 1 : 2;
+	jt = bpf_iarray_realloc(NULL, n);
 	if (!jt)
 		return -ENOMEM;
 
-	subprog = bpf_find_containing_subprog(env, t);
 	jt->items[0] = t + 1;
-	jt->items[1] = subprog->exit_idx;
+	if (n == 2)
+		jt->items[1] = subprog->exit_idx;
 	env->insn_aux_data[t].jt = jt;
 	return 0;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0c7562f007a80..6e76a9712d0b2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2412,6 +2412,7 @@ static int add_subprog(struct bpf_verifier_env *env, int off)
 		return -E2BIG;
 	}
 	/* determine subprog starts. The end is one before the next starts */
+	env->subprog_info[env->subprog_cnt].exit_idx = U32_MAX;
 	env->subprog_info[env->subprog_cnt++].start = off;
 	sort(env->subprog_info, env->subprog_cnt,
 	     sizeof(env->subprog_info[0]), cmp_subprogs, NULL);
-- 
2.53.0



