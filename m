Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619607;
	b=OLDKRrm4F0IkSZG8crpv8FQyVZbgdQVd5YbY6MAICnIfZPCpFbUnuZBPBcs/N5QwqLO6
	 y/TQ0ld/LxHK9NqUU87nFvIIV/13DpOp78zX5uh6K1M36pbx5z/zq7wK1zLUEB+puM+mu
	 ZuCW1wptYpthYFrD7KT+WOzW763Tv9Rm/M6wNYuJpczAYQ7nd0oc9/qU/q/HNDGYVhHbl
	 JzLaP8PF+wAkxkS61JTxnGy/W4kvb3eUDu5bMv5AszGih16xC/mOnqzRSmZqfhC4EKBZj
	 rNwGFVN7h2rCcYfSRhtUDfYJVMxQxrKxBnbOXk2H85xx7lyh7GHZ0D1SEq2BNiHvhTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/7OF1rW40RVJ644nwrIv9hoKSjKpOG4cPC/njoiHWdQ=;
	b=1I+/Vu+y8dDmcT66AwsIukfas65b+K0jzt+jM4OoltNIjinsu7ujHYIv3kMJKK3QA3KA
	 QLL5+G7CUQGL2ocd4sPfBSqZd1Z8c3qOg8v5FYsAODSMBuXZ0E/l+geodjPq1xFC1b5QE
	 PfvqS7M+dfcPI8YNPkoSViumNfrgd3teEL8kc8PAzKqQLM1XUMBedswdonsaiJ1vHbR/J
	 hmZeQEs8HXm4wVgFUAms5aRscevJNwa3qXg2MNV986i4NptHD0gJGF3u1SDwGVIYSuG+q
	 I/BT5UaoAWGDA5s/DBab4VqYaPhyVw0B6ifMXYzDbHAPPkswwLDJ5K0WTGHizln5T0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmIXQ3xS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B906606A31E;
	Wed, 25 Nov 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmIXQ3xS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A011F000C6;
	Wed, 25 Nov 2026 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619606;
	bh=/7OF1rW40RVJ644nwrIv9hoKSjKpOG4cPC/njoiHWdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmIXQ3xSiNa0nOXk0yZGTYVkdKbVDE7XDRO1sw2C/GJp0gnoYxfvL3kswNLczAXGB
	 fPrkDHPGRD/NPH46P6N2c4WIVI48VwiG+0PhSGjaR4+vOyzSVCF8eEH0fRi1nyDMfR
	 eB3mRyPOJHPNUGjeDi9Ei3e7WUH76xnhQ/UrUR5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0596/1005] mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
Date: Wed, 25 Nov 2026 15:32:14 +0100
Message-ID: <20261125143835.705549154@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 6c48b3ab4ee435c41c3395d31e8ec3dbccc3478c upstream.

should_reclaim_retry() walks a zonelist and passes the zoneref pointer
to the reclaim_retry_zone tracepoint, which loads the zone from the
entry again to find the node.

Memory hotplug rebuilds the zonelists in place while allocations are
under way. When a zone in front of the zoneref entry has become empty,
the entries move up, and this one can be the end marker by the time the
tracepoint looks at it. zonelist_node_idx() then dereferences a NULL
zone. Short of that, the event can name another zone than the one its
numbers belong to.

Pass the zone pointer instead of the zoneref pointer.

Fixes: d379f01de095 ("oom, trace: add oom detection tracepoints")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Link: https://patch.msgid.link/20261101021340.2251928-4-gourry@gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/oom.h |    8 ++++----
 mm/page_alloc.c            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -33,7 +33,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 TRACE_EVENT(reclaim_retry_zone,
 
-	TP_PROTO(struct zoneref *zoneref,
+	TP_PROTO(struct zone *zone,
 		int order,
 		unsigned long reclaimable,
 		unsigned long available,
@@ -41,7 +41,7 @@ TRACE_EVENT(reclaim_retry_zone,
 		int no_progress_loops,
 		bool wmark_check),
 
-	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+	TP_ARGS(zone, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
 
 	TP_STRUCT__entry(
 		__field(	int, node)
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zonelist_node_idx(zoneref);
-		__entry->zone_idx = zonelist_zone_idx(zoneref);
+		__entry->node = zone_to_nid(zone);
+		__entry->zone_idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4693,7 +4693,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;


