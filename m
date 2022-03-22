Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA726465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6384CC340F2;
	Tue, 22 Mar 2022 21:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985494;
	bh=ME/RtbfS+u0oOaqRfNDLWI3rW/1j4uR3uNN2Z3ml3A4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=J+fOALuoVrlpbRT7v3lwq3vVafQxztlTzU7O+A63iQY1SP/OaEFOUs+CD00KbLPt/
	 8wJgK5KMPANxALTjUyY3+FLC0Wn6Q/NdyTDWRhR5NDcAt0KD/dT4aUk4NGx7vyUTms
	 RBIWRbZ4FRI6UgPrrxxG0MvxH7fpNoukpa48crK4=
Date: Tue, 22 Mar 2022 14:44:53 -0700
To: willy@infradead.org,mgorman@techsingularity.net,david@redhat.com,vbabka@suse.cz,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 126/227] mm, fault-injection: declare should_fail_alloc_page()
Message-Id: <20220322214454.6384CC340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, fault-injection: declare should_fail_alloc_page()

The mm/ directory can almost fully be built with W=1, which would help in
local development.  One remaining issue is missing prototype for
should_fail_alloc_page().  Thus add it next to the should_failslab()
prototype.

Note the previous attempt by commit f7173090033c ("mm/page_alloc: make
should_fail_alloc_page() static") had to be reverted by commit
54aa386661fe as it caused an unresolved symbol error with
CONFIG_DEBUG_INFO_BTF=y

Link: https://lkml.kernel.org/r/20220314165724.16071-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fault-inject.h~mm-fault-injection-declare-should_fail_alloc_page
+++ a/include/linux/fault-inject.h
@@ -64,6 +64,8 @@ static inline struct dentry *fault_creat
 
 struct kmem_cache;
 
+bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
+
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
_
