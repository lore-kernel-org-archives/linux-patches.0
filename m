Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6586453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D57C340EC;
	Tue, 22 Mar 2022 21:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985470;
	bh=CYCAgfZaJlS+pByLr6BdL66Gk9MBlsp4NM9QveUQY6I=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=A02pgbBhecTW8shMFuLms40pR+vQwFIaxuydE+95b472UPszazlftFFy5k6e54OM9
	 EmHysvnnsheCo8NtROE4UiLqHvrtVElgob3cDjaXRlvbXq5OR5+XTQl4sMreFQyUgb
	 sOO5OrO69t5oB6N8FlFaKfE6i8I7mqjNnZvOtaMQ=
Date: Tue, 22 Mar 2022 14:44:30 -0700
To: linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 118/227] mm/memory-failure.c: remove obsolete comment in __soft_offline_page
Message-Id: <20220322214430.B6D57C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: remove obsolete comment in __soft_offline_page

Since commit add05cecef80 ("mm: soft-offline: don't free target page in
successful page migration"), set_migratetype_isolate logic is removed. 
Remove this obsolete comment.

Link: https://lkml.kernel.org/r/20220218090118.1105-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -2167,10 +2167,6 @@ static int __soft_offline_page(struct pa
 		ret = invalidate_inode_page(page);
 	unlock_page(page);
 
-	/*
-	 * RED-PEN would be better to keep it isolated here, but we
-	 * would need to fix isolation locking first.
-	 */
 	if (ret) {
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		page_handle_poison(page, false, true);
_
