Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8571189537;
	Tue, 30 Jul 2024 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358252; cv=none; b=porkitgK3ZIB684RjO1NyzAHQL7WFOie3kg8Ndav6bEbhRfdPAl5Ny8RBjYP4zgLnNymz+WyKO+OD7DyB2/jshp3eRHEoJKm2GwHEYkzEM5ffdvFd2lGyExKTP3ggIJxr7EUvFdjGu69shnomRIHVmYn6tcW9J58Z4R/R9UXdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358252; c=relaxed/simple;
	bh=19FQBswi54ayhvbM4aPGa98LT5XkLfEqnKTsZWCvqF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quD+vKdX6KQ0HKfNh2QROJETvh+dWryfupnutSm2voyE7pbhTI5ka18NyexbRJ5v1UwG+PuieL7RAvOcesjwCrzqpLWiwq9MMQt9WUjMWE4X/wWEb3iXbtwIbjXzAqUCAoOBAuYRWuAoXHmaIMOc1hXqq7fP+XMPJPenUp2bSkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdYsvoAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdYsvoAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB6FC32782;
	Tue, 30 Jul 2024 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358252;
	bh=19FQBswi54ayhvbM4aPGa98LT5XkLfEqnKTsZWCvqF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdYsvoAN6ZYbi9X0Fi27ljPW8QBoFTwfhqSkc5t1W3gtKmxpO1duRLx6eqIaRplQM
	 1KWx74ZJn3wF8D2/A3PkBs5YMP7VhTN8IQFC7LxpHNZVduLtZgWAhciBhBI1/TmThH
	 SOnz1R1ZzDpgD3s8+bSSapUm44ziuPys2UyuvGcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <teawater@antgroup.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrei Vagin <avagin@google.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/568] fs/proc/task_mmu.c: add_to_pagemap: remove useless parameter addr
Date: Tue, 30 Jul 2024 17:47:31 +0200
Message-ID: <20240730151653.316178434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Zhu <teawater@antgroup.com>

[ Upstream commit cabbb6d51e2af4fc2f3c763f58a12c628f228987 ]

Function parameter addr of add_to_pagemap() is useless.  Remove it.

Link: https://lkml.kernel.org/r/20240111084533.40038-1-teawaterz@linux.alibaba.com
Signed-off-by: Hui Zhu <teawater@antgroup.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2c1f057e5be6 ("fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0f5c06b8bb342..e327d1c77de88 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1358,8 +1358,7 @@ static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
 
-static int add_to_pagemap(unsigned long addr, pagemap_entry_t *pme,
-			  struct pagemapread *pm)
+static int add_to_pagemap(pagemap_entry_t *pme, struct pagemapread *pm)
 {
 	pm->buffer[pm->pos++] = *pme;
 	if (pm->pos >= pm->len)
@@ -1386,7 +1385,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 			hole_end = end;
 
 		for (; addr < hole_end; addr += PAGE_SIZE) {
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				goto out;
 		}
@@ -1398,7 +1397,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				goto out;
 		}
@@ -1527,7 +1526,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		for (; addr != end; addr += PAGE_SIZE) {
 			pagemap_entry_t pme = make_pme(frame, flags);
 
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				break;
 			if (pm->show_pfn) {
@@ -1555,7 +1554,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		pagemap_entry_t pme;
 
 		pme = pte_to_pagemap_entry(pm, vma, addr, ptep_get(pte));
-		err = add_to_pagemap(addr, &pme, pm);
+		err = add_to_pagemap(&pme, pm);
 		if (err)
 			break;
 	}
@@ -1605,7 +1604,7 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 	for (; addr != end; addr += PAGE_SIZE) {
 		pagemap_entry_t pme = make_pme(frame, flags);
 
-		err = add_to_pagemap(addr, &pme, pm);
+		err = add_to_pagemap(&pme, pm);
 		if (err)
 			return err;
 		if (pm->show_pfn && (flags & PM_PRESENT))
-- 
2.43.0



