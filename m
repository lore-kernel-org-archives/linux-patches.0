Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DAD6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F9C340EC;
	Tue, 22 Mar 2022 21:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985217;
	bh=vzhFL6mlQti7d58JDlxxBNhVkqwV3XQfc4/UNOriJag=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=0sRv+MWOIF0jYQ4lKQICEGXrbbm9gidGVdF7HQoZOJi8PbT72N0UkStaKuBIVeAjW
	 QCMMAdOxBx0jBdh5UVu46K8rclguFGyzbIZA8bT5kiGsyfuUbT1kko2RX4tK62IQo6
	 hoQAATH5/iIIUfWpr+DTng1bTAMox5RQipJzHJxE=
Date: Tue, 22 Mar 2022 14:40:16 -0700
To: vdavydov.dev@gmail.com,vbabka@suse.cz,surenb@google.com,songmuchun@bytedance.com,shy828301@gmail.com,shakeelb@google.com,rppt@linux.ibm.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,guro@fb.com,richard.weiyang@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 035/227] mm/memcg: retrieve parent memcg from css.parent
Message-Id: <20220322214017.806F9C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: retrieve parent memcg from css.parent

The parent we get from page_counter is correct, while this is two
different hierarchy.

Let's retrieve the parent memcg from css.parent just like parent_cs(),
blkcg_parent(), etc.

Link: https://lkml.kernel.org/r/20220201004643.8391-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-retrieve-parent-memcg-from-cssparent
+++ a/include/linux/memcontrol.h
@@ -842,9 +842,7 @@ static inline struct mem_cgroup *lruvec_
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
-	if (!memcg->memory.parent)
-		return NULL;
-	return mem_cgroup_from_counter(memcg->memory.parent, memory);
+	return mem_cgroup_from_css(memcg->css.parent);
 }
 
 static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
_
