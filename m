Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064550;
	b=I4s3M2EqHv9/Qe+ah3VTVSJ4ATb0Il2jX1H/g/nMX7S/KxKVwhN2x6N/ggMMPqzNgMqz
	 5M6Y57TE4KwdNX7Cx8pPghhWTH1e0Z8tit8WZl1h5uVj6BA6Pq8ss+1t2RjPYObOo6rpe
	 EyrypCeZmpoX/wC3B3qZqOc16ArI3p44He7xqQ98on+0eeCm5Uk1uSXhlTI2NRcVFEmvN
	 mZS66jaIrFLRxWKvSYf+Dk5ADgiXD/6oFgv02xhO7/euilbMJy5uqRB66QbM3MUH7cGM1
	 vLjowG8InnvQf98TK3wyWwctjeCdlrUfXBgousseIJvb41AaVU7/Z7kUy9l/K5jjP+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtJwLqo2ukYN3Nxn5bTI9uXREVZJXNS7Hm2gmmDiabM=;
	b=zxRsezrKA3WcwNt4gUulmBqfezRi/WVzCiMrgLSxUef+wHU9IUrG62CJoKr+t/002ftU
	 Gm70viHhrc8AwRiV/Gy5jNP0156AQ7pe5Ya8cF2NlFDxjL5jy/F8BgtjPqZytnTjEmq9a
	 mCP2C9fdMzLEVHN5Fges6OYD6vds4mcH4cOXWplUUfnmyQpApqS8FNCxmZSbh2FJGTfaW
	 jtgZ6iaTwiWc1IrMRzERc4ytLXdFEH4yHeD5Nyo3a9fJcRZVngH+9IajMAKGpFUGdDv9h
	 WOhTJpt7YDA8iukhFqsQNUWZsvyylooLk844W3y9TQTIMgXahqd6mYmRtfZqjDHQBgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8LZBcti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DEF606B8A6;
	Sat,  7 Nov 2026 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8LZBcti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3CA1F008A5;
	Sat,  7 Nov 2026 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064550;
	bh=vtJwLqo2ukYN3Nxn5bTI9uXREVZJXNS7Hm2gmmDiabM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8LZBctiStZD191+GtI9ON24H6CVOf1XUm4dXa7phcAgEkm6p1SdJ/Hs4BKeQd7Og
	 /bpjBvM4XBTdGiE7HbqmOOEOPHU4XqY+LuPBXF364UxDRCq+HYGeXyYnUnioZm0nk2
	 crrt26y2yGABdrJpCFlaSBb+T5eTfJzBUD5+HLdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0574/1257] mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Sat,  7 Nov 2026 08:47:50 -0500
Message-ID: <20261107134955.201056015@linuxfoundation.org>
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

[ Upstream commit c7a37bac3ccc2732993705d3c3488b278b422ec6 ]

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
which only the classic LRU paths maintain.  MGLRU accounts its pages
through __update_lru_size(), which skips that array, so with MGLRU on the
four evictable LRU lists are always seen as empty.  The shadow node budget
(pages >> 3) then collapses to slab plus unevictable pages, and the
workingset shadow shrinker reclaims eviction tokens almost as fast as they
are created, losing thrashing protection.

lruvec_page_state_local() reads lruvec_stats->state_local instead, which
both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
race this re-exposes on cgroup v2 is closed by the preceding patch that
redirects dying-memcg stat updates for all hierarchies.

Link: https://lore.kernel.org/2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/workingset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae5..8412f4840ae35 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -688,10 +688,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
-
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
-
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.53.0



