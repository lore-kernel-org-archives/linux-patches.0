Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065353;
	b=iDdr3j1jwtbNIjgH8GBHAdcQX722IgBZcIrpOFrZdXlCD70+YszhBDc2AWEX/mpIJ18n
	 tR7TAlvJNqPHVi4wJxHiVjWSpDxhtSzY97Hne9gwlY52lthXLQD+xj/8OB9rQLFpIabha
	 KmPqdh31hwselIsQacsAj0IC9iK9P60bDUZgZMNEwcw2GApRoDQyb8pd8WQoMQyw5YF+P
	 +9HiFOo2bddnwgVyoIkj7cXxwlU4B/n0My5Q8f3zK2i4s7QRtrsk4Swt/YMFTGuamNIWD
	 vED1JwUhOdsi2PLh0ynqHBASCvAASWNNca0Li/WpC2005B4BG2jvrp88Azt4O+pQvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VW9WgNBhgPZPxk/jkRJD2LtjD8aIQURj5LboCyFgQcQ=;
	b=BtxDMLWI1+bVyLu/2Vsq/4TNlm5Jf3VPvgzTW8HD1cf1ahqrhimPoQGPyTgFp97hJ4va
	 PJN6tpaOyoSksGsA9QiL7CY2S5LjOGiRkwsyoQ4Royzrf3oSZ/ivTDphXFi5gZq9tz57G
	 RLKrhUWyVk+m2lgFXZ8WaXXls9CM22JVz+J8Hi4LGqFQND0UP+fRnpV56KQylQ4ZQbuS2
	 8kOB/qF5QyR3SErFsLKbDdSZw6yiP7A6brjNDbWD4NNzS47GpqSgfhyVmGsWsuRwGbSvR
	 z9Nqz6lwxUKlCdN+ntHLNZNm6mUESxXXt7fvttuDwg7bVVZRGBrsze8umDRFr0RhN0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1xKZKvuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B9D606A32E;
	Sat,  7 Nov 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1xKZKvuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AEE1F0089F;
	Sat,  7 Nov 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065352;
	bh=VW9WgNBhgPZPxk/jkRJD2LtjD8aIQURj5LboCyFgQcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xKZKvuSciW7cd3YRR22QQPK4G7787HWg05zx3wyVxwSDqAvA18/eQCjC4cvhAVg5
	 ExFz6TmbdDjLMbmOH8mo+/+vnjgsqc3gz9PF/LV++UqyKWbawv/FuCeE24J0CyPiys
	 IVvgA/Aj+GAqJt6Xl4UWg4Bl30y2ShY8LlvXy8ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Dev Jain <dev.jain@arm.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baoquan He <baoquan.he@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1090/1257] mm/page_alloc: count guard pages as free again when their buddy merges
Date: Sat,  7 Nov 2026 08:56:26 -0500
Message-ID: <20261107135009.371227797@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 1503710b3b0cec02b531978129c6c1eb70a7c490 ]

With debug_guardpage_minorder set, expand() turns the unused halves of a
split into guard pages, which page_del_and_expand() leaves out of the free
counts.  Freeing the allocated half credits only that half, and
__free_one_page() then merges the guard buddy with clear_page_guard(),
which no longer touches the counters.

The merged block goes on a free list with the guard pages never counted,
so NR_FREE_PAGES falls behind the free lists by every guard that merges.
Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting"), __set_page_guard() and __clear_page_guard() adjusted the
counts themselves; that commit dropped both adjustments but kept the
subtraction implicit in expand().

Count the guard pages under the merged block's migratetype when the buddy
is cleared.  account_freepages() skips an isolated block as it does for
every other free page, and moving the block off the isolated list counts
it then.

Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
check the difference in free pages reported between /proc/vmstat and
/proc/buddyinfo.

At three points (idle, after a read and file-creation load, after a second
load), check the difference between nr_free_pages and the buddyinfo
numbers in the normal zone, as a number of pages:

                idle   after load   after second load
    unpatched   -130        79205               99121
    patched      -16           45                   0

The small remaining difference seems to be due to the numbers not being
read at exactly the same time, and is also seen without guard pages.

Link: https://lore.kernel.org/20261016122304.5b1eba8e@fangorn
Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Assisted-by: LLM
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c1cc9c705d2c1..8ca2289d0491b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -989,10 +989,12 @@ static inline void __free_one_page(struct page *page,
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-		if (page_is_guard(buddy))
+		if (page_is_guard(buddy)) {
 			clear_page_guard(zone, buddy, order);
-		else
+			account_freepages(zone, 1 << order, migratetype);
+		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+		}
 
 		if (unlikely(buddy_mt != migratetype)) {
 			/*
-- 
2.53.0



