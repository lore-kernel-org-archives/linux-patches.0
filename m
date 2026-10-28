Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213892;
	b=PaLNXVK7ajJ7C33AO4g2aJIw0m4XKhtV1amQyT1WDMXG7IJnshy6U9J3Fyw/L8QaBTCH
	 Y9jd4xirTfvdmrhLUkp9VtLOGTvXxOYcQlKdiVU8cDHhc3t/zzTF4fo5OvYP+gWqJMNNx
	 Cvv+bI6eibGAIH/e0gP29QLFrQyKZKgWETZWqxU0s8ztw/DucKaR1D0bGpI/KztxLpNKB
	 vXMfwYWifGf6tGzesKHHcE9fmQUCU2fZWOrF4fRRojkn5CDcHyj8DpxjxOdQ7Iujtk6yx
	 qcQNRO0ravEBhRbzBo6xuE5Ng2YbksnGW/7ZLnzNPDRmIVeZRRzPiHxg+GG70Dxi1Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OJO+41kv0v7MbelrCPTJG0m9CzgkzZn0JBCxtkh8ysA=;
	b=unmxaU7sDMMRuSxaT8qnMPSb/1VuVEWc+JU8vRw10/2WufBIzVcoJ+knfQgCkKDlYt+T
	 pXCxlSiaoZnhrq1umn6+ErwDkI71GKBhiSMtzMvayCxldBcLmeZL/1xun5sLhofn4wbHT
	 xv8jM/TzAFQ5ODPf65a6uDiosIU6sTWuqiMvHEMWDzVcIo9n/y73DPIIdRCmmqyAqJBya
	 Wyf4dErPQhHeY0e/mgaGpT25/Zfjm8Qfhj14h6qfBlmoL5UrLY3H3nml+8JOgvn71WkGT
	 NPQlXlRhlyNWvlhcexVi7wkGWXaDRakMMnIRaK0ls/CmOqFC6JelCEi7nJDLmOB6PoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=np2p3fPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3DE606A31D;
	Wed, 28 Oct 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=np2p3fPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934411F01825;
	Wed, 28 Oct 2026 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213892;
	bh=OJO+41kv0v7MbelrCPTJG0m9CzgkzZn0JBCxtkh8ysA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=np2p3fPfVwVyUEmNpgqox6a5cF4yBhKwyguPKldk7Rx248nUopG4bSy5P3WR/Z105
	 WgPzGEUcs7tHKkKL5qwEVepCQ80cQtYfcCUjng6be2B6KJJyBonS4/5Ov7hIGpE5lh
	 agM3M//cd6mFrtvI9Ww0j2cIkqqOJBnJSXs0PdMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0664/1887] bpf: Prevent tailcall infinite loop caused by freplace
Date: Wed, 28 Oct 2026 17:46:00 +0100
Message-ID: <20261028170514.522155823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit d6083f040d5d8f8d748462c77e90547097df936e ]

There is a potential infinite loop issue that can occur when using a
combination of tail calls and freplace.

In an upcoming selftest, the attach target for entry_freplace of
tailcall_freplace.c is subprog_tc of tc_bpf2bpf.c, while the tail call in
entry_freplace leads to entry_tc. This results in an infinite loop:

entry_tc -> subprog_tc -> entry_freplace --tailcall-> entry_tc.

The problem arises because the tail_call_cnt in entry_freplace resets to
zero each time entry_freplace is executed, causing the tail call mechanism
to never terminate, eventually leading to a kernel panic.

To fix this issue, the solution is twofold:

1. Prevent updating a program extended by an freplace program to a
   prog_array map.
2. Prevent extending a program that is already part of a prog_array map
   with an freplace program.

This ensures that:

* If a program or its subprogram has been extended by an freplace program,
  it can no longer be updated to a prog_array map.
* If a program has been added to a prog_array map, neither it nor its
  subprograms can be extended by an freplace program.

Moreover, an extension program should not be tailcalled. As such, return
-EINVAL if the program has a type of BPF_PROG_TYPE_EXT when adding it to a
prog_array map.

Additionally, fix a minor code style issue by replacing eight spaces with a
tab for proper formatting.

Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20241015150207.70264-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 17 +++++++++++----
 kernel/bpf/arraymap.c   | 26 +++++++++++++++++++++--
 kernel/bpf/core.c       |  1 +
 kernel/bpf/syscall.c    |  7 +++---
 kernel/bpf/trampoline.c | 47 ++++++++++++++++++++++++++++++++++-------
 5 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 085bb4e420ef3..4f09079ecaebd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1014,8 +1014,12 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 }
 
 #ifdef CONFIG_BPF_JIT
-int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
-int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
+int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+			     struct bpf_trampoline *tr,
+			     struct bpf_prog *tgt_prog);
+int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+			       struct bpf_trampoline *tr,
+			       struct bpf_prog *tgt_prog);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -1096,12 +1100,14 @@ void bpf_jit_uncharge_modmem(u32 size);
 bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
-					   struct bpf_trampoline *tr)
+					   struct bpf_trampoline *tr,
+					   struct bpf_prog *tgt_prog)
 {
 	return -ENOTSUPP;
 }
 static inline int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
-					     struct bpf_trampoline *tr)
+					     struct bpf_trampoline *tr,
+					     struct bpf_prog *tgt_prog)
 {
 	return -ENOTSUPP;
 }
@@ -1198,6 +1204,9 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
+	bool is_extended; /* true if extended by freplace program */
+	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
+	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 50b9bf57a4e3e..220df952aeabe 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -889,22 +889,44 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
 	struct bpf_prog *prog = bpf_prog_get(fd);
+	bool is_extended;
 
 	if (IS_ERR(prog))
 		return prog;
 
-	if (!bpf_prog_map_compatible(map, prog)) {
+	if (prog->type == BPF_PROG_TYPE_EXT ||
+	    !bpf_prog_map_compatible(map, prog)) {
 		bpf_prog_put(prog);
 		return ERR_PTR(-EINVAL);
 	}
 
+	mutex_lock(&prog->aux->ext_mutex);
+	is_extended = prog->aux->is_extended;
+	if (!is_extended)
+		prog->aux->prog_array_member_cnt++;
+	mutex_unlock(&prog->aux->ext_mutex);
+	if (is_extended) {
+		/* Extended prog can not be tail callee. It's to prevent a
+		 * potential infinite loop like:
+		 * tail callee prog entry -> tail callee prog subprog ->
+		 * freplace prog entry --tailcall-> tail callee prog entry.
+		 */
+		bpf_prog_put(prog);
+		return ERR_PTR(-EBUSY);
+	}
+
 	return prog;
 }
 
 static void prog_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	struct bpf_prog *prog = ptr;
+
+	mutex_lock(&prog->aux->ext_mutex);
+	prog->aux->prog_array_member_cnt--;
+	mutex_unlock(&prog->aux->ext_mutex);
 	/* bpf_prog is freed after one RCU or tasks trace grace period */
-	bpf_prog_put(ptr);
+	bpf_prog_put(prog);
 }
 
 static u32 prog_fd_array_sys_lookup_elem(void *ptr)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4ea21434bf78e..a9e7b17af4808 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -117,6 +117,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
+	mutex_init(&fp->aux->ext_mutex);
 	mutex_init(&fp->aux->dst_mutex);
 
 	return fp;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e997f7594c975..e32d9b9de0dcb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2980,7 +2980,8 @@ static void bpf_tracing_link_release(struct bpf_link *link)
 		container_of(link, struct bpf_tracing_link, link.link);
 
 	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&tr_link->link,
-						tr_link->trampoline));
+						tr_link->trampoline,
+						tr_link->tgt_prog));
 
 	bpf_trampoline_put(tr_link->trampoline);
 
@@ -3108,7 +3109,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	 *   in prog->aux
 	 *
 	 * - if prog->aux->dst_trampoline is NULL, the program has already been
-         *   attached to a target and its initial target was cleared (below)
+	 *   attached to a target and its initial target was cleared (below)
 	 *
 	 * - if tgt_prog != NULL, the caller specified tgt_prog_fd +
 	 *   target_btf_id using the link_create API.
@@ -3178,7 +3179,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(&link->link, tr);
+	err = bpf_trampoline_link_prog(&link->link, tr, tgt_prog);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 17763af54179b..930914f628c7a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -539,7 +539,27 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
+{
+	struct bpf_prog_aux *aux = tgt_prog->aux;
+
+	guard(mutex)(&aux->ext_mutex);
+	if (aux->prog_array_member_cnt)
+		/* Program extensions can not extend target prog when the target
+		 * prog has been updated to any prog_array map as tail callee.
+		 * It's to prevent a potential infinite loop like:
+		 * tgt prog entry -> tgt prog subprog -> freplace prog entry
+		 * --tailcall-> tgt prog entry.
+		 */
+		return -EBUSY;
+
+	aux->is_extended = true;
+	return 0;
+}
+
+static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+				      struct bpf_trampoline *tr,
+				      struct bpf_prog *tgt_prog)
 {
 	enum bpf_tramp_prog_type kind;
 	struct bpf_tramp_link *link_exiting;
@@ -560,6 +580,9 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt)
 			return -EBUSY;
+		err = bpf_freplace_check_tgt_prog(tgt_prog);
+		if (err)
+			return err;
 		tr->extension_prog = link->link.prog;
 		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
 					  link->link.prog->bpf_func);
@@ -586,17 +609,21 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
 	return err;
 }
 
-int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+			     struct bpf_trampoline *tr,
+			     struct bpf_prog *tgt_prog)
 {
 	int err;
 
 	mutex_lock(&tr->mutex);
-	err = __bpf_trampoline_link_prog(link, tr);
+	err = __bpf_trampoline_link_prog(link, tr, tgt_prog);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
 
-static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+					struct bpf_trampoline *tr,
+					struct bpf_prog *tgt_prog)
 {
 	enum bpf_tramp_prog_type kind;
 	int err;
@@ -607,6 +634,8 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
+		guard(mutex)(&tgt_prog->aux->ext_mutex);
+		tgt_prog->aux->is_extended = false;
 		return err;
 	}
 	hlist_del_init(&link->tramp_hlist);
@@ -615,12 +644,14 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+			       struct bpf_trampoline *tr,
+			       struct bpf_prog *tgt_prog)
 {
 	int err;
 
 	mutex_lock(&tr->mutex);
-	err = __bpf_trampoline_unlink_prog(link, tr);
+	err = __bpf_trampoline_unlink_prog(link, tr, tgt_prog);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
@@ -635,7 +666,7 @@ static void bpf_shim_tramp_link_release(struct bpf_link *link)
 	if (!shim_link->trampoline)
 		return;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline));
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline, NULL));
 	bpf_trampoline_put(shim_link->trampoline);
 }
 
@@ -747,7 +778,7 @@ int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
 		goto err;
 	}
 
-	err = __bpf_trampoline_link_prog(&shim_link->link, tr);
+	err = __bpf_trampoline_link_prog(&shim_link->link, tr, NULL);
 	if (err)
 		goto err;
 
-- 
2.53.0



