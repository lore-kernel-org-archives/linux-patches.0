Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C689D6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE1AC340EE;
	Tue, 22 Mar 2022 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985193;
	bh=8VA4dRateZukIxcuU24dYBOu+ngWksQajNF7aIpezC4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=J8wiKzZ+B9gGFOqH3UcgpGnjCYk1SLA7vLgYLhLLI5C/49Uyu+gJt5MDu547i2x5x
	 Hl9oFk9678TZXubc2BxJclUZS7g4K2YtSv0a13w4ip1CnNlPRK4MhB39/TE9A1IDcI
	 2cCQSP8ijvJlEVF+c1rFypSKc9QIV5tGv0YQPS5Q=
Date: Tue, 22 Mar 2022 14:39:52 -0700
To: libang.linuxer@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 027/227] mm/swap: fix confusing comment in folio_mark_accessed
Message-Id: <20220322213953.8DE1AC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/swap: fix confusing comment in folio_mark_accessed

For unevictable pages, we don't need mark them.

Link: https://lkml.kernel.org/r/20220311141519.59948-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-folio_mark_accessed
+++ a/mm/swap.c
@@ -425,7 +425,7 @@ void folio_mark_accessed(struct folio *f
 		/*
 		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
 		 * this list is never rotated or maintained, so marking an
-		 * evictable page accessed has no effect.
+		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
 		/*
_
