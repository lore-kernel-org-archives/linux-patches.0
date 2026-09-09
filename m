Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B75577E4F;
	Wed,  9 Sep 2026 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964891; cv=none; b=TjSFz3q3yQv7VNIdVov5X8dRgo96DBRRPjmlpqVe1FFCHlto2MsqzolSlKfgFS5ZR37xwsrmpeXLqDyXntzx57R2AuYZ/cpQ5ECBpF6mnwPkfj/kLQ8+hcRPocHfk7ONsfjglzSlh2Loth9pXhi74Ols8GOMIZLRQQ2quqn7tLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964891; c=relaxed/simple;
	bh=9kqXgLPgSr6xfDMgiFUBdUuy7oOrx6r203Mr3npQIrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHhSE0Cvi6T5lu8m7hLcvAJF69l2sWPqShLgjaIcXFf9PuMdWeo/RBEJsscJO+THnhv8yTxEbSHRidRKlBKTN24s6QVcvRwVF8uULG5VBRb/jWLN+enmSVRleaFMYnS9XglgRYVLQGCdnnqDz9RW5DnTtiHDeUwULThSEC0xVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIS6tOXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIS6tOXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733F81F00A3A;
	Wed,  9 Sep 2026 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964890;
	bh=Qgn6R6Wd1rGLESldgW9MJmXuWOBP/x+BJpHqhMYv4cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIS6tOXvjreU1j7PsAFI9r1X03tmTFXOSJEv38npDaMoOS1378BhOrf3Te5xZDqX5
	 q1o26TNYfuLNx/H61hwST1BNWrrCg0gdJ/KAODLIPieFfglKTpsuDPzXwJo4u7XTPd
	 wbTRatX2VaYL7XRIJm9Fw4SVCzdQ5fzunYbuuoRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/583] migrate: replace RMP_ flags with TTU_ flags
Date: Wed,  9 Sep 2026 15:44:24 +0200
Message-ID: <20260909134257.863561418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 832d95b5314eea558cf4cc9ca40db10122ce8f63 ]

Instead of translating between RMP_ and TTU_ flags, remove the RMP_ flags
and just use the TTU_ flag space; there's plenty available.

Possibly we should rename these to RMAP_ flags, and maybe even pass them
in through rmap_walk_arg, but that can be done later.

Link: https://lkml.kernel.org/r/20260109041345.3863089-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c299a2285d9d ("mm/huge_memory: use folio's memcg inside __folio_split()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    9 +++------
 mm/huge_memory.c     |    6 +++---
 mm/migrate.c         |   12 ++++++------
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -92,6 +92,7 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
+	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
@@ -1000,12 +1001,8 @@ int mapping_wrprotect_range(struct addre
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
-enum rmp_flags {
-	RMP_LOCKED		= 1 << 0,
-	RMP_USE_SHARED_ZEROPAGE	= 1 << 1,
-};
-
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3298,7 +3298,7 @@ static void remap_page(struct folio *fol
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
-		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
+		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
 		if (i >= nr)
 			break;
@@ -3702,8 +3702,8 @@ static int __folio_split(struct folio *f
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
+	pgoff_t end = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3948,7 +3948,7 @@ fail:
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon)
-		ttu_flags = (enum ttu_flags)RMP_USE_SHARED_ZEROPAGE;
+		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 	remap_page(folio, 1 << old_order, ttu_flags);
 
 	/*
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -451,11 +451,12 @@ static bool remove_migration_pte(struct
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags)
 {
 	struct rmap_walk_arg rmap_walk_arg = {
 		.folio = src,
-		.map_unused_to_zeropage = flags & RMP_USE_SHARED_ZEROPAGE,
+		.map_unused_to_zeropage = flags & TTU_USE_SHARED_ZEROPAGE,
 	};
 
 	struct rmap_walk_control rwc = {
@@ -463,9 +464,9 @@ void remove_migration_ptes(struct folio
 		.arg = &rmap_walk_arg,
 	};
 
-	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
+	VM_BUG_ON_FOLIO((flags & TTU_USE_SHARED_ZEROPAGE) && (src != dst), src);
 
-	if (flags & RMP_LOCKED)
+	if (flags & TTU_RMAP_LOCKED)
 		rmap_walk_locked(dst, &rwc);
 	else
 		rmap_walk(dst, &rwc);
@@ -1530,8 +1531,7 @@ static int unmap_and_move_huge_page(new_
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src,
-				ttu ? RMP_LOCKED : 0);
+		remove_migration_ptes(src, !rc ? dst : src, ttu);
 
 	if (ttu & TTU_RMAP_LOCKED)
 		i_mmap_unlock_write(mapping);


