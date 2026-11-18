Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045454;
	b=yW4yfGc8tSKlw5gYkIEEQfGM4HLSFxwwKb9VHHjjoVXtrrEEKyyblWM/iTZNJhgm7Uzu
	 rPX8ekVo3eCLioda0bp+BtgUsBtUbOpFO7WYVl5MkKoBBrBdEJLsoYu8uH9Lj+p19e547
	 JMrNfbrHN0G63rjZB29xlJGApwzQeeVOAyX2pxFuNofrc6osnvj5v83uPgIHA9asN1CzU
	 ocN49xVxoMxHTzm9DMLae6WzFa9RYv8Lo99Uppvym4O5X6kw7bv8VTyjBCflTLe4hvbrU
	 vQQxrKSo3qyxQTNTBZtxY+SR8fvgMyvk9ttsT4VYUAbYj5vtaus04pIJPoFJbeIn03Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBmmQyZQLAKDcYCPdSrw+3H7daeNlQWMitKG0QLHT34=;
	b=jQFbS0WHyDjytxSFDZ5fytAW5yPdDQrXiUmZ7M7Lgqki3RcJMif0Apv+HkxSD1NjuRsJ
	 uJEgiNixTVGJdKCy9fBnjPZy/khbMU8+2D1NzFLXQhgm7iqz1yoaaJtMhse0GZnh8R28g
	 wNdKTpSKyJPAlDjCqAeOYJsx/+16Yr+Sk89JNLaDNZGMlvd+oQEjNu6rEnCwoJPQJBbNa
	 qLOBhb7Ck9Eb4nkeL9YWGhUg/k9ljGwoVVUkwLk6uh3Kq1AaiJP0Ebcd47MKLwhMbHw0j
	 r4ePecdgu+jQJe9QjPL/Jp8tv9/tmrYOBzPStN38x5qE2cB9It1dJ/LsPHHCqPQO9rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8yKEm2d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229E5606A32A;
	Wed, 18 Nov 2026 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8yKEm2d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781FB1F000C4;
	Wed, 18 Nov 2026 23:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045454;
	bh=PBmmQyZQLAKDcYCPdSrw+3H7daeNlQWMitKG0QLHT34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8yKEm2dfus452FGBfRHMdHkPAcvNhUfUxxWzDzrS/uLpbdHjAqPPNLge/TgvyHJq
	 Z4E5m4gzX166Lr7cJ7skPiTfYTds0CvC0MmE0kx3rMYynDF76TI9W1FqOb9zizRydJ
	 6WVZcVjnkyNNbpFLWPiB/7bhlm0H/+LaIU5pMMz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Henry Willard <henry.willard@oracle.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0928/2857] mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Wed, 18 Nov 2026 15:32:42 +0100
Message-ID: <20261118150235.003927290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanhe Shu <xiangzao@linux.alibaba.com>

[ Upstream commit 331f94007d79b3c02d3098eea469a92aea3efc2c ]

A watermark boost is not confined to one watermark: wmark_pages() adds it
to min, low and high alike, so every watermark check sees it, including
should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH attempt in
__alloc_pages_may_oom().  Once the boost exceeds the memory still free the
allocator gives up and invokes the OOM killer, and a capture kernel that
is still booting has nothing to kill: the boot panics and the vmcore is
lost.

Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
(pageblock = 64M) and crashkernel=512M, running a distribution kernel
based on 7.0.14.  A high order UNMOVABLE allocation fell back to a MOVABLE
pageblock while the capture kernel was still in do_initcalls():

  Node 0 DMA free:68096kB boost:65536kB min:68160kB
  low:68800kB high:69440kB managed:479168kB
  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory

The zone was not short of memory.  Subtracting the boost gives min:2624kB
low:3264kB high:3904kB, so the 68096kB still free sat 17 times above the
high watermark and the allocator would not even have entered its slow
path.  The boost supplied 65536kB of the 68160kB min and by itself put the
zone 64kB under water.  It is that large because boost_watermark() clamps
it with max(pageblock_nr_pages, max_boost); watermark_boost_factor alone
would have allowed 5824kB.

Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
tried to protect capture kernels, but it infers them from the zone size
and skips the boost only below four pageblocks.  arm64 64K pageblocks were
512M then, so the guard reached zones up to 2G;
CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
to zones under 256M and lets this 468M zone through.

kdump is a property of the kernel, not of the zone, so test for it
directly.  A capture kernel exits within seconds and never uses the
fragmentation avoidance the boost buys.  Normal kernels are unaffected:
the size based check still covers their genuinely tiny zones.

Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does not
cover this window: sysctl.* parameters are written through procfs by
do_sysctl_args(), which runs after do_initcalls() where the panic above
happened, and watermark_boost_factor has no early_param of its own.

Link: https://lore.kernel.org/20260916112545.3707893-1-xiangzao@linux.alibaba.com
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.0
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 85b189bcab7ec..de91843b80fad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
 #include <linux/compaction.h>
+#include <linux/crash_dump.h>
 #include <trace/events/kmem.h>
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
@@ -2749,10 +2750,17 @@ static inline bool boost_watermark(struct zone *zone)
 
 	if (!watermark_boost_factor)
 		return false;
+
+	/*
+	 * A kdump capture kernel exits before a boost can pay off, while
+	 * the raised watermark can exceed the memory left for the dump.
+	 */
+	if (is_kdump_kernel())
+		return false;
+
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
-	 * On small machines, including kdump capture kernels running
-	 * in a small area, boosting the watermark can cause an out of
+	 * On small machines, boosting the watermark can cause an out of
 	 * memory situation immediately.
 	 */
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-- 
2.53.0



