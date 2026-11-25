Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622642;
	b=Q+UHBIYX/yNKCPJB0PGE2wk3iVgoDIeS0XmTmsNx/f2BOPh4egXlhs7CQLk42NxPNpFz
	 Fl8N2GEZfl31TsV3BhKxCEYBG4Sp9nGeMWWLTHq7hcI2VjEZK/ByziaJFDkJ5n+qHHzME
	 Iv9UHRK0sdLjg4jpE7hmBxLiYwK1Jo9yPNvwqthrITf/bk1vD4TtfZcE4SbAH86RgCMop
	 /AxH3/49GS8YZhKH1Lqtk4a3hWGHp4MhkKaxxTg3Ic7oPoFS+qkShS83zaoZG0xBQg1Ie
	 iqWwvsX9sd8lzGvEa1wcRSF8EpQQSwedcUr40bMqidVydUJae2gRjH8jDxoDHNtK4FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ypVCk8Fx8nWSAUOwXF4QInHxNfnv4tcT3bz7K1u1ao=;
	b=2FscI0OYyJzgYshDYv3vmbx9CTiZ0jpxHZPtzPgnBx7Q2Ko/QSFX+yPKkQkZvaKhv0Tg
	 aPBbBWIYsP3eV0SiUQKRoJcwfjGDDuIyIQmCC1D9Qoinxo6prUYQf9BNl/4Obj7PkiHDD
	 lgaDJkEG8q/fetF0pNC7SzqQZzJEtgd4N7SrsEoVmoX6oFoh2ggReahQT5vEe/2Bte2h+
	 8abV7tTcSqAtYRrCXQe4Bx98XCVcKuxWBFH3eigH4SBlWrMBI8MQv+XEsctdf4FdHntCS
	 I6WJtnYHL4iWCXVNH8pACQHqDPMWcDfmDFRGUKrZh8uF3MppbgVCDluo5C+iLeoPvmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVKnzOmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544C4606A31E;
	Wed, 25 Nov 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVKnzOmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9065C1F000C4;
	Wed, 25 Nov 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622642;
	bh=6ypVCk8Fx8nWSAUOwXF4QInHxNfnv4tcT3bz7K1u1ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVKnzOmf5vT6OYeClKXbgYNMeN2tThSAhAwEDaNO9VS9o94bs9vd6/QxDkwLZ61C+
	 tn1fPg+hjOyCEwd80XQNqQKNBUwUoHT8+NgZLGf99lDHHryl3BK1OYy1OAh3HD+YJC
	 m5joz4Q3OQZcLANodBkbMB5ZJrGXrFhnD81FvWvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 603/990] bpf: Count sleepable callbacks as sleepable map users
Date: Wed, 25 Nov 2026 15:32:50 +0100
Message-ID: <20261125143836.218531775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 927c9c985f3ef4d30c086884b7e0ecb933f742ef ]

map->sleepable_refcnt tells bpf_map_fd_put_ptr() whether an inner map that
is taken out of its outer map has to wait for an RCU Tasks Trace grace
period as well.  It counts the sleepable programs that use the outer map.
The bpf_wq or bpf_task_work callback of a program that is not sleepable
runs under rcu_read_lock_trace() only, and is not counted.

Such a callback can look an inner map up and keep it while user space
deletes it from the outer map.  The inner map is freed behind a plain RCU
grace period, under the callback:

  BUG: KASAN: slab-use-after-free in array_map_update_elem+0x6bc/0x7d0

Count a program with such a callback.  The maps are bound before the
verifier meets the callback, so raise the count of those that are bound
when it does.

Fixes: 8e83da9732d9 ("bpf: add bpf_wq_start")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-24-alexei.starovoitov@gmail.com
[ sashal: Kept the local static bool is_may_goto_insn() name in the context line instead of upstream's bpf_is_may_goto_insn(), with the new helper inserted above it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c     |  2 +-
 kernel/bpf/syscall.c  |  2 +-
 kernel/bpf/verifier.c | 17 +++++++++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index bbd0f1ebd2d3c..59c87eeb07cdb 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2908,7 +2908,7 @@ void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 	bool sleepable;
 	u32 i;
 
-	sleepable = aux->prog->sleepable;
+	sleepable = bpf_prog_runs_sleepable(aux->prog);
 	for (i = 0; i < len; i++) {
 		map = used_maps[i];
 		if (map->ops->map_poke_untrack)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 865107eb49467..a076c1bc41ac3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6124,7 +6124,7 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	/* The bpf program will not access the bpf map, but for the sake of
 	 * simplicity, increase sleepable_refcnt for sleepable program as well.
 	 */
-	if (prog->sleepable)
+	if (bpf_prog_runs_sleepable(prog))
 		atomic64_inc(&map->sleepable_refcnt);
 	memcpy(used_maps_new, used_maps_old,
 	       sizeof(used_maps_old[0]) * prog->aux->used_map_cnt);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 55d6cf2653755..ca27c14004ce3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -573,6 +573,19 @@ static bool is_async_cb_sleepable(struct bpf_verifier_env *env, struct bpf_insn
 	return false;
 }
 
+/* From here on the maps of the program count it as a sleepable user. */
+static void mark_sleepable_async_cb(struct bpf_verifier_env *env)
+{
+	int i;
+
+	if (bpf_prog_runs_sleepable(env->prog))
+		return;
+
+	env->prog->aux->sleepable_async_cb = true;
+	for (i = 0; i < env->used_map_cnt; i++)
+		atomic64_inc(&env->used_maps[i]->sleepable_refcnt);
+}
+
 static bool is_may_goto_insn(struct bpf_insn *insn)
 {
 	return insn->code == (BPF_JMP | BPF_JCOND) && insn->src_reg == BPF_MAY_GOTO;
@@ -10892,7 +10905,7 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
 		if (is_async_cb_sleepable(env, insn))
-			env->prog->aux->sleepable_async_cb = true;
+			mark_sleepable_async_cb(env);
 		callee = async_cb->frame[0];
 		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
@@ -21188,7 +21201,7 @@ static int __add_used_map(struct bpf_verifier_env *env, struct bpf_map *map)
 	if (err)
 		return err;
 
-	if (env->prog->sleepable)
+	if (bpf_prog_runs_sleepable(env->prog))
 		atomic64_inc(&map->sleepable_refcnt);
 
 	/* hold the map. If the program is rejected by verifier,
-- 
2.53.0



