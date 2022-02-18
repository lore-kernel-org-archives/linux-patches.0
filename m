Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13D320F
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 12:21:38 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id h18so15176008edb.7
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 04:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CxgcV2X+mf5tHHSItDMFwLt3GiNhfPQtXkA6xIDBOaU=;
        b=i+1343FYxgfR6BihLtuKedHVISnzI9jE9tFe2Iy+Vja5RWi3OdlAyRyq7Y2A2NVYgD
         SrzBmARjdNlbI0QD498t1atCBXDYXJdJkEDlPCVYlsDv3vjzcbC1lpEu6nT+pz/6VUH/
         fjSxuXKAOl21MzctVSfD7wlk1JzeP9pepFcTPb600oPMNrbs/hR1ecYY/tfWQUDRSe8W
         ZRVn3+hrb0UuF42B1bL+kDTnJF34/+HDYhZr9WqCO+uCBkGaMasPI/0B21aucm9nVtwf
         R2DNmCO6QhOGoNAeAuOx7HSFxIpYqqq9gPDA/zocZ2ychPaHEnW5clSwLKI8uw/zCIv2
         nYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CxgcV2X+mf5tHHSItDMFwLt3GiNhfPQtXkA6xIDBOaU=;
        b=ke+O+f+gmCjvdyww+ZjLW/TcSd5Fk8XIy4jGweRTTHkR3qlomtyebumsw2O+tMlhnq
         tlzb7GW8A4UboRd5dN7HNqP2SwWuzVd2heIRnO+XFVKC+q05rH4xfg9oz2vy+nw8H+ii
         mZXbBUVN9Uvwi8KkwR1hNV0pAgFKNUmFOxWoq2GF/26qZ+jYhknx/XWp4YuiUC23x0GD
         /x6jyvPFLMT7cx4oIRB7IbrPZOxiretP6Vd6kK3rkVEI2ohLW78WRe4wTcDAmzekA69G
         F/SW2Cu5Pymbpp4Z27dk3MoCx9xQiN7SW+jU/a+B7EqTLKQ/YNusNRRrvgsvoP12rgyy
         n3lA==
X-Gm-Message-State: AOAM5339ylhwxe/zkrmAxkGZTAwj9fFNBBjsIMSUbNg6hUTaLXpGfmQQ
	Cb31r4eoJRqOH0+hFlGHnYk=
X-Google-Smtp-Source: ABdhPJwV5LisTlr091/VkeaHJPcpPnY56InIouFFedi91Q8riGKroZfFTvtysCIzt/O56p+X5gLZ4w==
X-Received: by 2002:a05:6402:1a55:b0:410:a4b4:2a9d with SMTP id bf21-20020a0564021a5500b00410a4b42a9dmr7979016edb.45.1645186897081;
        Fri, 18 Feb 2022 04:21:37 -0800 (PST)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id vl24sm2160551ejb.141.2022.02.18.04.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 04:21:35 -0800 (PST)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 4C26BA81D1; Fri, 18 Feb 2022 13:20:44 +0100 (CET)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: linux-mm@kvack.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	vbabka@suse.cz,
	mhocko@kernel.org,
	mgorman@techsingularity.net,
	willy@infradead.org,
	liam.howlett@oracle.com,
	hughd@google.com,
	kirill@shutemov.name,
	riel@surriel.com,
	rostedt@goodmis.org,
	peterz@infradead.org,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [RFC PATCH 4/4] [PATCH 4/4] mm: add tracing for VMA merges
Date: Fri, 18 Feb 2022 13:20:19 +0100
Message-Id: <20220218122019.130274-5-matenajakub@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218122019.130274-1-matenajakub@gmail.com>
References: <20220218122019.130274-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Adds trace support for vma_merge to measure successful and unsuccessful
merges of two VMAs with distinct anon_vmas and also trace support for
merges made possible by update of page offset made possible by a previous
patch in this series.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 include/trace/events/mmap.h | 55 ++++++++++++++++++++++++++++++++
 mm/internal.h               | 11 +++++++
 mm/mmap.c                   | 63 ++++++++++++++++++++-----------------
 3 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/include/trace/events/mmap.h b/include/trace/events/mmap.h
index 4661f7ba07c0..9f6439e2ed2d 100644
--- a/include/trace/events/mmap.h
+++ b/include/trace/events/mmap.h
@@ -6,6 +6,7 @@
 #define _TRACE_MMAP_H
 
 #include <linux/tracepoint.h>
+#include <../mm/internal.h>
 
 TRACE_EVENT(vm_unmapped_area,
 
@@ -42,6 +43,60 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->low_limit, __entry->high_limit, __entry->align_mask,
 		__entry->align_offset)
 );
+
+TRACE_EVENT(vm_av_merge,
+
+	TP_PROTO(int merged, enum vma_merge_res merge_prev, enum vma_merge_res merge_next, enum vma_merge_res merge_both),
+
+	TP_ARGS(merged, merge_prev, merge_next, merge_both),
+
+	TP_STRUCT__entry(
+		__field(int,			merged)
+		__field(enum vma_merge_res,	predecessor_different_av)
+		__field(enum vma_merge_res,	successor_different_av)
+		__field(enum vma_merge_res,	predecessor_with_successor_different_av)
+		__field(int,			diff_count)
+		__field(int,			failed_count)
+	),
+
+	TP_fast_assign(
+		__entry->merged = merged == 0;
+		__entry->predecessor_different_av = merge_prev;
+		__entry->successor_different_av = merge_next;
+		__entry->predecessor_with_successor_different_av = merge_both;
+		__entry->diff_count = (merge_prev == AV_MERGE_DIFFERENT)
+		+ (merge_next == AV_MERGE_DIFFERENT) + (merge_both == AV_MERGE_DIFFERENT);
+		__entry->failed_count = (merge_prev == AV_MERGE_FAILED)
+		+ (merge_next == AV_MERGE_FAILED) + (merge_both == AV_MERGE_FAILED);
+	),
+
+	TP_printk("merged=%d predecessor=%d successor=%d predecessor_with_successor=%d diff_count=%d failed_count=%d\n",
+		__entry->merged,
+		__entry->predecessor_different_av, __entry->successor_different_av,
+		__entry->predecessor_with_successor_different_av,
+		__entry->diff_count, __entry->failed_count)
+
+);
+
+TRACE_EVENT(vm_pgoff_merge,
+
+	TP_PROTO(struct vm_area_struct *vma, bool anon_pgoff_updated),
+
+	TP_ARGS(vma, anon_pgoff_updated),
+
+	TP_STRUCT__entry(
+		__field(bool,	faulted)
+		__field(bool,	updated)
+	),
+
+	TP_fast_assign(
+		__entry->faulted = vma->anon_vma;
+		__entry->updated = anon_pgoff_updated;
+	),
+
+	TP_printk("faulted=%d updated=%d\n",
+		__entry->faulted, __entry->updated)
+);
 #endif
 
 /* This part must be outside protection */
diff --git a/mm/internal.h b/mm/internal.h
index d80300392a19..b3e482175518 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -34,6 +34,17 @@ struct folio_batch;
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
+/*
+ * Following values indicate reason for merge success or failure.
+ */
+enum vma_merge_res {
+	MERGE_FAILED,
+	AV_MERGE_FAILED,
+	AV_MERGE_SAME,
+	MERGE_OK = AV_MERGE_SAME,
+	AV_MERGE_DIFFERENT,
+};
+
 void page_writeback_init(void);
 
 static inline void *folio_raw_mapping(struct folio *folio)
diff --git a/mm/mmap.c b/mm/mmap.c
index ed91d0cd2111..10c76c6a3288 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1064,21 +1064,21 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
 	 */
 	if ((!anon_vma1 || !anon_vma2) && (!vma ||
 		list_is_singular(&vma->anon_vma_chain)))
-		return 1;
+		return AV_MERGE_SAME;
 	if (anon_vma1 == anon_vma2)
-		return 1;
+		return AV_MERGE_SAME;
 	/*
 	 * Different anon_vma but not shared by several processes
 	 */
 	else if ((anon_vma1 && anon_vma2) &&
 			(anon_vma1 == anon_vma1->root)
 			&& (rbt_no_children(anon_vma1)))
-		return 1;
+		return AV_MERGE_DIFFERENT;
 	/*
 	 * Different anon_vma and shared -> unmergeable
 	 */
 	else
-		return 0;
+		return AV_MERGE_FAILED;
 }
 
 /*
@@ -1099,12 +1099,10 @@ can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
 		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		     const char *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
-	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name))
 		if (vma->vm_pgoff == vm_pgoff)
-			return 1;
-	}
-	return 0;
+			return is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma);
+	return MERGE_FAILED;
 }
 
 /*
@@ -1121,14 +1119,13 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
 		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		    const char *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
-	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
 		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
-			return 1;
+			return is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma);
 	}
-	return 0;
+	return MERGE_FAILED;
 }
 
 /*
@@ -1185,9 +1182,14 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
 	int err;
-	int merge_prev = 0;
-	int merge_both = 0;
-	int merge_next = 0;
+	/*
+	 * Following three variables are used to store values
+	 * indicating wheather this VMA and its anon_vma can
+	 * be merged and also the type of failure or success.
+	 */
+	enum vma_merge_res merge_prev = MERGE_FAILED;
+	enum vma_merge_res merge_both = MERGE_FAILED;
+	enum vma_merge_res merge_next = MERGE_FAILED;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -1210,38 +1212,39 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	 * Can we merge predecessor?
 	 */
 	if (prev && prev->vm_end == addr &&
-			mpol_equal(vma_policy(prev), policy) &&
-			can_vma_merge_after(prev, vm_flags,
+			mpol_equal(vma_policy(prev), policy)) {
+		merge_prev = can_vma_merge_after(prev, vm_flags,
 					    anon_vma, file, pgoff,
-					    vm_userfaultfd_ctx, anon_name)) {
-		merge_prev = true;
+					    vm_userfaultfd_ctx, anon_name);
 	}
+
 	/*
 	 * Can we merge successor?
 	 */
 	if (next && end == next->vm_start &&
-			mpol_equal(policy, vma_policy(next)) &&
-			can_vma_merge_before(next, vm_flags,
+			mpol_equal(policy, vma_policy(next))) {
+		merge_next = can_vma_merge_before(next, vm_flags,
 					anon_vma, file, pgoff+pglen,
-					vm_userfaultfd_ctx, anon_name)) {
-		merge_next = true;
+					vm_userfaultfd_ctx, anon_name);
 	}
+
 	/*
 	 * Can we merge both predecessor and successor?
 	 */
-	if (merge_prev && merge_next)
+	if (merge_prev >= MERGE_OK && merge_next >= MERGE_OK) {
 		merge_both = is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL);
+	}
 
-	if (merge_both) {	 /* cases 1, 6 */
+	if (merge_both >= MERGE_OK) {	 /* cases 1, 6 */
 		err = __vma_adjust(prev, prev->vm_start,
 					next->vm_end, prev->vm_pgoff, NULL,
 					prev);
 		area = prev;
-	} else if (merge_prev) {			/* cases 2, 5, 7 */
+	} else if (merge_prev >= MERGE_OK) {			/* cases 2, 5, 7 */
 		err = __vma_adjust(prev, prev->vm_start,
 					end, prev->vm_pgoff, NULL, prev);
 		area = prev;
-	} else if (merge_next) {
+	} else if (merge_next >= MERGE_OK) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(prev, prev->vm_start,
 					addr, prev->vm_pgoff, NULL, next);
@@ -1252,7 +1255,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	} else {
 		err = -1;
 	}
-
+	trace_vm_av_merge(err, merge_prev, merge_next, merge_both);
 	/*
 	 * Cannot merge with predecessor or successor or error in __vma_adjust?
 	 */
@@ -3359,6 +3362,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		/*
 		 * Source vma may have been merged into new_vma
 		 */
+		trace_vm_pgoff_merge(vma, anon_pgoff_updated);
+
 		if (unlikely(vma_start >= new_vma->vm_start &&
 			     vma_start < new_vma->vm_end)) {
 			/*
-- 
2.34.1

