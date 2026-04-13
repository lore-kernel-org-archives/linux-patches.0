Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E733B6F8;
	Mon, 13 Apr 2026 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099738; cv=none; b=T5DEys8FOE9hOEFS64Bubj/XwtjIGcLNVFnWWnRKBO7OknnD0o+Aic0/vNPGmnj3vnwiGN052IEvEFKZLJGLpRfNjlnolI1W1A9h4Gooxe0MAz+C/77nufR0yUuhjVbNncyd8LPXQLXfO+6uz4a8ymeW0M0rXOBsYx2HlljlekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099738; c=relaxed/simple;
	bh=ki7VfXK+iosex8cJuIMyiSmEAK0Z1MLwQQ6kdfFTAqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2oUP5ZkqWF4DgizGA3Xb7ZhgVdsl3ANbBasr3kjWgS65EqLBjBEm1LiZYZAoXKytSv4i49xT7RYpcpNtDn66d41siuyVPfy7ktW5/EEeM9IYdid7TY2vs8cIcitzCBS8O2f321hRJK+ln+LdtpD9I5+5uD8q0nBt2NdF0jGmuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYbXlgJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYbXlgJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44406C2BCAF;
	Mon, 13 Apr 2026 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099738;
	bh=ki7VfXK+iosex8cJuIMyiSmEAK0Z1MLwQQ6kdfFTAqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYbXlgJlHS8bZygvSWq/9M/BmZxavyA1JTzz6tItM8rpQCrCUMpc2hK+n9dF1tSUe
	 DJJS9ZLNIgi/qv1FGZRaS+gV9PPnIF7saY6vXd9WaI2l9tSg7vsQpoYd0k8+arrESI
	 iE3uM5Oio8ODJkCfImolAQalC5UwE8rM4izdjf+E=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/491] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Mon, 13 Apr 2026 18:01:08 +0200
Message-ID: <20260413155834.862582376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Red Hat) <david@kernel.org>

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
(cherry picked from commit a8682d500f691b6dfaa16ae1502d990aeb86e8be)
[ David: We don't have 40549ba8f8e0 ("hugetlb: use new vma_lock
  for pmd sharing synchronization") and a98a2f0c8ce1 ("mm/rmap: split
  migration into its own so changes in mm/rmap.c looks quite different. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e6f840be18906..315d7ceb573ae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1490,13 +1490,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
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
-- 
2.53.0



