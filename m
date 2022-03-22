Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B0C6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B14C340EE;
	Tue, 22 Mar 2022 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985214;
	bh=HxZoLzTj6RCg+j3ovTGgyoE0bXf5C530MJKDVUt8Zm4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=xqVDj6fhSnn0Xf78q0BhffN8zlovUFJSZBbIjFb7NBmC01d0DNciDXPGEK2aOsSKc
	 0X/EI/gV63RNlxPo9Z8IokP3nMJS5FJG8yMkPETTbz+QC8Zgbg2lz/PWl9QmmkV5P/
	 SMv3Yd4VJ2HgYnVzt4/G8KOuTolMyhOacdgowlLI=
Date: Tue, 22 Mar 2022 14:40:13 -0700
To: vdavydov.dev@gmail.com,vbabka@suse.cz,surenb@google.com,songmuchun@bytedance.com,shy828301@gmail.com,shakeelb@google.com,rppt@linux.ibm.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,guro@fb.com,richard.weiyang@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 034/227] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Message-Id: <20220322214014.76B14C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: mem_cgroup_per_node is already set to 0 on allocation

kzalloc_node() would set data to 0, so it's not necessary to set it
again.

Link: https://lkml.kernel.org/r/20220201004643.8391-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation
+++ a/mm/memcontrol.c
@@ -5105,8 +5105,6 @@ static int alloc_mem_cgroup_per_node_inf
 	}
 
 	lruvec_init(&pn->lruvec);
-	pn->usage_in_excess = 0;
-	pn->on_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
_
