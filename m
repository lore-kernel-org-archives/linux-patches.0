Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E8C2E2299;
	Wed, 28 Jan 2026 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614747; cv=none; b=LFVy0tVkHLf5b1fXxcU2Dh4jlfkCJpF977XZdkKNQ2+1CsFrAQO5+lu5gzxUg2ei/CE+w4om1ie+i/H616GzQDqyQY2tgMYapyuhqfk6TnkA5yUiNHUDgCXjl4+RFW6JTM6TRmXiPxVZ2x6+E6lQqRuZurES6HopBE0hImWhHXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614747; c=relaxed/simple;
	bh=2naxXq9mJaRjzqpOKlGuUZdJdwCUbBxsQQxr7NV+3gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a516pdkktedI1KpeQ7u8CZUlXfl1R2K7/3mEeqH9CWbH1KtQnsHZlpautlxQRn9DUHetHCaEjvqXBnWOKiErqr+8YzbO43Alc/JyY2GFfX+ELNMvaB/AOdzavZUMKWH/aFLuitsbZVfGX+EuCG0Ziqv5/ueerexx2oOBGBC05r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFpo6aoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFpo6aoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EF9C4CEF1;
	Wed, 28 Jan 2026 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614747;
	bh=2naxXq9mJaRjzqpOKlGuUZdJdwCUbBxsQQxr7NV+3gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFpo6aoWjaMEVK7gv3L3RBkRQM9DdpynVm4iU6Cky0tiG3QbGeEcZzGb8AqqfRQ/k
	 3JOQL5+6sKJIUEoBR073YV3Xljxxo8F/2Clwr4ZszMqeqkia8ePqGaMpBodrPyfN+O
	 Nzw2eGIJzOyNpBPDJJLFWk6bw1lnMqw5CjCXr0Vc=
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
Subject: [PATCH 6.6 229/254] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Wed, 28 Jan 2026 16:23:25 +0100
Message-ID: <20260128145353.028208584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

[ Upstream commit a8682d500f691b6dfaa16ae1502d990aeb86e8be ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1579,14 +1579,8 @@ static bool try_to_unmap_one(struct foli
 					flush_tlb_range(vma,
 						range.start, range.end);
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					page_vma_mapped_walk_done(&pvmw);
 					break;
@@ -1945,14 +1939,8 @@ static bool try_to_migrate_one(struct fo
 						range.start, range.end);
 
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					page_vma_mapped_walk_done(&pvmw);
 					break;


