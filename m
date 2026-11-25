Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622433;
	b=Hxj+dGpb2UWz5mJWNFHAwOt9w4SxN076AdPEzFsDXlvqO0sfxO5RDRtVasRa4ma6s5+1
	 +Fc5/iZjDbF30G0xUaxKQrc2mSq+IojagdPldyNjeFI66ssKXeDZyrmy8A/Ny3DrX8n+G
	 d1TVlOu2zgrJLxtWTz8voPMty2Bxu9jE4vI+oFc02uVwoorzeSy77Xt34lHXIEHztcauP
	 QIZE28rQizyHgev1pGChnA7AsO7aaVswHeOzEKvxIQA0GNxFdQ3AHv7q8L4fMVfAHWVl8
	 lB62L4R1vtZTwQmxvb24kRQrYOkcUhbZ3+1+Mktg/JMC1mGmrUitL7L8yjYVIchQuTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8JxLVvwWnztsJt912eE+AYRGj7ngvKkmOxEz9dNBpCU=;
	b=ycZFLs2W38Yst7VsOMKqDFKqT/clFd76SPzC7P9zSt/Ts3Gjp5GA9HSvghrLEcGDy0jg
	 0aIndeOGbsuRVPzScqLfQY8qIJFZYxmcZ96zLkHdE1uFDn0OrqlSeLEfOhMdftrmCOzFd
	 3Vi5sFZidICIg4Nv/u5+xEVfvqTj4ceDY2SStHSYAmm//VS1hSkv6CQvgb9mFVlf3K8OC
	 I/hWsKKQV2TGvMuZbD/s+gm/zt3sdKzhRfxBRluuAUGfhAI/p125ExVMbTivbgGCn4Ccw
	 0X/FO0v0v20a3FPIXcPSWpYmuwEdlrV5BEb5eB9cuQYAo+Pnl/dnwZYNy7aiJjK5Tlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mcjg7gnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27958606A31E;
	Wed, 25 Nov 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mcjg7gnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D991F000C0;
	Wed, 25 Nov 2026 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622432;
	bh=8JxLVvwWnztsJt912eE+AYRGj7ngvKkmOxEz9dNBpCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mcjg7gnrL7RRB6DLT4oFQ04UE4n3ksKFaRu6xPRwYUHX6nz1CSQIY56tTGd53RXaU
	 Ea8VO3tGyGTxwEexK0Ba0Xbuz0wkx4kz28pd5ck1QQUJ8ULIncAyhfVvPsN3rL67o8
	 J9RSneBlXAFeJIJd0BCmNCp5OYdyX2uSlfFti3Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Dipietro <dipiets@amazon.it>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christoph Hellwig <hch@lst.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Ali Saidi <alisaidi@amazon.com>,
	Geoff Blake <blakgeof@amazon.com>,
	Christian Brauner <brauner@kernel.org>,
	dipietro.salvatore@gmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	rvvandan@amazon.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Garg, Shivank" <shivankg@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/990] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Wed, 25 Nov 2026 15:31:06 +0100
Message-ID: <20261125143833.784803344@linuxfoundation.org>
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

From: Salvatore Dipietro <dipiets@amazon.it>

[ Upstream commit 0e05a469c29400eb6e35448ce7318581688a1806 ]

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path.
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation.
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>

introduced high-order folio allocations in the iomap buffered write path.
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation.

[ sashal: Kept this tree's existing can_compact expression and dropped the defrag_mode __GFP_NORETRY hunk, since the code it modifies isn't present here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2578475dd5d3f..867796dad0107 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4738,10 +4738,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4753,6 +4753,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * We most definitely don't want callers attempting to
-- 
2.53.0



