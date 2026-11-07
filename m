Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065338;
	b=MP6bGz2PfW4p9e0DxwfiqAEtLpRBOuMGEZC4eKWKUAvH2u3sdQIYRW3Ul8ddiDE2qzKR
	 6oVENyQOP3HgQXiIXlSsPxkQxjFWG1oLldsQKG0WliTa/iqHBvgzrcGuEuYazH5UyhLm0
	 PSO/q9b2L6iWrI3xdqEfrp8RkcLuFkOn0wsoZv0P6xOaMNAAvY4KVznKx9ArOjp++9daz
	 mxG9Lufim+qyUGyudhG88I9SQe9PdQggslR+WFcsBbVDscSJauvh+jBiXjuCFXWtEpwZH
	 axQBztKGp4Obcl9gmon2EMalXa61889ZCeOrqdN2e8Fs6F1CXVWtwYgHUHO+pJ8aMhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UoYjF/b0k21IzUAXNbcxlt2W6AauYPw88+vBvdaWqlg=;
	b=CqF4AB6PIHbIfK61tMi3rk8Fe5fc4KfaKu2+c95ZEMPTJdq29lAxq7Fel6rZ4CMleQGJ
	 +5EPFPEVkH0fvjYUE9VNxu/t8BnRV4ibjYO5w6YLsHr+ighd+iVeXJH9OBl+YxrMelRbj
	 vY9dGXBT9hipC3kpRugg7abqpTCabe3UVJahw2TbvitazCgo7yo8QD/suUVNrZqF64zsS
	 goTv6MVzFw7xL1iDp39MDVv9OROkpMHhox6Fc0P76jjGosuBUpnwVqpNwmAaFTq8kpTjn
	 sHmJb67LVvE8BqgGTLjsa4RokiJnoYTHKQIYeAt3CjuKwpHo5thZfi8kC/jh9dYt4Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cg6bJKuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C661606A326;
	Sat,  7 Nov 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cg6bJKuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913EE1F0089F;
	Sat,  7 Nov 2026 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065337;
	bh=UoYjF/b0k21IzUAXNbcxlt2W6AauYPw88+vBvdaWqlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cg6bJKuLxVoIHVdnnktzVd7//hGLiR0MbDo6slP86v8E4geGkxVk5p/NppcrQ7AOg
	 UYZxuc1ElptaHUEnRb4bZS5+uHe1dCNM4u14m7OLBeAPUZRh0wUEOV21JQr0IZa3Se
	 3rsUhjwSoB9cWIgDb9KUvB/xD3cM9dtAC8l6zid8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Down <chris@chrisdown.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1076/1257] mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Sat,  7 Nov 2026 08:56:12 -0500
Message-ID: <20261107135008.985605122@linuxfoundation.org>
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

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 02e0c8cc2815f0082b5b5aabafe3b46688082adc ]

memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
stats.  These stats are accounted against folio_nid(): incremented on the
folio's node when handed to a user, decremented when the folio is returned
to the pool.

During hugetlb folio migration, mem_cgroup_migrate() moves the charge to
the new folio and drops the memcg data of the old one, so the free of the
old folio right after the migration skips the memcg per-node lruvec
decrement.  The hugetlb count stays attributed to the old node for the
rest of the life of the charge, while the target folio gets no increment
on the new node; its later free decrements a counter that was never
incremented.

Migrate the per-node lruvec accounting alongside migration.  Global memcg
totals remain balanced because they track resource consumption, not node
placement.

Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h |  8 ++++++++
 mm/hugetlb.c               | 25 +++++++++++++++++++++++++
 mm/memcontrol.c            |  5 ++---
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf057d80e2c6e..6d1c9e9a28d92 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -958,6 +958,9 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1420,6 +1423,11 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 90a8076e7ccc4..e71e0ab116bfb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -23,6 +23,7 @@
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/rcupdate.h>
 #include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
@@ -7360,12 +7361,36 @@ void folio_putback_hugetlb(struct folio *folio)
 	folio_put(folio);
 }
 
+static void move_hugetlb_lruvec_stat(struct folio *old_folio,
+				     struct folio *new_folio)
+{
+	struct mem_cgroup *memcg;
+	long nr_pages = folio_nr_pages(old_folio);
+	int old_nid = folio_nid(old_folio);
+	int new_nid = folio_nid(new_folio);
+
+	if (old_nid == new_nid)
+		return;
+
+	guard(rcu)();
+
+	memcg = folio_memcg(new_folio);
+	if (!memcg)
+		return;
+
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+}
+
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
 	hugetlb_cgroup_migrate(old_folio, new_folio);
+	move_hugetlb_lruvec_stat(old_folio, new_folio);
 	folio_set_owner_migrate_reason(new_folio, reason);
 
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c7a506873eed..b5137e86bed70 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -987,9 +987,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-- 
2.53.0



