Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DB46477
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A08C340EE;
	Tue, 22 Mar 2022 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985636;
	bh=oA4q3srNS/ASuTBwak4bUqiug5XtLMt68SKmOkdl8i4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Wo44jk+vm0zF9tiavGanLr5WOG8Qu0sq75BXDge9LOmIiDgXT8tzQQGWTVw8uvstG
	 nyuJzpHjyyBh3cG6evli3VUWREJFJ5jP1FpO48H1eDH9IMYNzI7nOJudAQrQlUAf5t
	 Uq4nbxioeSVMmu+f2bmsA0FYBZfJ7mL0sc8P4u48=
Date: Tue, 22 Mar 2022 14:47:16 -0700
To: david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 172/227] mm/memory_hotplug: remove obsolete comment of __add_pages
Message-Id: <20220322214716.C3A08C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: remove obsolete comment of __add_pages

Patch series "A few cleanup patches around memory_hotplug".

This series contains a few patches to fix obsolete and misplaced comments,
clean up the try_offline_node function and so on.  


This patch (of 4):

Since commit f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded
memory to zones until online"), there is no need to pass in the zone.

[akpm@linux-foundation.org: remove the comment altogether, per David]
Link: https://lkml.kernel.org/r/20220207133643.23427-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220207133643.23427-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-obsolete-comment-of-__add_pages
+++ a/mm/memory_hotplug.c
@@ -295,12 +295,6 @@ struct page *pfn_to_online_page(unsigned
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
-/*
- * Reasonably generic function for adding memory.  It is
- * expected that archs that support memory hotplug will
- * call this function after deciding the zone to which to
- * add the new pages.
- */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
_
