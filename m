Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625601;
	b=ID+lumNBz+Q5d4xmYan5p8qkkFR6gnCfAcHg+pFhHAUjKbhcHqt3AwdnjTOGzmXc91ky
	 E54OMkGokt7+7N0arPF4t6PLxRfS0MDAEYzS62RBAloDPEIaEYaTW+EDvIBZJr+sjUbdx
	 /CFaYebxtgk3U0a4NaYOYddDpcJThyJNqLx1zVyrsDHZQCvWrntyhck4gQQtWCDsbON/B
	 /QMjmi0mZDaYI1bTVXYLljZN+i/slmKlKXQgHbvm96tDJTol93+7L82I/uywg0ATtLNeI
	 V/R5td/ASbsc5jvJZ78hIvYtn38gAfYGUZ9jV9r1SMGdAniSwy3LFwZWS/idVMvqfPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=stexy7eRy1RNbgF2sPegvUkA/RBDrc8tNip+9rP3ZAA=;
	b=vo3KscFy3PZzvGUnVHXh/pbTk2OuCfTPikL7cSyMSHAA7E1BTizVNV5fH8PhDI+vToM+
	 Xhu7RYxVmnvA4rAzYYrEuy/4LSJMLYJG0V7COPoRFwcB9IYP/98z4KFmFuchD31jnMTY8
	 vQ9Sns2Xy8j9iaDVNBaFT51CGyin30wn9EdtVNjrZgTAm4uLoIz4qd/ZZPpZ5/XoACWcB
	 APcSh8OwJrNMBQx8YmVgkSVSyJYwV1sqbl3xKfMC6rMBEBKaFXDlrAyJi2JzHyeHo9/Fp
	 dX3eKloIY5TukTTVv+ynYCPJBC8X1Fx2l8lG4Tm+kEQIFf1SxzjVpATi/NYf9QGLr9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5X6oM7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607F7606A31E;
	Wed, 25 Nov 2026 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5X6oM7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DFA1F000CA;
	Wed, 25 Nov 2026 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625601;
	bh=stexy7eRy1RNbgF2sPegvUkA/RBDrc8tNip+9rP3ZAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5X6oM7nUqwFaoFZkFvu9330GkQOnidLwJbW1peepY/LrPChoiR+Laab7TOYIpth/
	 9vspluNXj6QE8p6QuaoF1u+9SP2Zlk1QSiWRpkEe9aLeep3SiczH3Rz2A5ovu5dyFD
	 /t9ln15vmtpJpJOFXYxXOs5Bxt94lXuXeaMX5UIo=
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
Subject: [PATCH 6.12 571/816] mm/page_alloc: keep the pagesets of an empty zone
Date: Wed, 25 Nov 2026 15:35:19 +0100
Message-ID: <20261125143902.398934681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5840,6 +5840,10 @@ void __meminit setup_zone_pageset(struct
 {
 	int cpu;
 
+	/* The zone has been populated before, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -5933,6 +5937,10 @@ void __init setup_per_cpu_pageset(void)
 
 __meminit void zone_pcp_init(struct zone *zone)
 {
+	/* This initialization only needs to be done once */
+	if (zone->per_cpu_pageset)
+		return;
+
 	/*
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
@@ -6982,6 +6990,12 @@ void zone_pcp_enable(struct zone *zone)
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
@@ -6992,12 +7006,6 @@ void zone_pcp_reset(struct zone *zone)
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
 


