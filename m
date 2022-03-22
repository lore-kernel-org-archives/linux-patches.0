Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D96453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E61AC340EE;
	Tue, 22 Mar 2022 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985365;
	bh=mPKzudlzJ9FrbxOIvBg6s/Z3UnRNW3NEEw4AvYzkQms=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=V2vzQDFCGt6BdNeVyLtyGfOfFwl1eE6jujWz4746NaHZdloDZWbIHhQJOEFAZHF90
	 2O2gF3qI1svoSXUn38kuraatY6afo6ieEKeH65kzjMjrULICUg5v9ILgU9o1yQO0y4
	 4e/g4AoLBWP/HiGWf4JeDScVsWJKwRFhVpbJT5fk=
Date: Tue, 22 Mar 2022 14:42:44 -0700
To: rppt@linux.ibm.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 083/227] mm/sparse: make mminit_validate_memmodel_limits() static
Message-Id: <20220322214245.7E61AC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/sparse: make mminit_validate_memmodel_limits() static

It's only used in the sparse.c now. So we can make it static and further
clean up the relevant code.

Link: https://lkml.kernel.org/r/20220127093221.63524-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   11 -----------
 mm/sparse.c   |    2 +-
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/mm/internal.h~mm-sparse-make-mminit_validate_memmodel_limits-static
+++ a/mm/internal.h
@@ -572,17 +572,6 @@ static inline void mminit_verify_zonelis
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-/* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
-#if defined(CONFIG_SPARSEMEM)
-extern void mminit_validate_memmodel_limits(unsigned long *start_pfn,
-				unsigned long *end_pfn);
-#else
-static inline void mminit_validate_memmodel_limits(unsigned long *start_pfn,
-				unsigned long *end_pfn)
-{
-}
-#endif /* CONFIG_SPARSEMEM */
-
 #define NODE_RECLAIM_NOSCAN	-2
 #define NODE_RECLAIM_FULL	-1
 #define NODE_RECLAIM_SOME	0
--- a/mm/sparse.c~mm-sparse-make-mminit_validate_memmodel_limits-static
+++ a/mm/sparse.c
@@ -126,7 +126,7 @@ static inline int sparse_early_nid(struc
 }
 
 /* Validate the physical addressing limitations of the model */
-void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
+static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
 						unsigned long *end_pfn)
 {
 	unsigned long max_sparsemem_pfn = 1UL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
_
