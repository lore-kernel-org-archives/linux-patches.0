Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061894;
	b=lO8rFCjXFXQ7/7X4UU/1ZNfSJkEy5Pn+uquPLtU7uMWX+sa3XnES1aeYOVlTopX56OZ2
	 zqPW1du1IynbwZ+qdLAV5u0HEsbkiFXnF23YJuPW76Znm2QqK00Sbzn0cjDPiGMkPdTb5
	 OzsUKub5ykhn8jjSYtBadBjdmpVDBejbp2Jc/EPSQ//vyQy4N7YjhIDqiBmp+aksDD1fm
	 HmR4TIEJnqLz+CPav8KDBOLIcpYhUnzCIVarM+IQWhvjyDr0qHpyptqpazs8qfr8qjT/T
	 1HqcdvVQpruGLI5gH2VIBMny7WAEwWKZtorNiC6vGrmI/uuOpXDJLJwBaFlYTWWA+ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ykemrqOvrHlrcFAKl9vSxQpIMrCjMRNL9bxygQjRbxw=;
	b=2ezWvD5tDFgE0Ahjg96Q39sH+nP5V+d894r0V+T4HNjZofyO2WplZcwEuYMV34gXAdgl
	 vjV5wecoBtkNSJHai3TNUclIGg7I7OfAhJr1VGtAcQojRI21boU55wqkdaJNVFLIb4rk0
	 u7iKacCPObH6OSagCjbRyK+axo5exkM2Hsbcgpw9Ciy+8DQ2Zg/36OLpyPt3kB0ZERH3h
	 X3aRBFi2YL8DobMGw+02vWlX0OMgIYyYk0RxN3LFE/BB9WKNT5s6/HlrlfiSICYTPJmle
	 y2P4zMRhR/X0SlNW4xXJ3EC0InsCfrIhlUIjlupJ9NQzorGZqhhbgp7vLMYZKxD+5WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pm4+6aiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E837606A330;
	Sat,  7 Nov 2026 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pm4+6aiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DEC1F008A1;
	Sat,  7 Nov 2026 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061894;
	bh=ykemrqOvrHlrcFAKl9vSxQpIMrCjMRNL9bxygQjRbxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pm4+6aizcTQE9gERcYuElOZprRzUQ0QzPhuC3uXIfRHXWlS6OG1I3HTACIe8R8RER
	 5kRoF61o9kvVGZphqJ8sXlsQlW+Rf5GsGgt0vVTmnvQbBD4S87VhY7CruWSiDLOKrW
	 cMlb9Y+LU10Lp4FKTN1IAryiR1XPObyDomnuf5S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Ackerley Tng <ackerleytng@google.com>,
	Breno Leitao <leitao@debian.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0868/1536] mm/hugetlb: rename avoid_reserve to cow_from_owner
Date: Sat,  7 Nov 2026 08:48:04 -0500
Message-ID: <20261107135021.925202406@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 30cef82bc6e8975a360ec05b707f7fb194c875ed ]

The old name "avoid_reserve" can be too generic and can be used wrongly in
the new call sites that want to allocate a hugetlb folio.

It's confusing on two things: (1) whether one can opt-in to avoid global
reservation, and (2) whether it should take more than one count.

In reality, this flag is only used in an extremely hacky path, in an
extremely hacky way in hugetlb CoW path only, and always use with 1 saying
"skip global reservation".  Rename the flag to avoid future abuse of this
flag, making it a boolean so as to reflect its true representation that
it's not a counter.  To make it even harder to abuse, add a comment above
the function to explain it.

Link: https://lkml.kernel.org/r/20250107204002.2683356-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 824cc56bf43c ("mm/hugetlb: fix use-after-free of a new anon folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c    |  2 +-
 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            | 33 ++++++++++++++++++++-------------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 734eb08bafc92..1a12932b58806 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -884,7 +884,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		folio = alloc_hugetlb_folio(&pseudo_vma, addr, 0);
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 7eaabacdf1105..32cbaaaccfe54 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -691,7 +691,7 @@ struct huge_bootmem_page {
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, int avoid_reserve);
+				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
@@ -1083,7 +1083,7 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   int avoid_reserve)
+					   bool cow_from_owner)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1dc40a06eb0a..2805ddda5adeb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2991,8 +2991,15 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+/*
+ * NOTE! "cow_from_owner" represents a very hacky usage only used in CoW
+ * faults of hugetlb private mappings on top of a non-page-cache folio (in
+ * which case even if there's a private vma resv map it won't cover such
+ * allocation).  New call sites should (probably) never set it to true!!
+ * When it's set, the allocation will bypass all vma level reservations.
+ */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, int avoid_reserve)
+				    unsigned long addr, bool cow_from_owner)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -3034,7 +3041,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Allocations for MAP_NORESERVE mappings also need to be
 	 * checked against any subpool limit.
 	 */
-	if (map_chg || avoid_reserve) {
+	if (map_chg || cow_from_owner) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
 		if (gbl_chg < 0)
 			goto out_end_reservation;
@@ -3042,7 +3049,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	/* If this allocation is not consuming a reservation, charge it now.
 	 */
-	deferred_reserve = map_chg || avoid_reserve;
+	deferred_reserve = map_chg || cow_from_owner;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg_rsvd);
@@ -3067,7 +3074,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
+		if (!cow_from_owner && vma_has_reserves(vma, gbl_chg)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
@@ -3125,7 +3132,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg_rsvd);
 out_subpool_put:
-	if (map_chg || avoid_reserve)
+	if (map_chg || cow_from_owner)
 		hugepage_subpool_put_pages(spool, 1);
 out_end_reservation:
 	vma_end_reservation(h, vma, addr);
@@ -5366,7 +5373,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5827,7 +5834,7 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 	struct hstate *h = hstate_vma(vma);
 	struct folio *old_folio;
 	struct folio *new_folio;
-	int outside_reserve = 0;
+	bool cow_from_owner = 0;
 	vm_fault_t ret = 0;
 	struct mmu_notifier_range range;
 
@@ -5896,7 +5903,7 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
 			old_folio != pagecache_folio)
-		outside_reserve = 1;
+		cow_from_owner = true;
 
 	folio_get(old_folio);
 
@@ -5905,7 +5912,7 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, outside_reserve);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5915,7 +5922,7 @@ static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 		 * reliability, unmap the page from child processes. The child
 		 * may get SIGKILLed if it later faults.
 		 */
-		if (outside_reserve) {
+		if (cow_from_owner) {
 			struct address_space *mapping = vma->vm_file->f_mapping;
 			pgoff_t idx;
 			u32 hash;
@@ -6166,7 +6173,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, 0);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -6630,7 +6637,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			ret = -ENOMEM;
 			goto out;
@@ -6672,7 +6679,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
2.53.0



