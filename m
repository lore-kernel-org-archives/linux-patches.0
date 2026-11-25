Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622897;
	b=hGMnV7EAfCF+SWHBulebOKAuqZ3zre9EGzGxZ4zyHZVfqU+UbXViy0G2Iq5CM4uLHgRO
	 0GdxwGNhOcps6rzSN+wFNeW0O8oUeQVAUSKvy7dznjiL4qh5giTVpSnNPpOol31IjJMeS
	 gcZ5SaG/hKp96+FoxbVAy1zHvY9TTyHCsSsWk775y8iHnC7ogl5JAkmY2n3zUIUvxBYmr
	 vvLcFU/G7LfSzkTZn+BEp0HG6h8j7d29PXVOIAwHVAVJpxOb/NchbY0Tip7dr1Zr+pVKX
	 6fwBGsZdEdrQLW4ftQJRqLfBW4mRgabktRQ7f0JppvIF3T4qFcBfIpjntK0hSmv0aVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVAmEknIYUAoXMBWuXSdADqFCqlVjAKrpW8fXYzvsUs=;
	b=UxmpGOI4bbQhAJYAAoXwpoR8qjUcFqMkgM3qTV1J34wq2wYGn0iQdgB5Scq8AGVCgUjp
	 VV7z1GiB8W1BuJJ/s15x+omZUD9s4v41msdN2wQtxUNy0nVOi9osEj1Pzbyvv/38ev1iN
	 bBH2MxlLS0JRpEFffJhU0ybU1+XbjFRoeuPTAOsknvkC3yTt8nm8QzjaEb2UCp8nQyYuO
	 gUJ6M+01nchWKw9x8INOA2sT2+8CrXG27hyCb4Y4f1zRjMDoOAGqa7rYbAWLvA2Fek56q
	 oHlXOdvPrOyAzbvN3C8ZrOmi2RbWKIWI4Eye47FkKIZjlkhYlCYk+VIq48BRT1ftQSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzlVmvjq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB5606A335;
	Wed, 25 Nov 2026 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzlVmvjq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF9E1F000C0;
	Wed, 25 Nov 2026 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622897;
	bh=zVAmEknIYUAoXMBWuXSdADqFCqlVjAKrpW8fXYzvsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzlVmvjqBkFwQ/WSIFcqVzcINtqCcruuextUz/bTSvMhAb+1wooOoigy1g6MALFlS
	 cuwir2TH6u7KF0lHSJfBLgW80xeDHMzSEs0Mov/s7mn7nI0S4M5gKt2uje2d4KEBtE
	 HCWEbX1h2c7qVJzyX6KN6KmBNCev4Qr21JpDqk8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 683/990] mm/page_alloc: keep the pagesets of an empty zone
Date: Wed, 25 Nov 2026 15:34:10 +0100
Message-ID: <20261125143838.083636565@linuxfoundation.org>
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

commit 7bfcf81b1cb469bc016fa8e07939c0924b9ff8db upstream.

When the last memory of a zone goes offline, zone_pcp_reset() frees
zone->per_cpu_pageset and zone->per_cpu_zonestats. Nothing waits for those
who found the zone populated and still use the two pointers. They take
neither the memory hotplug lock nor any other lock which offline_pages()
holds, and some of them can sleep:

  CPU0 vmstat_update()                CPU1 offline_pages()
  refresh_cpu_vm_stats()
    for_each_populated_zone(zone)
      pcp = zone->per_cpu_pageset
      cond_resched()
                                      adjust_present_page_count()
                                      zone_pcp_reset(zone)
                                        free_percpu(zone->per_cpu_pageset)
      decay_pcp_high(zone, pcp)
      __this_cpu_write(pcp->expire, 0)

The same goes for drain_all_pages(NULL), which takes pcp->lock, for
zone_pcp_update(), show_free_areas() and the readers and writers of the
zonestats. If the per-cpu memory has got a new owner in the meantime, it
is corrupted.

The pagesets are only freed because setup_zone_pageset() would otherwise
leak them when the zone gets memory again. Keep them instead and let
setup_zone_pageset() and zone_pcp_init() use them again, like it is done
with pgdat->per_cpu_nodestats. Their lists are empty, and their limits
have been calculated for a zone without memory by the
init_per_zone_wmark_min() of offline_pages(), which is what
setup_zone_pageset() would come up with as well.

Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes empty")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-3-gourry@gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6210,6 +6210,10 @@ void __meminit setup_zone_pageset(struct
 {
 	int cpu;
 
+	/* The zone has been populated before, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -6303,6 +6307,10 @@ void __init setup_per_cpu_pageset(void)
 
 __meminit void zone_pcp_init(struct zone *zone)
 {
+	/* This initialization only needs to be done once */
+	if (zone->per_cpu_pageset)
+		return;
+
 	/*
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
@@ -7344,6 +7352,12 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * The zone has become empty. Its pagesets and zonestats are not freed: nothing
+ * keeps somebody who found the zone populated, such as refresh_cpu_vm_stats()
+ * or drain_all_pages(), from still using them. They are used again when the
+ * zone gets memory again.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7354,12 +7368,6 @@ void zone_pcp_reset(struct zone *zone)
 			pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 			drain_zonestat(zone, pzstats);
 		}
-		free_percpu(zone->per_cpu_pageset);
-		zone->per_cpu_pageset = &boot_pageset;
-		if (zone->per_cpu_zonestats != &boot_zonestats) {
-			free_percpu(zone->per_cpu_zonestats);
-			zone->per_cpu_zonestats = &boot_zonestats;
-		}
 	}
 }
 


