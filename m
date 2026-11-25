Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619462;
	b=B3s3u40xHUu8zvhf/qXfJoK2ZJZblZzjrgCWKXrdlQsSY9Tl1Gcd7KMIDEJYr4bbsElG
	 VLPAheOMFF7h4hZguFKn7PHocI2lKXKiJbw6JuttCg2S9imKw02CQWIfqcb90n73kcFfp
	 PRO4otYArlDyQnGmdRjrJvd1l2ojW7G0gwflsnPjbjGbaSdDH6/C/wryYAZcpNycf/Q+b
	 xYwEETG/DVmmvROCbvYhO5I9cN/LuPoPFoaRmFPb78HKw7akeF984xJQLfH11FyvEpO+O
	 +fjubY2V7WVlxHKGq1YIHqOdK9d4oQ45JO889xpioxTdc2kKKPZoH93FdGthSBHRmVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NgF5zXiNLuxtBm7VDzvxVUBWgANVTEcwfJ3KMVDsXDM=;
	b=ES1/nEaflQLgdDvOhZIxVt3Qbcg/lV5opvl4GMFR5kH3YWIm98gSz1e8iwJhtMnPz7u/
	 WH2nSnzfIR4ebWmlw25WiEbryXk1LaYMyk/vbCaJOkMJVhvvH01pE4dyZM0BqeF88WMU3
	 DWbtUI+0NBCLdc03lCmzQegggUnOqN16mPQcHJ1+HGOoVQcuB6VbVvgbOs2hAw3mBnDeK
	 gIzuAIolUhuZ/dFbhPAlJxVRK/VFbdeXTgqmaunOA/MpcFcB2nuCF9b3qP+vWJl3aJyW7
	 HRM7gJkytMAi1WcLCWZkN2wIJOR3H7RnBf7l2bw+ln38RE8IGagIQ0sDOxAgDoRcU6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xcoMPvS/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D4A606A337;
	Wed, 25 Nov 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcoMPvS/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A51E1F000F4;
	Wed, 25 Nov 2026 15:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619462;
	bh=NgF5zXiNLuxtBm7VDzvxVUBWgANVTEcwfJ3KMVDsXDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcoMPvS/JKTJuhg1lQdFH26kkukTy8Ydp5hNKgAG/hE+djWuZ39CO+Mjt6RPVjg8h
	 ucw4+ShIkq3Lc1Gm68GkgI9MEOrlLb1VPhnBD2lT2t1fatK1eXtawF09jWn6AJjhtg
	 aJVIM14B6DaSqO1OOyNFuaOwgJQ78h0RFuM8lgWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 7.3 0597/1005] mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
Date: Wed, 25 Nov 2026 15:32:15 +0100
Message-ID: <20261125143835.730379058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

commit da0d7a895e9021dc2cffa90fb6fafd8b9379e544 upstream.

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone.
alloc_contig_frozen_pages_noprof() approves a slot by the caller's gfp
and nodemask, then loads the zone from it:

  CPU 0                             CPU 1
  alloc_contig_frozen_pages_noprof(GFP_HIGHUSER | __GFP_THISNODE)
    slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1]
                                        -> [MOVABLE1, NORMAL1]
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    alloc_contig_frozen_range(MOVABLE1 pfns)

A gigantic hugetlb page can then land in ZONE_MOVABLE, and a nodemask
caller can get a range from another node.  Gigantic pages are kept out
of ZONE_MOVABLE since commit 79b63f12abcb ("mm, hugetlb: do not allocate
non-migrateable gigantic pages from movable zones").

Check zonelist_update_seq before using each zone, and restart the walk
if it changed, as the hugetlb pool walk does.  Check again before
escalating to the pass that may migrate hugetlb pages, so a pass a
rebuild cut short is redone rather than escalated.

With kprobes holding the walk across the online, the base kernel put the
1G page in ZONE_MOVABLE in 3 of 3 runs, and this change put it in
ZONE_NORMAL in 3 of 3.  Direct GFP_KERNEL calls with nodemask {1} and
{2} got a ZONE_MOVABLE range and a node 1 range on base, 3 of 3 each,
and neither with this change.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://patch.msgid.link/20261101021340.2251928-11-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7583,6 +7583,7 @@ struct page *alloc_contig_frozen_pages_n
 		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
+	unsigned int zonelist_cookie;
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
@@ -7591,8 +7592,13 @@ struct page *alloc_contig_frozen_pages_n
 
 retry:
 	zonelist = node_zonelist(nid, gfp_mask);
+	zonelist_cookie = zonelist_iter_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
+		/* A rebuild may have shifted an ineligible zone into this slot. */
+		if (unlikely(check_retry_zonelist(zonelist_cookie)))
+			goto retry;
+
 		spin_lock_irqsave(&zone->lock, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
@@ -7627,6 +7633,9 @@ retry:
 	 * second pass, we will try moving HugeTLB pages when those pages are
 	 * smaller than the requested contiguous region size.
 	 */
+	/* Redo a pass that a rebuild cut short before escalating. */
+	if (unlikely(check_retry_zonelist(zonelist_cookie)))
+		goto retry;
 	if (skip_hugetlb && skipped_hugetlb) {
 		skip_hugetlb = false;
 		goto retry;


