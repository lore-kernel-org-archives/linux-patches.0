Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272B36A37A;
	Thu, 20 Aug 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239089; cv=none; b=UB1ON/FV2Bzmc3FntrvGuuPnICbLEXUoDy+OOV6m1dxAuNSZdgEA2m+kNBF6d5ME4udhgxaVfka7Lnnv5nmUYlXcCL9A/bG2SWNz9SLaFrpLL8u9Fi7t1WqiJjCmPK5aRqJVuw85udcT/qxQE+M685FfhuTfXjDYPf2e520raIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239089; c=relaxed/simple;
	bh=rDqgMk/4ydoE87Un3R7bB8cJf5WZoshOfr8//e3m1Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpfBdWbYNKfGhxJ8RZk6O+D87N7cMClAXQ08jIPoR1pmEeoLUtqTJLuRr5y7DhrYV3OqC1MM7jfFfJdR8sj3tan8GivcQ7A7bJseWLzhMJBxKAXHFaq7ryPFb02S19irvwQ2a0DCQbnuxKALSQ9gpl+mnG8oE2qxCvZ9z0l16mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnH9FK6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnH9FK6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48E71F000E9;
	Thu, 20 Aug 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239087;
	bh=gVnIZ3BgzzVeI5DkjlGXZUpgriW1fEvtaVWzfvba7gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnH9FK6OosRSjjnDDXZLkgI6VMvkhMIJf+3rDJvva/88NSTAyKgtkUb09F1hu2IHx
	 iDaSZIywn8QI1uPt9hgOb8DPTR9oHU6DmJEyCcT/mnkIZxh66aPPhidh96jb81qJ7U
	 C2zw+csD7f/GTJXC0mLDE4QZZEwh1opnaH4JuHx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Gregory Price <gourry@gourry.net>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mathew Brost <matthew.brost@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Wei Xu <weixugc@google.com>,
	xu xin <xu.xin16@zte.com.cn>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.18 145/217] mm: replace pmd_to_swp_entry() with softleaf_from_pmd()
Date: Thu, 20 Aug 2026 16:55:13 +0200
Message-ID: <20260820145242.118239358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 0ac881efe16468503e8c1e7d8a7210b75f027ce3 ]

Introduce softleaf_from_pmd() to do the equivalent operation for PMDs that
softleaf_from_pte() fulfils, and cascade changes through code base
accordingly, introducing helpers as necessary.

We are then able to eliminate pmd_to_swp_entry(),
is_pmd_migration_entry(), is_pmd_device_private_entry() and
is_pmd_non_present_folio_entry().

This further establishes the use of leaf operations throughout the code
base and further establishes the foundations for eliminating
is_swap_pmd().

No functional change intended.

[lorenzo.stoakes@oracle.com: check writable, not readable/writable, per Vlastimil]
  Link: https://lkml.kernel.org/r/cd97b6ec-00f9-45a4-9ae0-8f009c212a94@lucifer.local
Link: https://lkml.kernel.org/r/3fb431699639ded8fdc63d2210aa77a38c8891f1.1762812360.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>\
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 4165b7d1c45c ("userfaultfd: wait on source PMD during UFFDIO_MOVE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c      |    2 +-
 include/linux/swapops.h |    4 ++--
 mm/hmm.c                |    2 +-
 mm/huge_memory.c        |   20 ++++++++++----------
 mm/khugepaged.c         |    2 +-
 mm/madvise.c            |    2 +-
 mm/memory.c             |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    2 +-
 mm/page_vma_mapped.c    |    2 +-
 mm/pagewalk.c           |    2 +-
 mm/pgtable-generic.c    |    2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2031,7 +2031,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!is_pmd_migration_entry(pmd));
+		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = pfn_swap_entry_to_page(entry);
 	}
 
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -570,7 +570,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __swp_entry_to_pmd(arch_entry);
 }
 
-static inline int is_pmd_migration_entry(pmd_t pmd)
+static inline int pmd_is_migration_entry(pmd_t pmd)
 {
 	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
@@ -599,7 +599,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __pmd(0);
 }
 
-static inline int is_pmd_migration_entry(pmd_t pmd)
+static inline int pmd_is_migration_entry(pmd_t pmd)
 {
 	return 0;
 }
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -407,7 +407,7 @@ again:
 	if (pmd_none(pmd))
 		return hmm_vma_walk_hole(start, end, -1, walk);
 
-	if (thp_migration_supported() && is_pmd_migration_entry(pmd)) {
+	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
 			hmm_vma_walk->last = addr;
 			pmd_migration_entry_wait(walk->mm, pmdp);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1722,7 +1722,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
+		VM_BUG_ON(!pmd_is_migration_entry(pmd));
 		if (!is_readable_migration_entry(entry)) {
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
@@ -2132,7 +2132,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 
 	if (unlikely(!pmd_present(orig_pmd))) {
 		VM_BUG_ON(thp_migration_supported() &&
-				  !is_pmd_migration_entry(orig_pmd));
+				  !pmd_is_migration_entry(orig_pmd));
 		goto out;
 	}
 
@@ -2233,7 +2233,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		} else if (thp_migration_supported()) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
+			VM_BUG_ON(!pmd_is_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
@@ -2283,7 +2283,7 @@ static inline int pmd_move_must_withdraw
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	if (unlikely(is_pmd_migration_entry(pmd)))
+	if (unlikely(pmd_is_migration_entry(pmd)))
 		pmd = pmd_swp_mksoft_dirty(pmd);
 	else if (pmd_present(pmd))
 		pmd = pmd_mksoft_dirty(pmd);
@@ -2386,7 +2386,7 @@ int change_huge_pmd(struct mmu_gather *t
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_BUG_ON(!pmd_is_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2574,7 +2574,7 @@ int move_pages_huge_pmd(struct mm_struct
 
 	if (!pmd_trans_huge(src_pmdval)) {
 		spin_unlock(src_ptl);
-		if (is_pmd_migration_entry(src_pmdval)) {
+		if (pmd_is_migration_entry(src_pmdval)) {
 			pmd_migration_entry_wait(mm, &src_pmdval);
 			return -EAGAIN;
 		}
@@ -2863,7 +2863,7 @@ static void __split_huge_pmd_locked(stru
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+	VM_BUG_ON(!pmd_is_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2877,7 +2877,7 @@ static void __split_huge_pmd_locked(stru
 			zap_deposited_table(mm, pmd);
 		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
 			return;
-		if (unlikely(is_pmd_migration_entry(old_pmd))) {
+		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			swp_entry_t entry;
 
 			entry = pmd_to_swp_entry(old_pmd);
@@ -2913,7 +2913,7 @@ static void __split_huge_pmd_locked(stru
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
+	pmd_migration = pmd_is_migration_entry(*pmd);
 	if (unlikely(pmd_migration)) {
 		swp_entry_t entry;
 
@@ -3073,7 +3073,7 @@ void split_huge_pmd_locked(struct vm_are
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_migration_entry(*pmd))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -939,7 +939,7 @@ static inline int check_pmd_state(pmd_t
 	 * collapse it. Migration success or failure will eventually end
 	 * up with a present PMD mapping a folio again.
 	 */
-	if (is_pmd_migration_entry(pmde))
+	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_PMD_NULL;
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -391,7 +391,7 @@ static int madvise_cold_or_pageout_pte_r
 
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
-					!is_pmd_migration_entry(orig_pmd));
+					!pmd_is_migration_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6327,8 +6327,8 @@ retry_pud:
 
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(vmf.orig_pmd));
-			if (is_pmd_migration_entry(vmf.orig_pmd))
+					  !pmd_is_migration_entry(vmf.orig_pmd));
+			if (pmd_is_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
 		}
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -651,7 +651,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 
-	if (unlikely(is_pmd_migration_entry(*pmd))) {
+	if (unlikely(pmd_is_migration_entry(*pmd))) {
 		qp->nr_failed++;
 		return;
 	}
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -542,7 +542,7 @@ void pmd_migration_entry_wait(struct mm_
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
-	if (!is_pmd_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(*pmd))
 		goto unlock;
 	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), ptl);
 	return;
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -246,7 +246,7 @@ restart:
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
 			if (!pmd_present(pmde)) {
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -991,7 +991,7 @@ pmd_table:
 				goto found;
 			}
 		} else if ((flags & FW_MIGRATION) &&
-			   is_pmd_migration_entry(pmd)) {
+			   pmd_is_migration_entry(pmd)) {
 			swp_entry_t entry = pmd_to_swp_entry(pmd);
 
 			page = pfn_swap_entry_to_page(entry);
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -291,7 +291,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, uns
 
 	if (pmdvalp)
 		*pmdvalp = pmdval;
-	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
+	if (unlikely(pmd_none(pmdval) || pmd_is_migration_entry(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;


