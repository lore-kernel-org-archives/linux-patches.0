Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590727;
	b=jAXrv/oW3tF99Hs5J43fBJDm1k93ZIb2DxDFtQXaNFJQi4HmF45hxEWc3zOUQQ8SXJEW
	 o5iwAfVxMu3CRuJnDbK5XeFjhS+HnkKDR5FKSIN62GTrEptOYVTHcRnRwAdBaSMhMTuhY
	 k9nljZOPmsLSmXMUxqyXFNoGV9q6Me80x0NgiMIZWbCNNaJyFmVALY6uSYzuMAzMDKocx
	 3lxpeNBwv+ua3ms1f+zxpE43tsgn5skqNfpu1l0j0fg8FTxMm/Y2WFIEn3ofRgySm50Rw
	 IPk2AQ6Kbhum0oWVlyvM7DvUqiJWjPL/T2mPeQ9FpxSUo9Gtc3vR9ddSVbFDnFa5cuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4SZJufXmSagXcWO26Mhmz+v5u/A10h0tpEAm+J9vPvI=;
	b=Wj6lUsedJZBoyYWbkUs1DFAN3n4W/QpotO5h5nmz55SKLbRhaNIOU7ShTmcEIifo7agG
	 uUT5hUieMlR2XRdxZC9S4GnD3/v07Ta7t8bk7tLVzD5eD033YJS79ivwO8dm5BsFZYiEW
	 UefDCUL1aGz4ljfRfDD6tKJno4M5sQ96VayW++mgI8Ljuuaz8KilPTAsmeMRVk3yYefjZ
	 Ua6iXlIebErQB+ECBX1c80klaskORjT+l8cDWX7ytXLwVWPzEC4dyeoSy6aNrVUlKar3V
	 XG41EWlpojsae3BbpIKZcDLOmY7NLzkGPWJw0Ybs1u2cfI2H7b7qU8aAsno2iT7hVRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HN63+j7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343896079D4A;
	Fri, 13 Nov 2026 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HN63+j7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBA11F000C4;
	Fri, 13 Nov 2026 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590727;
	bh=4SZJufXmSagXcWO26Mhmz+v5u/A10h0tpEAm+J9vPvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HN63+j7yri3u/tj6iC1Et2e6FW7wB2lOhfTqAADMHfWH7sI1WwFElmUbiwIfndLvZ
	 tw0LkPhVDvCjfkXz3B0sjigxqPIFsbxBfb54qlyOZW3hzdKRPsG/XAGF2zjW2g54HI
	 Rnar6J0oafqPzDJjymaVvfr4rDmG5zvFfYnxzeBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Allen Pais <apais@linux.microsoft.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baoquan He <bhe@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kamalesh Babulal <kamalesh.babulal@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 631/686] mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
Date: Fri, 13 Nov 2026 10:52:44 -0500
Message-ID: <20261113153843.213886215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit 5371e350fda70bbdbee364215ca37b7fea25047b ]

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
non-hierarchical stats.

Link: https://lore.kernel.org/7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com
Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 02e0c8cc2815 ("mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 50 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db12e61ee9852..371bbfc419170 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -678,21 +678,12 @@ static int memcg_state_val_in_pages(int idx, int val)
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
@@ -706,6 +697,21 @@ void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 	put_cpu();
 }
 
+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	__mod_memcg_state(memcg, idx, val);
+}
+
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -725,21 +731,16 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+				     enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
-
 	cpu = get_cpu();
 
 	/* Update memcg */
@@ -755,6 +756,17 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	put_cpu();
 }
 
+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx,
+				     int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	__mod_memcg_lruvec_state(pn, idx, val);
+}
+
 /**
  * __mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
-- 
2.53.0



