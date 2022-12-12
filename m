Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED622585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04415C433EF;
	Mon, 12 Dec 2022 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850756;
	bh=oWC/Q9RHsgnXL57RJrWazyvwtSwmc8YjZ0itsLFoj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnQ2qlycdwx+N9INEl7xo6fF2Fe2n48TMf4cH8O2xb+FDPCc7FcOfBTq04z4sW/PL
	 ZsQgH6Xes8WDcaxFrhKYiI3SKtytpRfhyg0J44G/xPfSQHL4yzyBjrhoPlxrd7jl8J
	 p0k9Ubu9rTOREOufeWBoIa8JCF+Ty8jyMU6Ei2+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Shi <alex.shi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	"Chen, Rong A" <rong.a.chen@intel.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Jann Horn <jannh@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@nextfour.com>,
	Minchan Kim <minchan@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <yang.shi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/106] mm/mlock: remove __munlock_isolate_lru_page()
Date: Mon, 12 Dec 2022 14:09:05 +0100
Message-Id: <20221212130924.973976950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit 13805a88a9bd3fb37f33dd8972d904de62796f3d ]

__munlock_isolate_lru_page() only has one caller, remove it to clean up
and simplify code.

Link: https://lkml.kernel.org/r/1604566549-62481-14-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttilä <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 796c726a0407..d487aa864e86 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -105,26 +105,6 @@ void mlock_vma_page(struct page *page)
 	}
 }
 
-/*
- * Isolate a page from LRU with optional get_page() pin.
- * Assumes lru_lock already held and page already pinned.
- */
-static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
-{
-	if (PageLRU(page)) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (getpage)
-			get_page(page);
-		ClearPageLRU(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
-		return true;
-	}
-
-	return false;
-}
-
 /*
  * Finish munlock after successful page isolation
  *
@@ -296,9 +276,16 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
 			 */
-			if (__munlock_isolate_lru_page(page, false))
+			if (PageLRU(page)) {
+				struct lruvec *lruvec;
+
+				ClearPageLRU(page);
+				lruvec = mem_cgroup_page_lruvec(page,
+							page_pgdat(page));
+				del_page_from_lru_list(page, lruvec,
+							page_lru(page));
 				continue;
-			else
+			} else
 				__munlock_isolation_failed(page);
 		} else {
 			delta_munlocked++;
-- 
2.35.1



