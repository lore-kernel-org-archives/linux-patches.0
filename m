Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B718C025;
	Tue, 10 Sep 2024 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963174; cv=none; b=d59VkJ3HM/Snec+MJYniLsPkyREfrlE84PHZzRqaWr6TGIeIpHwlJJPXo2E1oqywTDq/87xKwtRpyMsdssngG6mnoRWAeGHErWxW02vL6SdZbwGMa9ZCI0OBdPSaSPmTWT/GbfeYbfmreJM5cQpG5gjj8M9vcXUkbXIFat6K9XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963174; c=relaxed/simple;
	bh=YLcCfIFZ2Ot5qKbNPYKW7ZlpHuRQU0CnMEfMFB7JoVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVwE0+LXx7UUO3zWQGlXVrDzWL6hPMaM8CX/1jvOmbUoIK5ctrbdQzb9ZbGKI/PyMRcxRrET7rT/UFf51vRKF5Q+Q+wCMWlk/wQcKwQZkDBX5EytbQ/gseKr/2RRt0wKlMTh+8gme8UoA+gJ1QdNeEcP1yint4TGRuipfBNuzlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybzEi9bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybzEi9bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCDFC4CEC3;
	Tue, 10 Sep 2024 10:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963174;
	bh=YLcCfIFZ2Ot5qKbNPYKW7ZlpHuRQU0CnMEfMFB7JoVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybzEi9bGkJJwNoaHhsF7avWkCLanZvMJaCbGIHXhGtYxQAnRiOflHrUG7P8sH37dq
	 YfsdfuLN7eO3gTVNilcNH3Jfh/4pzfPKNn6QUQ2pB5bJ+z5vcag/TWZggpDyDEiHIV
	 Chkj3MjEUgjPWDiZlXwyqDZ8/9WPFwOESqRyB9uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/192] mm: Rename pmd_read_atomic()
Date: Tue, 10 Sep 2024 11:33:04 +0200
Message-ID: <20240910092604.534760140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit dab6e717429e5ec795d558a0e9a5337a1ed33a3d ]

There's no point in having the identical routines for PTE/PMD have
different names.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221022114424.841277397%40infradead.org
Stable-dep-of: 71c186efc1b2 ("userfaultfd: fix checks for huge PMDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pgtable.h    | 9 ++-------
 mm/hmm.c                   | 2 +-
 mm/khugepaged.c            | 2 +-
 mm/mapping_dirty_helpers.c | 2 +-
 mm/mprotect.c              | 2 +-
 mm/userfaultfd.c           | 2 +-
 mm/vmscan.c                | 4 ++--
 7 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8f31e2ff6b58..3e3c00e80b65 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1373,11 +1373,6 @@ static inline int pud_trans_unstable(pud_t *pud)
 #endif
 }
 
-static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
-{
-	return pmdp_get_lockless(pmdp);
-}
-
 #ifndef arch_needs_pgtable_deposit
 #define arch_needs_pgtable_deposit() (false)
 #endif
@@ -1404,13 +1399,13 @@ static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
  */
 static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
 {
-	pmd_t pmdval = pmd_read_atomic(pmd);
+	pmd_t pmdval = pmdp_get_lockless(pmd);
 	/*
 	 * The barrier will stabilize the pmdval in a register or on
 	 * the stack so that it will stop changing under the code.
 	 *
 	 * When CONFIG_TRANSPARENT_HUGEPAGE=y on x86 32bit PAE,
-	 * pmd_read_atomic is allowed to return a not atomic pmdval
+	 * pmdp_get_lockless is allowed to return a not atomic pmdval
 	 * (for example pointing to an hugepage that has never been
 	 * mapped in the pmd). The below checks will only care about
 	 * the low part of the pmd with 32bit PAE x86 anyway, with the
diff --git a/mm/hmm.c b/mm/hmm.c
index 3850fb625dda..39cf50de76d7 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -361,7 +361,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		 * huge or device mapping one and compute corresponding pfn
 		 * values.
 		 */
-		pmd = pmd_read_atomic(pmdp);
+		pmd = pmdp_get_lockless(pmdp);
 		barrier();
 		if (!pmd_devmap(pmd) && !pmd_trans_huge(pmd))
 			goto again;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 085fca1fa27a..47010c3b5c4d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -866,7 +866,7 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 	if (!*pmd)
 		return SCAN_PMD_NULL;
 
-	pmde = pmd_read_atomic(*pmd);
+	pmde = pmdp_get_lockless(*pmd);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* See comments in pmd_none_or_trans_huge_or_clear_bad() */
diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index 1b0ab8fcfd8b..175e424b9ab1 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -126,7 +126,7 @@ static int clean_record_pte(pte_t *pte, unsigned long addr,
 static int wp_clean_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
-	pmd_t pmdval = pmd_read_atomic(pmd);
+	pmd_t pmdval = pmdp_get_lockless(pmd);
 
 	if (!pmd_trans_unstable(&pmdval))
 		return 0;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 668bfaa6ed2a..f006bafe338f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -294,7 +294,7 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
  */
 static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
 {
-	pmd_t pmdval = pmd_read_atomic(pmd);
+	pmd_t pmdval = pmdp_get_lockless(pmd);
 
 	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 992a0a16846f..5d873aadec76 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -641,7 +641,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 			break;
 		}
 
-		dst_pmdval = pmd_read_atomic(dst_pmd);
+		dst_pmdval = pmdp_get_lockless(dst_pmd);
 		/*
 		 * If the dst_pmd is mapped as THP don't
 		 * override it and just be strict.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4cd0cbf9c121..f5fa1c76d9e6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4068,9 +4068,9 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
-		pmd_t val = pmd_read_atomic(pmd + i);
+		pmd_t val = pmdp_get_lockless(pmd + i);
 
-		/* for pmd_read_atomic() */
+		/* for pmdp_get_lockless() */
 		barrier();
 
 		next = pmd_addr_end(addr, end);
-- 
2.43.0



