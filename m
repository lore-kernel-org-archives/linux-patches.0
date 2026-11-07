Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064553;
	b=rZm2oj3SafHLVGQWEnEScMAKXnCwHAn33gn0R4+B5MdiMdt4tuLCJToPeiPJ+NwLHfy9
	 m/Tyd1UNSrvgjRrhLDtqG1R688E8+Rrf6iODs9Fmy6QuurGMvDJaII+cL5+L0pG8o0wCU
	 0/+42AIBVPlg9fL6oElqPbBOp8QQ7c8ohs/R0V7PivoqPhDkgV/9+A3BJaF8sKG3awNfM
	 XWQVKXjUsLapiyLy8AQsMTB+kvuneKO1RbppxlnRywhQm3KgA7OD0RgoDTHEv2UfQGnTc
	 PHTN+yNgD3q1+DDDu5rY6MICIUgSsaDOCvgsjyJauFPkJCLYzznudbZKjUo2BjhBOvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q80XHiC/+OdEb+Je7ZA3tUMrfwAqx4Z6OT6/ZSuMQFM=;
	b=vZz+x4Ai+vT2OcqrJHK9dArjchdG0xHX3aJfivnELfET7QcTIrQy44w7JbNi6L46XRRe
	 phGrPl/o1ZOavKwnowROTeEzD2shRTB8FTLaEYssy9U7QEWyfH+LeG6/BggkoeqC1tX2L
	 ce53qpOLINcmHBtE4b6DFNj1GklfolhCjXELRuXVPGtiZH0IYQrIPEdKOJS4r76IOFalK
	 cXcLRU2Gp+NmN2IIdF4nKdIl8UBIgWS9NxFu4m23+yCF97ipyZ7jshsTXx8iZKm3ry8Qx
	 foJBeJ2W0YmMHKBTpBSTNR7ec/1M2XIqbZTjc7Ptmvs19CeQ9IR7zikhiXbDs0bnT+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YOTSc0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D68606B8A6;
	Sat,  7 Nov 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YOTSc0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589311F008A1;
	Sat,  7 Nov 2026 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064552;
	bh=Q80XHiC/+OdEb+Je7ZA3tUMrfwAqx4Z6OT6/ZSuMQFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YOTSc0SnlQUFemqkNAWGRMgXMofTXm6e1cp4YXcAjzvgVeaAznlzKdR6A+92T1pS
	 VpVRYgw0+coloBTykXbXMECfWPa/y3S1/I3nS31s07qVk46sxOMfgl5sZ6pynwo72q
	 2efJTTuf9mUuAqtu1DXcRNTLviLc2qtwiIqbrbX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0576/1257] mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
Date: Sat,  7 Nov 2026 08:47:52 -0500
Message-ID: <20261107134955.253729782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit 154c16a783b75105347cf5ed7731afc887308120 ]

On cgroup v2, reparent_state_local() returns early and never moves the
dying memcg's non-hierarchical state_local base counts to its parent.
Meanwhile memcg_reparent_objcgs() rewrites objcg->memcg to the parent, so
when the reparented folios are freed later, the negative deltas land on
the parent's lruvec.  The parent therefore receives the uncharges without
ever having received the matching charges, and its state_local
(NR_LRU_BASE + lru, MEMCG_SOCK, NR_SLAB_RECLAIMABLE_B,
NR_SLAB_UNRECLAIMABLE_B) permanently underflows.  Since
lruvec_page_state_local() clamps negative values to zero, the underflow
masks the parent's own legitimate pages.

count_shadow_nodes() is the only reader of these non-hierarchical
state_locals on cgroup v2, so the underflow directly distorts the
workingset shadow node budget.

Fix this by reparenting the lruvec state_locals on cgroup v2 as well,
mirroring what cgroup v1 already does.  Only the lruvec stats consumed by
count_shadow_nodes() are moved; the memcg-level stats are left alone
because on v2 they are exposed through the rstat hierarchical tree and are
not read from state_local.

Link: https://lore.kernel.org/4a7a64eed2b145ad535fedaea3624f8310c29d5b.1789096175.git.zhuhui@kylinos.cn
Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol-v1.h |  5 +++--
 mm/memcontrol.c    | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 1e394269c613d..0578b7076764d 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m, void *v);
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -73,8 +76,6 @@ void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgr
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed371b1ddab87..a3f16cbfdc6e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -232,14 +232,29 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
 
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -248,17 +263,18 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -570,7 +586,6 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -592,7 +607,6 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
-- 
2.53.0



