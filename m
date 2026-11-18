Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038355;
	b=hVVreOX6u0hgXabGv+JCHAv399rYJni5a1Tel+JBFNnajS+23LNPoAPHgcXDbzu4YOPZ
	 5EI6U33Aw/UFX0w8X/A7aGuGAkRsd3y9Dd8I/UjZYpEOxzCWQNNEv+gahTo0MjaLOcoDw
	 0ucjZd35U5yRC7yJI4WOu3iDyO/27nEhRLH6YSj3l6aGRdbrZtb74Zjt5ebiYBtFVZt03
	 ABk5nAVfvrdIcZHWon4oFQgnZsdya+QHRGNS7P6vatoU5D1+JEOw127NgvEHqWvMG+oSK
	 o5SBFj3pzw2jBc2jFf4uClCgxhVfcF1EZnUupis5ZRoPtt8ew61zrk11STxoklTiCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nY7XziTq/GYTTuxAVmFMKsCRT1liDwW5ISBvynHUsLQ=;
	b=1zRy187UuEfsZlddWQeuSl2z8sxHRNp9ZL/lQiNxo/GhQb3KUa4gOwX/ccKZCTJFehVp
	 T3B7w/TAZkFnsBKJoTl71OL9wkcy8uaZdxEfbvXbLV/cUIxwUm9HdzDpa3E+3kn9OCCmO
	 hiIjqPbVcF3Xca8YCXgymepIL+EESqXiZlhQcx4zR38SolMG22kN0w0RZ0plkh+F3YwBI
	 NFy3sIJbP3gGg0S49ZLbk67wP/m/iVehRDE6GOSXVu4euQGIs3FKFoAn7Fps2ito6wKmd
	 xGvge8FGoijfmTTOSmx5ayh8R8ICYKIk75/2vCL9cdPvC1hRU72BtwPSjR0wqYbSodg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yrQ9C81y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F44606A320;
	Wed, 18 Nov 2026 21:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yrQ9C81y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B31F000C4;
	Wed, 18 Nov 2026 21:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038355;
	bh=nY7XziTq/GYTTuxAVmFMKsCRT1liDwW5ISBvynHUsLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrQ9C81y5kcTUaLoUUOFplP7TNqRL/bwyhAtdEj4OITq0EGo3/YOvBhc7AF0TroG4
	 pOPLqehKbuRdcAJ6UOGIw5caDWheeLMGtpYW7R4p5Hoo8EHKy+d3eSdBpPYwW2PLfG
	 fWCp0PA/IqG9RcQQtQPQ7nPE/vslYqM8wLUKp8vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1715/3318] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118150413.318225198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

[ Upstream commit 374f65b1481992eb6b9c6bffd53f3afa5c2e94cf ]

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not visible
in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
enforced allocations") added raised_max_event to cover charges that are
force charged without ever reaching reclaim, but charges that are rejected
outright were left out.  Getting an allocation failure without the
corresponding MEMCG_MAX event is unexpected and makes debugging and
monitoring harder.

Raise the event on the way out for rejected charges as well, by routing
the -ENOMEM return through the same exit path that already covers forced
charges.  The existing behavior of raising a MEMCG_MAX event on every
charge/reclaim/retry iteration is left unchanged.

Tested with a module that performs accounted GFP_NOWAIT page allocations
from a task in a cgroup at its memory.max, and measures the resulting
memory.events:max delta.  Without this patch the rejected charges raise no
event at all; with it the delta matches the number of rejected charges
exactly.  A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim,
raises the same two events per failed charge before and after, confirming
the existing charge/reclaim/retry accounting is unchanged.

Link: https://lore.kernel.org/20260831174836.3102406-1-joe@dama.to
Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
Signed-off-by: Joe Damato <joe@dama.to>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: Changed __memcg_memory_event(..., allow_spinning) to memcg_memory_event(...) to match the existing API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e6fffb91742a8..ff9927140c836 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2682,10 +2682,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
@@ -2797,16 +2798,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2816,7 +2812,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
+	 * requests.
+	 */
+	if (!raised_max_event)
+		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2869,7 +2873,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    gfpflags_allow_blocking(gfp_mask)) {
 		mem_cgroup_handle_over_high(gfp_mask);
 	}
-	return 0;
+	return ret;
 }
 
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
2.53.0



