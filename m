Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938FE18E368;
	Mon, 28 Oct 2024 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098180; cv=none; b=DeErj2ZoIgchzaG6YpSxs1DSTEV+lxyXjTVcbgtsPYulFVmIqnyYkP3Rmr858DA3wRywe0oB25n6K2TJ1m4wNUEqSMFGRTteYewAUFqO9XINEOjDz9HuHKgTXFLF0MPBkphK9IWi8u77QPrjf4mj4pOgdPrhCuiMwM2jhi4hSw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098180; c=relaxed/simple;
	bh=Plk1LDuZxl3h18ae6cRuwE6f9j8TXPs5Fwnju+WR/20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcUtfvFQXAqIZq+YIQ4yYsYHSktuivgEiI3EdsJVpMe3HVXGPe01FQaswLT7kW32dWOqel2ajMfl9efMOzcHRpcKOZWTFgWg22rHuIy64u96Pb5iSFJGAhRGWvLl/XMq43VF/V+yozk4yiuptT9yEmvdEs+CfOxoNgJUfr+qjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsrZ712b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsrZ712b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B08C4CEC3;
	Mon, 28 Oct 2024 06:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098180;
	bh=Plk1LDuZxl3h18ae6cRuwE6f9j8TXPs5Fwnju+WR/20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsrZ712bqGcOUKd6VZ+4R//pJIFA8GYP98AVehJgitknqMDwRmk0hPSy3deIGm2t0
	 +JCxj4Ch7y3cGNZNc5ZUVoYH7/JndQzrSmLW/1qWxirTKXZRDZazHq8QyKZscat53n
	 vdApDp8STmyOR/FQPXtVfcZRwNRWSu5EJvrpGmNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <21cnbao@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <ioworker0@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 113/261] mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
Date: Mon, 28 Oct 2024 07:24:15 +0100
Message-ID: <20241028062314.861467011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit d58a2a581f132529eefac5377676011562b631b8 ]

shmem_is_huge() is now used to check if the top-level huge page is
enabled, thus rename it to reflect its usage.

Link: https://lkml.kernel.org/r/da53296e0ab6359aa083561d9dc01e4223d60fbe.1721626645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2b0f922323cc ("mm: don't install PMD mappings when THPs are disabled by the hw/process/vma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h |  9 +++++----
 mm/huge_memory.c         |  5 +++--
 mm/shmem.c               | 15 ++++++++-------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 1d06b1e5408a5..405ee8d3589a5 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -111,14 +111,15 @@ extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-			  struct mm_struct *mm, unsigned long vm_flags);
+extern bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+				      struct mm_struct *mm, unsigned long vm_flags);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				bool global_huge);
 #else
-static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-					  struct mm_struct *mm, unsigned long vm_flags)
+static __always_inline bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+						      bool shmem_huge_force, struct mm_struct *mm,
+						      unsigned long vm_flags)
 {
 	return false;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 99b146d16a185..26843caa46962 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -160,8 +160,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file)) {
-		bool global_huge = shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
-							!enforce_sysfs, vma->vm_mm, vm_flags);
+		bool global_huge = shmem_huge_global_enabled(file_inode(vma->vm_file),
+							     vma->vm_pgoff, !enforce_sysfs,
+							     vma->vm_mm, vm_flags);
 
 		if (!vma_is_anon_shmem(vma))
 			return global_huge ? orders : 0;
diff --git a/mm/shmem.c b/mm/shmem.c
index 5a77acf6ac6a6..d2ca6d4300bb8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -548,9 +548,9 @@ static bool shmem_confirm_swap(struct address_space *mapping,
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool __shmem_is_huge(struct inode *inode, pgoff_t index,
-			    bool shmem_huge_force, struct mm_struct *mm,
-			    unsigned long vm_flags)
+static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					bool shmem_huge_force, struct mm_struct *mm,
+					unsigned long vm_flags)
 {
 	loff_t i_size;
 
@@ -581,14 +581,15 @@ static bool __shmem_is_huge(struct inode *inode, pgoff_t index,
 	}
 }
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index,
+bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 		   bool shmem_huge_force, struct mm_struct *mm,
 		   unsigned long vm_flags)
 {
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
 
-	return __shmem_is_huge(inode, index, shmem_huge_force, mm, vm_flags);
+	return __shmem_huge_global_enabled(inode, index, shmem_huge_force,
+					   mm, vm_flags);
 }
 
 #if defined(CONFIG_SYSFS)
@@ -1156,7 +1157,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_is_huge(inode, 0, false, NULL, 0))
+	if (shmem_huge_global_enabled(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -2158,7 +2159,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		return 0;
 	}
 
-	huge = shmem_is_huge(inode, index, false, fault_mm,
+	huge = shmem_huge_global_enabled(inode, index, false, fault_mm,
 			     vma ? vma->vm_flags : 0);
 	/* Find hugepage orders that are allowed for anonymous shmem. */
 	if (vma && vma_is_anon_shmem(vma))
-- 
2.43.0



