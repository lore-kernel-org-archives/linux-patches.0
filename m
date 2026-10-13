Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83C64F799A;
	Tue, 13 Oct 2026 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895421; cv=none; b=AiF3bJ/kj7x47Pje6waT/GqCDDnUfE8iph3epo3y8JHmO3kcdOMUGbxDKAl3/JYsnSyI541B9hS0rPnESwIq0LRjthlMlStJeLLIw+xmwZjGia1XH9ct6kC84sQqX8VdOZRclC8J1fEE5dNM0bXSVFNULinMS1iLgCtB25tNq1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895421; c=relaxed/simple;
	bh=BXuPxwnEjLoBhqWMnGPhA4Vuw1+hb6wNLROQhYMIBhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd2hnWVLrPHl6je+OGJBPiHz84KMrmSpREFQXvAwdeyRLXebcTma7C7fkmzFYRSZLsamkmOcxAJHGfDePrG1c4t9YUfE8gog3B5KUDe6U8iB+Ixo2i2Bc7RpczYk7QpoDCONSIzcjblA3LK4KB2PK834HUTjWyQfAd64wJB7GfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3rpUgOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3rpUgOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359221F000FF;
	Tue, 13 Oct 2026 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895420;
	bh=m3nAatqmTexGlYGfBASEOPgACaFJlCKOVcYM0cVM9xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3rpUgOuzKsQxTZ19Xka3Zt55ko/29tKzV7vysFK+8flnKKZwkTbeg0Ij8xEsbbsF
	 4u2LC1HHq3UBG6OajIWzC0dJgS2RSJQO0IhAVDVwU7HYTufWL4t+G0QtEt1kZMPr5X
	 w/q4O2KXdQd2rf6ShlJ5nov33uYm4v8DRXdxXYDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/497] mm: shmem: remove __shmem_huge_global_enabled()
Date: Tue, 13 Oct 2026 13:37:14 +0200
Message-ID: <20261013112914.229857541@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 4a9a27fdf7bfd29013491aea45e3512988cc5876 ]

Remove __shmem_huge_global_enabled() since it as only one caller, and
remove repeated check of VM_NOHUGEPAGE/MMF_DISABLE_THP as they are checked
in shmem_allowable_huge_orders(), also remove unnecessary vma parameter.

Link: https://lkml.kernel.org/r/20241017141457.1169092-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 72c3d682c165 ("mm: shmem: ignore sysfs configs for shmem forced collapse")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 51a0f94e6d9fe..e760dc2d7d41e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -559,17 +559,15 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-					loff_t write_end, bool shmem_huge_force,
-					struct vm_area_struct *vma,
-					unsigned long vm_flags)
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+				      loff_t write_end, bool shmem_huge_force,
+				      unsigned long vm_flags)
 {
-	struct mm_struct *mm = vma ? vma->vm_mm : NULL;
 	loff_t i_size;
 
-	if (!S_ISREG(inode->i_mode))
+	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
-	if (mm && ((vm_flags & VM_NOHUGEPAGE) || test_bit(MMF_DISABLE_THP, &mm->flags)))
+	if (!S_ISREG(inode->i_mode))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
@@ -587,7 +585,7 @@ static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
-		if (mm && (vm_flags & VM_HUGEPAGE))
+		if (vm_flags & VM_HUGEPAGE)
 			return true;
 		fallthrough;
 	default:
@@ -595,17 +593,6 @@ static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 	}
 }
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		   loff_t write_end, bool shmem_huge_force,
-		   struct vm_area_struct *vma, unsigned long vm_flags)
-{
-	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
-		return false;
-
-	return __shmem_huge_global_enabled(inode, index, write_end,
-					   shmem_huge_force, vma, vm_flags);
-}
-
 #if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
@@ -783,8 +770,8 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 }
 
 static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		loff_t write_end, bool shmem_huge_force,
-		struct vm_area_struct *vma, unsigned long vm_flags)
+				      loff_t write_end, bool shmem_huge_force,
+				      unsigned long vm_flags)
 {
 	return false;
 }
@@ -1224,7 +1211,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
+	if (shmem_huge_global_enabled(inode, 0, 0, false, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -1725,7 +1712,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-					shmem_huge_force, vma, vm_flags);
+						shmem_huge_force, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
-- 
2.53.0



