Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4828D169AD2;
	Tue, 16 Jun 2026 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632986; cv=none; b=Ond9I3xvWeloX69qHNmaQdOvF/WiDhrOajb8iJDB/HqnJ7kqCno7sn8FHRNxSCC+x/rHRGYr2mtq3Q0JpAgd2QtBVvs1HkRzv4zmmE+XP3bh4Ks2hKAkzEw9MH6hMY3VBd/yvO1QdcSCGw+kbKr00P1AT5ey0ptbYCsbGFY/hc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632986; c=relaxed/simple;
	bh=2As2Js8C5v4wbyj4P2Rt+k3nwjVLEwC7ZNsFyFyeCNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0njdSfl5k07wRAZMNfzTrni3P+MFtqNivt1sbj7RAVewSGPswcF2DmCu8jLqgggIEWQ+AvRhMcCz0N/pgX3gZvv93iChLQx7V9v82YTsgld8wVKv3bEhjls1z8Pn/Up3thLmG6Zd7+UFBx1bPpPBbwmy7FPM7disHl3JETnte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pyxap7yH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pyxap7yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2C21F000E9;
	Tue, 16 Jun 2026 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632985;
	bh=FziLQ/y9piXVvvJj6qUmatNHOd9gGj1LQcWdkwddcu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pyxap7yHFoTzsQchhg1/pi8k8VSO0LpCQZUiV10xZ5rxtYU7uC/vSGNFBJdJFMjPM
	 NdavhtZ8Ma1E4g1Upf7IAUEVHLIduZPKDFqECw5LpIC+rmrKodFytP6zoy7BgPENNO
	 3Y7qhytvf2MwNBwRY32bHdd4O076hDFOAHWRWCiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 482/522] mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
Date: Tue, 16 Jun 2026 20:30:29 +0530
Message-ID: <20260616145148.373150969@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 4c640f128074e0d4459ecf072595a44df5c2ae18 ]

Let's make the function name match "folio_isolate_lru()", and add some
kernel doc.

Link: https://lkml.kernel.org/r/20250113131611.2554758-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3c2d42b8ee34 ("mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    4 ++--
 mm/gup.c                |    2 +-
 mm/hugetlb.c            |   23 ++++++++++++++++++++---
 mm/memory-failure.c     |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    4 ++--
 7 files changed, 28 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -182,7 +182,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-int isolate_hugetlb(struct page *page, struct list_head *list);
+int folio_isolate_hugetlb(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
@@ -428,7 +428,7 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline int isolate_hugetlb(struct page *page, struct list_head *list)
+static inline int folio_isolate_hugetlb(struct page *page, struct list_head *list)
 {
 	return -EBUSY;
 }
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1986,7 +1986,7 @@ static unsigned long collect_longterm_un
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(&folio->page, movable_page_list);
+			folio_isolate_hugetlb(&folio->page, movable_page_list);
 			continue;
 		}
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2994,7 +2994,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		ret = isolate_hugetlb(old_page, list);
+		ret = folio_isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
@@ -3070,7 +3070,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && !isolate_hugetlb(head, list))
+	if (page_count(head) && !folio_isolate_hugetlb(head, list))
 		ret = 0;
 	else if (!page_count(head))
 		ret = alloc_and_dissolve_huge_page(h, head, list);
@@ -7445,7 +7445,24 @@ follow_huge_pgd(struct mm_struct *mm, un
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-int isolate_hugetlb(struct page *page, struct list_head *list)
+/**
+ * folio_isolate_hugetlb - try to isolate an allocated hugetlb page
+ * @page: the page to isolate
+ * @list: the list to add the page to on success
+ *
+ * Isolate an allocated (refcount > 0) hugetlb page, marking it as
+ * isolated/non-migratable, and moving it from the active list to the
+ * given list.
+ *
+ * Isolation will fail if @page is not an allocated hugetlb page, or if
+ * it is already isolated/non-migratable.
+ *
+ * On success, an additional page reference is taken that must be dropped
+ * using putback_active_hugepage() to undo the isolation.
+ *
+ * Return: 0 if isolation worked, otherwise -EBUSY.
+ */
+int folio_isolate_hugetlb(struct page *page, struct list_head *list)
 {
 	int ret = 0;
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2444,7 +2444,7 @@ static bool isolate_page(struct page *pa
 	bool isolated = false;
 
 	if (PageHuge(page)) {
-		isolated = !isolate_hugetlb(page, pagelist);
+		isolated = !folio_isolate_hugetlb(page, pagelist);
 	} else {
 		bool lru = !__PageMovable(page);
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1641,7 +1641,7 @@ do_migrate_range(unsigned long start_pfn
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_hugetlb(head, &source);
+			folio_isolate_hugetlb(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -598,7 +598,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
 	     !hugetlb_pmd_shared(pte))) {
-		if (isolate_hugetlb(page, qp->pagelist) &&
+		if (folio_isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -133,7 +133,7 @@ static void putback_movable_page(struct
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_hugetlb().
+ * and folio_isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1995,7 +1995,7 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			err = isolate_hugetlb(page, pagelist);
+			err = folio_isolate_hugetlb(page, pagelist);
 			if (!err)
 				err = 1;
 		}


