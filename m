Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF776453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB061C340EC;
	Tue, 22 Mar 2022 21:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985350;
	bh=8I0AvYzXU0dWraExZB72rwlmoaAJKY60nseCbClVmMU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=bCsjG3bA5HiIdFWZ7NSSoMUAqaRgkLAIvzq0GSl4nLoF6XiL/s0fI97/lW6BVdrEH
	 etmsxpd5ZsrZszR2lFUg834NUz0xIccw8j/o+zJXA6eaQ1ivZc0RADxPSZsGo9xtoi
	 jfV5ELHNNzrHwI0pRhty+NjrNTWeMEsqxRlATxLE=
Date: Tue, 22 Mar 2022 14:42:30 -0700
To: linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 078/227] mm/memory.c: use helper function range_in_vma()
Message-Id: <20220322214230.CB061C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: use helper function range_in_vma()

Use helper function range_in_vma() to check if address, address + size are
within the vma range.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220219021441.29173-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-use-helper-function-range_in_vma
+++ a/mm/memory.c
@@ -1715,7 +1715,7 @@ static void zap_page_range_single(struct
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
-	if (address < vma->vm_start || address + size > vma->vm_end ||
+	if (!range_in_vma(vma, address, address + size) ||
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
_
