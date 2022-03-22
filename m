Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F9E6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906AFC340EC;
	Tue, 22 Mar 2022 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985362;
	bh=nLd/e0wfjnqccZgkuzXkEmRaOX/nNoEF/3WrCYYj7oI=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=FM55E8451rTYyUODUG37K9nGKHXIJtTlFGD9wxEk97PtcQjbBC3Rv+eqM4wmHdCta
	 SXwjGvRq3G8btTfxIvmRxN9p554BOLMmbQ71J6ygxjqVG/ox3+jawbzYOylnhEU0wk
	 82kVrKdW9aTprGaVHwpuE5sPYJV1YhSSYUDWsqZA=
Date: Tue, 22 Mar 2022 14:42:41 -0700
To: david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 082/227] mm/mremap:: use vma_lookup() instead of find_vma()
Message-Id: <20220322214242.906AFC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mremap:: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the address is contained in the found vma. 
This results in easier to read code.

Link: https://lkml.kernel.org/r/20220312083118.48284-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vma_lookup-instead-of-find_vma
+++ a/mm/mremap.c
@@ -942,8 +942,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr) {
+	vma = vma_lookup(mm, addr);
+	if (!vma) {
 		ret = EFAULT;
 		goto out;
 	}
_
