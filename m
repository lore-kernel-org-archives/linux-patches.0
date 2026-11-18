Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017435;
	b=pW7a2MIbWY3a38J05EXdESF51HN0ss/4iq1PNB0TuQQzMS8C+C/x0HwbyLQz4c9nzM4K
	 sGfhHRT4xWKu0jIZFPGjjJeWqwj5KW00/TvlSrz5whpCH40zUCHCjNQxji8a1XQSlhtkI
	 MDdu+x6WJL2i9EbYjTBGcQqMdXGJB8v+RAvD4wPKza0SgUc3/t8NQlPPqXV+ZrBgAV9Yg
	 BadUuFbRvg4EMZ3lITWU7gd/raq3BWeN+3XSu1pZFVwyMJe48ihMPJeEJ23aMmuJEWGDx
	 T6xoj0BONVofkR1JBVfOGOvCTOl56lccxwZmLNlSGvaTLLTjqp5z9Ma+iukNuXmMcTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NuX3dWTsxj8yOzMGs/VR1QcBA8h2ekoFks+yo51Dnvs=;
	b=A7jSYm/xabIORnmANC7aYHPmizpN534RBcYfhuw5095LoqdohmxmGMbBHTuTI4AV/QEH
	 m7OYqo4CGhWzK3rcRh75kCVP7cIAuiBcChs3DYCdNqD0QkvixIX1/UEMudLdW5xdHtQ89
	 aN2xCs4ZVV1xmrPPUa1eNaZ3zKoaD8ytdC0dYwJaHU0SjkpB/0eiKxvGTWB6+jTYgvp7q
	 sGd5vXQOHYUevGFaTnPLidSImqQo+ZpcN4mjTH7FczhbHniATP5SE9t4qJBszg8KCkhiv
	 ldjVJFP12aBg0bbYM1Tn664GkwgBy4DPDaMl4So63fmchkYNbmY8JGSf9bkvpSoV9Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsmxk7HC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD6A606A31C;
	Wed, 18 Nov 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsmxk7HC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A937C1F000C4;
	Wed, 18 Nov 2026 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017435;
	bh=NuX3dWTsxj8yOzMGs/VR1QcBA8h2ekoFks+yo51Dnvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dsmxk7HC5sbOCs71No44OtIIlqPYMzsolx0ji1c8zcTehAGxkhgZgNOLRRVM3EH/d
	 iYTatcAU91Bdata8UK+e65UZ1nnltwNaDnd4FxhKhKjZrYjDLfELn4vtkp97MZfEYm
	 U6B8r1OTRwZViZIMcZ5fN/pjU0zY8UNZMUpTCiV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0884/2651] bpf: Bound the number of indirect jump edges in a program
Date: Wed, 18 Nov 2026 15:35:24 +0100
Message-ID: <20261118150319.684519274@linuxfoundation.org>
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

[ Upstream commit 57f6eca2f63b46dc9526e040cb419321a5013564 ]

Every gotox instruction gets its own copy of the jump table of the subprog
containing it, and each distinct target in that table is a CFG successor
of the instruction. The number of such edges is therefore the number of
gotox instructions times the number of distinct targets, and neither
factor is bounded by anything except the instruction limit.

What is expensive is a BPF prog whose gotox instructions are themselves
the targets, which makes the edge count quadratic. 1024 such gotox are
already ~1e6 edges and about 4s of CPU to load.

Bound the total across the program at BPF_COMPLEXITY_LIMIT_INSNS, aka
the limit on the number of instructions the verifier processes. Progs
with real switch statements are orders of magnitude below this.

This bounds the edges only. Building the jump table of a gotox costs the
number of entries of all insn array maps regardless of how many distinct
targets they hold, which a later patch addresses separately.

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://patch.msgid.link/20260925175244.1136329-3-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/cfg.c             | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index bcbad168aa25e..18d809f5aa3d1 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -998,6 +998,7 @@ struct bpf_verifier_env {
 		int cur_stack;
 		/* current position in the insn_postorder vector */
 		int cur_postorder;
+		u32 gotox_edges;
 	} cfg;
 	struct backtrack_state bt;
 	struct bpf_jmp_history_entry *cur_hist_ent;
diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index 5cfd02c42afd5..6404f70252916 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -9,6 +9,8 @@
 
 #define verbose(env, fmt, args...) bpf_verifier_log_write(env, fmt, ##args)
 
+#define BPF_MAX_GOTOX_EDGES	BPF_COMPLEXITY_LIMIT_INSNS
+
 /* non-recursive DFS pseudo code
  * 1  procedure DFS-iterative(G,v):
  * 2      label v as discovered
@@ -388,6 +390,19 @@ static int visit_gotox_insn(int t, struct bpf_verifier_env *env)
 			return PTR_ERR(jt);
 
 		env->insn_aux_data[t].jt = jt;
+
+		if (check_add_overflow(env->cfg.gotox_edges, jt->cnt,
+				       &env->cfg.gotox_edges) ||
+		    env->cfg.gotox_edges > BPF_MAX_GOTOX_EDGES) {
+			verbose(env, "number of indirect jump edges in the program exceeds %u\n",
+				BPF_MAX_GOTOX_EDGES);
+			bpf_diag_program_structure(
+			env, t, "too many indirect jump edges",
+				"Reduce the number of indirect jumps, or the number of distinct targets they can reach.",
+				"The program has more than %u indirect jump edges in total, counted over every gotox instruction.",
+				BPF_MAX_GOTOX_EDGES);
+			return -E2BIG;
+		}
 	}
 
 	mark_prune_point(env, t);
-- 
2.53.0



