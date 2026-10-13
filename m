Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000394F7CDB;
	Tue, 13 Oct 2026 12:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895428; cv=none; b=h6KA0pyPNKOWPbvt0V/nms1dAtLXo7UjMCFWp3qxLMXpMMLDnYTx52ySeiJ55QHGCuGkQooVQjPlrAF/OKCf9+eewBoa426dX6CwqHQVijo9gkeYvxiQsLpcUWCD6acxWjc6+9f8yCNUKOYFq/JghdcGE+WnO/FAMkBKwWLRBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895428; c=relaxed/simple;
	bh=MbR+MlpH12DukZIrvqjXns/vsWxvVY7rb1BfzdbMUns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbm5jfXFEwC5ksAkZGUspEJ2ep65OXypeHmLDJ0tSds0ppAro2PusVJd2y1saAR0Be1co4QeJAjtWRypEn8ItpKSbgiV79zrwM7hheLaimUAp671G77tgRrfxuwpx/K1wyRE3RCGTHOditSlPl1uxadsQWrvJUkw3JfU7wFBkE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5qsO4yF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5qsO4yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FAA1F000FF;
	Tue, 13 Oct 2026 12:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895426;
	bh=E/QIleahsPG7z05Vso7VPkSLdyZD7b/MbBCff3SMjEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5qsO4yFhRowrflHahFZ1nVovKZA0H4AgfZcStBmhXy8swgFf+f83bBAVI+uKgsQZ
	 y/KqFGG73dF5C8V3IHDHUSGTT6yrqeKhp73Zc30qLw42Z40WwqAqUpD5Qj61ROaxtQ
	 AISIb5kuGzeIWG6jkJ4Hkt/UrO3l4Qac0KRr9lMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Hugh Dickins <hughd@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lance Yang <ioworker0@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/497] mm: shmem: change shmem_huge_global_enabled() to return huge order bitmap
Date: Tue, 13 Oct 2026 13:37:16 +0200
Message-ID: <20261013112914.278177551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 736bbc68255fd451d26353a255f15ad347c26132 ]

Change the shmem_huge_global_enabled() to return the suitable huge order
bitmap, and return 0 if huge pages are not allowed.  This is a preparation
for supporting various huge orders allocation of tmpfs in the following
patches.

No functional changes.

Link: https://lkml.kernel.org/r/9dce1cfad3e9c1587cf1a0ea782ddbebd0e92984.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 72c3d682c165 ("mm: shmem: ignore sysfs configs for shmem forced collapse")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e760dc2d7d41e..1a5932bda558f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -559,37 +559,37 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-				      loff_t write_end, bool shmem_huge_force,
-				      unsigned long vm_flags)
+static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					      loff_t write_end, bool shmem_huge_force,
+					      unsigned long vm_flags)
 {
 	loff_t i_size;
 
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
-		return false;
+		return 0;
 	if (!S_ISREG(inode->i_mode))
-		return false;
+		return 0;
 	if (shmem_huge == SHMEM_HUGE_DENY)
-		return false;
+		return 0;
 	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
+		return BIT(HPAGE_PMD_ORDER);
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-		return true;
+		return BIT(HPAGE_PMD_ORDER);
 	case SHMEM_HUGE_WITHIN_SIZE:
 		index = round_up(index + 1, HPAGE_PMD_NR);
 		i_size = max(write_end, i_size_read(inode));
 		i_size = round_up(i_size, PAGE_SIZE);
 		if (i_size >> PAGE_SHIFT >= index)
-			return true;
+			return BIT(HPAGE_PMD_ORDER);
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
-			return true;
+			return BIT(HPAGE_PMD_ORDER);
 		fallthrough;
 	default:
-		return false;
+		return 0;
 	}
 }
 
@@ -769,11 +769,11 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 	return 0;
 }
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-				      loff_t write_end, bool shmem_huge_force,
-				      unsigned long vm_flags)
+static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					      loff_t write_end, bool shmem_huge_force,
+					      unsigned long vm_flags)
 {
-	return false;
+	return 0;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -1704,21 +1704,21 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
 	pgoff_t aligned_index;
-	bool global_huge;
+	unsigned int global_orders;
 	loff_t i_size;
 	int order;
 
 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
 
-	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-						shmem_huge_force, vm_flags);
+	global_orders = shmem_huge_global_enabled(inode, index, write_end,
+						  shmem_huge_force, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
 		 * is enabled, otherwise fallback to order 0.
 		 */
-		return global_huge ? BIT(HPAGE_PMD_ORDER) : 0;
+		return global_orders;
 	}
 
 	/*
@@ -1751,7 +1751,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (vm_flags & VM_HUGEPAGE)
 		mask |= READ_ONCE(huge_shmem_orders_madvise);
 
-	if (global_huge)
+	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
-- 
2.53.0



