Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBCD1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A404C340EC;
	Fri, 25 Mar 2022 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170581;
	bh=JEwlsmaCWsYPSfq4eMAfyXLhoiviqfYNsh02Ru88fq0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=lvBSUYJJ0rJRnJx3HIaHwVNWCIZwr9mZ6jlykJWrLEM+Qq68v29n88az47NrtlzCE
	 +nnNbMoSMSgCZ8OirjaqaUqvDwgLpb7xXT3M2XVz+7zYJ3BjJjiCt4veJNcqyOJ3Kl
	 EwwFQ8P8mGi39yOTHdgeIKChBnKSP3aVkAq1QqaU=
Date: Thu, 24 Mar 2022 18:09:40 -0700
To: david@redhat.com,hch@lst.de,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 022/114] mm: unexport page_init_poison
Message-Id: <20220325010941.7A404C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport page_init_poison

page_init_poison is only used in core MM code, so unexport it.

Link: https://lkml.kernel.org/r/20220207063446.1833404-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/debug.c~mm-unexport-page_init_poison
+++ a/mm/debug.c
@@ -261,5 +261,4 @@ void page_init_poison(struct page *page,
 	if (page_init_poisoning)
 		memset(page, PAGE_POISON_PATTERN, size);
 }
-EXPORT_SYMBOL_GPL(page_init_poison);
 #endif		/* CONFIG_DEBUG_VM */
_
