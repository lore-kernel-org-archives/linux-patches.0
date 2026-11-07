Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062609;
	b=NNibxtX8ugVDh7DobV6Skhz38EqDhfOTDhuCMLnwZRU/R1Uny4qGTL7lS8JAYJJO24CI
	 J9FWLD9I14Fhl7e+1dP3mrwwwrJnnE5YfJc4v7soIY+eW8GHq5pYtvcSY1xe78wHdih/4
	 y5Vp9APl2nEPKxA0t9SYeikiFKRfoE5VvPrXVloh1MFtWHOmLkR8uFTf37JvU8aJpzxNz
	 8Kk8+eaVO2OK0EVXLlH7HMP2HPdWzTvcI0oXfHywE5azKmYPujty6lxyhtlshfXC7QHfH
	 QFvrNyQFJZSbesLbX6V9D90yqWyMWsctt/uGfc2d30A3tmpenYhPK/wIAVZPyA62zmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4efFVmxiHtQx9M/jdXvfY0kY3PhbG9e+JKfVdt49lRE=;
	b=WDxo0aZj43cv63C2Miye3fYU0Gu5H+9USevzBXP8WnVk2wZ1AZ0DZbzzqvH3sY/1WpmD
	 mrwwGujU2z4E+O4aPs5D28cAqcFXWu0nZT+9ZO2LCRbKI2xgtymOTLQ+jr3/PbxdNfcLn
	 ijaDNfD3cKpc3saRnpbjz+I0Y1JxdxEBR2OFLjd/etHkR/L51J7Fz1Xh4h2fBVHtcH49l
	 PdYVZAGD7fLYgIy7LpnfcF91N5us2FISQVm5kFWj2pNaeeQ+NjfNLT6AhuBghMynRDj7X
	 yZd0sQAmC2gL36g9crLN9jLjdD5oYVZyKaUfeqWBp6T+u5zy9EpcV7q+hk/rZf/3mwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSnxB4yk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0820606A335;
	Sat,  7 Nov 2026 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSnxB4yk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4A81F0089F;
	Sat,  7 Nov 2026 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062608;
	bh=4efFVmxiHtQx9M/jdXvfY0kY3PhbG9e+JKfVdt49lRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSnxB4ykJBYUaJkNrHb13ol7zqB5NptSF+rDunVDMhryxC1egn9hhDYitWUaEfEPm
	 35FJBa2/6+gQYxnFRWgvlnyqSb+YZnQohRpjAVUVpEPm+BX0QnwNrWQv2IOSe9yket
	 fBeqU0Cds6D9YQqLcOFX1SmHQNKFtYaQchfLoKgo=
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
Subject: [PATCH 6.12 1445/1536] mm/page_alloc: count guard pages as free again when their buddy merges
Date: Sat,  7 Nov 2026 08:57:41 -0500
Message-ID: <20261107135038.419624204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index e68a47d8485c8..a649f0245e3bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -858,10 +858,12 @@ static inline void __free_one_page(struct page *page,
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



