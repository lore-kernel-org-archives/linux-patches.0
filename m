Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622880;
	b=M5GpQqISt6m/8CxxciVqXCosVe35C1zTnxtvcZzqXm1mhXV5pNLmNq2tFjkDmT7rf/0H
	 vL7v/fmNnAzYCq8Opy/fDAlEHHHOUGaUQPZM5zEwpgvlGqvCNARhxf2UaGw5ffsrSBlxM
	 72pfrE8+LFXLWDkcEVTfWqS2vh9w1FvGPXk8jMKIxSfsJJeG34pEq10fJhVyll8vRt6l2
	 DolqTjmOK6QyMdJqUWf6aoWNKvxRcGW91IpEGyOQBiSfAJiTuAJz6CPwnWazSraolIEEo
	 Bfbs19Q9IH0TjRJV/dQaYlTSx30ytxE1BXs52Ghv62jk2PSjS0blLmPK0074V5hR2Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVUKDR7cuqk+c5hm8Ca4iYa5HUuENi8euYF2WPz17cU=;
	b=DB2TMnDllAQtvUgVNaJvTGJfV1kOhRbwNgJxT/lqfcot52QqAEOwF4Z1xpbiE/hOTm9l
	 roJIIkCfQwdqJ+21n0rwArnxiWgSO/nhkIXs/dN46CRRywKVuEa5Zt1R28qETMIf+32nc
	 L2+bsIl3Vetkgiha0gmZ6OOs+7ArdF66sUwp/1PSRDowNiPm6Xb/Xb3Bn97kUqxJvV6W0
	 g7PaHJPlS3rkJI2S/kAJciman0YFJcCRsY93w14TV2NNzhKVGgHqXWyZKFqYFtyaCkQHI
	 bPtRnFY1bUDMBaqjxzBPODTokvGap69LlaHLBQ7R95zNUiNP95Hpd33VYKPiCxSa8cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5spObFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE36606A323;
	Wed, 25 Nov 2026 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5spObFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08891F000C4;
	Wed, 25 Nov 2026 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622880;
	bh=mVUKDR7cuqk+c5hm8Ca4iYa5HUuENi8euYF2WPz17cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5spObFZVHi5LHZH5MlaisxZIequ4EMhBz0+VVhew8DFsGxsuUak2D6LuQSE1S5J+
	 MDyNyGkZOy3CBTxwChl29/gDMGbRCiUtNjJ6TozP9u7F+oWX7cDEkxM5NAcmXsmZjo
	 yCtHKe5gR+Xa+m37m99sCvPq6Xe4GDKpp15SW1x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 678/990] mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
Date: Wed, 25 Nov 2026 15:34:05 +0100
Message-ID: <20261125143837.968373914@linuxfoundation.org>
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
@@ -4674,7 +4674,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;


