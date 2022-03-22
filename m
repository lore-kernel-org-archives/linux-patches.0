Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC5E6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67DCC340F2;
	Tue, 22 Mar 2022 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985639;
	bh=CM1n9mzzhlL7za/LeGoqlxU72kT0yRPY/3c8VjkAdpw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=NcQ7n2NFi96gYLMps5hb3/IiVGnhOXfQgX77FnwXfR4FrBaS0KWepr+YRsiIW14fo
	 kZAd9Qzqc/CzXiQtRte5j9yuXADOLjQQ4FLncXLqTbYpWSpG0/tGTYWAPLmz28hsMD
	 RdUlZIBUc4z8SiV6CIWZuLr/pqjvTLLEmHzE+Tjk=
Date: Tue, 22 Mar 2022 14:47:19 -0700
To: osalvador@suse.de,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 173/227] mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL
Message-Id: <20220322214719.A67DCC340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL

If zid reaches ZONE_NORMAL, the caller will always get the NORMAL zone no
matter what zone_intersects() returns.  So we can save some possible cpu
cycles by avoid calling zone_intersects() for ZONE_NORMAL.

Link: https://lkml.kernel.org/r/20220207133643.23427-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal
+++ a/mm/memory_hotplug.c
@@ -823,7 +823,7 @@ static struct zone *default_kernel_zone_
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	int zid;
 
-	for (zid = 0; zid <= ZONE_NORMAL; zid++) {
+	for (zid = 0; zid < ZONE_NORMAL; zid++) {
 		struct zone *zone = &pgdat->node_zones[zid];
 
 		if (zone_intersects(zone, start_pfn, nr_pages))
_
