Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BFE7E
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 04:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD80C36AE3;
	Sat,  5 Mar 2022 04:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1646454548;
	bh=U3rCi1jiOKjimyFDmIahLfJ79nDdVEZ/4lv6zR1v7S4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=oMRlI7r1RuLZFdF5dHmWQpZNTf5hWKY4aATLi4dFCBYvJhaDZGHoTf+A4KDkR1sCQ
	 6h61ag9La6rDhdg//A4DMy2cDaAvv3et4w6pqnkko/R4iaNOK48CwZMkjLFrwLXL4u
	 keh6DNCg3HBSUhEoEytKGMR0JnyUiBsEJC/m4EQM=
Date: Fri, 04 Mar 2022 20:29:07 -0800
To: tiberiu.georgescu@nutanix.com,sj@kernel.org,shy828301@gmail.com,peterx@redhat.com,linmiaohe@huawei.com,ivan.teterevkov@nutanix.com,florian.schmidt@nutanix.com,david@redhat.com,corbet@lwn.net,ccross@google.com,axelrasmussen@google.com,apopple@nvidia.com,aarcange@redhat.com,yun.zhou@windriver.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org>
Subject: [patch 7/8] proc: fix documentation and description of pagemap
Message-Id: <20220305042908.4BD80C36AE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yun Zhou <yun.zhou@windriver.com>
Subject: proc: fix documentation and description of pagemap

Since bit 57 was exported for uffd-wp write-protected(commit
fb8e37f35a2f), fixing it can reduce some unnecessary confusion.

Link: https://lkml.kernel.org/r/20220301044538.3042713-1-yun.zhou@windriver.com
Fixes: fb8e37f35a2fe1 ("mm/pagemap: export uffd-wp protection information")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tiberiu A Georgescu <tiberiu.georgescu@nutanix.com>
Cc: Florian Schmidt <florian.schmidt@nutanix.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Colin Cross <ccross@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    2 +-
 fs/proc/task_mmu.c                       |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~proc-fix-documentation-and-description-of-pagemap
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -23,7 +23,7 @@ There are four components to pagemap:
     * Bit  56    page exclusively mapped (since 4.2)
     * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
       :ref:`Documentation/admin-guide/mm/userfaultfd.rst <userfaultfd>`)
-    * Bits 57-60 zero
+    * Bits 58-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
--- a/fs/proc/task_mmu.c~proc-fix-documentation-and-description-of-pagemap
+++ a/fs/proc/task_mmu.c
@@ -1597,7 +1597,8 @@ static const struct mm_walk_ops pagemap_
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bits 57-60 zero
+ * Bit  57    pte is uffd-wp write-protected
+ * Bits 58-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
_
