Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044774;
	b=APeBfcGgSIQ0jEByz3vpd0EZl84GLkHfEHCLyO79iDbG5XhLM1gPovfG1cj+F/1wEZOT
	 /qd71+GhYTxV+sRQA9hhqQFQSKezR0Ed8o0175gjmLwloezdC2GXmWaEKLndkU9LQHvJj
	 GwBmC1CGkLtGe7IF3XtYfONJgGGqfro6mCggZ3i/H6DE5kXfGgV7Uh5Gc/Jh9Dd5p5Dfj
	 HjuRy6m2Lz9PT/FjR5TJOECS9exFtr1c86vnQ6x2dsPDjgTjkcFWzTSjPfzSIQ32Xqnii
	 Rq2qswaGvrJQJcIZNg2//R5tZ3gWcxNNR7t5Ci/YTJcBYtO2c6cx3TZRh/PwbjGvvwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ed81jyONQOBjsHdEGmqNujODk9VDI0AHxXSZnbUyl5o=;
	b=q30UnLaU9UBy+wK+2NkH1+xO3/uPe2X5qby1idCdycPKLpCObeCW5Mf5H/on/05TslIg
	 qpWbd9fdazNS3UiXaUPaxYeK8i3O96uj/4kqPhpoJs+Mwz06MXl51LlOA2WjRNQr7x/+c
	 ADrfIQ4vbsRUR+KrD/Upu236JqXxsYKvZeb0VO7F7MXuyuN/BlHiZxzlD3dD8MFLsCH9S
	 s4rLxzQ27nsh+8Y12UCfpwCsahsAYRORRJtRR7hbz8MfmDwjPCsxU0crYGKIBzv5VQb0D
	 /b4mkXxk85wNeqJLEeGYihkrzAVVvfIi2D2G7mdUvWfgt1bRAOgEszuY7Ntw62yIAkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCgg6jiY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DB4606D64A;
	Wed, 18 Nov 2026 23:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCgg6jiY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C651F000CA;
	Wed, 18 Nov 2026 23:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044773;
	bh=ed81jyONQOBjsHdEGmqNujODk9VDI0AHxXSZnbUyl5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCgg6jiYeCRF9h3tf4SwSjINcBTHAfALZL5gxeoH8slKSTLB2WTtyuEfNuGr/X8La
	 whUBagKr1VRv4D0goUYIkCD8JiEfZ4I4uoxWARLlI3q4AXvASo1+UhaG1/qrSmZ3bb
	 dJkX42Z5zc027cSHJgxAbrTpNbjO84b2spRoHqTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0688/2857] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed, 18 Nov 2026 15:28:42 +0100
Message-ID: <20261118150226.330954504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d8a9cd7fd2fb01211430c933932da58839b8ca65 ]

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted folio operations to the existing struct page API in hugetlb_mcopy_atomic_pte(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fc26639f87dc5..de805b385d06b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6428,11 +6428,16 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		SetHPageMigratable(page);
 	if (vm_shared || is_continue)
 		unlock_page(page);
+
+	/*
+	 * Hold the PTL until we're done with the page: the page table owns the
+	 * page reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;
-- 
2.53.0



