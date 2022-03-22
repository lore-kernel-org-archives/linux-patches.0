Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F006465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6CEC340EC;
	Tue, 22 Mar 2022 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985602;
	bh=DZeMtvAKaJMEfII0unlLLrvet4WaXJzruMCAT5PWPkw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=tjqcLOtVdZVoMjm+7UHwoRg9Ri4zf4P8deO2fQLao9R8VKTfapaDMX/8kM9uaztc9
	 BRDePb/9rL5RFEM99/sFFnD15N6BRl1L2isT8uR3zbDVlzSRyrMPN1KzQBXDdxykdA
	 HCKTupwgDqfDAuiPSMvqQV5LHneKiMgSIu94po6o=
Date: Tue, 22 Mar 2022 14:46:41 -0700
To: david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 161/227] mm/madvise: use vma_lookup() instead of find_vma()
Message-Id: <20220322214642.7F6CEC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the start address is contained in the found
vma.  This results in easier to read the code.

Link: https://lkml.kernel.org/r/20220311082731.63513-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vma_lookup-instead-of-find_vma
+++ a/mm/madvise.c
@@ -849,8 +849,8 @@ static long madvise_populate(struct vm_a
 		 * our VMA might have been split.
 		 */
 		if (!vma || start >= vma->vm_end) {
-			vma = find_vma(mm, start);
-			if (!vma || start < vma->vm_start)
+			vma = vma_lookup(mm, start);
+			if (!vma)
 				return -ENOMEM;
 		}
 
_
