Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018249;
	b=nibsiYO6Q5nk7id+eRt8GopOlrlNXXVrWmNVxgB1rbDEKakpr8lBQQ8s9fuEheJqR/mD
	 y9AxBs4m2f4ciHCXJy1HwGgy4wc/5eJJGt0UF+YEE0lMzXVIABnpgl40Vs30Hle+wZeTG
	 Bx1AVVf7F0+FvnDv0eN9uvr3BZQPlFImFgiSy5ZDv0PjtC6Z1cXQwt5KET6sgl/4Hk8l6
	 8yGElDDFgW+ztPOfcv1lArMHiYYsoRmRUp4l6KhgzTMbfsg2iuCpFJ65xCypnCluBtymQ
	 pLDd0DX9BRbJsfWtx9RuLItWspei1wT+l2DuWCl3DfETWS5pQdEoyRYBiFVTSXBBhGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SzLPNWjG4A3NwLdR1TeBZUuhf8BletrHoLs/m8zu+0M=;
	b=kdKLVQaNsQZ3AiSfQBr+LxPigO2ro7nOBTnsOT7rYID9kSA88FHefnVW6tn3aRyYqfwb
	 9xR5w2fEPcnZzNcm9A+XmyiA1GZmnGxR4mMcMyR+asJHjGGqjuRW665aDbaekejuQ0Zho
	 l3Q4kTZsx+MTmcafVUhmSfN9B00cYENyJ+p/DmaSumem03PNDA2kwqp/h0Ko7jxIbNMtf
	 eEI1IDeKvCJV4ZZ5aGxMwwZdDnBPMJU5zyNpeukalxCE2Krr9KB4AGSqPkI4l4RNfVqKK
	 pp3yX3abg6sT2hqFcQzBjm6aEClva0gOzrgFri8VYgva5b3O3xDxo93WR6lIus7mM+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMAuZciT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723AC606A320;
	Wed, 18 Nov 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMAuZciT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E881F000C4;
	Wed, 18 Nov 2026 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018249;
	bh=SzLPNWjG4A3NwLdR1TeBZUuhf8BletrHoLs/m8zu+0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMAuZciTAkXIZile6Rp6Lgb6Xa89pYPpy6hFOOS/Bbw0EF7r8gbhJy/XATs9/CRIn
	 LhOurBPZ50rTNZEl/jA9RjqKZI3WcAdZc8zM5G/OaWsFOVRy1VRtnkKmvCVHOzs8FG
	 PqeOuTxa0071EkVpL7FXh13mVI0dI7AbcYfqh9DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1171/2651] bpf: Add sleepable argument to bpf_alloc_pages()
Date: Wed, 18 Nov 2026 15:40:11 +0100
Message-ID: <20261118150330.170576389@linuxfoundation.org>
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

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit cbe7d2bf7355416815c878e839d03028f4724dfb ]

bpf_alloc_pages() currently decides whether it may use the
blocking page allocator from the current execution context
alone. Let callers further restrict that choice by passing
whether their context is sleepable.

Use the blocking allocator only when both the caller and
runtime context allow sleeping. Add __GFP_RETRY_MAYFAIL so
this path can reclaim without invoking the OOM killer when
the allocation is charged to another memcg. Existing
non-sleepable callers retain the no-lock allocation behavior.

Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261002105218.6171-3-emil@etsalapatis.com
Stable-dep-of: 5316ede1f5d0 ("bpf: Add sleepable arena page allocation path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  4 ++--
 kernel/bpf/arena.c   |  6 +++---
 kernel/bpf/syscall.c | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3d6589a74993c..86f7b70bbd9a1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2821,9 +2821,9 @@ struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
 struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
 
 
-struct page *bpf_alloc_page(int nid);
+struct page *bpf_alloc_page(int nid, bool sleepable);
 int bpf_alloc_pages(int nid, unsigned long nr_pages,
-		    struct llist_head *pages);
+		    struct llist_head *pages, bool sleepable);
 void bpf_free_pages(struct llist_head *pages);
 #ifdef CONFIG_MEMCG
 void bpf_map_memcg_enter(const struct bpf_map *map, struct mem_cgroup **old_memcg,
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index de4f7c7f68f52..c556df7730c4e 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -317,7 +317,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&arena->free_work, arena_free_worker);
 	bpf_map_init_from_attr(&arena->map, attr);
 
-	arena->scratch_page = bpf_alloc_page(NUMA_NO_NODE);
+	arena->scratch_page = bpf_alloc_page(NUMA_NO_NODE, true);
 	if (!arena->scratch_page)
 		goto err_free_arena;
 
@@ -550,7 +550,7 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 		 * The probed page was freed meanwhile or preallocation failed;
 		 * try the non-blocking allocator, we cannot sleep here.
 		 */
-		new_page = bpf_alloc_page(map->numa_node);
+		new_page = bpf_alloc_page(map->numa_node, false);
 		if (!new_page) {
 			fault_ret = VM_FAULT_SIGBUS;
 			goto out_err_locked_memcg;
@@ -771,7 +771,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 
 	uaddr32 = (u32)(arena->user_vm_start + pgoff * PAGE_SIZE);
 
-	ret = bpf_alloc_pages(node_id, page_cnt, &pages);
+	ret = bpf_alloc_pages(node_id, page_cnt, &pages, false);
 	if (ret)
 		goto out;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d35b2a8ae7695..a353e3d4e7d8c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -602,14 +602,14 @@ static bool can_alloc_pages(void)
 		!IS_ENABLED(CONFIG_PREEMPT_RT);
 }
 
-struct page *bpf_alloc_page(int nid)
+struct page *bpf_alloc_page(int nid, bool sleepable)
 {
-	if (!can_alloc_pages())
+	if (!sleepable || !can_alloc_pages())
 		return alloc_pages_nolock(__GFP_ACCOUNT, nid, 0);
 
 	return alloc_pages_node(nid,
 				GFP_KERNEL | __GFP_ZERO | __GFP_ACCOUNT
-				| __GFP_NOWARN,
+				| __GFP_NOWARN | __GFP_RETRY_MAYFAIL,
 				0);
 }
 
@@ -624,13 +624,13 @@ void bpf_free_pages(struct llist_head *pages)
 }
 
 int bpf_alloc_pages(int nid, unsigned long nr_pages,
-		    struct llist_head *pages)
+		    struct llist_head *pages, bool sleepable)
 {
 	unsigned long i;
 	struct page *pg;
 
 	for (i = 0; i < nr_pages; i++) {
-		pg = bpf_alloc_page(nid);
+		pg = bpf_alloc_page(nid, sleepable);
 		if (!pg)
 			goto free_pages;
 		llist_add(&pg->pcp_llist, pages);
-- 
2.53.0



