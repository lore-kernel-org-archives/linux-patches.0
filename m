Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064472;
	b=zqZltsiUynEdvH1V8NAI+1F4m8gYrArKNZYEd1HKZWKo7uMfEkYW7zbk/fqs+UiJH7gY
	 8Uvotyj/wXjgryToJJZenCl3Cz5faZxU/S6TlRYTIRQfj0RNmtpDoRpGTWk3Eh7su0QoI
	 ww8BETdCkKAwqb8HIH5ZODRc/l8+sQ/dKiXDrIL2rhKcZoNqXvnGwapISqnukgazDaE3p
	 jpCGlmeRs/l672O7ogYoDDFW0Svjppxl/ZYgvwCMWnLfB9mZfjzAC7hYv8X2InPuPkzvL
	 B0CP5dEM/GUdCWjCrz43m55sKHL9Oavw8nFimSnWZY37gZX1aFUA5emVguYQ4HNeSZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gLKghrZpIA8ao8ZWY4wtESPKRwteZflFaXWXEu70zko=;
	b=y+o//A9M4CW+A7WNJ8ckxTVxAuz9xVV9zYtAgFe27D09rCKm6QKGRa9rHzi89uJw/9Zr
	 uTmMXd63n1lwwdKZHnhnBfCcytwiLOKLOg1PABWiodfg3ic+vjtRKlWnrKkVbtgLsWE/P
	 l3UjsH/KeyNfJJRy9sjIrUwm1zSVpt7lfZpqKZ23OYgMQ16AXUl4OxAFzPfgCbgcRGN8i
	 XoQJgJtvz5aebuXFP0grgvyG7SrI+aCYam/zVBPfGwjx3bgUvGEiBkzLXe1KmIevH+97v
	 dlCySdEvNNDwYXC8Sx69N+kg+strMrlkfSry+C5SvVonYRtv4Z/H5Hz6Tz48V5gtdjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RySsYpPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65687606C015;
	Sat,  7 Nov 2026 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RySsYpPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D541F0089F;
	Sat,  7 Nov 2026 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064472;
	bh=gLKghrZpIA8ao8ZWY4wtESPKRwteZflFaXWXEu70zko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RySsYpPvDZSCx8h+cXuF/7M1DkWvdFqH1n2Bc93MlCzlyGdWZcoJl1liXE/lPtbhj
	 uGo8r0wx2gsK6Kh2TuxvhyPnohezG557fAgt6ckXOVw+n5iNzmqQqya1EnFTNaZDeH
	 KHAUAuxOtXTfWEdmUORdjN3kikkQhEZRAxT5nYak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	David Hildenbrand <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0512/1257] mm/list_lru: dont copy stale shrinker id from non-memcg-aware shrinkers
Date: Sat,  7 Nov 2026 08:46:48 -0500
Message-ID: <20261107134953.575761604@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qinyun Tan <qinyuntan@linux.alibaba.com>

[ Upstream commit 6a100811c7c5fa39d452ff2e380bd14efbc0208e ]

With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS for
shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls back to a
non-memcg-aware shrinker.  On this fallback path, shrinker->id is never
assigned and keeps 0 from kzalloc(), which is a valid id belonging to
whichever memcg-aware shrinker registers first.

__list_lru_init() copies shrinker->id unconditionally, so every list_lru
backed by such a fallback shrinker (thp-deferred_split, zswap-shrinker,
workingset shadow nodes, superblock lrus, ...) ends up with
lru->shrinker_id == 0 instead of -1.

Under nokmem the list_lru collapses to the shared per-node lists, but
__list_lru_add() still calls set_shrinker_bit() against the memcg of
the added object.  Most list_lru users are unaffected because their
objects resolve to a NULL memcg without kmem accounting, but the THP
deferred split queue holds user folios, which are charged regardless of
nokmem.  On a system where no SHRINKER_NONSLAB shrinker registers,
shrinker_nr_max stays 0 and every memcg's shrinker_info has map_nr_max
== 0, so the first folio added by khugepaged triggers on every boot:

  WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0

On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register and
expand the maps, there is no warning; instead bit 0 is set spuriously for
an unrelated shrinker.

shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set, and all
readers inside mm/shrinker.c already check the flag before using the id.
Make __list_lru_init() do the same and fall back to -1, so
set_shrinker_bit() is never reached with a bogus id.  The stale
shrinker->id itself is left as is; cleaning that up is a separate topic.

Verified on a machine booting with cgroup.memory=nokmem and
CONFIG_TRANSPARENT_HUGEPAGE=y: the warning fires once per boot from
khugepaged, disappears when nokmem is removed from the command line, and
no longer triggers with this fix applied and nokmem set.

Link: https://lore.kernel.org/20260901115104.2944996-1-qinyuntan@linux.alibaba.com
Fixes: fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Wentao Guan <guanwentao@uniontech.com>
Closes: https://lore.kernel.org/linux-mm/20260904190028.21542-1-guanwentao@uniontech.com/
Tested-by: Wentao Guan <guanwentao@uniontech.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/list_lru.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..96d02ea206a88 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -666,7 +666,12 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	int i;
 
 #ifdef CONFIG_MEMCG
-	if (shrinker)
+	/*
+	 * If the shrinker fell back to being non-memcg-aware (e.g. with
+	 * cgroup.memory=nokmem), its id was never assigned and holds a
+	 * stale 0. Don't let set_shrinker_bit() act on it.
+	 */
+	if (shrinker && (shrinker->flags & SHRINKER_MEMCG_AWARE))
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
-- 
2.53.0



