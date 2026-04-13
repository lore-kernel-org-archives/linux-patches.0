Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A798E309F09;
	Mon, 13 Apr 2026 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097648; cv=none; b=toRLNHpIyRbnyR9+sTlVoybO/H0645umqlO65vEnG1YBlJrvg9zmVNB77ofWn0trg9l3qqcrbzRq1ffaVuSTkFC4/umKAeVLpeAFyYhWWEUbEVGJVgVPXmKadFX+dkGXAavlyv9tQUd74Iycd+OBZq11dZJY5yTW3gqROi0+e4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097648; c=relaxed/simple;
	bh=eNQ/az6lh71gGlZ1rHLkg84kV2WZNdeq3EqkKcXDrSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBOhcgCyuRYks2gqdPrql9agijPuFant/JC7KXK7pxB8ThHj59wlD7VC95Gz1jgnJPYkok8iYHuTLdfkMLckbyi+s6cFe4ju8RS1kBaFsJB/2QUicRCPxbPTWMJO75+QtOCUDnzM6X5jLhPQu+HFK/GQZ7gzH+Gk1++0TD8K9nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygm8wdtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygm8wdtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F543C2BCAF;
	Mon, 13 Apr 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097648;
	bh=eNQ/az6lh71gGlZ1rHLkg84kV2WZNdeq3EqkKcXDrSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ygm8wdtAVMP+jBHGyDFTGSl/mK1+XwQuEElriujawGrf977VYvju4537rBjYUP0sD
	 yr/2pV5f+eg1P3PW9KzzOf0vRU+1yyw76ZgZPSl3ryxkvpdi83BeH6WFQaIYrh9Qwt
	 ybhy4MoMo7sTTeMYL3th972pRGWUQc6rcamDy008=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Liu Shixin <liushixin2@huawei.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Uschakow, Stanislav" <suschako@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 218/570] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Mon, 13 Apr 2026 17:55:49 +0200
Message-ID: <20260413155838.621000055@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Red Hat) <david@kernel.org>

commit a8682d500f691b6dfaa16ae1502d990aeb86e8be upstream.

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251223214037.580860-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ David: We don't have 40549ba8f8e0 ("hugetlb: use new vma_lock
  for pmd sharing synchronization") so there are some contextual
  differences. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1489,13 +1489,8 @@ static bool try_to_unmap_one(struct page
 							      range.end);
 
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
 				 */
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -1808,13 +1803,8 @@ static bool try_to_migrate_one(struct pa
 							      range.end);
 
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
 				 */
 				page_vma_mapped_walk_done(&pvmw);
 				break;


