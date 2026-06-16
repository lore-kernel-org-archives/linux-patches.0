Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC447B434;
	Tue, 16 Jun 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630200; cv=none; b=AcyubUkQf55iGDETeroQBOXFzA8sCrErit6QEWSZT4MgZxprkhPQWV53eb1D7TeDsP4Zgwdlr8KTYW7qmn1qLJJEZfVAUag+L2VB0vZlaRmQPHGUyFZKvZjJuA6D7TLeLFrAf1aHH0yIBu+hrxE3wEmJ4Qox2ye7DJRbF1OWusQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630200; c=relaxed/simple;
	bh=xBSXlqOKaHbhKZkqKPsumH10DmF9ooTgVuzwq6lccsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP9y06ea6wvSn/cxongGmEMbyKEbjWHGCuzTHIdTNqi6QzI5hTornP1+RPRLs9vKt/9R7pgZzgyTiJ+7NSy6YKYGVytz53ClDiXgDXnRFo+i0f8p32Fz5hPVrIwU2CGHsgF104I7bzP530OCWuTAjxFSFRFy2LMxQwmnjbKeXWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uuhd4grZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uuhd4grZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ED21F000E9;
	Tue, 16 Jun 2026 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630193;
	bh=2RiaefZRNsM3b86r/MJQv2wzPdpE9coO3VOblNUyJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uuhd4grZt8mgpP/v9UvWVBs3djg7Yzyk9eiW9aZyzZvw3q2K49lLjjN8IE7NL0L/v
	 WDiWC8zj1HCceAfCfzOpS23wx/5weaLALRaKDyqmsa5osCNa2QWMvrEMAQhSmo129Y
	 sxhcf3AaSk+2vEaOCR6RCivEGoXjIiD58ST+S2HQ=
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
Subject: [PATCH 6.6 428/452] mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
Date: Tue, 16 Jun 2026 20:30:55 +0530
Message-ID: <20260616145139.166167401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 mm/hugetlb.c            |   25 +++++++++++++++++++------
 mm/memory-failure.c     |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    4 ++--
 7 files changed, 27 insertions(+), 14 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -162,7 +162,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_hugetlb(struct folio *folio, struct list_head *list);
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -446,7 +446,7 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+static inline bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	return false;
 }
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1971,7 +1971,7 @@ static unsigned long collect_longterm_un
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, movable_page_list);
+			folio_isolate_hugetlb(folio, movable_page_list);
 			continue;
 		}
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2969,7 +2969,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		isolated = isolate_hugetlb(old_folio, list);
+		isolated = folio_isolate_hugetlb(old_folio, list);
 		ret = isolated ? 0 : -EBUSY;
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
@@ -3045,7 +3045,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (folio_ref_count(folio) && isolate_hugetlb(folio, list))
+	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
 		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
@@ -7246,11 +7246,24 @@ __weak unsigned long hugetlb_mask_last_p
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
-/*
- * These functions are overwritable if your architecture needs its own
- * behavior.
+/**
+ * folio_isolate_hugetlb - try to isolate an allocated hugetlb folio
+ * @folio: the folio to isolate
+ * @list: the list to add the folio to on success
+ *
+ * Isolate an allocated (refcount > 0) hugetlb folio, marking it as
+ * isolated/non-migratable, and moving it from the active list to the
+ * given list.
+ *
+ * Isolation will fail if @folio is not an allocated hugetlb folio, or if
+ * it is already isolated/non-migratable.
+ *
+ * On success, an additional folio reference is taken that must be dropped
+ * using folio_putback_active_hugetlb() to undo the isolation.
+ *
+ * Return: True if isolation worked, otherwise False.
  */
-bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	bool ret = true;
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2639,7 +2639,7 @@ static bool isolate_page(struct page *pa
 	bool isolated = false;
 
 	if (PageHuge(page)) {
-		isolated = isolate_hugetlb(page_folio(page), pagelist);
+		isolated = folio_isolate_hugetlb(page_folio(page), pagelist);
 	} else {
 		bool lru = !__PageMovable(page);
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1720,7 +1720,7 @@ static void do_migrate_range(unsigned lo
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_hugetlb(folio, &source);
+			folio_isolate_hugetlb(folio, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -608,7 +608,7 @@ static int queue_folios_hugetlb(pte_t *p
 	 */
 	if ((flags & MPOL_MF_MOVE_ALL) ||
 	    (folio_estimated_sharers(folio) == 1 && !hugetlb_pmd_shared(pte)))
-		if (!isolate_hugetlb(folio, qp->pagelist))
+		if (!folio_isolate_hugetlb(folio, qp->pagelist))
 			qp->nr_failed++;
 unlock:
 	spin_unlock(ptl);
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -142,7 +142,7 @@ static void putback_movable_folio(struct
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_hugetlb().
+ * and folio_isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -2113,7 +2113,7 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			isolated = isolate_hugetlb(page_folio(page), pagelist);
+			isolated = folio_isolate_hugetlb(page_folio(page), pagelist);
 			err = isolated ? 1 : -EBUSY;
 		}
 	} else {


